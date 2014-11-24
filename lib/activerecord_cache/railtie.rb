require 'activerecord_cache'
require 'rails'

class ActiveRecordCache::Railtie < Rails::Railtie

  initializer "activerecord_cache.initialize" do
    ActiveSupport.on_load(:active_record) do
      ActiveRecord::Base.send(:include, ActiveRecordCache::Base)
      ActiveRecord::Associations::BelongsToAssociation.send(:include, ActiveRecordCache::BelongsToAssociation)
      ActiveRecord::Associations::Preloader::BelongsTo.send(:include, ActiveRecordCache::BelongsToPreloader)

      # FinderMethods only gets included in ActiveRecord::Relation, so extend it there.
      # This gets around some headaches caused by extending modules already included in other classes.
      ActiveRecord::Relation.send(:include, ActiveRecordCache::FinderMethods)
    end
  end
  
end
