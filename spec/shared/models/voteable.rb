require_relative '../../rails_helper'

shared_examples_for 'voteable' do 
  let!(:model){ create(described_class.to_s.downcase.to_sym) }
  let!(:user) { create(:user) }
  let!(:vote_up) { create(:vote, :up, user: user, voteable: model) }
  let(:model2) { create(described_class.to_s.downcase.to_sym) }  


  context '.vote?' do 
    it 'return true if user has vote in this obj' do 
      expect(model.vote?(user, 1)).to eq true
    end

    it 'return false if user dont has vote in this obj ' do
      expect(model2.vote?(user, 1)).to eq false 
    end
  end

  context '.vote' do 
    it 'change votes count' do 
      expect{ model2.vote(user, -1) }.to change(Vote, :count).by 1
    end

    it 'created vote have correct params' do
      new_vote = model2.vote(user, -1)

      expect(new_vote.voteable).to eq model2
      expect(new_vote.user_id).to eq user.id
      expect(new_vote.status).to eq -1
    end
  end

end