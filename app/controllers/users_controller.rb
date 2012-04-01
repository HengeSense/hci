class UsersController < ApplicationController
  respond_to :json, :html
  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end
  def show
    @user = User.find(params[:id])
    respond_with @user
  end
  
  def bills
    @user = User.find(params[:id])
    @bills = @user.bills
    @unpaidBills = @user.bills.where("complete = ?", false)    
    @paidBills = @user.bills.where("complete = ?", true)    
    respond_with(@bills)
  end
  
  def paidBills
    @user = User.find(params[:id])
    @paidBills = @user.bills.where("complete = ?", true)
    respond_with(@paidBills)
  end
  
  def unpaidBills
    @user = User.find(params[:id])
    @unpaidBills = @user.bills.where("complete = ?", false)
    respond_with(@unpaidBills)
  end
  
  def invoices
    @user = User.find(params[:id])
    @invoices = @user.invoices
    @paidInvoices = @user.invoices.where("complete = ?", true)
    @unpaidInvoices = @user.invoices.where("complete = ?", false)    
    respond_with(@invoices)
  end
  
  def unpaidInvoices
    @user = User.find(params[:id])
    @unpaidInvoices = @user.invoices.where("complete = ?", false)
    respond_with(@unpaidInvoices)
  end
  
  def paidInvoices
    @user = User.find(params[:id])
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
  
  def createItem
    @user = User.find(params[:id])
    @item = @user.sellable_items.build(params[:item])
    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
