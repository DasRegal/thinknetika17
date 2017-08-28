require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :voteable }
  it { should validate_presence_of :status }

  context '.vote?' do 
    before do 
      @user = create(:user)
      @question = create(:question)
      vote_up = create(:vote_up, user: @user, voteable: @question)
      @question2 = create(:question)
    end

    it 'return true if user has vote in this obj' do 
      expect(@question.vote?(@user, 'up')).to eq true
    end

    it 'return false if user dont has vote in this obj ' do
      expect(@question2.vote?(@user, 'up')).to eq false 
    end
  end

  context '.vote' do 
    before do 
      @user = create(:user)
      @question = create(:question)
      @vote_up = create(:vote_up, user: @user, voteable: @question)
      @question2 = create(:question)
      @question.vote(@user, 'down')
    end

    it 'destroy all votes on this obj on this user' do 
    end

    it 'create new vote' do 
      
    end
  end
end
