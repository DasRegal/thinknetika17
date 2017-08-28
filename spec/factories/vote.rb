FactoryGirl.define do  
  factory :vote, class: 'Vote' do
   self.voteable { |a| a.association :obj }
   user

   trait :up do 
    status 1
   end

   trait :down do 
    status -1
   end
  end
end