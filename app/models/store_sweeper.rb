class StoreSweeper < ActionController::Caching::Sweeper

  observe Store

  def after_create
    expire_cache
  end

  def after_update
    expire_cache
  end


  def after_destroy
    expire_cache
  end

  private
  def expire_cache
    expire_page(:controller => :euroshop, :action => :stores)
  end


end