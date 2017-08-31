class QuestionsController < ApplicationController
  include Voted
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  
  after_action :publish_question, only: [:create]  

  def index
    @questions = Question.all
  end

  def show
    gon.question = @question
    @answer = @question.answers.new
    @answer.attachments.build
    # coccon не билдит аттачменты если их нет, поэтому не появляется форма
    if @question.attachments.count == 0
      @question.attachments.build
    end
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      flash[:alert] = 'Error while creating question'
      render :new
    end
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
      @question.destroy
      flash[:notice] = 'Your question was succesfully deleted'
      redirect_to questions_path
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
end
