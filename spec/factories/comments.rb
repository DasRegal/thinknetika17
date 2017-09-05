FactoryGirl.define do
  factory :comment, class: 'Comment' do
   self.commentable { |a| a.association :obj }
   user
   body 'some body'

   trait :invalid do 
    body nil
   end
  end
end
