#!/usr/bin/env ruby
# encoding: utf-8

# File: client_spec.rb
# Created: 08/02/12
#
# (c) Michel Demazure <michel@demazure.com>

require_relative 'spec_helper.rb'
# require_relative '../lib/j2r/reports/extensions.rb'

describe 'String' do

  it('does not change when no accents') do
    'abcd'.without_accents.must_equal('abcd')
  end
  it('take accents out') do
    'éèë'.without_accents.must_equal('eee')
  end
end
