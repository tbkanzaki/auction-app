require 'rails_helper'

describe 'Usuário visita página de Controle de Lotes' do
  it 'a partir da tela inicial como visitante' do
    #Arrange
    user_maria = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )
    #Act
    login_as(user_maria)
    visit root_path
    visit lots_path

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este módulo.'
  end

  it 'e encerra lote a partir da tela inicial como administrador' do
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
    LotApprover.create!(lot: lot, user: user_cristina) 
    Lot.where(id: lot.id).update(start_date: 1.month.ago)
    LotBid.create!(lot: lot, user: user_maria, bid: 110) 
    Lot.where(id: lot.id).update(limit_date: 2.days.ago)

    #Act
    login_as(user_tereza)
    visit root_path
    click_on 'Controle de Lotes'
    click_on 'Encerrar'

    #Assert
    p_a = Product.find(product_a.id)
    p_b = Product.find(product_b.id)
    expect(p_a.status).to eq 'sold'
    expect(p_b.status).to eq 'sold'
    expect(page).to have_content 'Lote ABC123456'
    expect(page).to have_content 'Status Encerrado'
    expect(page).to have_content 'Lote encerrado com sucesso.'
  end 

  it 'e cancela lote a partir da tela inicial como administrador' do
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
    LotApprover.create!(lot: lot, user: user_cristina) 
    Lot.where(id: lot).update(start_date: 1.month.ago)
    Lot.where(id: lot).update(limit_date: 2.days.ago)

    #Act
    login_as(user_tereza)
    visit root_path
    click_on 'Controle de Lotes'
    click_on 'Cancelar'

    #Assert
    p_a = Product.find(product_a.id)
    p_b = Product.find(product_b.id)
    expect(p_a.status).to eq 'unblocked'
    expect(p_b.status).to eq 'unblocked'
    expect(page).to have_content 'Lote cancelado com sucesso.'
    expect(page).to have_content 'Lote ABC123456'
    expect(page).to have_content 'Status Cancelado'
  end 
end