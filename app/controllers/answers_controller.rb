class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def edit
    answer
  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = 'Your answer was successfully created'
      redirect_to question_path(@question)
    else
      flash[:alert] = 'Error while creating answer'
      render 'questions/show'
    end
  end

  def destroy
    if answer.user == current_user
      answer.destroy
      flash[:notice] = 'Your answer was succesfully deleted'
      redirect_to question_path(question)
    else
      flash[:alert] = 'You dont have enough privilege'
      redirect_to question_path(question)
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
