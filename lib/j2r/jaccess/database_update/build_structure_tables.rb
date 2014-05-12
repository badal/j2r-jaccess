#!/usr/bin/env ruby
# encoding: utf-8

# File: build_structure_tables.rb
# Created: 02/02/12
#
# (c) Michel Demazure <michel@demazure.com>

require_relative '../../jaccess.rb'
require_relative 'load_modifications.rb'

module JacintheReports
  module Update
    # building fields and joins tables
    module JaccessTables
      # build the field table
      # @param mode [String] connection mode
      def self.build_field_table(mode)
        base = Jaccess.connect(mode)
        @field_table = {}
        (base.tables + base.views).each do |table|
          @field_table[table] = base.schema(table).map(&:first)
        end
        @field_table
      end

      # save the field table in the file FIELD_TABLE
      def self.dump_field_table
        J2R.yaml_dump(J2R::FIELD_FILE, @field_table)
      end

      # open the connection and build the association list
      # @param mode [String] connection mode
      # @return [Array] join list
      # FLOG: 25.1
      def self.build_join_list(mode) # rubocop:disable MethodLength
        forbidden_joins, added_joins = Modifications.load_join_modification_data
        puts "Forbidden joins : #{forbidden_joins.size}"
        puts "Added joins : #{added_joins.size}"
        base = Jaccess.connect(mode)
        @join_list = added_joins.dup
        base.tables.each do |table|
          base.foreign_key_list(table).each do |entry|
            field = entry[:columns].first
            next if forbidden_joins.include?(field)
            @join_list << [table, field, entry[:table], entry[:key].first]
          end
        end
        @join_list
      end

      # save the join list in the file JOIN_FILE
      def self.dump_join_list
        J2R.yaml_dump(J2R::JOIN_FILE, @join_list)
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME

  include J2R
  include Update

  mode = 'exploitation'

  puts "Tables : #{JaccessTables.build_field_table(mode).size}"
  # Update.dump_field_table
  puts "Total joins : #{JaccessTables.build_join_list(mode).size}"
  # Update.dump_join_list

end
