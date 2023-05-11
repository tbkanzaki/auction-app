class Lot < ApplicationRecord
  belongs_to :user
  has_many :lot_items
  has_many :products, through: :lot_items

  has_many :lot_approvers
  has_many :users, through: :lot_approvers

  validates :code, :start_date, :limit_date, :minimum_bid, :minimum_difference_bids, presence: true
  validates :code, uniqueness: true
  validates :code, format: { with: /\A[A-Za-z]{3}\d{6}\z/, message: ' deve ser composto por 3 letras e 6 caracteres.' }
  validates :start_date, comparison: { greater_than: Date.today, message: ' deve ser maior que a data de hoje.'}, on: :create
  validates :limit_date, comparison: { greater_than: Date.today, message: ' deve ser maior que a data de hoje.'}
  validates :limit_date, comparison: { greater_than: :start_date, message: ' deve ser maior que a data inicial.'}
  validates :minimum_bid, numericality: { only_integer: true, greater_than:0, message: ' deve ser maior que zero.' }
  validates :minimum_difference_bids, numericality: { only_integer: true, greater_than:0, message: ' deve ser maior que zero.' }

  enum status: {waiting_approval: 0, approved: 3, closed: 6, cancelled: 9}
  
end
