#!/usr/bin/env ruby
# encoding: utf-8

require 'yard'
require 'yard/rake/yardoc_task'
require 'rake/testtask'

require_relative 'lib/j2r/jaccess/version.rb'

desc 'build gem file'
task :build_gem do
  system 'gem build j2r-jaccess.gemspec'
  dest = File.join(ENV['LOCAL_GEMS'], RUBY_VERSION)
  FileUtils.mv(Dir.glob('*.gem'), dest)
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
  system ' mast lib test LICENSE Rakefile README.md HISTORY.md Gemfile > MANIFEST'
end

import('metrics.rake')
