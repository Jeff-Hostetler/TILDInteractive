class SessionsController < ApplicationController

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
    log_in(user)
    render json: user
    else
      render json: ["Incorrect email and/or password."], status: :unauthorized
    end
  end

  private

  def log_in(user)
    session[:user_id] = user.id
  end

end