#!/usr/bin/env ruby
# encoding: utf-8

# File: jaccess.rb
# Modified: 15/03/12, 10/5/14
#
# (c) Michel Demazure <michel@demazure.com>

require 'sequel'
require 'yaml'
require 'json'
require 'logger'
require 'unicode'

# production de rapports pour Jacinthe
module JacintheReports
  # directory of config files
  DATA = ENV['J2R_DATA']

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
end

# alternative name of module
J2R = JacintheReports

require_relative 'jaccess/version.rb'
require_relative 'jaccess/errors.rb'
require_relative 'jaccess/string_extensions.rb'
require_relative 'jaccess/file_methods.rb'
require_relative 'jaccess/files_and_directories.rb'
require_relative 'jaccess/connect.rb'
require_relative 'jaccess/joins_and_fields.rb'
require_relative 'jaccess/model.rb'
require_relative 'jaccess/patterns.rb'
require_relative 'jaccess/mailing_list.rb'
