#!/usr/bin/env ruby
# encoding: utf-8

# File: tiers_spec.rb
# Created: 25/01/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module Jaccess
    module Model
      # Instance Methods for J2R::Tiers
      module TiersInstanceMethods
        ## other J2R objects connected to the Tiers

        # @return [Array<J2R::Clients>] solutions of client_sage_client_final = self
        # @param hash [Hash] filtering condition
        def clients(hash = {})
          @clients ||= J2R::Client.filter({ client_sage_client_final: id }.merge(hash))
        end

        # @return [Array<String>] reports on particularities
        def particularites
          J2R::Particularite.where(particularite_tiers: id).map do |part|
            part.format([:type_particularite_nom])
          end.flatten.sort.join(', ')
        end

        # @param [Integer] usage id in table usage_adresse
        # @return [J2R::VueAdresse] vue_adresse record
        def address(usage = 1)
          J2R::VueAdresse.filter(vue_adresse_tiers: id,
                                 vue_adresse_etat: 1,
                                 vue_adresse_usage: usage).first
        end

        ## Output formats

        # @return [Array<String>] normalized address
        def afnor
          Patterns.afnor_clean(format(Patterns::AFNOR))
        end

        # @return [Array<String>] reporting of "rapports"
        def rapports
          self_id = id
          sources = J2R::Rapport.where(rapport_tiers_source: self_id)
          targets = J2R::Rapport.where(rapport_tiers_but: self_id)
          (sources.all + targets.all).map do |rap|
            rap.format(Patterns::RAPPORTS)
          end
        end
      end
    end
  end
end
