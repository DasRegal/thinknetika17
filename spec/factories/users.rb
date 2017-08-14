FactoryGirl.define do
  sequence :email do |n|
    "testmail#{n}@mail.com"
  end
  factory :user do
    email 
    password '1234567'
    password_confirmation '1234567'
  end
end
