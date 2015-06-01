class UsersController < ApplicationController

  skip_before_action :authenticate_user!, only: [:create]

  def index
    if @current_user && @current_user.admin == true
      render json: User.all, each_serializer: UserSerializer
    else
      render json: access_denied_message, status: :unauthorized
    end
  end

  def create
    if params["admin"] == "true"
      render json: ["You may not create an admin user. This event has been recorded."], status: :unauthorized
      return
    end

    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password)
  end

end