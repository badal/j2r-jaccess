#!/usr/bin/env ruby
# encoding: utf-8

# File: build_extended_tables.rb
# Created: 07/02/12
#
# (c) Michel Demazure <michel@demazure.com>

require_relative '../../jaccess.rb'
require_relative 'build_structure_tables'

# reopening core class
class Hash
  # @param blok [Hash] block to map the values
  # @return [Hash] new hash : same keys, values mapped by given block
  def map_value(&blok)
    {}.tap do |hash|
      each_pair { |key, value| hash[key] = blok.call(value) }
    end
  end

  # @param other [Hash] other hash to merge
  # @return [Hash] add the keys and merge the values for the common keys
  def merge_hash(other)
    hash = dup
    other.each_pair { |key, value| hash[key] = (hash[key] || []) + value }
    hash
  end
end

module JacintheReports
  module Update
    # building extended fields and joins
    module ExtendedTables
      # @param new_joins [Hash] joins to compose
      # @param previous_joins [Hash] composed joins already built
      # @return [Hash] joins composed of a previous followed by a new
      def self.compose_step(new_joins, previous_joins)
        composed_joins = Hash.new([])
        previous_joins.each_pair do |(source, target), list|
          new_joins.each_pair do |(other_source, other_target), join|
            next unless target == other_source
            composed_joins[[source, other_target]] += extend_with_item(list, join)
          end
        end
        composed_joins
      end

      # @param item [Object] item to add
      # @param list [Array<Array>] given array
      # @return [Array<Array>] array with components extended by given item
      def self.extend_with_item(list, item)
        list.map { |items| items + [item] }
      end

      # @param joins [Hash] joins to compose
      # @return [Hash] all compositions from given joins
      def self.compose_all_from(joins)
        previous_joins = joins.map_value { |join| [[join]] }
        full_joins = previous_joins
        new_joins = { 1 => 2 }
        until new_joins.empty?
          new_joins = compose_step(joins, previous_joins)
          full_joins = full_joins.merge_hash(new_joins)
          previous_joins = new_joins
        end
        full_joins
      end

      # build the table of all composed joins uniquely defined by their extremities
      # @return [Enumerator (Hash)] table of all acceptable composed joins
      def self.composed_joins
        # on compose tous les joints
        full_joins = compose_all_from(initial_joins)
        # on garde ceux qui sont uniquement de'termine's par source et but
        full_joins.select { |_, joins| joins.size == 1 }
      end

      # @return [Hash] all table joins except loops and "rapport" joins
      # @param table [Hash] joining table
      def self.initial_joins
        initial_joins = {}
        Jaccess::Model.joining_table.each_pair do |(source, field), (target, _)|
          initial_joins[[source, target]] = [source, field]
        end
        initial_joins
      end

      # @param composed_joins [Hash] table of composed joins
      # @return [Hash] table of (full = with terminal fields) composed joins
      def self.build_list_with_fields(composed_joins)
        @full_list = {}
        composed_joins.each do |(source, target), joins|
          @full_list[[source, target]] = joins_with_terminal_field(joins, target)
        end
      end

      # @param joins [Hash] table of joins
      # @param target [Symbol] common target of the given joins
      # @return [Hash] table of all joins completing the given ones by all target fields
      def self.joins_with_terminal_field(joins, target)
        Jaccess::Model.field_table[target].reduce([]) do |acc, field|
          acc + joins.map { |join| join + [[target, field]] }
        end
      end

      # @return [Hash] table of full composed joins
      def self.full_list
        build_list_with_fields(composed_joins) unless @full_list
        @full_list
      end

      # build the @extended_fields hash
      def self.build_extended_fields
        @extended_fields = {}
        full_list.each_pair do |(source, _), joins|
          joins.each do |join|
            @extended_fields[[source, join.last.last]] = join.map(&:last)
          end
        end
      end

      # @return [Hash] the extended fields table
      def self.extended_fields
        build_extended_fields unless @extended_fields
        @extended_fields
      end

      # save the extended fields in the file EXTENDED_FIELDS_FILE
      def self.dump_extended_fields_list
        J2R.yaml_dump(J2R::EXTENDED_FIELDS_FILE, extended_fields)
      end

      # @param list [Array] array of pairs
      # @return [Array] array interlacing the given one
      def self.twisted(list)
        Array.new.tap do |twisted|
          old_field = list.shift.last
          list.each do |table, field|
            twisted << table << old_field
            old_field = field
          end
        end
      end

      # WARNING: do not erase the dup !
      # @return [Hash] the extended joins table
      def self.extended_joins
        @extended_joins ||= full_list.map_value { |list| twisted(list.first.dup) }
      end

      # save the extended joins in the file EXTENDED_JOINS_FILE
      def self.dump_extended_joins_list
        J2R.yaml_dump(J2R::EXTENDED_JOINS_FILE, extended_joins)
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME

  include J2R
  include Update

  J2R.jaccess('exploitation')

  ExtendedTables.dump_extended_joins_list
  ExtendedTables.dump_extended_fields_list

end
