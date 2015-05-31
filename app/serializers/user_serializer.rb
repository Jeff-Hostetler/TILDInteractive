class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :email,
             :first_name,
             :last_name,
             :display_name,
             :admin

  def display_name
    "#{object.try(:first_name)} #{object.try(:last_name)}"
  end
end