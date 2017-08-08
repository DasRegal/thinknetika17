class Answer < ApplicationRecord
  validates :question_id, :body, presence: true
  belongs_to :question
end
