FactoryBot.define do
  factory :user do
    email {"test@user.com"}
    password {"qwerty"}
  end

  # left to show an example of different user types
  # factory :admin do
  #   email {"test@admin.com"}
  #   password {"qwerty"}
  #   admin {true}
  # end
end