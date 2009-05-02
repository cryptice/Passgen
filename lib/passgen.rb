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
    set_seed

    if n == 1
      generate_one(tokens)
    else
      Array.new(n) {|i| generate_one(tokens) }
    end
  end

  def self.generate_one(tokens)
    Array.new(password_length) {tokens[rand(tokens.size)]}.join
  end

  def self.set_seed
    if @options[:seed]
      if @options[:seed] == :default
        srand(Digest::MD5.hexdigest("#{rand}#{Time.now}#{Process.object_id}").to_i(16))
      else
        srand(@options[:seed])
      end
    end
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