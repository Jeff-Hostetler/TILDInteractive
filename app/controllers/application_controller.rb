class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!

  private

  class MissingAuthHeaderException < StandardError
  end

  def authenticate_user!
    #make this better
    raise MissingAuthHeaderException unless request.headers["Authorization"]
    token = request.headers["Authorization"].gsub("Bearer ", "")
    user = User.find_by(authentication_token: token)
    if Devise.secure_compare(user.authentication_token, token)
      @current_user = user
    end
  end

  def current_user
    @current_user
  end

end
