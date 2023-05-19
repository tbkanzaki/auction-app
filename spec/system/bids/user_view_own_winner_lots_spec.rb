require 'rails_helper'

describe 'Usuário visitante seus lotes vencedores' do 
  it 'e vê com sucesso' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    user_cristina = User.create!(name: 'Cristina Souza', email:'cristina@leilaodogalpao.com.br', password:'senha1234', cpf: '97458446919')
    user_maria = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
    user_joana = User.create!(name: 'Joana Sousa', email:'joana@provedor.com', password:'senha1234', cpf: '85236832241')

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
    
    LotItem.create!(lot: lot, product: product_a)  
    product_a.blocked!    
    LotItem.create!(lot: lot, product: product_b)   
    product_b.blocked!    
    lot.approved!
    LotApprover.create!(lot: lot, user: user_cristina) 
    lot.start_date = 1.month.ago
    LotBid.create!(lot: lot, user: user_maria, bid: 110) 
    LotBid.create!(lot: lot, user: user_joana, bid: 120) 
    lot.start_date = 2.days.ago
    lot.closed!

    #Act
    login_as(user_joana)
    visit root_path
    click_on 'Meus Lotes'

    #Assert
    expect(page).to have_content 'Seus lotes contemplados'
    expect(page).to have_content 'Lotes'
    expect(page).to have_content 'ABC123456'
  end
  
  it 'e não vê o que não foi contemplada' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    user_cristina = User.create!(name: 'Cristina Souza', email:'cristina@leilaodogalpao.com.br', password:'senha1234', cpf: '97458446919')
    user_maria = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
    user_joana = User.create!(name: 'Joana Sousa', email:'joana@provedor.com', password:'senha1234', cpf: '85236832241')

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
    
    LotItem.create!(lot: lot, product: product_a)  
    product_a.blocked!    
    LotItem.create!(lot: lot, product: product_b)   
    product_b.blocked!    
    lot.approved!
    LotApprover.create!(lot: lot, user: user_cristina) 
    lot.start_date = 1.month.ago
    LotBid.create!(lot: lot, user: user_maria, bid: 110) 
    LotBid.create!(lot: lot, user: user_joana, bid: 120) 
    lot.start_date = 2.days.ago
    lot.closed!

    #Act
    login_as(user_maria)
    visit root_path
    click_on 'Meus Lotes'

    #Assert
    expect(page).to have_content 'Seus lotes contemplados'
    expect(page).not_to have_content 'ABC123456'
  end
  
  it 'e não tem lotes contemplados.' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    user_cristina = User.create!(name: 'Cristina Souza', email:'cristina@leilaodogalpao.com.br', password:'senha1234', cpf: '97458446919')
    user_maria = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
    user_joana = User.create!(name: 'Joana Sousa', email:'joana@provedor.com', password:'senha1234', cpf: '85236832241')

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
    
    LotItem.create!(lot: lot, product: product_a)  
    product_a.blocked!    
    LotItem.create!(lot: lot, product: product_b)   
    product_b.blocked!   
    lot.approved!
    LotApprover.create!(lot: lot, user: user_cristina) 
    lot.start_date = 1.month.ago
    LotBid.create!(lot: lot, user: user_maria, bid: 110) 
    LotBid.create!(lot: lot, user: user_joana, bid: 150) 
    lot.limit_date = 2.days.ago
    lot.closed!

    #Act
    login_as(user_maria)
    visit root_path
    click_on 'Meus Lotes'

    #Assert
    expect(page).to have_content 'Seus lotes contemplados'
    expect(page).not_to have_content 'ABC123456'
  end
end
