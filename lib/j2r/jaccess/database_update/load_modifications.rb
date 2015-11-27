#!/usr/bin/env ruby
# encoding: utf-8

# File: load_modifications.rb
# Created: 22/10/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module Update
    # processing modification data
    module Modifications
      # load the modification data from the join config file
      def self.load_join_modification_data
        cfg = J2R.load_config(JOINS_CONFIG_FILE)
        [forbidden_joins(cfg), added_joins(cfg)]
      rescue StandardError => err
        raise(Error::ConfigureError, err.message)
      end

      # build @forbidden_joins
      # @param [Hash] cfg configuration hash
      def self.forbidden_joins(cfg)
        cfg['forbidden_joins'].map(&:to_sym)
      end

      # build @added_joins
      # @param [Hash] cfg configuration hash
      def self.added_joins(cfg)
        cfg['added_joins'].each_pair.map do |field, table|
          [table_of(field), field.to_sym, table.to_sym, "#{table}_id".to_sym]
        end
      end

      # @param [Symbol or String] field database field
      # @return [Symbol] table of this field
      def self.table_of(field)
        Jaccess.base.tables.find do |table|
          /^#{table}/ =~ field.to_s
        end
      end
    end
  end
end
