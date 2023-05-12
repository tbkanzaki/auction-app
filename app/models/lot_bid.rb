class LotBid < ApplicationRecord
  belongs_to :lot
  belongs_to :user

  validates :bid, numericality: { only_integer: true, greater_than:0, message: ' deve ser maior que zero.' }

end
