require "rails_helper"

describe SessionsController do
  describe "#create" do
    user = TestObjectFactory.create_user
    it "sets a session id for sign in with valid info and redirects to " do
      post :create, session: {email: user.email, password: user.password}


      expect(response.status).to eq 200
      expect(session[:user_id]).to eq user.id

      result = JSON.parse(response.body, symbolize_names: true)[:user]

      expect(result.keys).to match_array([:id,
                                          :email,
                                          :first_name,
                                          :last_name,
                                          :display_name,
                                          :admin,
                                         ])
    end

    it "does not sign in if password is incorrect and renders error" do
      post :create, session: {email: user.email, password: "Incorrect-password"}

      expect(response.status).to eq 401
      expect(session[:user_id]).to eq nil

      result = JSON.parse(response.body, symbolize_names: true)[:sessions]

      expect(result).to match_array("Incorrect email and/or password.")
    end
  end
end