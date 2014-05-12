#!/usr/bin/env ruby
# encoding: utf-8
#
# File: client_spec.rb
# Created: 08/02/12
#
# (c) Michel Demazure <michel@demazure.com>

require_relative 'spec_helper.rb'
require_relative '../lib/j2r/jaccess.rb'

include J2R

describe 'J2R::Client' do

  describe 'Finding a Client' do

    let(:client) do
      J2R.jaccess('test')
      J2R::Client.find(Sequel.like(:client_sage_id, '%MAYER'))
    end

    it('') { client.must_be_kind_of(Client) }
    it('') { client.id.must_equal('7356MAYER') }

  end

  describe 'A complex case' do

    let(:client) do
      J2R.jaccess('test')
      J2R::Client['9258SWETSGB']
    end

    it('') { client.final.must_be_kind_of(Tiers) }
    it('') { client.final.id.must_equal(9258) }
    it('') { client.livraison.must_be_kind_of(Tiers) }
    it('') { client.livraison.id.must_equal(66) }
    it('') { client.payeur.must_be_kind_of(Client) }
    it('') { client.payeur.id.must_equal('73') }

  end

end
