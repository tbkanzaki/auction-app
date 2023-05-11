require 'rails_helper'

describe 'Usuário adiciona itens ao lote' do
  it 'a partir da tela inicial como visitante' do
    #Arrange
    user = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
    
    lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
    minimum_bid: 100, minimum_difference_bids: 5, user: user )

    #Act
    login_as(user)
    visit root_path
    visit new_lot_lot_item_path(lot.id)

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este módulo.'
  end

  it 'e não é o cadastrante do lote' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    user_cristina = User.create!(name: 'Cristina Souza', email:'cristina@leilaodogalpao.com.br', password:'senha1234', cpf: '97458446919')

    category_a = Category.create!(name: 'TV')
    category_b = Category.create!(name: 'Computadore/Notebooks/Tablets')
    
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV24SAMSUN')
    Product.create!(name: 'TV 24', description: 'TV 24 SAMSUNG', 
    weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('NOTEI5ASUS')
    Product.create!(name: 'Notebook Asus', description: 'Notebook Asus SAMSUNG', 
    weight: 5000, width: 100, height: 200, depth: 10, category: category_b)  

    lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, user: user_tereza)
    #Act
    login_as(user_cristina)
    visit root_path
    click_on 'Controle de Lotes'
    click_on 'ABC123456'
    
    #Assert
    expect(current_path).to eq lot_path(lot.id)
    expect(page).not_to have_content 'Adicionar item'
  end

  it 'com sucesso, como administrador e cadastrante do lote' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    
    category_a = Category.create!(name: 'TV')
    category_b = Category.create!(name: 'Computadore/Notebooks/Tablets')
    
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV24SAMSUN')
    Product.create!(name: 'TV 24', description: 'TV 24 SAMSUNG', 
    weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('NOTEI5ASUS')
    Product.create!(name: 'Notebook Asus', description: 'Notebook Asus SAMSUNG', 
    weight: 5000, width: 100, height: 200, depth: 10, category: category_b)  

    lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, user: user_tereza)
    #Act
    login_as(user_tereza)
    visit root_path
    click_on 'Controle de Lotes'
    click_on 'ABC123456'
    click_on 'Adicionar item'
    select 'TV 24', from: 'Produto'
    click_on 'Salvar'
    
    #Assert
    expect(current_path).to eq lot_path(lot.id)
    expect(page).to have_content 'TV24SAMSUN - TV 24'
    expect(page).not_to have_content 'NOTEI5ASUS - Notebook Asus'
  end

  it 'e não vê itens bloqueados, como administrador e cadastrante do lote' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    category_a = Category.create!(name: 'TV')
    category_b = Category.create!(name: 'Computadore/Notebooks/Tablets')
    category_c = Category.create!(name: 'Celulares')
    
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV24SAMSUN')
    Product.create!(name: 'TV 24', description: 'TV 24 SAMSUNG', 
    weight: 10000, width: 600, height: 900, depth: 10, category: category_a, status: 'unblocked')  

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('NOTEI5ASUS')
    Product.create!(name: 'Notebook Asus', description: 'Notebook Asus SAMSUNG', 
        weight: 5000, width: 100, height: 200, depth: 10, category: category_b, status: 'unblocked')  
    
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('CELMOTOG42')
    Product.create!(name: 'Celular MotG42',  description: 'Smartphone Motorola Azul',
    weight: 800, width: 10, height: 15, depth: 5, category: category_c, status: 'blocked') 

    lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, user: user_tereza )
    #Act
    login_as(user_tereza)
    visit root_path
    click_on 'Controle de Lotes'
    click_on 'ABC123456'
    click_on 'Adicionar item'

    #Assert
    expect(current_path).to eq new_lot_lot_item_path(lot.id)
    expect(page).to have_content 'TV 24'
    expect(page).to have_content 'Notebook Asus'
    expect(page).not_to have_content 'Celular MotG42'
  end
  it 'e não tem mais produtos disponíveis, como administrador e cadastrante do lote' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    category_a = Category.create!(name: 'TV')
    
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV24SAMSUN')
    Product.create!(name: 'TV 24', description: 'TV 24 SAMSUNG', 
                  weight: 10000, width: 600, height: 900, depth: 10, 
                  category: category_a, status: 'blocked')  

    lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, user: user_tereza )
    #Act
    login_as(user_tereza)
    visit root_path
    click_on 'Controle de Lotes'
    click_on 'ABC123456'
    click_on 'Adicionar item'

    #Assert
    expect(current_path).to eq new_lot_lot_item_path(lot.id)
    expect(page).to have_content 'Não existem produtos disponíveis a serem adicionados ao lote.'
    expect(page).not_to have_content 'TV 24'
  end
end