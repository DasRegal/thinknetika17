class AnswersController < ApplicationController
  include Voted
  
  before_action :authenticate_user!, only: [:create, :destroy, :update, :set_as_best]

  after_action :publish_answer, only: [:create]

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
      flash.now[:notice] = 'Your answer was succesfully deleted'
    else
      flash.now[:alert] = 'You dont have enough privilege'
    end
  end

  def set_as_best
    if current_user.author_of?(question) && question.answers.include?(answer)
      answer.set_best
      flash.now[:notice] = 'Answer set as best'
    else
      flash.now[:alert] = 'You dont have enough privilege'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def answer 
    @answer ||= Answer.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def publish_answer
    return if @answer.errors.any?
    attachments = @answer.
      attachments.
      collect{|aa| { id: aa.id, url: aa.file.url, file_name: aa.file.file.filename } }
    ActionCable.server.broadcast(
      "question_#{@question.id}",
       {answer: { id: @answer.id,
                  body: @answer.body,
                  user_id: @answer.user_id },
        attachments: attachments }.to_json )          
  end
end
