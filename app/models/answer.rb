class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy
  validates  :body, presence: true

  accepts_nested_attributes_for :attachments

  scope :bests, -> { where(is_best: true) }
  
  def set_best
    self.transaction do 
      self.question.answers.update_all(is_best: false)
      self.update!(is_best: true)
    end
  end
end
