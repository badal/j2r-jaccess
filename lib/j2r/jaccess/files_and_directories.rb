#!/usr/bin/env ruby
# encoding: utf-8

# File: file_methods.rb
# Created: 15/02/12
#
# (c) Michel Demazure <michel@demazure.com>

# reporting tools for Jacinthe
module JacintheReports
  # subdirectory for configuration files
  CONFIG_DIR = File.join(DATA, 'config')
  # name of connection configuration file
  CONNECT_CONFIG_FILE = 'connect.ini'
  # name of join modification file
  JOINS_CONFIG_FILE = 'joins.ini'
  # name of sources.ini list file
  SOURCES_CONFIG_FILE = 'sources.ini'

  # subdirectory where yaml fields and joins file are dumped
  STRUCTURE_DIR = File.expand_path('structure', DATA)
  # where the dumped field data are
  FIELD_FILE = File.join(STRUCTURE_DIR, 'fields.yaml')
  # where the dumped joining data are
  JOIN_FILE = File.join(STRUCTURE_DIR, 'joins.yaml')
  # subdirectory where yaml structure file are dumped

  # subdirectory where extended data are dumped
  EXTENDED_DIR = File.expand_path('extended', DATA)
  # where the dumped structure data are
  EXTENDED_FIELDS_FILE = File.join(EXTENDED_DIR, 'extended_fields.yaml')
  # where the dumped joins data are
  EXTENDED_JOINS_FILE = File.join(EXTENDED_DIR, 'extended_joins.yaml')
end
