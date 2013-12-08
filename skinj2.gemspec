#
# skinj2/skinj2.gemspec
#
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'skinj2/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "skinj2"
  s.summary     = "Pre-Processor esque library in ruby"
  s.description = %q(C style pre-processor in ruby)
  s.date        = %q(2013-05-24)
  s.version     = Skinj2::VERSION
  s.homepage    = %q{https://github.com/IceDragon200/skinj2}
  s.license     = 'MIT'

  s.author = "Corey Powell"
  s.email  = %q{mistdragon100@gmail.com}

  s.add_dependency("thor")
  s.add_bindir("bin")
  s.files = ["Rakefile", "LICENSE", "README.md"]
  s.files.concat(Dir.glob("lib/**/*"))
  s.files.concat(Dir.glob("bin/**/*"))
  s.files.concat(Dir.glob("test/**/*"))
  s.test_file = 'test/test-suite.rb'
  s.require_path = "lib"
end
