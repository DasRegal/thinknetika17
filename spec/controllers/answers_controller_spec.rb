require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
let(:question) { create(:question) }
let(:question_with_answers) { create(:question_with_answers) }
let(:answer) { create(:answer) }
let(:invalid_answer) { create(:invalid_answer) }

  describe 'GET #edit' do
    before { get :edit, params: { id: question_with_answers.answers.first, question_id: question_with_answers } }

    it 'assigns the requested answer to @answer' do 
      expect(assigns(:answer)).to eq question_with_answers.answers.first
    end

    it 'render edit view' do 
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do 
    sign_in_user
    context 'with valid attributes' do 
      it 'saves the new answer in the db' do 
        expect { post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do 
        post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js   }
        expect(response).to render_template 'create'
      end

      it 'have current_user as author' do 
        post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js   }
        expect(assigns(:answer).user).to eq @user
      end
    end

    context 'with invalid attributes' do 
      it 'saves the new answer in the db' do 
        expect { post :create, params: {question_id: question, answer: attributes_for(:invalid_answer)  } }.to_not change(Answer, :count)
      end

      it 'render template question show view' do 
        post :create, params: {question_id: question, answer: attributes_for(:invalid_answer)  }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do 
    context 'his own answer' do 
      sign_in_user
      before { question_with_answers.answers.first.update(user_id: @user.id) }

      it 'deletes question' do 
        expect { delete :destroy, params: { question_id: question_with_answers, id: question_with_answers.answers.first } }.to change(Answer, :count).by(-1) 
      end

      it 'redirect to parent question show' do 
        delete :destroy, params: { question_id: question_with_answers, id: question_with_answers.answers.first }
        expect(response).to redirect_to question_path(question_with_answers)
      end
    end

    context 'not his answer' do 
      sign_in_user

      it 'deletes question' do 
        question_with_answers
        expect { delete :destroy, params: { question_id: question_with_answers, id: question_with_answers.answers.first } }.to_not change(Answer, :count) 
      end

      it 'redirect to parent question show' do 
        delete :destroy, params: { question_id: question_with_answers, id: question_with_answers.answers.first }
        expect(response).to redirect_to question_path(question_with_answers)
      end      
    end
  end
end
