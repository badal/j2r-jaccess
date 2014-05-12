require 'rubygems/package_task'
require 'yard'
require 'yard/rake/yardoc_task'
require 'rake/testtask'
# require "cucumber/rake/task"

require_relative 'lib/j2r/jaccess.rb'

spec = Gem::Specification.new do |s|
  s.name = 'j2r-jaccess'
  s.version = J2R::VERSION
  s.has_rdoc = true
  s.extra_rdoc_files = %w(README.md LICENSE)
  s.summary = 'To be replaced'
  s.description = 'To be replaced'
  s.author = 'Michel Demazure'
  s.email = 'michel@demazure.com'
  # s.executables = ['your_executable_here']
  s.files = %w(LICENSE README.md HISTORY.md MANIFEST Rakefile) + Dir.glob('{bin,lib,spec}/**/*')
  s.require_path = 'lib'
  s.bindir = 'bin'
end

Gem::PackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
 # p.need_zip = true
end

YARD::Rake::YardocTask.new do |t|
  t.options += ['--title', "j2r-jaccess #{J2R::VERSION} Documentation"]
  t.options += %w(--files LICENSE)
end

Rake::TestTask.new do |t|
  t.libs.push 'lib'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

desc 'build Manifest'
task :manifest do
  system ' mast -x bin -x metrics -x doc -x help -x coverage -x pkg * > MANIFEST'
end

# Cucumber::Rake::Task.new do |task|
#  task.cucumber_opts = ["features"]
# end

import('metrics.rake')
