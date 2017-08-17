class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  
  validates  :body, presence: true

  def self.bests
    where(is_best_flag: true)
  end

  def self.best
    find_by(is_best_flag: true)
  end

  def best_answer?
    self.is_best_flag
  end
end
