#!/usr/bin/env ruby
# encoding: utf-8

# File: connect_spec.rb
# Created: 24/01/12
#
# (c) Michel Demazure <michel@demazure.com>
require_relative 'spec_helper'
require_relative '../lib/j2r/jaccess/connect.rb'

describe 'Connection' do

  it 'wrong mode' do
    (->() { Jaccess.connect('error') }).must_raise(Error::ConfigureError)
  end

  describe 'for Sequel' do

    let(:base) { Jaccess.connect('test') }

    it 'should connect' do
      base.wont_be_nil
      Jaccess.base.must_equal(base)
    end

    it 'should find tables' do
      base.tables.size.must_equal(41)
    end

    it 'should find views' do
      base.views.size.must_equal(16)
    end

  end

end
