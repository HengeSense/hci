class UsersController < ApplicationController
  respond_to :json, :html
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
    respond_with(@paidBills)
  end
  
  def unpaidbills
    @user = User.find(params[:id])
    @unpaidBills = @user.bills.where("complete = ?", false)
    respond_with(@unpaidBills)
  end
  
  def unpaidinvoices
    @user = User.find(params[:id])
    @unpaidInvoices = @user.invoices.where("complete = ?", false)
    respond_with(@unpaidInvoices)
  end
  
  def invoices
    @user = User.find(params[:id])
    @unpaidInvoices = @user.invoices.where("complete = ?", false)
    @paidInvoices = @user.invoices.where("complete = ?", true)
    respond_with(@paidInvoices)
  end
  
  def unpaidTransactions
    @user = User.find(params[:id])
    @unpaidInvoices = @user.invoices.where("complete = ?", false)
    @unpaidBills = @user.bills.where("complete = ?", false)
    @unpaidTransactions = @unpaidInvoices |= @unpaidBills
    respond_with(@unpaidTransactions)
  end
  
  def paidTransactions
    @user = User.find(params[:id])
    @invoices = @user.invoices.where("complete = ?", true)
    @bills = @user.bills.where("complete = ?", true)
    @paidTransactions = @invoices |= @bills
    respond_with(@paidTransactions)
  end
  
end
