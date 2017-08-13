FactoryGirl.define do
  factory :answer do
    user
    question
    body 'body text'
  end

  factory :invalid_answer, class: "Answer" do 
    user
    question
    body nil
  end
end
