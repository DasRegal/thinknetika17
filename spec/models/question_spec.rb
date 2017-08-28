require 'rails_helper'

RSpec.describe Question, type: :model do
  let!(:question) { create(:question) }
  let!(:user) { create(:user) }
  let!(:vote_up) { create(:vote, :up, user: user, voteable: question) }
  let(:question2) { create(:question) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should belong_to(:user) }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  context '.vote?' do 
    it 'return true if user has vote in this obj' do 
      expect(question.vote?(user, 1)).to eq true
    end

    it 'return false if user dont has vote in this obj ' do
      expect(question2.vote?(user, 1)).to eq false 
    end
  end

  context '.vote' do 
    it 'have only new vote' do 
      new_vote = question.vote(user, -1)
      expect(question.votes).to match_array(new_vote)
    end
  end
end
