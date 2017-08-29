require_relative '../../rails_helper'

shared_examples_for 'voted' do 

  describe 'PATCH #vote_up' do 
    sign_in_user
    context 'non question author try to vote up' do 
      context 'user already has vote' do 
        before { create(:vote, :up, user: @user, voteable: model) }

        it 'dont change votes' do 
          expect{ patch :vote_up, params: { id: model } }.to_not change(model.votes, :count)
        end

        it 'render error' do 
          patch :vote_up, params: { id: model }
          expect(response.body).to eq 'You are already voted up'
        end

        it 'response status 422' do 
          patch :vote_up, params: { id: model }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'user dont has vote' do 
        it 'create a new vote' do 
          expect{ patch :vote_up, params: { id:model } }.to change(model.votes, :total_count).by 1
        end

        it 'render total count of votes' do 
          patch :vote_up, params: { id:model }
          expect(response.body). to eq model.votes.total_count.to_s
        end
      end
    end

    context 'model author try to vote up' do 
      before { model.update(user: @user) }

      it 'dont change votes' do 
        expect{ patch :vote_up, params: { id:model } }.to_not change(model.votes, :total_count)
      end

      it 'response status 422' do 
        patch :vote_up, params: { id:model }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #vote_down' do 
    sign_in_user
    context 'non model author try to vote down' do 
      context 'user already has vote' do 
        before { create(:vote, :down, user: @user, voteable: model) }

        it 'dont change votes' do 
          expect{ patch :vote_down, params: { id:model } }.to_not change(model.votes, :total_count)
        end

        it 'render error' do 
          patch :vote_down, params: { id:model }
          expect(response.body).to eq 'You are already voted down'
        end

        it 'response status 422' do 
          patch :vote_down, params: { id:model }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'user dont has vote' do 
        it 'create a new vote' do 
          expect{ patch :vote_down, params: { id:model } }.to change(model.votes, :total_count).by -1
        end

        it 'render total count of votes' do 
          patch :vote_down, params: { id:model }
          expect(response.body). to eq model.votes.total_count.to_s
        end
      end
    end

    context 'model author try to vote down' do 
      before { model.update(user: @user) }

      it 'dont change votes' do 
        expect{ patch :vote_down, params: { id:model } }.to_not change(model.votes, :total_count)
      end

      it 'response status 422' do 
        patch :vote_down, params: { id:model }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #vote_delete' do 
    sign_in_user
    context 'user has votes' do 
      before { create(:vote, :down, user: @user, voteable: model) }
      
      it 'change votes count' do 
        expect { delete :vote_delete, params: { id: model } }.to change(model.votes, :count).by -1
      end
    end

    context 'user dont has votes' do 
      before { create(:vote, :down, user: user, voteable: model) }

      it 'votes dont change' do 
        expect { delete :vote_delete, params: { id: model } }.to_not change(model.votes, :total_count)
      end
    end
  end  
end