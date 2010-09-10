# Rakefile
require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('passgen', '0.9.0') do |p|
  p.description    = "A password generation gem for Ruby and Rails applications."
  p.url            = "http://github.com/cryptice/passgen"
  p.author         = "Erik Lindblad"
  p.email          = "erik@l2c.se"
  p.ignore_pattern = ["tmp/*", "script/*", "nbproject/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
