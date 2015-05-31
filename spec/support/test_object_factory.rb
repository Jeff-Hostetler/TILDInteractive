class TestObjectFactory
  class << self
    def new_user(overrides = {})
      random_string = (0...8).map { (65 + rand(26)).chr }.join
      defaults = {
          first_name: "Beth#{random_string}",
          last_name: "Jones",
          email: "user#{random_string}@example.com",
          password: "fake-password",
          password_confirmation: "fake-password"
      }

      User.new(defaults.merge(overrides))
    end

    def create_user(overrides = {})
      new_user(overrides).tap(&:save!)
    end
  end
end