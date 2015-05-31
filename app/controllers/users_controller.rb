class UsersController < ApplicationController

  def index
    render json: User.all, each_serializer: UserSerializer
  end

  def create
    if params["admin"] == true
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
    params.require(:user).permit(:first_name, :last_name, :email)
  end

end