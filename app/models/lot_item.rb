class LotItem < ApplicationRecord
  belongs_to :lot
  belongs_to :product
end
