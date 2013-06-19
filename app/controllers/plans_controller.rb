class PlansController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init
  layout "client"

  def index
  end
  def new
  end
  def create
    @plan = @client.plans.new(params[:plan])
    if @plan.save
      redirect_to [@client, @plan], notice: t('plans.created')
    else
      render :new
    end
  end
  def show
    @payment = @plan.payments.new
  end
  def update
    respond_to do |format|
      if @plan.update_attributes(params[:plan])
        flash[:notice] = t('updated')
        format.html { redirect_to [@client, @plan] }
        format.js
      else
        format.html { render :show }  
        format.js
      end  
    end
  end
  def destroy
    if @plan.destroy
      redirect_to @client, notice: t('deleted')
    else
      render :show
    end
  end
  def create_payment
    @payment = @plan.payments.new(params[:payment])
    respond_to do |format|
      if @payment.save
        @plan.save # necessary to trigger callbacks
        @payments = @plan.payments
        flash[:notice] = t('created')
        format.html { redirect_to [@client, @plan] }  
        format.js
      else
        format.html { render :show }  
        format.js
      end  
    end
  end
  def destroy_payment
    @payment = @plan.payments.where(id: params[:id]).first
    if @payment.destroy
      @plan.save # necessary to trigger callbacks
      redirect_to [@client, @plan], notice: t('deleted')
    else
      render :show
    end
  end
  
  private
  def init
    @client = current_user.client(params[:client_id] || params[:id])
    render_404 and return unless @client
    @plans = @client.plans.where(:created_at.ne=>nil)
    @header = @client.name.to_s

    @plan = @client.plans.where(id: params[:plan_id] || params[:id]).first || Plan.new(product: Product.new)
    render_404 and return unless @plan
    @payments = @plan.payments.where(:created_at.ne=>nil)
  end
end
