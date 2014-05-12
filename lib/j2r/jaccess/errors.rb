#!/usr/bin/env ruby
# encoding: utf-8

# File: errors.rb
# Created: 19/01/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  # top module for errors
  module Error
    # Configuration or connection errors
    ConfigureError = Class.new(::StandardError)

    # For re-raising Sequel errors
    SequelError = Class.new(::StandardError)

    # For errors in system support
    SystemError = Class.new(::StandardError)
  end
end
