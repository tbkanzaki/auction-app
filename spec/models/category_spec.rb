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
  end
end
