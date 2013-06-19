class Api::MainController < ApplicationController
  before_filter :authenticate_user!

  def group_profit
    group = current_user.group(params[:group])
    respond_to do |f|
      if group
        f.json { render json: group.highest_profit_clients.to_json }
      else
        f.json { render json: [], status:403 }
      end
    end
  end
  def group_paid_sum
    group = current_user.group(params[:group])
    respond_to do |f|
      if group
        f.json { render json: group.highest_paid_clients.to_json }
      else
        f.json { render json: [], status:403 }
      end
    end
  end
  def group_remaining
    group = current_user.group(params[:group])
    respond_to do |f|
      if group
        f.json { render json: group.highest_remaining_clients.to_json }
      else
        f.json { render json: [], status:403 }
      end
    end
  end
  
end