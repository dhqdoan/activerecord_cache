require 'activerecord_cache'
require 'rails'

class ActiveRecordCache::Railtie < Rails::Railtie

  initializer "activerecord_cache.initialize" do
    ActiveSupport.on_load(:active_record) do
      ActiveRecord::Base.send(:include, ActiveRecordCache::Base)
      ActiveRecord::FinderMethods.send(:include, ActiveRecordCache::FinderMethods)
      ActiveRecord::Associations::BelongsToAssociation.send(:include, ActiveRecordCache::BelongsToAssociation)
    end
  end
  
end
