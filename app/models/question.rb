class Question < ApplicationRecord
  validates :title, :body, presence: true
  have_many :answers
end
