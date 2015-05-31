require "rails_helper"

describe "Sessions API" do
  describe "#create" do
    user = TestObjectFactory.create_user
    it "sets token with valid info" do
      p user.password
      post "/sessions/",  {email: user.email, password: user.password}


      expect(response.status).to eq 200

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data.keys).to match_array([:email,
                                          :token,
                                         ])

      expect(data[:token]).to eq user.authentication_token
    end

    it "does not sign in if password is incorrect and renders error" do
      post "/sessions/", {email: user.email, password: "Incorrect-password"}

      expect(response.status).to eq 401

      result = JSON.parse(response.body, symbolize_names: true)[:sessions]

      expect(result).to match_array("Incorrect email and/or password.")
    end
  end
end