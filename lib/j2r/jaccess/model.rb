#!/usr/bin/env ruby
# encoding: utf-8

# File: model.rb
# Created: 20/01/12
#
# (c) Michel Demazure <michel@demazure.com>

require_relative 'instance_methods.rb'
require_relative 'tiers_instance_methods.rb'
require_relative 'client_instance_methods.rb'

# reopening Symbol
class Symbol
  # @return [String] CamelName associated to :camel_name
  def camelize
    to_s.split('_').map do |part|
      part[0].chr.upcase + part[1..-1]
    end.join
  end
end

module JacintheReports
  module Jaccess
    # Model for the J2R tables
    module Model
      # @param table [Symbol] name of table
      # @return [J2R::Model] corresponding model
      def self.[](table)
        @models[table.to_sym]
      end

      # @return [Hash] name of table => model
      def self.model_table
        @models
      end

      # Build all Model classes for all J2R tables
      def self.build_models
        @models = {}
        all_tables.each { |symbol| build_model(symbol) }
        build_associations
      end

      # build the Sequel associations
      def self.build_associations
        joining_table.each_pair do |(source, key), snd|
          next unless @models.key?(source)
          @models[source].send(:many_to_one, snd.last, key: key)
        end
      end

      # @param table_name [Symbol] table to build the Model for
      # @return [Class] Model class for the table
      def self.build_model(table_name)
        sequel_klass = sequel_class(table_name)
        klass = j2r_class(sequel_klass, table_name)
        @models[table_name] = klass
        J2R.const_set(j2r_name(table_name), klass) unless J2R.const_defined?(j2r_name(table_name))
        build_methods(klass, table_name)
      end

      # @param sequel_klass [Class] Sequel::Model class to subclass
      # @param table_name [Symbol] name of database table
      # @return [Class] J2R class with included instance methods
      def self.j2r_class(sequel_klass, table_name)
        klass = Class.new(sequel_klass)
        klass.include InstanceMethods
        if table_name == :tiers
          klass.include TiersInstanceMethods
        elsif table_name == :client_sage
          klass.include ClientInstanceMethods
        end
        klass
      end

      # @param table_name [Symbol] name of database table
      # @return [Constant] name to be given to J2R class
      def self.j2r_name(table_name)
        if table_name == :client_sage
          'Client'
        else
          table_name.camelize
        end
      end

      # @param table_name [Symbol] name of database table
      # @return [Class] ::Sequel::Model class
      def self.sequel_class(table_name)
        name = table_name.camelize
        sequel_klass = Class.new(::Sequel::Model)
        const_set(name, sequel_klass) unless const_defined?(name)
        sequel_klass.dataset = Jaccess[table_name]
        sequel_klass
      end

      # build methods by instance_eval'ing'
      # @param klass [Class] model created
      # @param table_name [String] name of Jaccess table
      def self.build_methods(klass, table_name)
        klass.class_eval "def table; '#{table_name}'.to_sym end"
        klass.class_eval "def self.table; '#{table_name}'.to_sym end"
        klass.dataset_module do
          def extended_join(symbol)
            link_list = Model.extended_joins[[model.table, symbol]]
            link_list.each_slice(2).reduce(self) do |acc, (table, key)|
              acc.join(table.to_sym, (table.to_s + '_id').to_sym => key)
            end
          end
        end
      end
    end
  end
end
