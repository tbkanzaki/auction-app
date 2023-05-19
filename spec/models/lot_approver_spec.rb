require 'rails_helper'

RSpec.describe LotApprover, type: :model do
  describe '#valid?' do
    it 'e para ser encerrado, lote precisa ter pelo menos um lance' do
      #Arrange
      user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
      cristina = User.create!(name: 'Cristina Souza', email:'cristina@leilaodogalpao.com.br', password:'senha1234', cpf: '97458446919')
      
      category_a = Category.create!(name: 'TV')

      allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV01-32SAN')
      product_a = Product.create!(name: 'TV-01 SAMSUNG32', 
          description: 'Smart TV LED 32" HD Samsung T3200 com HDR, Sistema Operacional Tizen', 
          weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

      lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                    minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )
      
      LotItem.create!(lot: lot, product: product_a)  
      product_a.blocked!    
    
      lot.approved!
      LotApprover.create!(lot_id: lot.id, user_id: cristina.id)
      lot_approver = LotApprover.new(lot_id: lot.id, user_id: cristina.id)

      # Act
      lot_approver.valid?
      result = lot_approver.errors.include?(:lot_id)
      
      # Assert
      expect(result).to be true
      expect(lot_approver.errors[:lot_id]).to include("já está em uso")
    end
  end
end
