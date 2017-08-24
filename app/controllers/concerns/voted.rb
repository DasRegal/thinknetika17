module Voted
  extend ActiveSupport::Concern

  included do 
    before_action :set_obj, only: [:vote_up, :vote_down]
  end

  def vote_up
    @obj.vote(current_user, 'up')
    render json: @obj.votes.total_count
  end

  def vote_down
    @obj.vote(current_user, 'down')
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