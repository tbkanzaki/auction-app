class LotDoubtAnswer < ApplicationRecord
  belongs_to :lot_doubt
  belongs_to :user

  validates :answer, presence: true
end
