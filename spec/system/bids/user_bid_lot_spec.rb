require 'rails_helper'

describe 'Usuário visitante autenticado dá lance em um lote' do 
  it 'com sucesso, a partir da tela inicial' do
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
    LotItem.create!(lot: lot, product: product_b)   
    lot.approved!
    lot_approver = LotApprover.create!(lot: lot, user: user_cristina) 
    Lot.where(id: lot).update(start_date: 2.days.ago)

    #Act
    login_as(user_maria)
    visit root_path
    click_on 'ABC123456'
    click_on 'Dar lance'
    fill_in 'Lance', with: 110
    click_on 'Salvar'

    #Assert
    expect(current_path).to eq lot_path(lot.id)
    expect(page).to have_content 'Lote ABC123456'
    expect(page).to have_content 'Itens do Lote'
    expect(page).to have_content 'TV01-32SAN - TV-01 SAMSUNG32'
    expect(page).to have_content 'Último lance registrado R$ 110,00'
    expect(page).to have_content 'Lance mínimo atual R$ 115,00'
  end

  it 'sendo o primeiro lance com valor igual ao lance m@inimo inicial ' do
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
    LotItem.create!(lot: lot, product: product_b)   
    lot.approved!
    lot_approver = LotApprover.create!(lot: lot, user: user_cristina) 
    Lot.where(id: lot).update(start_date: 2.days.ago)

    #Act
    login_as(user_maria)
    visit root_path
    click_on 'ABC123456'
    click_on 'Dar lance'
    fill_in 'Lance', with: 100
    click_on 'Salvar'

    #Assert
    expect(page).to have_content 'Lance para o lote ABC123456'
    expect(page).to have_content 'O lance tem que ser maior que o lance inicial'
    expect(page).not_to have_content 'Lance feito com sucesso.'
  end

  it 'com valor inferior do que o lance mínimo atual e existe lance cadasrado' do
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
    LotItem.create!(lot: lot, product: product_b)   
    lot.approved!
    lot_approver = LotApprover.create!(lot: lot, user: user_cristina) 
    Lot.where(id: lot).update(start_date: 2.days.ago)
    LotBid.create!(lot: lot, user: user_maria, bid: 110) 

    #Act
    login_as(user_maria)
    visit root_path
    click_on 'ABC123456'
    click_on 'Dar lance'
    fill_in 'Lance', with: 113
    click_on 'Salvar'

    #Assert
    expect(page).to have_content 'Lance para o lote ABC123456'
    expect(page).to have_content 'O lance tem que ser maior que o lance mínimo atual'
    expect(page).not_to have_content 'Lance feito com sucesso.'
  end
end
