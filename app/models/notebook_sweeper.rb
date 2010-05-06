class NotebookSweeper < ActionController::Caching::Sweeper
# This sweeper is going to keep an eye on the Product model
  observe Notebook
# If our sweeper detects that a Product was created call this
  def after_create
    expire_cache
  end

# If our sweeper detects that a Product was updated call this
  def after_update
    expire_cache
  end

# If our sweeper detects that a Product was deleted call this
  def after_destroy
    expire_cache
  end

  private
  def expire_cache
    # Expire the list page now that we added a new product
    expire_page(:controller => "/euroshop", :action => "index")

  end

end