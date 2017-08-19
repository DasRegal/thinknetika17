class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  
  validates :title, :body, presence: true

  def best_answer
    self.answers.find_by(is_best: true)
  end
end
