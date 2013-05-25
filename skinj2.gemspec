#
# Sadie/sadie.gemspec
#
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'skinj2/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "skinj2"
  s.summary     = "Pre-Processor esque library in ruby"
  s.description = %q(Written as a pre-processor for ruby in ruby, it enables quite flexible and a very modular design)
  s.date        = %q(2013-05-24)
  s.version     = Skinj2::VERSION
  s.homepage    = %q{https://github.com/IceDragon200/Sadie}
  s.license     = 'MIT'

  s.author = "Corey Powell"
  s.email  = %q{mistdragon100@gmail.com}

  s.require_path = "lib"
  s.test_file = 'test/test-suite.rb'
  s.files = ["Rakefile", "LICENSE", "README.md"]
  s.files.concat(Dir.glob("lib/**/*"))
  s.files.concat(Dir.glob("test/**/*"))
end
