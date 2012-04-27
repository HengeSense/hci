class TransactionsController < ApplicationController
#  before_filter :authenticate_user!
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
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transaction }
    end
  end

  # GET /transactions/new
  # GET /transactions/new.json
  def new
    @transaction = current_user.bills.build
    3.times do
      @transaction.items.build
    end
    @transaction.items.each do |i|
      i.merchant_id = current_user.id
      i.price_points.build
    end
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
    @transaction.recipient_email = current_user.email
    if @sender
      @transaction.sender_id = @sender.id
    end
    respond_to do |format|
      if @sender and @sender != current_user and @transaction.save
        format.html { redirect_to @transaction, notice: 'Invoice successfully sent!' }
        format.json { render json: @transaction, status: :created, location: @transaction }
        UserMailer.requestMoney_invitation(params[:transaction][:sender_email], current_user, @transaction).deliver
      elsif !@sender and @sender != current_user and @transaction.save
        UserMailer.requestMoney_invitation(params[:transaction][:sender_email], current_user, @transaction).deliver
        format.html { redirect_to @transaction, notice: 'Invoice successfully sent!' }
        format.json { render json: @transaction, status: :created, location: @transaction }
      else
        logger.info @transaction.errors.as_json
        logger.info @transaction.errors.blank?
        logger.info current_user.nil?
        logger.info current_user.email
        logger.info @sender.as_json
        format.html { render action: "new" }
        format.json { render json: @transaction.errors, status: :forbidden }
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
    @transaction.sender_email = current_user.email
    if @recipient
      @transaction.recipient_id = @recipient.id
    end
    @amount = params[:transaction][:amount].to_i
    logger.debug @recipient
    respond_to do |format|
      if @recipient and @recipient != current_user and @transaction.save

        # ## -----------------------------------------
        # ## Create Pubnub Client API (INITIALIZATION)
        # ## -----------------------------------------
        # puts('Creating new PubNub Client API')
        # pubnub = Pubnub.new(
        # publish_key   = 'pub-c-81a1ecf7-18a0-4e60-beb0-811d233028a0',
        # subscribe_key = 'sub-c-acd74d61-7af7-11e1-b628-2706ba9f8a00',
        # secret_key    = 'sec-c-8ecbd036-6733-495e-8e8c-64b1b01f1261',
        # ssl_on        = false
        # )
        # ## ----------------------
        # ## Send Message (PUBLISH)
        # ## ----------------------
        # puts('Broadcasting Message')
        # message = { 'some_data' => 'my data here' }
        # info    = pubnub.publish({
        #     'channel' => 'simpleMoney',
        #     'message' => message
        # })
        #
        # ## Publish Success?
        # puts(info)
        #
        # ## --------------------------------
        # ## Request Past Publishes (HISTORY)
        # ## --------------------------------
        # puts('Requesting History')
        # messages = pubnub.history({
        #     'channel' => 'simpleMoney',
        #     'limit'   => 10
        # })
        #
        # puts(messages)


        current_user.decreaseBalance(@amount)
        @recipient.increaseBalance(@amount)
        UserMailer.sendMoney_invitation(params[:transaction][:recipient_email], current_user, @transaction).deliver
        format.html { redirect_to @transaction, notice: 'Money successfully sent!' }
        format.json { render json: @transaction, status: :created, location: @transaction }
      elsif !@recipient and @recipient != current_user and @transaction.save
        current_user.decreaseBalance(@amount)
        UserMailer.sendMoney_invitation(params[:transaction][:recipient_email], current_user, @transaction).deliver
        format.html { redirect_to @transaction, notice: 'Money successfully sent!' }
        format.json { render json: @transaction, status: :created, location: @transaction }
      else
        format.html { render action: "new" }
        format.json { render json: @transaction.errors, status: :forbidden }
      end
    end
  end


  # POST /transactionWithRecommendation.json
  def createAndReturnRecommendation
    @recipient = User.find_by_email(params[:transaction][:recipient_email])
    @transaction = current_user.bills.build(params[:transaction])
    @recommendation = User.where("is_merchant = 1").offset(rand(Thing.count)).first

    if @recipient
      @transaction.recipient_id = @recipient.id
    end
    @amount = params[:transaction][:amount].to_i
    logger.debug @recipient
    respond_to do |format|
      if @recipient and @recipient != current_user and @transaction.save

        # ## -----------------------------------------
        # ## Create Pubnub Client API (INITIALIZATION)
        # ## -----------------------------------------
        # puts('Creating new PubNub Client API')
        # pubnub = Pubnub.new(
        # publish_key   = 'pub-c-81a1ecf7-18a0-4e60-beb0-811d233028a0',
        # subscribe_key = 'sub-c-acd74d61-7af7-11e1-b628-2706ba9f8a00',
        # secret_key    = 'sec-c-8ecbd036-6733-495e-8e8c-64b1b01f1261',
        # ssl_on        = false
        # )
        # ## ----------------------
        # ## Send Message (PUBLISH)
        # ## ----------------------
        # puts('Broadcasting Message')
        # message = { 'some_data' => 'my data here' }
        # info    = pubnub.publish({
        #     'channel' => 'simpleMoney',
        #     'message' => message
        # })
        #
        # ## Publish Success?
        # puts(info)
        #
        # ## --------------------------------
        # ## Request Past Publishes (HISTORY)
        # ## --------------------------------
        # puts('Requesting History')
        # messages = pubnub.history({
        #     'channel' => 'simpleMoney',
        #     'limit'   => 10
        # })
        #
        # puts(messages)


        current_user.decreaseBalance(@amount)
        @recipient.increaseBalance(@amount)
        UserMailer.sendMoney_invitation(params[:transaction][:recipient_email], current_user, @transaction).deliver
        format.html { redirect_to @transaction, notice: 'Money successfully sent!' }
        format.json { render json => {:transaction => @transaction,
                                      :merchant => @recommendation,
                                      :user => @recipient}, status: :created, location: @transaction }
      else
        format.html { render action: "new" }
        format.json { render json: @transaction.errors, status: :bad_request }
      end
    end
  end

  # PUT /transactions/1
  # PUT /transactions/1.json
  def update
    @transaction = Transaction.find(params[:id])
    @sender = User.find_by_email(@transaction.sender_email)
    @recipient = User.find_by_email(@transaction.recipient_email)
    @amount = @transaction.amount.cents
    @wasComplete = @transaction.complete
    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        if !@wasComplete && @transaction.complete
          @sender.decreaseBalance(@amount)
          @recipient.increaseBalance(@amount)
        else
          logger.debug @sender
        end
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render json: @transaction, status: :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @transaction.errors, status: :forbidden }
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
