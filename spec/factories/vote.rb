FactoryGirl.define do  
  factory :vote_up, class: 'Vote' do 
    self.voteable { |a| a.association :obj }
    status 'up'
    user
  end

  factory :vote_down, class: 'Vote' do
    self.voteable { |a| a.association :obj }
    status 'down'
    user
  end
end