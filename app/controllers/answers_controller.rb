class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update]

  def edit
    answer
  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash.now[:notice] = 'Your answer was successfully created'
    else
      flash.now[:alert] = 'Error while creating answer'
    end
  end

  def update 
    if current_user.author_of?(answer)
      if answer.update(answer_params)
        flash.now[:notice] = 'Your answer was succesfully updated'
      else
        flash.now[:alert] = 'Error while creating answer'
      end
    else
      flash.now[:alert] = 'You dont have enough privilege'
    end
  end 

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      flash[:notice] = 'Your answer was succesfully deleted'
    else
      flash[:alert] = 'You dont have enough privilege'
    end
    redirect_to question_path(question)
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
