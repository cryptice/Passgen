module Passgen

  DEFAULT_PARAMS = {
    :number => 1,
    :length => 10,
    :lowercase => true,
    :uppercase => true,
    :digits => true,
    :symbols => false
  }

  def self.generate(params={})
    set_options(params)

    tokens = valid_tokens
    puts tokens.join

    if n == 1
      generate_one(tokens)
    else
      Array.new(n) { generate_one(tokens) }
    end
  end

  def self.generate_one(tokens)
    Array.new(@options[:length]) {tokens[rand(tokens.size)]}.join
  end

  def self.n
    @n ||= @options[:number]
  end

  def self.set_options(params)
    if params[:lowercase] == :only
      params[:uppercase] = false
      params[:digits] = false
    end

    if params[:uppercase] == :only
      params[:lowercase] = false
      params[:digits] = false
    end

    if params[:digits] == :only
      params[:lowercase] = false
      params[:uppercase] = false
    end

    if params[:symbols] == :only
      params[:lowercase] = false
      params[:uppercase] = false
      params[:digits] = false
      params[:symbols] = true
    end

    @options = DEFAULT_PARAMS.merge(params)
    p @options
  end

  def self.valid_tokens
    tmp = []
    tmp += ("a".."z").to_a if @options[:lowercase]
    tmp += ("A".."Z").to_a if @options[:uppercase]
    tmp += ("0".."9").to_a if @options[:digits]
    tmp += %w{! @ # $ % & / ( ) + ? *} if @options[:symbols]
    tmp
  end
end