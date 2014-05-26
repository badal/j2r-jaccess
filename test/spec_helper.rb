#!/usr/bin/env ruby
# encoding: utf-8
#
# File: spec_helper.rb
# Created: 16 January 2012
#
# (c) Michel Demazure <michel@demazure.com>

# require 'simplecov'
# SimpleCov.start

# GUIs for Jacinthe
module JacintheReports
  # data directory
  DATA = ENV['J2R_DATA']
end

require_relative '../lib/j2r/jaccess.rb'
require 'minitest/autorun'

include JacintheReports
