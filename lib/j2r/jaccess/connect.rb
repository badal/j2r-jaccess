#!/usr/bin/env ruby
# encoding: utf-8

# File: connect.rb
# Created: 16/01/12
#
# (c) Michel Demazure <michel@demazure.com>

# production de rapports pour Jacinthe
module JacintheReports
  # initialize the Jaccess environment
  # @param mode [String] connection mode
  def self.jaccess(mode)
    Jaccess.connect(mode)
    Jaccess::Model.build_models
    true
  end

  # access methods for Jacinthe
  module Jaccess
    # load the configuration file
    # @return [Hash] configurations
    def self.configurations
      @configurations ||= J2R.load_config(CONNECT_CONFIG_FILE)
    end

    # connects to the sqel server according to the given configuration
    # @param mode [String] configuration
    # @return [Sequel::Mysql2::Database] database
    def self.connect(mode)
      config = configurations[mode]
      @base = Sequel.mysql2(config)
      @base[:tiers].count # to test actual connexion
      @base
    rescue Sequel::Error
      raise J2R::Error::ConfigureError, "Incorrect connect mode '#{mode}'"
    end

    # create a temporary empty table
    def self.create_empty_table
      @base.run('drop temporary table if exists vide;')
      @base.run('create temporary table vide (vide char(1));')
    end

    # returns the loaded database
    # @return [Sequel::Mysql2::Database] the loaded database
    def self.base # rubocop:disable TrivialAccessors
      @base
    end

    # @param mode [String] configuration
    # @return [String] name of the database
    def self.database(mode)
      configurations[mode]['database']
    end

    # @param table [Symbol] name of table
    # @return [Sequel::Mysql2::Dataset] corresponding dataset [only in Sequel]
    def self.[](table)
      @base[table]
    end

    # @param [Symbol] field field of a table
    # @return [String] Sequel type of field, ex "int(11)"
    def self.type_of(field)
      @base.tables.each do |table|
        next unless Regexp.new(table.to_s + '_(.*)').match(field.to_s)
        return @base.schema(table).assoc(field).last[:type]
      end
    end

    # @param [Symbol] field field of a table
    # @return [Bool] check if field is numeric
    def self.numeric?(field)
      type = type_of(field)
      type == :integer || type == :decimal
    rescue
      false
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require_relative '../../../lib/j2r.rb'
  include J2R
  include Jaccess
  base = Jaccess.connect('exploitation')
  p base.tables
  p base.views
end
