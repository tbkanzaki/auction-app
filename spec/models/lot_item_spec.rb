require 'rails_helper'

RSpec.describe LotItem, type: :model do
  describe '#valid?' do
    it 'true (errors.include) produto já cadastrado para o mesmo lote' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    user_cristina = User.create!(name: 'Cristina Souza', email:'cristina@leilaodogalpao.com.br', password:'senha1234', cpf: '97458446919')

    category_a = Category.create!(name: 'TV')

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV01-32SAN')
    product_a = Product.create!(name: 'TV-01 SAMSUNG32', 
        description: 'Smart TV LED 32" HD Samsung T3200 com HDR, Sistema Operacional Tizen', 
        weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV02-43SAN')
    product_b = Product.create!(name: 'TV-02 SAMSUNG43', 
        description: 'Smart TV LED 43" HD Samsung T4300 com HDR, Sistema Operacional Tizen',
        weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )

    LotItem.create!(lot_id: lot.id, product_id: product_a.id) 
    product_a.blocked!  
    lot_item = LotItem.new(lot_id: lot.id, product_id: product_a.id) 

      # Act
      lot_item.valid?
      result = lot_item.errors.include?(:product_id)
      
      # Assert
      expect(result).to be true
      expect(lot_item.errors[:product_id]).to include("já está em uso")
    end

    it 'true (errors.include) produto já cadastrado em outro lote' do
      #Arrange
      user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
      user_cristina = User.create!(name: 'Cristina Souza', email:'cristina@leilaodogalpao.com.br', password:'senha1234', cpf: '97458446919')

      category_a = Category.create!(name: 'TV')

      allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV01-32SAN')
      product_a = Product.create!(name: 'TV-01 SAMSUNG32', 
          description: 'Smart TV LED 32" HD Samsung T3200 com HDR, Sistema Operacional Tizen', 
          weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

      allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV02-43SAN')
      product_b = Product.create!(name: 'TV-02 SAMSUNG43', 
          description: 'Smart TV LED 43" HD Samsung T4300 com HDR, Sistema Operacional Tizen',
          weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

      lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                    minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )

      lot2 = Lot.create!(code:'XYZ123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                    minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )
      
      LotItem.create!(lot_id: lot.id, product_id: product_a.id) 
      product_a.blocked!  
      lot_item = LotItem.new(lot_id: lot2.id, product_id: product_a.id) 

      # Act
      lot_item.valid?
      result = lot_item.errors.include?(:product_id)
      
      # Assert
      expect(result).to be true
      expect(lot_item.errors[:product_id]).to include("já está em uso")
    end
  end
end
