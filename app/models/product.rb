class Product < ApplicationRecord
  has_one_attached :product_image
  belongs_to :category
  validates :code, :name, :weight, :width, :height, :depth, presence: true

  before_validation :generate_code
  
  enum status: {unblocked: 0, blocked: 5, sold: 9}
 
  private

  def generate_code
    self.code = SecureRandom.alphanumeric(10).upcase
  end
end
