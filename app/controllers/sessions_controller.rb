class SessionsController < ApplicationController

  skip_before_action :authenticate_user_with_token!
  skip_before_action :authenticate_user!

  def create
    authorized_data = AuthService.new.login(params)

    if authorized_data
      render json: authorized_data
    else
      render json: ["Incorrect email and/or password."], status: :unauthorized
    end
  end
end