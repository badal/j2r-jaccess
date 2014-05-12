#!/usr/bin/env ruby
# encoding: utf-8

# File: jaccess.rb
# Modified: 15/03/12, 10/5/14
#
# (c) Michel Demazure <michel@demazure.com>

gem 'sequel' # , '<4.0'
require 'sequel'
require 'yaml'
require 'json'
require 'logger'

# production de rapports pour Jacinthe
module JacintheReports
  # author
  COPYRIGHT = "\u00A9 Michel Demazure 2011-2014"

  # this year
  YEAR = Time.now.strftime('%Y').to_i

  # windows ?
  def self.win?
    RUBY_PLATFORM =~ /mswin|mingw/
  end

  # linux ?
  def self.linux?
    RUBY_PLATFORM =~ /linux/
  end

  # mac ?
  def self.darwin?
    RUBY_PLATFORM =~ /darwin/
  end

  NAME = 'Jacinthe violette'
  VERSION = '3.0.0.dev'
end

J2R = JacintheReports

require_relative 'jaccess/errors.rb'
require_relative 'jaccess/file_methods.rb'
require_relative 'jaccess/files_and_directories.rb'
require_relative 'jaccess/connect.rb'
require_relative 'jaccess/joins_and_fields.rb'
require_relative 'jaccess/model.rb'
require_relative 'jaccess/patterns.rb'
require_relative 'jaccess/mailing_list.rb'
