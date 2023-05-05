require 'rails_helper'

RSpec.describe Category, type: :model do
  describe '#valid?' do
    it 'true (errors.include) quando o nome é vazio' do
      # Arrange
      category = Category.new(name: '')

      # Act
      category.valid?
      result = category.errors.include?(:name)

      # Assert
      expect(result).to be true
    end

    it 'false quando o nome da categoria já está em uso' do
      # Arrange
      category_01 = Category.create!(name: 'Esporte/Lazer')
      category_02 = Category.new(name: 'Esporte/Lazer')
      # Act
      result = category_02.valid?

      # Assert
      expect(result).to eq false
    end
  end
end
