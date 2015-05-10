$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "foreman_chef/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "foreman_chef"
  s.version     = ForemanChef::VERSION
  s.authors     = ["Marek Hulan"]
  s.email       = ["ares@igloonet.cz"]
  s.homepage    = "https://github.com/theforeman/foreman_chef"
  s.summary     = "Plugin for Chef integration with Foreman"
  s.description = "Foreman extensions that are required for better Chef integration."
  s.licenses    = ['GPL-3']

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"
  s.add_dependency "deface", "< 1.0"
  s.add_dependency "foreman-tasks", '~> 0.6.9'

  s.add_development_dependency "sqlite3"
end
