# encoding: utf-8

dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(dir) unless $LOAD_PATH.include?(dir)

require 'lib/j2r/jaccess/version'

Gem::Specification.new do |s|
  s.name = 'j2r-jaccess'
  s.version = JacintheReports::Jaccess::VERSION
  s.has_rdoc = true
  s.extra_rdoc_files = %w(README.md LICENSE)
  s.summary = 'To be replaced'
  s.description = 'To be replaced'
  s.author = 'Michel Demazure'
  s.email = 'michel@demazure.com'
  if RUBY_PLATFORM =~ /mswin|mingw/
    s.add_dependency('mysql2', '0.3.13')
  else
    s.add_dependency('mysql2')
  end
  s.add_dependency('sequel')
  s.add_dependency('unicode')
  s.files = %w(LICENSE README.md HISTORY.md MANIFEST Rakefile) + Dir.glob('{bin,lib,test}/**/*')
  s.require_path = 'lib'
end
