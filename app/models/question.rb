class Question < ApplicationRecord
  include Votable
  include Commentable
  
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  belongs_to :user
  
  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def best_answer
    self.answers.bests.first
  end
end
