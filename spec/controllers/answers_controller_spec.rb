require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
let(:question) { create(:question) }
let(:question_with_answers) { create(:question_with_answers) }
let(:answer) { create(:answer) }
let(:invalid_answer) { create(:invalid_answer) }

  describe 'GET #index' do 
    before { get :index, params: { question_id: question_with_answers } }

    it 'populates an array of all answers for question' do 
      expect(assigns(:answers)).to match_array(question_with_answers.answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before do 
      get :show, params: { id: question_with_answers.answers.first, question_id: question_with_answers }
    end

    it 'assigns the requested answer to @answer' do 
      expect(assigns(:answer)).to eq question_with_answers.answers.first
    end 

    it 'renders show view' do 
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do 
    before { get :new, params: { question_id: question } }
    it 'assign a new answer to @answer' do 
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do 
      expect(response).to render_template :new
    end
  end

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
    context 'with valid attributes' do 
      it 'saves the new answer in the db' do 
        expect { post :create, params: {question_id: question, answer: attributes_for(:answer)  } }.to change(Answer, :count).by(1)
      end

      it 'redirect to question show view' do 
        post :create, params: {question_id: question, answer: attributes_for(:answer)  }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do 
      it 'saves the new answer in the db' do 
        expect { post :create, params: {question_id: question, answer: attributes_for(:invalid_answer)  } }.to_not change(Answer, :count)
      end

      it 'redirect to answer new view' do 
        post :create, params: {question_id: question, answer: attributes_for(:invalid_answer)  }
        expect(response).to render_template :new
      end
    end
  end
end
