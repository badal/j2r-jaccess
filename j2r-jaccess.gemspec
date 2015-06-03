# encoding: utf-8

dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(dir) unless $LOAD_PATH.include?(dir)

require 'lib/j2r/jaccess/version'

Gem::Specification.new do |s|
  s.name = 'j2r-jaccess'
  s.version = JacintheReports::Jaccess::VERSION
  s.has_rdoc = true
  s.extra_rdoc_files = %w(README.md LICENSE)
  s.summary = 'Access methods for Jacinthe'
  s.description = 'Base gem for Jacinthe, to be used by j2r-core and j2r-qt'
  s.author = 'Michel Demazure'
  s.email = 'michel@demazure.com'
  s.add_dependency('mysql2')
  s.add_dependency('sequel')
  s.add_dependency('unicode')
  s.files = %w(LICENSE README.md HISTORY.md MANIFEST Rakefile) + Dir.glob('{bin,lib,test}/**/*')
  s.require_path = 'lib'
end
