class SessionsController < Devise::SessionsController
  responds_to :json
  def new
    super
  end
  
  def create
    super
    respond_with current_user
  end
  
  def update
    super
  end
  
  def destroy
    super
  end
  
end