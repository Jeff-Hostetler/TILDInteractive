class AuthService
  def login(params)
    user = User.find_by_email(params[:email])

    if user && user.valid_password?(params[:password])
      {
          token: user.authentication_token,
          email: user.email
      }
    end
  end
end