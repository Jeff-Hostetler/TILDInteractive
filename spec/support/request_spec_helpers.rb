def authenticated_get(path, params = {}, headers = {}, options = {})
  auth_token = token(options)
  yield(User.last) if block_given?
  headers = headers.merge(
      "Accept" => "application/json",
      "Authorization" => "Bearer #{auth_token}"
  )
  get path, params, headers
end

def authenticated_post(path, params = "", headers = {}, options = {})
  token_headers = headers_with_token(headers, options)
  yield(User.last) if block_given?
  post path, params, token_headers
end

def authenticated_put(path, params = "", headers = {}, options = {})
  token_headers = headers_with_token(headers, options)
  yield(User.last) if block_given?
  put path, params, token_headers
end

def authenticated_patch(path, params = "", headers = {}, options = {})
  token_headers = headers_with_token(headers, options)
  yield(User.last) if block_given?
  patch path, params, token_headers
end

def authenticated_delete(path, params = "", headers = {}, options = {})
  delete path, params, headers_with_token(headers, options)
end

private

def token(options)
  user_email = options[:email]

  params = if user_email.nil?
             {
                 email: "beth@example.com",
                 password: "ilovecats",
                 first_name: "Otis",
                 last_name: "Andrews",
             }
           else
             {
                 email: user_email,
                 password: options[:password]
             }
           end

  if user_email.nil?
    User.create!(params)
  end

  AuthService.new.login(params)[:token]
end

def headers_with_token(headers, options)
  headers.reverse_merge(
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{token(options)}"
  )
end

