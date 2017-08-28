module Voted
  extend ActiveSupport::Concern

  included do 
    before_action :set_obj, only: [:vote_up, :vote_down, :vote_delete]
  end

  def vote_up
    if @obj.vote?(current_user, 1) || current_user.author_of?(@obj)
      render json: 'You are already voted up', status: :unprocessable_entity
    else
      @obj.vote(current_user, 1)
      render json: @obj.votes.total_count
    end
  end

  def vote_down
    if @obj.vote?(current_user, -1) || current_user.author_of?(@obj)
      render json: 'You are already voted down', status: :unprocessable_entity
    else
      @obj.vote(current_user, -1)
      render json: @obj.votes.total_count
    end
  end

  def vote_delete
    @obj.votes.where(user: current_user).destroy_all
    render json: @obj.votes.total_count
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_obj
    @obj = model_klass.find(params[:id])
  end
end