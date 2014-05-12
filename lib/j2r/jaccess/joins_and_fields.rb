#!/usr/bin/env ruby
# encoding: utf-8

# File: joins_and_fields.rb
# Created: 20/01/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module Jaccess
    # Model for the J2R tables
    module Model
      # return the field table
      # @return [Hash : Symbol => Array<Symbol>] table of fields
      def self.field_table
        @field_table ||= Psych.load_file(FIELD_FILE)
      end

      # return the joining table
      # @return [Hash : Symbol * 2 => Symbol * 2 ] table of association rules
      def self.joining_table
        @joining_table ||= load_joining_table
      end

      # build  the join table from all the files in JOIN_DIR
      # and build the Sequel associations
      def self.load_joining_table
        {}.tap do |joining_table|
          list = Psych.load_file(JOIN_FILE)
          list.each do |source, key, target, target_id|
            joining_table[[source, key]] = [target, target_id]
          end
        end
      end

      # return the extended fields table
      # @return [Hash] the extended fields table
      def self.extended_fields
        @extended_fields ||= Psych.load_file(EXTENDED_FIELDS_FILE)
      end

      # return the extended joins table
      # @return [Hash] the extended joins table
      def self.extended_joins
        @extended_joins ||= Psych.load_file(EXTENDED_JOINS_FILE)
      end

      # @return [Array] all tables of database
      def self.all_tables
        field_table.keys
      end

      # @param table [Symbol] table where the links start
      # @return [Array] list of all possible fields
      def self.possible_fields(table)
        return [] if table == :vide
        (extra_fields(table) + field_table[table]).sort_by(&:downcase)
      end

      # @param table [Symbol] table where the links start
      # @return [Array] list of accessible fields by joins
      def self.extra_fields(table)
        paths = extended_fields.keys.select { |key| key.first == table }
        paths.map(&:last).uniq
      end
    end
  end
end
