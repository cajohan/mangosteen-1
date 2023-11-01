class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.page(params[:page]).per(100)
    # items = Item.where("id>?",params[start_id]).limit(100) 如果是流形式内容，id需自增数字
    render json: { resources: items, pager: {
             page: params[:page],
             per_page: 100,
             count: Item.count,
           } }
  end

  def create
    item = Item.new amount: 1
    if item.save
      render json: { resource: item }
    else
      render json: { errors: item.errors }
    end
  end
end
