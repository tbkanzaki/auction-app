class LotItem < ApplicationRecord
  belongs_to :lot
  belongs_to :product

  validates :product_id, uniqueness: true
end
