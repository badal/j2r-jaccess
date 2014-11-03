#!/usr/bin/env ruby
# encoding: utf-8

# File: instance_methods_spec.rb
# Created: 05/02/12
#
# (c) Michel Demazure <michel@demazure.com>
require_relative 'spec_helper.rb'

require_relative '../lib/j2r/jaccess/connect.rb'
require_relative '../lib/j2r/jaccess/instance_methods.rb'
require_relative '../lib/j2r/jaccess/model.rb'
require_relative '../lib/j2r/jaccess/joins_and_fields.rb'

include Jaccess

describe 'Format' do

  let(:tiers) do
    Jaccess.connect('test')
    Model.build_models
    J2R::Tiers[383]
  end

  it('') { tiers.format(['string']).must_equal(['string']) }
  it('') { tiers.format([:tiers_prenom, :tiers_nom]).must_equal ['Michel DEMAZURE'] }
  it('') { tiers.format([:tiers_prenom, nil, :tiers_nom]).must_equal %w(Michel DEMAZURE) }

end

describe 'Metaprogrammation' do

  let(:tiers) do
    Jaccess.connect('test')
    Model.build_models
    J2R::Tiers[100]
  end

  describe 'extended fields' do
    it('') { tiers.public_methods.include?(:compte_collectif_nom).must_equal(false) }
    it('') { tiers.respond_to?(:compte_collectif_nom).must_equal(true) }
    it('') { tiers.compte_collectif_nom.must_equal('Clients FRANCE') }
  end

  describe 'extended_join' do
    it('') do
      J2R::Tiers.extended_join(:compte_collectif).first.tiers_nom
        .must_equal('Universite Rennes I')
    end
  end

  describe 'search' do
    it('') { tiers.search_ids(:abonnement).must_equal [339, 340, 341] }
    it '' do
      (->() { tiers.search_ids(:pays) }).must_raise(NoMethodError)
    end
  end
end
