class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  
  validates :title, :body, presence: true

  def set_best_answer(answer)
    answers = self.answers
    if answers.include?(answer)
      self.answers.update_all(is_best_flag: false)
      answer.update(is_best_flag: true)
    end
  end
end
