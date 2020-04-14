#= Passgen
#
# Ruby gem for generating passwords quickly and easily. Although it is
# suitable for use within Rails it has no Rails dependencies and can be used in
# non-Rails applications as well.
#
#== Install
#
#  gem install cryptice-passgen --source http://gems.github.com
#
#== Usage
#
# The usage could not be easier. Just require and call the generate method:
#
#  >> require 'rubygems'
#  >> require 'passgen'
#  >> Passgen::generate
#  => "zLWCeS3xC9"
#
# == Examples
#
#  >> Passgen::generate
#  => "zLWCeS3xC9"
#
#  >> Passgen::generate(length: 20)
#  => "6lCcHvkuEW6OuzAtkoAs"
#
#  >> Passgen::generate(symbols: true)
#  => "gr)$6bIym1"
#
#  >> Passgen::generate(lowercase: :only)
#  => "ysbwuxbcea"
#
#  >> Passgen::generate(number: 3)
#  => ["REdOigTkdI", "PQu8DsV9WZ", "qptKLbw8YQ"]
#
#  >> Passgen::generate(seed: 5)
#  => "JoV9M2qjiK"
#  >> Passgen::generate(seed: 5) # Will generate same password again
#  => "JoV9M2qjiK"
#
#  >> Passgen::generate(seed: :default) # Will set random seed...
#  => "SI8QDBdV98"
#  >> Passgen::generate(seed: :default) # and hence give different password
#  => "tHHU5HLBAn"
#
# == Options:
#
# === :lowercase => true/false/:only
# * true - Use lowercase letters in the generated password.
# * false - Do not use lowercase letters in the generated password.
# * :only - Only use lowercase letters in the generated password.
#
# === :uppercase => true/false/:only
# * true - Use uppercase letters in the generated password.
# * false - Do not use uppercase letters in the generated password.
# * :only - Only use uppercase letters in the generated password.
#
# === :digits => true/false/:only
# * true - Use digits in the generated password.
# * false - Do not use digits in the generated password.
# * :only - Only use digits in the generated password.
#
# === :symbols => true/false/:only/:list
# * true - Use symbols in the generated password.
# * false - Do not use symbols in the generated password.
# * :only - Only use symbols in the generated password.
# * :list - A string with the symbols to use. Not implemented yet.
#
# === :pronounceable => true/false
# Not implmented yet.
#
# === :number => integer
# Number of passwords to generate. If >1 the result is an Array.
#
# === :length => integer/range
# The number of characters in the generated passwords. A range results in passwords
# lengths within the given range.
#
# === :seed => integer/:default
# Set the srand seed to the given integer prior to generating the passwords.
#
# === Default values:
#
# lowercase: true
#
# uppercase: true
#
# digits: true
#
# symbols: false
#
# pronounceable: Not implemented yet.
#
# number: 1
#
# length: 10
#
# seed: nil
#
# == Copyright and license
#
# Copyright (c) 2009 Erik Lindblad
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'digest'
require 'passgen/probabilities'
require 'passgen/strength_analyzer'

module Passgen

  VERSION = "1.0.0"

  DEFAULT_PARAMS = {
      number:        1,
      length:        10,
      lowercase:     true,
      uppercase:     true,
      digits:        true,
      symbols:       false,
      pronounceable: false
  }

  def self.default_seed
    Digest::MD5.hexdigest("#{rand}#{Time.now}#{Process.object_id}").to_i(16)
  end

  def self.generate(params = {})
    set_options(params)
    tokens = valid_tokens
    set_seed

    if n == 1
      generate_one(tokens)
    else
      Array.new(n) { |i| generate_one(tokens) }
    end
  end

  def self.analyze(pw)
    Passgen::StrengthAnalyzer.analyze(pw)
  end

  private

  def self.alphabet(index)
    if use_lowercase? && !use_uppercase?
      LOWERCASE_TOKENS[index]
    elsif use_uppercase? && !use_lowercase?
      UPPERCASE_TOKENS[index]
    else
      tmp = LOWERCASE_TOKENS[index]
      tmp.upcase! if rand > 0.5
      tmp
    end
  end

  def self.generate_one(tokens)
    if @options[:pronounceable]
      generate_pronounceable
    else
      Array.new(password_length) { tokens[rand(tokens.size)] }.join
    end
  end

  def self.generate_pronounceable
    password = ""

    # Append digits in front
    digits_prefix = if @options[:digits_before]
                      @options[:length] -= @options[:digits_before]
                      Array.new(@options[:digits_before]) { DIGIT_TOKENS[rand(DIGIT_TOKENS.size)] }.join
                    else
                      ""
                    end

    # Append digits at the end
    digits_suffix = if @options[:digits_after]
                      @options[:length] -= @options[:digits_after]
                      Array.new(@options[:digits_after]) { DIGIT_TOKENS[rand(DIGIT_TOKENS.size)] }.join
                    else
                      ""
                    end

    # Find a random starting point.
    found_start = false
    ranno       = rand * SIGMA # random number [0,1[ weighed by sum of frequencies
    sum         = 0;
    N_LETTERS.times do |c1|
      N_LETTERS.times do |c2|
        N_LETTERS.times do |c3|
          sum += P[c1][c2][c3]
          if sum > ranno
            password << alphabet(c1)
            password << alphabet(c2)
            password << alphabet(c3)
            found_start = true
            break
          end
        end
        break if found_start
      end
      break if found_start
    end

    # Do a random walk.
    (3...@options[:length]).each do |nchar|
      c1  = LETTER_INDEXES[password[nchar - 2..nchar - 2]]
      c2  = LETTER_INDEXES[password[nchar - 1..nchar - 1]]
      sum = 0
      N_LETTERS.times { |c3| sum += P[c1][c2][c3] }
      break if sum == 0
      ranno = rand * sum
      sum   = 0
      N_LETTERS.times do |c3|
        sum += P[c1][c2][c3]
        if sum > ranno
          password << alphabet(c3)
          break
        end
      end
    end
    digits_prefix + password + digits_suffix
  end

  def self.password_length
    if @options[:length].is_a?(Range)
      tmp = @options[:length].to_a
      tmp[rand(tmp.size)]
    else
      @options[:length].to_i
    end
  end

  def self.n
    @options[:number]
  end

  def self.set_options(params)
    if params[:lowercase] == :only
      params[:uppercase] = false
      params[:digits]    = false
    end

    if params[:uppercase] == :only
      params[:lowercase] = false
      params[:digits]    = false
    end

    if params[:digits] == :only
      params[:lowercase] = false
      params[:uppercase] = false
    end

    if params[:symbols] == :only
      params[:lowercase] = false
      params[:uppercase] = false
      params[:digits]    = false
      params[:symbols]   = true
    end

    if params[:digits_before] == true
      params[:digits_before] = 2
    end

    if params[:digits_after] == true
      params[:digits_after] = 2
    end

    @options = DEFAULT_PARAMS.merge(params)
  end

  def self.set_seed
    if @options[:seed]
      if @options[:seed] == :default
        srand(default_seed)
      else
        srand(@options[:seed])
      end
    end
  end

  def self.symbol_tokens
    %w{! @ # $ % & / ( ) + ? *}
  end

  def self.use_lowercase?
    @options[:lowercase]
  end

  def self.use_uppercase?
    @options[:uppercase]
  end

  def self.use_digits?
    @options[:digits]
  end

  def self.use_symbols?
    @options[:symbols]
  end

  def self.valid_tokens
    tmp = []
    tmp += LOWERCASE_TOKENS if use_lowercase?
    tmp += UPPERCASE_TOKENS if use_uppercase?
    tmp += DIGIT_TOKENS if use_digits?
    tmp += symbol_tokens if use_symbols?
    tmp
  end
end