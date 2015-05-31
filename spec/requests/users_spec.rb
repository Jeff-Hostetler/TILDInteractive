require "rails_helper"

describe "Users API" do
  describe "GET /users" do
    it "responds with list of all users if user is an admin" do
      user = TestObjectFactory.create_user(email: "user@example.com", first_name: "Some", last_name: "Guy", admin: true)
      TestObjectFactory.create_user(email: "ex@example.com", first_name: "Other", last_name: "Person")

      authenticated_get "/users/",
                        params = {},
                        headers = {},
                        options = {email: user.email, password: user.password}

      expect(response.status).to eq 200

      results = JSON.parse(response.body, symbolize_names: true)[:users]

      expect(results.count).to eq 2

      expect(results.first.keys).to match_array([:id,
                                                 :email,
                                                 :first_name,
                                                 :last_name,
                                                 :display_name,
                                                 :admin
                                                ])

      expect(results[0][:email]).to eq "user@example.com"
      expect(results[0][:first_name]).to eq "Some"
      expect(results[0][:last_name]).to eq "Guy"
      expect(results[0][:admin]).to eq true

      expect(results[1][:email]).to eq "ex@example.com"
      expect(results[1][:first_name]).to eq "Other"
      expect(results[1][:last_name]).to eq "Person"
      expect(results[1][:admin]).to eq false
    end

    it "responds with an error if non-admin" do
      TestObjectFactory.create_user(email: "user@example.com", first_name: "Some", last_name: "Guy", admin: true)
      non_admin = TestObjectFactory.create_user(email: "ex@example.com", first_name: "Other", last_name: "Person")

      authenticated_get "/users/",
                        params = {},
                        headers = {},
                        options = {current_user_email: non_admin.email}

      expect(response.status).to eq 200

      results = JSON.parse(response.body, symbolize_names: true)[:users]

      expect(results).to match_array("Page is unauthorized or does not exist.")
    end
  end

  describe "POST /users" do
    before do
      TestObjectFactory.create_user(email: "person@example.com")
    end
    it "creates a new user" do
      expect(User.count).to eq 1

      params =  {first_name: "first",
                       last_name: "last",
                       email: "fl@example.com",
                       password: "password"
      }


      post "/users/", params


      expect(response.status).to eq 200

      expect(User.count).to eq 2
      expect(User.last.encrypted_password).to_not eq nil
    end

    it "renders an errors if present" do
      expect(User.count).to eq 1

      post "/users/", {email: "person@example.com"}

      expect(response.status).to eq 422
      expect(User.count).to eq 1

      body = JSON.parse(response.body, symbolize_names: true)[:users]

      expect(body).to match_array ["Email has already been taken", "Password can't be blank"]
    end

    it "does not allow admin users to be created" do
      post "/users/", {email: "person2@example.com", admin: true}

      expect(response.status).to eq 401
      expect(User.count).to eq 1

      body = JSON.parse(response.body, symbolize_names: true)[:users]

      expect(body).to match_array("You may not create an admin user. This event has been recorded.")
    end
  end
end