class FavoriteLot < ApplicationRecord
  belongs_to :lot
  belongs_to :user

  validates :lot_id, uniqueness: true
end
