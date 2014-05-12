#!/usr/bin/env ruby
# encoding: utf-8

# File: model_spec.rb
# Created: 24/01/12
#
# (c) Michel Demazure <michel@demazure.com>
require_relative 'spec_helper.rb'
require_relative '../lib/j2r/jaccess/connect.rb'
require_relative '../lib/j2r/jaccess/model.rb'

include Jaccess

describe Model do

  before do
    Jaccess.connect('test') # ('test')
    Model.build_models
  end

  it 'should build_models' do
    Model.model_table.size.must_equal(43)
  end

  it 'should find a tiers' do
    J2R::Tiers.find(tiers_nom: 'Papa').must_be_nil
    J2R::Tiers.find(tiers_nom: 'Demazure').wont_be_nil
    J2R::Tiers.find(tiers_nom: 'Demazure').values.size.must_equal(36)
  end

end
