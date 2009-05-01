module Passgen

  DEFAULT_PARAMS = {
    :length => 10,
    :lowercase => true,
    :uppercase => true,
    :digits => true,
    :symbols => false
  }

  def self.generate(params={})
    parse_valid_tokens(params)
    options = DEFAULT_PARAMS.merge(params)
    p params

    valid_tokens = []
    
    valid_tokens += ("a".."z").to_a if options[:lowercase]
    valid_tokens += ("A".."Z").to_a if options[:uppercase]
    valid_tokens += ("0".."9").to_a if options[:digits]
    valid_tokens += %w{! @ # £ $ % & / ( ) + ? *} if options[:symbols]
    puts valid_tokens.join
    
    Array.new(options[:length]) {valid_tokens[rand(valid_tokens.size)]}.join
  end

  def self.parse_valid_tokens(params)
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
  end
end