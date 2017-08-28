class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :status, presence: true

  def self.total_count
    self.sum(:status)
  end
end

