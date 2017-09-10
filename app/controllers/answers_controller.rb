class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [:create, :destroy, :update, :set_as_best]

  after_action :publish_answer, only: [:create]

  respond_to :js
  respond_to :json, only: :create

  def edit
    answer
  end

  def create
    @answer = question.answers.create(answer_params.merge(user: current_user))
    respond_with @answer
  end

  def update
    if current_user.author_of?(answer)
      answer.update(answer_params)
      respond_with answer
    else
      flash.now[:alert] = 'You dont have enough privilege'
    end
  end

  def destroy
    if current_user.author_of?(answer)
      respond_with answer.destroy
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

    ActionCable.server.broadcast(
      "question_#{@question.id}",
      @answer.to_json(include: :attachments)
      )
  end
end
