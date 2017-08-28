module Votable 
  extend ActiveSupport::Concern

  included do 
    has_many :votes, as: :voteable, dependent: :destroy
  end

  def vote?(user, status)
    if self.votes.where(user: user, status: status).count > 0 
      return true
    else
      return false
    end
  end


  def vote(user, status)
    self.transaction do 
      self.votes.where(user: user).destroy_all
      self.votes.create!(user: user, status: status)
    end
  end
end