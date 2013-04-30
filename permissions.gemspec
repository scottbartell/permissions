$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "permissions/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "permissions"
  s.version     = Permissions::VERSION
  s.authors     = ["James Pinto"]
  s.email       = ["james@rubyfactory.net"]
  s.homepage    = "https://github.com/yakko/permissions"
  s.summary     = "Simplified authorization for Rails."
  s.description = "All your Rails authorization logic stored in the permission.rb file, the DSL is very similar to routes.rb making it easy for rails developers to learn and implement."


  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  #s.add_dependency "rails", "~> 4.0.0.beta1"
  s.add_dependency "colorize"

  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
