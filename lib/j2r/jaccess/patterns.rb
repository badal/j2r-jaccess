#!/usr/bin/env ruby
# encoding: utf-8

# File: patterns.rb
# Created: 20/01/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  # patterns for formatting J2R::(Klass) objects
  module Patterns
    # @param text [Object] object to clean
    # @return [Array<String>] output conforming to AFNOR
    def self.afnor_clean(text)
      Array(text).map do |line|
        line.without_accents.upcase.gsub(/(\W)/, ' ').gsub('  ', ' ')
      end
    end

    # format for adresses
    ADRESSE = ['Tiers numéro :', :tiers_id, nil,
               :civilite_nom, :tiers_prenom, :tiers_nom, nil,
               :tiers_adresse_ligne1, nil, :tiers_adresse_ligne2, nil,
               :tiers_adresse_ligne3, nil, :tiers_adresse_ligne4, nil,
               :tiers_adresse_code_postal, :tiers_adresse_code_postal_complement,
               :tiers_adresse_ville, nil,
               :tiers_adresse_province, nil,
               :pays_nom, nil,
               'Téléphone :', :tiers_tel, nil,
               'Courriel :', :tiers_email]

    # format for AFNOR adresse
    AFNOR = [:civilite_nom, :tiers_prenom, :tiers_nom, nil,
             :tiers_adresse_ligne1, nil, :tiers_adresse_ligne2, nil,
             :tiers_adresse_ligne3, nil, :tiers_adresse_ligne4, nil,
             :tiers_adresse_code_postal, :tiers_adresse_code_postal_complement,
             :tiers_adresse_ville, nil,
             :tiers_adresse_province, nil,
             :pays_nom]

    # format for ip plage
    PLAGE = ['Plage :', :tiers_ip_plage, nil, 'Mail :', :tiers_ip_mails,
             nil, 'Utilisateurs :', :tiers_ip_nb_utilsateurs]

    # format for abonnement
    ABONNEMENT = [:revue_nom, :abonnement_annee, :type_abonnement_nom]

    # format for sage client
    CLIENT = ['Client sage :', :client_sage_id, nil, :client_sage_intitule]

    # format for connexion between tiers
    RAPPORTS = [:rapport_tiers_source, [:rapport_type, :type_rapport_nom] , :rapport_tiers_but,
                ':', [:rapport_tiers_but, :tiers_prenom], [:rapport_tiers_but, :tiers_nom],
                '=', :rapport_commentaire]
  end
end
