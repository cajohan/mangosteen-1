class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.where({created_at: params[:created_after]..params[:created_before]}).page(params[:page])
    # items = Item.where("id>?",params[start_id]).limit(100) 如果是流形式内容，id需自增数字
    render json: { resources: items, pager: {
             page: params[:page] || 1,
             per_page: Item.default_per_page,
             count: Item.count,
           } }
  end

  def create
    item = Item.new amount: params[:amount]
    if item.save
      render json: { resource: item }
    else
      render json: { errors: item.errors }
    end
  end
end
