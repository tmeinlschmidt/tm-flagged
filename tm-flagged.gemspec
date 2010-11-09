# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tm-flagged}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tom Meinlschmidt"]
  s.date = %q{2010-11-09}
  s.description = %q{Adds support for flags with using only one column in db}
  s.email = %q{tom@meinlschmidt.org}
  s.files = ["lib/flagged_model.rb", "CHANGELOG.rdoc", "init.rb", "Rakefile", "README.rdoc"]
  s.homepage = %q{http://tom.meinlschmidt.org}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Adds support for flags with using only one column in db}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
