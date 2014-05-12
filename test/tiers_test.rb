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

describe 'J2R::Tiers' do

  before { J2R.jaccess('test') }

  describe 'Finding a Tiers' do

    let(:tiers) { Tiers.find(Sequel.like(:tiers_nom, '%Orleans')) }

    it('') { tiers.must_be_kind_of(J2R::Tiers) }
    it('') { tiers.id.must_equal(10) }

  end

  describe 'A simple Tiers' do

    let(:tiers) { Tiers[100] }
    let(:client) { Client.find(client_sage_client_final: 100) }

    it('') { tiers.must_be_kind_of(Tiers) }
    it('') { tiers.id.must_equal(100) }
    it('') { client.id.must_equal('100') }
    it('') do
      tiers.afnor.must_equal(
          ['M JEAN LOUIS KOSZUL', '34 AVENUE JEAN PERROT', '38100 GRENOBLE', 'FRANCE']
      )
    end

  end

  describe 'A complex Tiers' do

    let(:tiers) { J2R::Tiers[9258] }
    let(:clients) { tiers.clients }

    it('is a Tiers') { tiers.must_be_kind_of(Tiers) }
    it('has the good id') { tiers.id.must_equal(9258) }
    it('the good number of clients') { clients.count.must_equal(3) }
    it('the good clients') do
      clients.map(&:id).must_equal(%w(9258 9258MAYER 9258SWETSGB))
    end
    it('') { clients.all[2].abonnements.count.must_equal(10) }
    it('') { clients.all[2].abonnements.first[:abonnement_revue].must_equal(1) }

  end

  describe 'Rapports' do

    let(:tiers) { Tiers[6822] }
    it('') { tiers.rapports.size.must_equal(2) }

  end
end
