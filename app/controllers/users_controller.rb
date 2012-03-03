class UsersController < ApplicationController
  respond_to :json
  def index
    @users = User.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
  
  def bills
    @user = User.find(params[:id])
    @unpaidBills = @user.bills.where("complete = ?", false)
    @paidBills = @user.bills.where("complete = ?", true)
  end
  
  def invoices
    @user = User.find(params[:id])
    @unpaidInvoices = @user.invoices.where("complete = ?", false)
    @paidInvoices = @user.invoices.where("complete = ?", true)
  end
  
end
