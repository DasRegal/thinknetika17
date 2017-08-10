class AnswersController < ApplicationController
  def index
    @answers = Question.find(params[:question_id]).answers
  end

  def new
    @answer = Question.find(params[:question_id]).answers.new
  end

  def show
    @answer = Answer.find(params[:id])
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to question_path(@question)
    else
      render :new
    end

  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
