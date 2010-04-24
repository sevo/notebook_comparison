class StoreSweeper < ActionController::Caching::Sweeper

  observe Store

  def after_create(store)
    expire_cache_for(store)
  end

  def after_update(store)
    expire_cache_for(store)
  end


  def after_destroy(store)
    expire_cache_for(store)
  end

  private
  def expire_cache_for(record)
    expire_page(:controller => '#{record}', :action => 'stores')
  end


end