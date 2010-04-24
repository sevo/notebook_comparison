class NotebookSweeper < ActionController::Caching::Sweeper
# This sweeper is going to keep an eye on the Product model
  observe Notebook
# If our sweeper detects that a Product was created call this
  def after_create(notebook)
    expire_cache_for(notebook)
  end

# If our sweeper detects that a Product was updated call this
  def after_update(notebook)
    expire_cache_for(notebook)
  end

# If our sweeper detects that a Product was deleted call this
  def after_destroy(notebook)
    expire_cache_for(notebook)
  end

  private
  def expire_cache_for(record)
    # Expire the list page now that we added a new product
    expire_page(:controller => '#{record}', :action => 'index')

  end

end