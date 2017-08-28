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
    it 'change votes count' do 
      expect{ question2.vote(user, -1) }.to change(Vote, :count).by 1
    end
    it 'created vote have correct params' do
      new_vote = question2.vote(user, -1)
      expect(new_vote.voteable_id).to eq question2.id
      expect(new_vote.voteable_type).to eq 'Question'
      expect(new_vote.user_id).to eq user.id
      expect(new_vote.status).to eq -1
    end

  end
end
