class QuestionsController < ApplicationController
  include Voted
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: [:show]

  after_action :publish_question, only: [:create]

  def index
    respond_with(@questions = Question.all)
  end

  def show
    gon.question = @question
    respond_with @question
  end

  def new
    respond_with @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.create(question_params.merge(user: current_user))
    respond_with @question
  end

  def update
    if current_user.author_of?(@question)
      if @question.update(question_params)
        flash.now[:notice] = 'Your question was succesfully updated'
      else
        flash.now[:alert] = 'Error while creating question'
      end
    else
      flash.now[:alert] = 'You dont have enough privilege'
    end
  end

  def destroy
    if current_user.author_of?(@question)
      respond_with @question.destroy
    else
      flash[:alert] = 'You dont have enough privilege'
      render :show
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def build_answer
    @answer = @question.answers.new
  end
end
