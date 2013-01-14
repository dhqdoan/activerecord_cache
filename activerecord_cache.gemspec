require File.join(File.dirname(__FILE__), 'lib/activerecord_cache/version')

Gem::Specification.new do |s|
  s.name        = 'activerecord_cache'
  s.version     = ActiveRecordCache::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['David Doan']
  s.email       = ['davedoan@gmail.com']
  s.homepage    = 'https://github.com/davedoan/activerecord_cache'
  s.summary     = 'A basic caching plugin for ActiveRecord'
  s.description = 'Caches ActiveRecord models for simple finds using the Rails low-level cache'

  # s.rubyforge_project = 'activerecord_cache'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']

  s.licenses = ['MIT']

  s.add_dependency 'rails', ['>= 3.1.3', '<= 3.3.0']
end
