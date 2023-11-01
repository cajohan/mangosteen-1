class UsersController < ApplicationController
  def create
    user = User.new email:'huangdi@x.com', name: 'huangd'
    if user.save
      p 'save'
      render json: user
    else
      p 'fail'
      render json: user.errors
    end
  end

  def show
    user = User.find_by_id params[:id]
    if user
      render json:user
      p '你访问了show'
    else
      head 404
      p '你访问了show1'
    end
  end
end
