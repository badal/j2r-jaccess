#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems/package_task'
require 'yard'
require 'yard/rake/yardoc_task'
require 'rake/testtask'
# require "cucumber/rake/task"

require_relative 'lib/j2r/jaccess/version.rb'

spec = Gem::Specification.new do |s|
  s.name = 'j2r-jaccess'
  s.version = JacintheReports::Jaccess::VERSION
  s.has_rdoc = true
  s.extra_rdoc_files = %w(README.md LICENSE)
  s.summary = 'To be replaced'
  s.description = 'To be replaced'
  s.author = 'Michel Demazure'
  s.email = 'michel@demazure.com'
  s.add_dependency('mysql2', '0.3.13')
  s.add_dependency('sequel')
  s.add_dependency('unicode')
  # s.executables = ['your_executable_here']
  s.files = %w(LICENSE README.md HISTORY.md MANIFEST Rakefile) + Dir.glob('{bin,lib,spec}/**/*')
  s.require_path = 'lib'
  s.bindir = 'bin'
end

Gem::PackageTask.new(spec) do |p|
  p.package_dir = ENV['LOCAL_GEMS']
  p.gem_spec = spec
  p.need_tar = false
 # p.need_zip = true
end

YARD::Rake::YardocTask.new do |t|
  t.options += ['--title', "JacintheReports #{JacintheReports::Jaccess::VERSION} Documentation"]
  t.options += %w(--files LICENSE)
  t.options += %w(--files HISTORY.md)
  t.options += %w(--files TODO.md)
  t.options += %w(--verbose)
end

desc 'show not documented'
task :yard_not_documented do
  system 'yard stats --list-undoc'
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
