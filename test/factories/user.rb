FactoryGirl.define do
  factory :user do
    name "I Am Grook"
    email "iamgrook@example.com"
    password "password"
    password_confirmation "password"
  end
end