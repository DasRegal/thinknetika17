class AnswersController < ApplicationController
  def index
    @answers = question.answers
  end

  def new
    @answer = question.answers.new
  end

  def show
    answer
  end

  def edit
    answer
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

  def answer 
    @answer ||= Answer.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end
end
