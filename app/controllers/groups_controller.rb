class GroupsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init, only: [:index, :create]
  before_filter :init2, only: [:search_clients, :add, :remove, :show, :update, :destroy]
  layout "group"
  def index
    render layout: "list"
  end
  def create
    @group = current_user.groups.new(params[:group])
    respond_to do |format|
      if @group.save
        msg = t('created')
        format.html { flash[:notice] = msg; redirect_to groups_path }
        format.js { render json: [{id: @group.id, name: @group.name}].to_json, status:201 }
      else
        format.html { render :index, layout:"list" } 
        format.js { render json: [].to_json } 
      end
    end
  end
  def search_clients
    @group = current_user.group(params[:group_id])
    @search_clients = current_user.search_clients(params[:q]).page params[:page]
    respond_to do |format|
      if @search_clients
        format.js { render layout: "list" }
      end
    end
  end
  def add
    client = current_user.client(params[:client_id])
    @group.add_client(client.id)
    if @group.save
      redirect_to @group
    else
      render :index
    end
  end
  def remove
    client = current_user.client(params[:client_id])
    @group.remove_client(client.id)
    if @group.save
      redirect_to @group
    else
      render :index
    end
  end
  def show
    @clients = @group.clients
    respond_to do |format|
      format.html
      format.pdf {render :pdf=>@group.id.to_s, :formats=>['pdf.html.erb']}
    end
  end
  def update
    if @group.update_attributes(params[:group])
      flash[:notice] = t('updated'); redirect_to @group
    else 
      render :show
    end
  end
  def destroy
    if @group.destroy
      redirect_to groups_path, notice: t('deleted')
    else
      render :index
    end
  end
  

  private
  def init
    @groups = current_user.get_groups
    @group = Group.new
    @header = t("groups.groups")
  end
  def init2
    @groups = current_user.get_groups
    @group = current_user.group(params[:group_id] || params[:id])
    @header = @group.name
  end
end
