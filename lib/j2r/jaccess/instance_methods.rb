#!/usr/bin/env ruby
# encoding: utf-8

# File: instance_methods.rb
# Created: 03/02/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheReports
  module Jaccess
    module Model
      # Instance Methods for J2R::Model
      module InstanceMethods
        # @return [Object] primary key
        def id
          pk
        end

        # @param method [Symbol] method called
        # @return [Object] answer or super
        def method_missing(method, *)
          list = Model.extended_fields[[table, method]]
          # noinspection RubySuperCallWithoutSuperclassInspection
          list ? follow(list) : super
        end

        # @param method [Symbol] method called
        # @return [Bool] true/false
        def respond_to?(method)
          list = Model.extended_fields[[table, method]]
          # noinspection RubySuperCallWithoutSuperclassInspection
          list ? true : super
        end

        # :nodoc:
        MARK = '@@@'
        # :nodoc:
        MARK2 = Regexp.new(" #{MARK}( #{MARK})* ", encoding: 'utf-8')

        # @param key [Object] generalized access key (see spec)
        # @return [Object] value (recursively) computed along key
        def follow(key) # rubocop:disable MethodLength
          case key
          when nil
            MARK
          when String, Integer
            key
          when Symbol
            send(key)
          when Array
            follow_array_case(key)
          end
        end

        # @param key [Object] generalized access key (see spec)
        # @return [Object] value (recursively) computed along key
        def follow_array_case(key)
          key_dup = key.dup
          other = key_dup.shift
          value = self[other]
          value && key_dup.first ? get_next(other, value).follow(key_dup) : value
        end

        # @param other [Symbol] field to follow
        # @param other_id [Object] value of field
        # @return [Object] value after joining
        def get_next(other, other_id)
          table, id = *J2R::Jaccess::Model.joining_table[[self.table, other]]
          Model.model_table[table].filter(id => other_id).first
        end

        # @return [Array<String>] array of formatted lines without empty lines
        # @param pattern [Array] pattern
        def format(pattern)
          raw_format(pattern).compact.join(' ').gsub(MARK2, MARK).split(MARK)
        end

        # @return [Array<String>] array of formatted lines for routing
        # @param pattern [Array] pattern
        def routing(pattern)
          raw_format(pattern).join(' ').split(MARK).map(&:strip)
        end

        # @return [Array<String>] array of lines including MARK
        # @param pattern [Array] pattern
        def raw_format(pattern)
          pattern.map { |key| follow(key) }
        end

        ## general tools

        # WARNING: hash parameter nowhere used
        # @param other_table [Symbol] Jacinthe table to search
        # @return [Sequel] Sequel enumerator of records corresponding to this object
        # @param [Hash] hash extra Sequel constraints
        def search(other_table, hash = {})
          self_table = table
          self_id = "#{self_table}_id".to_sym
          model_to_search = Jaccess::Model.model_table[other_table]
          join = model_to_search.extended_join(self_table)
          join.filter({ self_id => id }.merge(hash))
        end

        # @param other_table [Symbol] Jacinthe table to search
        # @return [Array] id's of records corresponding to this object
        def search_ids(other_table)
          found = search(other_table)
          found ? found.map(&:id) : []
        end

        # Much too clever => deleted
        # @return [Hash<Array<Hash>>] all records related to given object
        # def audit
        #  {}.tap do |aud|
        #    SOURCES.map(&:to_sym).each do |source|
        #      aud[source] = search(source).all.map(&:values)
        #    end
        #  end
        # end
      end
    end
  end
end
