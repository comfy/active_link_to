# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{active_link_helper}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Oleg Khabarov"]
  s.date = %q{2009-03-18}
  s.description = %q{Easily manage currently active links}
  s.email = %q{oleg@theworkinggroup.ca}
  s.extra_rdoc_files = ["CHANGELOG", "lib/active_link_helper.rb", "README.rdoc"]
  s.files = ["active_link_helper.gemspec", "CHANGELOG", "init.rb", "lib/active_link_helper.rb", "Manifest", "Rakefile", "README.rdoc"]
  s.has_rdoc = true
  s.homepage = %q{http://theworkinggroup.ca}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Active_link_helper", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{active_link_helper}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Easily manage currently active links}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
