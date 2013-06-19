class ClientsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init, only:[:index, :create, :search]
  before_filter :init2, only:[:show, :update, :destroy]

  def index
    render layout: "list"
  end
  def create
    @client = current_user.clients.new(params[:client])
    respond_to do |format|
      if @client.save
        group = current_user.group(params[:group_id])
        (group.add_client(@client.id) and group.save) if group

        msg = t('clients.created')
        format.html { flash[:notice] = msg; redirect_to clients_path }
        format.js { render json: [{msg: [msg], clientname: @client.name, clientid: @client.id}].to_json, status:201 }
      else
        format.html { render :index, layout: "list" }  
        format.js { render json: [{msg: @client.errors.full_messages}].to_json, status:403 }
      end
    end
  end
  def search
    respond_to do |format|
      if @clients
        format.html { render :index, layout: "list" }
        format.js { render layout: "list" }
      end
    end
  end
  def show
    render layout: "client"
  end
  def update
    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.html { flash[:notice] = t('updated'); redirect_to client_path(@client) }
        format.js { render json: [{msg: [t('updated')]}].to_json, status:201 }
      else
        format.html { render :show, layout: "client" }  
        format.js { render json: [{msg: @client.errors.full_messages}].to_json, status:403 }
      end  
    end
  end
  def destroy
    if @client.destroy
      redirect_to clients_path, notice: t('deleted')
    else
      render :show, layout: "client"
    end
  end

  private
  def init
    @header = t("clients.clients")
    @clients = current_user.search_clients(params[:q].to_s).page params[:page]
    @client = current_user.clients.new
    @group = Group.new
  end
  def init2
    @client = current_user.client(params[:client_id] || params[:id])
    render_404 and return unless @client
    @plans = @client.plans.where(:created_at.ne=>nil)
    @header = @client.name.to_s
  end
end
