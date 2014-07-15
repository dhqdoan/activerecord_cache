module ActiveRecordCache
end

require File.join(File.dirname(__FILE__), 'activerecord_cache/base')
require File.join(File.dirname(__FILE__), 'activerecord_cache/finder_methods')
require File.join(File.dirname(__FILE__), 'activerecord_cache/belongs_to_association')
require File.join(File.dirname(__FILE__), 'activerecord_cache/belongs_to_preloader')
require File.join(File.dirname(__FILE__), 'activerecord_cache/relation')
require File.join(File.dirname(__FILE__), 'activerecord_cache/errors')

require 'activerecord_cache/railtie.rb' if defined?(Rails)
