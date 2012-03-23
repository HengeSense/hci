class TransactionsController < ApplicationController
  respond_to :json, :html
  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transactions }
    end
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
    @transaction = Transaction.find(params[:id])
    @sender = User.find_by_email(@transaction.sender_email)
    @recipient = User.find_by_email(@transaction.recipient_email)    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transaction }
    end
  end

  # GET /transactions/new
  # GET /transactions/new.json
  def new
    @transaction = current_user.bills.build
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transaction }
    end
  end

  def newInvoice
    @transaction = Transaction.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transaction }
    end
  end

  def createInvoice
    @sender = User.find_by_email(params[:transaction][:sender_email])
    @transaction = current_user.invoices.build(params[:transaction])
    respond_to do |format|
      if @sender and @sender != current_user and @transaction.save
        format.html { redirect_to @transaction, notice: 'Invoice successfully sent!' }
        format.json { render json: @transaction, status: :created, location: @transaction }
      else
        format.html { render action: "new" }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /transactions/1/edit
  def edit
    @transaction = Transaction.find(params[:id])
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @recipient = User.find_by_email(params[:transaction][:recipient_email])
    @transaction = current_user.bills.build(params[:transaction])
    @amount = params[:transaction][:amount].to_d
    respond_to do |format|
      if @recipient and @recipient != current_user and @transaction.save
        current_user.decreaseBalance(@amount)
        @recipient.increaseBalance(@amount)
        format.html { redirect_to @transaction, notice: 'Money successfully sent!' }
        format.json { render json: @transaction, status: :created, location: @transaction }
      else
        format.html { render action: "new" }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /transactions/1
  # PUT /transactions/1.json
  def update
    @transaction = Transaction.find(params[:id])
    @sender = User.find_by_email(@transaction.sender_email)
    @recipient = User.find_by_email(@transaction.recipient_email)
    @amount = @transaction.amount.to_d
    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        if @sender == current_user
          current_user.decreaseBalance(@amount)
          @recipient.increaseBalance(@amount)
        elsif @sender == current_user
          current_user.increaseBalance(@amount)
        else
          logger.debug @sender
        end
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render json: @transaction, status: :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to transactions_url }
      format.json { head :no_content }
    end
  end
end
