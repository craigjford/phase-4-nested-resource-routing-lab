class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
      render json: items 
    else
      items = Item.all
      render json: items, include: :user
    end  
  end

  def show
    item = Item.find(params[:id])

    if params[:user_id]
      render json: item
    else
      render json: item, include: :user
    end  

  end

  def create   

    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.create(item_params)
      render json: item, status: :created
    end

  end

  private 

  def item_params
    params.permit(:name, :description, :price)
  end

  def render_not_found_response       
    render json: { error: "Item not found" }, status: :not_found
  end

  def render_unprocessable_entity_response    
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end

end
