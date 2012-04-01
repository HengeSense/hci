class PagesController < ApplicationController
  
  def index    
    @users = User.all
    @transactions = Transaction.all
    if !user_signed_in?
      redirect_to new_user_session_path
    end
  end
  
end
