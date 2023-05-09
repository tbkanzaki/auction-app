require 'rails_helper'

RSpec.describe Lot, type: :model do
  describe '#valid?' do
    it 'true (errors.include) quando o código é vazio' do
      # Arrange
      lot = Lot.new(code: '')

      # Act
      lot.valid?
      result = lot.errors.include?(:code)
      
      # Assert
      expect(result).to be true
      expect(lot.errors[:code]).to include("não pode ficar em branco")
    end
    
    it 'true (errors.include) quando o código tem menos de 9 caracteres' do
      # Arrange
      lot = Lot.new(code: 'ABC45678')

      # Act
      lot.valid?
      result = lot.errors.include?(:code)

      # Assert
      expect(result).to be true
      expect(lot.errors[:code]).to include(" deve ser composto por 3 letras e 6 caracteres.")
    end
    
    
    it 'true (errors.include) quando o código não é composto por 3 letras e 6 caracteres' do
      # Arrange
      lot = Lot.new(code: 'XXXYYYYYY')

      # Act
      lot.valid?
      result = lot.errors.include?(:code)

      # Assert
      expect(result).to be true
      expect(lot.errors[:code]).to include(" deve ser composto por 3 letras e 6 caracteres.")
    end
    
    it 'true (errors.include) quando a data de início não pode ficar em branco' do
      # Arrange
      lot = Lot.new(start_date: '')

      # Act
      lot.valid?
      result = lot.errors.include?(:start_date)

      # Assert
      expect(result).to be true
      expect(lot.errors[:start_date]).to include("não pode ficar em branco")
    end
    
    it 'true (errors.include) quando a data de início deve ser maior que a data de hoje.' do
      # Arrange
      lot = Lot.new(start_date: 1.week.ago.to_date)

      # Act
      lot.valid?
      result = lot.errors.include?(:start_date)

      # Assert
      expect(result).to be true
      expect(lot.errors[:start_date]).to include(" deve ser maior que a data de hoje.")
    end
    
    it 'true (errors.include) quando a data de início deve ser maior que a data de hoje.' do
      # Arrange
      lot = Lot.new(limit_date: 1.week.ago.to_date)

      # Act
      lot.valid?
      result = lot.errors.include?(:limit_date)

      # Assert
      expect(result).to be true
      expect(lot.errors[:limit_date]).to include(" deve ser maior que a data de hoje.")
    end
    
    it 'true (errors.include) quando o lance minimo  deve ser maior que zero.' do
      # Arrange
      lot = Lot.new(minimum_bid: -1)

      # Act
      lot.valid?
      result = lot.errors.include?(:minimum_bid)

      # Assert
      expect(result).to be true
      expect(lot.errors[:minimum_bid]).to include(" deve ser maior que zero.")
    end

    it 'true (errors.include) quando a diferença mínima entre lances deve ser maior que zero' do
      # Arrange
      lot = Lot.new(minimum_difference_bids: -1)

      # Act
      lot.valid?
      result = lot.errors.include?(:minimum_difference_bids)

      # Assert
      expect(result).to be true
      expect(lot.errors[:minimum_difference_bids]).to include(" deve ser maior que zero.")
    end
  end
end
