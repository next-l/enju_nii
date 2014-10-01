$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "enju_nii/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "enju_nii"
  s.version     = EnjuNii::VERSION
  s.authors     = ["Kosuke Tanabe"]
  s.email       = ["nabeta@fastmail.fm"]
  s.homepage    = "https://github.com/next-l/enju_nii"
  s.summary     = "enju_nii plugin"
  s.description = "add nii_type attribute to Next-L Enju"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"] - Dir["spec/dummy/log/*"] - Dir["spec/dummy/solr/{data,pids}/*"]

  s.add_dependency "enju_biblio", "~> 0.1.0.pre59"
  s.add_dependency "faraday"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 3.0.2"
  s.add_development_dependency "vcr"
  s.add_development_dependency "webmock"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "enju_leaf", "~> 1.1.0.rc14"
  s.add_development_dependency "enju_subject", "~> 0.1.0.pre27"
end
