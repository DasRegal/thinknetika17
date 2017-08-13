FactoryGirl.define do
  sequence :title do |n|
    "Test title #{n}"
  end

  sequence :body do |n|
    "Test body #{n}"
  end

  factory :question do
    title 
    body 
    user
    factory :question_with_answers do
      # posts_count is declared as a transient attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      transient do
        answers_count 5
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
