FactoryGirl.define do
  sequence :answer_body do |n|
    "answer body #{n}"
  end

  factory :answer do
    user
    question
    body { generate :answer_body }
  end

  factory :invalid_answer, class: "Answer" do 
    user
    question
    body nil
  end
end
