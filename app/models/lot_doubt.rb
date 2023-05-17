class LotDoubt < ApplicationRecord
  belongs_to :lot
  belongs_to :user

  has_one :lot_doubt_answer

  validates :question, presence: true

  enum status: {unblocked: 0, blocked: 2}
end
