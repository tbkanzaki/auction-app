require 'rails_helper'

describe 'Usuário visitante autenticado visita lista de lotes favoritos' do 
  it 'e vê a lista de favoritos' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    user_cristina = User.create!(name: 'Cristina Souza', email:'cristina@leilaodogalpao.com.br', password:'senha1234', cpf: '97458446919')
    user_maria = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')

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
    lot_approver = LotApprover.create!(lot: lot, user: user_cristina) 
    Lot.where(id: lot).update(start_date: 2.days.ago)
    FavoriteLot.create!(lot: lot, user: user_maria)

    #Act
    login_as(user_maria)
    visit root_path
    click_on 'Meus Favoritos'

    #Assert
    expect(current_path).to eq  favorite_lots_path
    expect(page).to have_content 'Lotes Favoritos'
    expect(page).to have_content 'ABC123456'
  end

  it 'e por aqui também consegue remover da lista de favoritos' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    user_cristina = User.create!(name: 'Cristina Souza', email:'cristina@leilaodogalpao.com.br', password:'senha1234', cpf: '97458446919')
    user_maria = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')

    category_a = Category.create!(name: 'TV')

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV01-32SAN')
    product_a = Product.create!(name: 'TV-01 SAMSUNG32', 
        description: 'Smart TV LED 32" HD Samsung T3200 com HDR, Sistema Operacional Tizen', 
        weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV02-43SAN')
    product_b = Product.create!(name: 'TV-02 SAMSUNG43', 
        description: 'Smart TV LED 43" HD Samsung T4300 com HDR, Sistema Operacional Tizen',
        weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    lot1 = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )
    
    lot2 = Lot.create!(code:'XYZ123456', start_date: 1.week.from_now, limit_date: 3.weeks.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 10, status: 0, user: user_tereza )
    
    LotItem.create!(lot: lot1, product: product_a)  
    product_a.blocked!    
    LotItem.create!(lot: lot2, product: product_b)   
    product_b.blocked!     
    lot1.approved!
    lot_approver = LotApprover.create!(lot: lot1, user: user_cristina) 
    lot2.approved!
    lot_approver = LotApprover.create!(lot: lot2, user: user_cristina) 

    #Lot.where(id: lot1).update(start_date: 2.days.ago)
    Lot.find(lot1.id).update(start_date: 2.days.ago)
    Lot.find(lot2.id).update(start_date: 2.days.ago)

    FavoriteLot.create!(lot: lot1, user: user_maria)
    FavoriteLot.create!(lot: lot2, user: user_maria)

    #Act
    login_as(user_maria)
    visit root_path
    click_on 'Meus Favoritos'
    find_button('Remover', id: 'favorite_lot_1').click()
    

    #Assert
    expect(current_path).to eq lot_path(lot1.id)
    expect(page).to have_content 'Lote removido dos favoritos com sucesso.'
    expect(page).to have_content 'Lote ABC123456'
    expect(page).to  have_selector(:link_or_button, 'Adicionar aos favoritos')
  end
end