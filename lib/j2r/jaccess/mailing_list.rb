#!/usr/bin/env ruby
# encoding: utf-8

# File: mailing_list.rb
# Created: 29/04/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module Jaccess
    # address methods for mailings
    class MailingList
      # pattern for routing file
      COMMON = [:vue_adresse_nom, nil,
                :vue_adresse_ligne1, nil,
                :vue_adresse_ligne2, nil,
                :vue_adresse_ligne3, nil,
                :vue_adresse_ligne4, nil,
                :vue_adresse_code_postal, :vue_adresse_code_postal_complement, nil,
                :vue_adresse_ville, nil,
                :vue_adresse_province, nil,
                :vue_adresse_pays]

      ROUTER = [:vue_adresse_tiers, nil] + COMMON

      SEARCHABLE = [:civilite_nom, nil,
                    :tiers_prenom, nil,
                    :tiers_nom, nil] + COMMON

      # pattern for list of tiers w/o email
      LIST = [:vue_adresse_tiers, ' ', :vue_adresse_nom]

      # @param [Array] tiers_list of tiers_id
      # @param [Integer] usage id of adresse_usage
      # @param [Integer] etat_tiers id of etat_tiers
      # @param [Integer] zone id of zone_poste
      # @return [Array<VueAdresse>] list of vue_adresse records
      def self.build_addresses(tiers_list, usage, etat_tiers, zone)
        adrs = J2R::VueAdresse.filter(vue_adresse_etat: 1)
        adrs = adrs.filter(vue_adresse_usage: usage) if usage > 0
        adrs = adrs.filter(vue_adresse_tiers_etat: etat_tiers) if etat_tiers > 0
        adrs = adrs.filter(vue_adresse_zone_poste: zone) if zone > 0
        tiers_list.map do |tiers_id|
          adrs.filter(vue_adresse_tiers: tiers_id).first
        end.compact
      end

      # @param [Array] tiers_list list of tiers_id
      # @param [Hash] params parameters (usage, etat_tiers, zone)
      # @return [MailingList] new mailing list
      def initialize(tiers_list, params = {})
        usage = params[:usage] || 0
        etat_tiers = params[:etat_tiers] || 0
        zone = params[:zone] || 0
        @tiers_list = tiers_list
        @mailing = MailingList.build_addresses(tiers_list, usage, etat_tiers, zone)
      end

      # @return [Integer] size of mailing list
      def size
        @mailing.size
      end

      # @return [Table] (id, name) table
      def show_table
        columns = %w(Numéro Nom)
        lines = @mailing.map do |item|
          %W(#{item[:vue_adresse_tiers]} #{item[:vue_adresse_nom]})
        end
        # noinspection RubyArgCount
        Reports::Table.new(columns, lines)
      end

      # @return [Array<String>] content of csv file (ROUTER)
      def postal_adresses
        @mailing.map do |adrs|
          adrs.routing(ROUTER)
        end
      end

      # @return [Array<String>] content of csv file (SEARCHABLE)
      def searchable_adresses
        @mailing.map do |adrs|
          adrs.routing(SEARCHABLE)
        end
      end

      # @return [Array<String>] content of csv file (AFNOR)
      def afnor_adresses
        @mailing.map do |adrs|
          Patterns.afnor_clean(adrs.routing(ROUTER))
        end
      end

      # @return [Array<String>] content of csv file (EMAIL)
      def email_adresses
        list = @mailing.map { |adrs| adrs.routing(EMAIL) }
        list.reject { |item| item.last.empty? }
      end

      # @return [Array<String>] content of csv file (tiers w/o addresses)
      def no_email_adresses
        list = @mailing.select { |adrs| adrs.routing(EMAIL).last.empty? }
        list.map { |adrs| adrs.routing(ROUTER) }
      end

      # @return [Array<String>] content of csv file (Tiers list)
      def simple_list
        @tiers_list.map do |number|
          tiers = J2R::Tiers[number]
          ["#{number} #{tiers[:tiers_nom]} #{tiers[:tiers_prenom]}"] if tiers
        end.compact
      end
    end
  end
end
