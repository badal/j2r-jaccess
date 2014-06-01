#!/usr/bin/env ruby
# encoding: utf-8
#
# File: joins_and_fields_spec.rb
# Created: 24/01/12
#
# (c) Michel Demazure <michel@demazure.com>
require_relative 'spec_helper.rb'

require_relative '../lib/j2r/jaccess/connect.rb'
require_relative '../lib/j2r/jaccess/instance_methods.rb'
require_relative '../lib/j2r/jaccess/model.rb'
require_relative '../lib/j2r/jaccess/joins_and_fields.rb'

include Jaccess

describe Model do

  before do
    Jaccess.connect('test')
    Model.build_models
  end

  it 'should build joins' do
    Model.joining_table.size.must_equal(46)
  end

  it 'should build the field table' do
    Model.field_table.size.must_equal(43)
    list = [12, 8, 6, 8, 20, 3, 3, 3, 2, 12, 3, 7, 20, 3, 2,
            2, 5, 15, 6, 3, 7, 5, 3, 4, 11, 3, 40, 3, 3, 3, 3, 2,
            2, 24, 5, 4, 2, 2, 4, 8, 21, 5, 3]
    Model.field_table.values.map(&:size).must_equal(list)
  end

end
