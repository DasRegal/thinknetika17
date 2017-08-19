require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
let(:question) { create(:question) }
let(:questions) { create_list(:question,2) }

  describe 'GET #index' do
    before do 
      get :index      
    end

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do 
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before do 
      get :show, params: { id: question }
    end

    it 'assigns the requested question to @question' do 
      expect(assigns(:question)).to eq question
    end 

    it 'assigns a new answer' do 
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do 
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do 
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do 
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do 
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before do 
      get :edit, params: { id: question }
    end

    it 'assigns the requested question to @question' do 
      expect(assigns(:question)).to eq question
    end 

    it 'renders edit view' do 
      expect(response).to render_template :edit
    end    
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do

      it 'saves the new question in the database' do 
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do 
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'have current_user as author' do 
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).user).to eq @user
      end
    end

    context 'with invalid attributes' do 
      it 'does not save the question' do 
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do 
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do 
    sign_in_user
    context 'with valid attributes' do
      it 'assigns the requested question to @question' do 
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do 
        question.update(user: @user)
        patch :update, params: { id: question, question: {title: 'title', body: 'body'}, format: :js }
        question.reload
        expect(question.title).to eq 'title'
        expect(question.body).to eq 'body'
      end

      it 'redirect to the updated question' do 
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do 
      before do
        @old_title = question.title
        @old_body = question.body
        patch :update, params: { id: question, question: {title: 'title', body: nil}, format: :js } 
      end

      it 'does not chenge question attributes' do 
        question.reload
        expect(question.title).to eq @old_title
        expect(question.body).to eq @old_body
      end

      it 're-render update' do 
        expect(response).to render_template :update
      end
    end

    context 'non-author try to update' do 
      before do 
        question.update(user: create(:user))
        @old_body = question.body
        @old_title = question.title
        patch :update, params: { id: question, question: attributes_for(:question), format: :js}  
      end

      it 'does not change question attributes' do 
        question.reload
        expect(question.title).to eq @old_title
        expect(question.body).to eq @old_body
      end

      it 're-render update' do 
        expect(response).to render_template :update
      end

      it 'show flash message' do 
        expect(flash['alert']).to eq 'You dont have enough privilege'
      end
    end
  end

  describe 'DELETE #destroy' do 
    context 'his own question' do 
      sign_in_user
      before { question.update(user_id: @user.id) }
      it 'deletes question' do 
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1) 
      end

      it 'redirect to index view' do 
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'not his question' do 
      sign_in_user
      it 'not deletes question' do 
        question
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to show view' do 
        delete :destroy, params: { id: question }
        expect(response).to render_template :show
      end      
    end
  end
end
