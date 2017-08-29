require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:answer) { create(:answer) }
  let!(:user) { create(:user) }
  let!(:vote_up) { create(:vote, :up, user: user, voteable: answer) }
  let(:answer2) { create(:answer) }

  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }
  
  context 'setting answer to be best' do 
    before { @question = create :question_with_answers }

    it 'have only 1 best answer' do 
      @question.answers.each do |a|
        a.set_best
      end
      expect(@question.answers.bests.count).to eq 1
    end

    it 'set best answer' do 
      answer = @question.answers.first
      answer.set_best
      expect(answer.is_best?).to eq true
    end
  end

  context '.vote?' do 
    it 'return true if user has vote in this obj' do 
      expect(answer.vote?(user, 1)).to eq true
    end

    it 'return false if user dont has vote in this obj ' do
      expect(answer2.vote?(user, 1)).to eq false 
    end
  end

  context '.vote' do 
    it 'change votes count' do 
      expect{ answer2.vote(user, -1) }.to change(Vote, :count).by 1
    end

    it 'created vote have correct params' do
      new_vote = answer2.vote(user, -1)

      expect(new_vote.voteable).to eq answer2
      expect(new_vote.user_id).to eq user.id
      expect(new_vote.status).to eq -1
    end
  end
end
