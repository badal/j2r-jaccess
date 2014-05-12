#!/usr/bin/env ruby
# encoding: utf-8

# File: update.rb
# Created: 19/03/12
#
# (c) Michel Demazure <michel@demazure.com>

require_relative '../../jaccess.rb'
require_relative 'build_structure_tables.rb'
require_relative 'build_extended_tables.rb'

module JacintheReports
  # methods for building the association and field Jaccess tables
  module Update
    # before processing
    WARNING = ['', 'AVERTISSEMENT', 'Cette opération est destructrice !',
               'Les nombres affichés après l\'exécution doivent ressembler à',
               '  Tables : 40',
               '  Total joins : 40',
               '  Extended joins : 100',
               '  Extended fields : 1000',
               'Vérifiez aussi que les quatre fichiers des sous-dossiers',
               '\'structure\' et \'extended\' du dossier',
               "  #{J2R::DATA}",
               'ont bien été enregistrés.',
               'En cas d\'erreur, reconstituez-les à l\'aide des fichiers \'.bak\'.',
               '---------------']

    # build and dump joins and fields files
    # @param mode [String] configuration
    def self.dump_joins_and_fields_tables(mode)
      puts "Tables : #{JaccessTables.build_field_table(mode).size}"
      JaccessTables.dump_field_table
      puts "Total joins : #{JaccessTables.build_join_list(mode).size}"
      JaccessTables.dump_join_list
    end

    # build and dump extended lists files
    # @param mode [String] configuration
    def self.dump_extended_lists(mode)
      J2R.jaccess(mode)
      puts "Extended joins : #{ExtendedTables.extended_joins.size}"
      ExtendedTables.dump_extended_joins_list
      puts "Extended fields : #{ExtendedTables.extended_fields.size}"
      ExtendedTables.dump_extended_fields_list
    end

    # build and dump all DATA files
    # @param mode [String] configuration
    def self.dump_all_tables(mode)
      puts WARNING
      dump_joins_and_fields_tables(mode)
      dump_extended_lists(mode)
    end
  end
end

if __FILE__ == $PROGRAM_NAME

  include J2R
  mode = 'exploitation'
  # mode = 'localadmin'
  Update.dump_all_tables(mode)

end
