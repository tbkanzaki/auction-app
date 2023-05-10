require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'gera um código aleatório' do
    it 'ao criar um novo produto' do
      # Arrange
      category = Category.create!(name: 'TV')
    
      product = Product.new(name: 'TV 24', description: 'TV 24 SAMSUNG', 
                weight: 10000, width: 600, height: 900, depth: 10, category: category)  

      # Act
      product.save!
      result = product.code

      # Assert
      expect(result).not_to be_empty
      expect(result.length).to eq 10
    end

    it 'e o código é único' do
      # Arrange
      category = Category.create!(name: 'TV')
    
      product_a = Product.create!(name: 'TV 24', description: 'TV 24 SAMSUNG', 
                weight: 10000, width: 600, height: 900, depth: 10, category: category)  

      product_b = Product.new(name: 'TV 24', description: 'TV 24 SAMSUNG', 
                weight: 10000, width: 600, height: 900, depth: 10, category: category)  

      # Act
      product_b.save!
      result = product_b.code

      # Assert
      expect(result).not_to eq product_a.code
    end
  end
  describe '#valid?' do
    it 'true (errors.include) quando o código é vazio' do
      # Arrange
      product = Product.new(name: '')
     
      # Act
      product.valid?
      result = product.errors.include?(:name)

      # Assert
      expect(result).to be true
      expect(product.errors[:name]).to include("não pode ficar em branco")     
    end
  end
end
