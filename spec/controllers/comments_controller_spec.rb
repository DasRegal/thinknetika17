require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer) }

  describe 'POST #create' do
    sign_in_user
    context 'invalid attributes' do
      context 'question' do
        it 'render create.js.erb template' do
          post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid, commentable: question), commentable: 'question', format: :js }
          expect(response).to render_template :create
        end

        it 'render errors' do
          post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid, commentable: question), commentable: 'question', format: :js }
          expect(flash['alert']).to eq 'Comment could not be created.'
        end

        it 'dont save the comment' do
          expect { post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid, commentable: question), commentable: 'question', format: :js } }.to_not change(Comment, :count)
        end
      end

      context 'answer' do
        it 'render create.js.erb template' do
          post :create, params: { answer_id: answer, comment: attributes_for(:comment, :invalid, commentable: answer), commentable: 'answer', format: :js }
          expect(response).to render_template :create
        end

        it 'render errors' do
          post :create, params: { answer_id: answer, comment: attributes_for(:comment, :invalid, commentable: answer), commentable: 'answer', format: :js }
          expect(flash['alert']).to eq 'Comment could not be created.'
        end

        it 'dont save the comment' do
          expect { post :create, params: { answer_id: answer, comment: attributes_for(:comment, :invalid, commentable: answer), commentable: 'answer', format: :js } }.to_not change(Comment, :count)
        end
      end
    end

    context 'valid attributes' do
      context 'question' do
        it 'render create.js.erb template' do
          post :create, params: { question_id: question, comment: attributes_for(:comment, commentable: question), commentable: 'question', format: :js }
          expect(response).to render_template :create
        end

        it 'render success flash' do
          post :create, params: { question_id: question, comment: attributes_for(:comment, commentable: question), commentable: 'question', format: :js }
          expect(flash['notice']).to eq 'Comment was successfully created.'
        end

        it 'have current user as author' do
          post :create, params: { question_id: question, comment: attributes_for(:comment, commentable: question), commentable: 'question', format: :js }
          expect(assigns(:comment).user).to eq @user
        end

        it 'save comment in satabase' do
          expect { post :create, params: { question_id: question, comment: attributes_for(:comment, commentable: question), commentable: 'question', format: :js } }.to change(question.comments, :count).by(1)
        end
      end

      context 'answer' do
        it 'render create.js.erb template' do
          post :create, params: { answer_id: answer, comment: attributes_for(:comment, commentable: answer), commentable: 'answer', format: :js }
          expect(response).to render_template :create
        end

        it 'render success flash' do
          post :create, params: { answer_id: answer, comment: attributes_for(:comment, commentable: answer), commentable: 'answer', format: :js }
          expect(flash['notice']).to eq 'Comment was successfully created.'
        end

        it 'have current user as author' do
          post :create, params: { answer_id: answer, comment: attributes_for(:comment, commentable: answer), commentable: 'answer', format: :js }
          expect(assigns(:comment).user).to eq @user
        end

        it 'save comment in satabase' do
          expect { post :create, params: { answer_id: answer, comment: attributes_for(:comment, commentable: answer), commentable: 'answer', format: :js } }.to change(answer.comments, :count).by(1)
        end
      end
    end
  end
end
