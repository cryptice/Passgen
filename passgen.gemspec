# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{passgen}
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Erik Lindblad"]
  s.date = %q{2020-03-31}
  s.description = %q{A password generation gem for Ruby and Rails applications.}
  s.email = %q{erik@l2c.se}
  s.extra_rdoc_files = ["CHANGELOG", "README.rdoc", "lib/passgen.rb", "lib/passgen/probabilities.rb", "lib/passgen/strength_analyzer.rb"]
  s.files = ["CHANGELOG", "Manifest", "README.rdoc", "Rakefile", "rails/init.rb", "lib/passgen.rb", "lib/passgen/probabilities.rb", "lib/passgen/strength_analyzer.rb", "passgen.gemspec", "spec/passgen/strength_analyzer_spec.rb", "spec/passgen_spec.rb"]
  s.homepage = %q{http://github.com/cryptice/passgen}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Passgen", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A password generation gem for Ruby and Rails applications.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
