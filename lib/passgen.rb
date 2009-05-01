module Passgen

  DEFAULT_PARAMS = {
    :length => 10,
    :lowercase => true,
    :uppercase => true,
    :digits => true,
    :symbols => false
  }

  def self.generate(params={})
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
end