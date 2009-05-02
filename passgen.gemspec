# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{passgen}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Erik Lindblad"]
  s.date = %q{2009-05-02}
  s.description = %q{A password generation gem for Ruby and Rails applications.}
  s.email = %q{eriklindblad3@gmail.com}
  s.extra_rdoc_files = ["lib/passgen.rb", "CHANGELOG", "README.rdoc"]
  s.files = ["spec/passgen_spec.rb", "Rakefile", "Manifest", "lib/passgen.rb", "CHANGELOG", "init.rb", "passgen.gemspec", "nbproject/project.xml", "nbproject/project.properties", "README.rdoc"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/cryptice/passgen}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Passgen", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{passgen}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A password generation gem for Ruby and Rails applications.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
