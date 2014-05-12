#!/usr/bin/env ruby
# encoding: utf-8

# File: client_instance_methods.rb
# Created: 09/02/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module Jaccess
    module Model
      # Instance Methods for J2R::Client
      module ClientInstanceMethods
        # @return [Enum of J2R::Abonnement] solutions of abonnement_client_sage = self
        # @param hash [Hash] filtering condition
        def abonnements(hash = {})
          J2R::Abonnement.filter({ abonnement_client_sage: id }.merge(hash))
        end

        # @return [Enum of J2R::AdhesionLocale] solutions of adhesion_locale_client_sage = self
        def adhesions_locales
          J2R::AdhesionLocale.where(adhesion_locale_client_sage: id)
        end

        # @return [Enum of J2R::AdhesionTierce] solutions of adhesion_tierce_client_sage = self
        def adhesions_tierces
          J2R::AdhesionTierce.where(adhesion_locale_client_sage: id)
        end

        # @return [Enum of J2R::Don] solutions of don_client_sage = self
        def dons
          J2R::Don.where(don_client_sage: id)
        end

        # @return [J2R::Tiers] final tiers
        def final
          J2R::Tiers[self[:client_sage_client_final]]
        end

        # @return [J2R::Tiers] tiers for delivery
        def livraison
          J2R::Tiers[self[:client_sage_livraison_chez]]
        end

        # @return [J2R::Tiers] paying client
        def payeur
          J2R::Client[self[:client_sage_paiement_chez]]
        end
      end
    end
  end
end
