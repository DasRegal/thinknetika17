require 'rails_helper'

RSpec.describe User do 
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it 'author_of methods work correct' do 
    user = create :user
    question = create :question
    answer = create :answer
    expect(user.author_of?(question)).to eq false
    expect(user.author_of?(answer)).to eq false

    question.user = user
    answer.user = user
    expect(user.author_of?(question)).to eq true
    expect(user.author_of?(answer)).to eq true
  end
end