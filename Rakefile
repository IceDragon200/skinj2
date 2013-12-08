#
# skinj2/Rakefile
#
require 'rubygems'
require 'rubygems/package_task'
require 'rake'
require 'rake/clean'
require 'rdoc/task'

task :doc do
  puts `yard doc lib --no-save --no-cache`
end

spec = Gem::Specification.load('skinj2.gemspec')
Gem::PackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end
