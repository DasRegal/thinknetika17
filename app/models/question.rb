class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  belongs_to :user
  
  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments

  def best_answer
    self.answers.bests.first
  end
end
