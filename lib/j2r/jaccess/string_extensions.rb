#!/usr/bin/env ruby
# encoding: utf-8

# File: string_extensions.rb
# Created: 29/03/12, modified with unicode gem: 29/05/14
#
# (c) Michel Demazure <michel@demazure.com>

# reopening String
class String
  # TRANSTABLE = Array.new(192, nil) +
  #     [65, 65, 65, 65, 65, 65, nil, 67] + # 128..135
  #     [69, 69, 69, 69, 73, 73, 73, 73, nil, 78] + # 136..145
  #     [79, 79, 79, 79, 79, nil, 79, 85, 85, 85] + # 146..155
  #     [85, 89, nil, nil, 97, 97, 97, 97, 97, 97] + # 156..165
  #     [nil, 99, 101, 101, 101, 101, 105, 105, 105, 105] + # 166..175
  #     [nil, 110, 111, 111, 111, 111, 111, nil, 111, 117] + # 176..185
  #     [117, 117, 117, 121, nil, 121] # 186..191
  #
  # def without_accents
  #   each_char.map do |char|
  #     val = TRANSTABLE[char.ord]
  #     val ? val.chr : char
  #   end.join
  # end
  #
  # removing accents
  # @return [String] with accents removed
  def without_accents
    decomposed = Unicode.decompose(self)
    decomposed.chars.select { |chr| chr.ord < 128 }.join
  end

  # remove accents and downcase letters
  # @return [String] downcase with accents removed
  def downcase_without_accents
    downcase.without_accents
  end
end
