require 'rails_helper'

describe 'Usuário adiciona itens ao lote' do
  it 'loga como visitante e não tem acesso' do
    #Arrange
    user = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    
    lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
    minimum_bid: 100, minimum_difference_bids: 5, user: user_tereza )

    #Act
    login_as(user)
    visit root_path
    visit new_lot_lot_item_path(lot.id)

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este módulo.'
  end

  it 'e  precisa estar logado' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    
    lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
    minimum_bid: 100, minimum_difference_bids: 5, user: user_tereza )

    #Act
    visit root_path
    visit new_lot_lot_item_path(lot.id)

    #Assert
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'e não foi quem cadastrou o lote, e não visualiza o botão de Adicionar item' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    user_cristina = User.create!(name: 'Cristina Souza', email:'cristina@leilaodogalpao.com.br', password:'senha1234', cpf: '97458446919')

    category_a = Category.create!(name: 'TV')
    category_b = Category.create!(name: 'Computadore/Notebooks/Tablets')
    
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV24SAMSUN')
    Product.create!(name: 'TV 24', description: 'TV 24 SAMSUNG', 
    weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('NOTEI5ASUS')
    Product.create!(name: 'Notebook Asus', description: 'Notebook Asus', 
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

  it 'e data inicial passou do prazo (data inicial < data de hoje) e não vizualiza botão de Adicionar item' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    user_cristina = User.create!(name: 'Cristina Souza', email:'cristina@leilaodogalpao.com.br', password:'senha1234', cpf: '97458446919')

    category_a = Category.create!(name: 'TV')
    category_b = Category.create!(name: 'Computadore/Notebooks/Tablets')
    
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV24SAMSUN')
    Product.create!(name: 'TV 24', description: 'TV 24 SAMSUNG', 
    weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('NOTEI5ASUS')
    Product.create!(name: 'Notebook Asus', description: 'Notebook Asus', 
    weight: 5000, width: 100, height: 200, depth: 10, category: category_b)  

    lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, user: user_tereza)
    
    Lot.find(lot.id).update(start_date: 2.days.ago)

    #Act
    login_as(user_cristina)
    visit root_path
    click_on 'Controle de Lotes'
    click_on 'ABC123456'
    
    #Assert
    expect(current_path).to eq lot_path(lot.id)
    expect(page).not_to have_content 'Adicionar item'
  end

  it 'e lote já foi aprovado e não vizualiza mais botão de Adicionar item' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    user_cristina = User.create!(name: 'Cristina Souza', email:'cristina@leilaodogalpao.com.br', password:'senha1234', cpf: '97458446919')

    category_a = Category.create!(name: 'TV')
    category_b = Category.create!(name: 'Computadore/Notebooks/Tablets')
    
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV24SAMSUN')
    product_a = Product.create!(name: 'TV 24', description: 'TV 24 SAMSUNG', 
    weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('NOTEI5ASUS')
    product_b = Product.create!(name: 'Notebook Asus', description: 'Notebook Asus', 
    weight: 5000, width: 100, height: 200, depth: 10, category: category_b)  

    lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, user: user_tereza)
    
    LotItem.create!(lot: lot, product: product_a)  
    product_a.blocked!    
    LotItem.create!(lot: lot, product: product_b)   
    product_b.blocked!      
    lot.approved!
    LotApprover.create!(lot: lot, user: user_cristina) 

    #Act
    login_as(user_cristina)
    visit root_path
    click_on 'Controle de Lotes'
    click_on 'ABC123456'
    
    #Assert
    expect(current_path).to eq lot_path(lot.id)
    expect(page).not_to have_content 'Adicionar item'
  end

  it 'com sucesso, como administrador e quem cadastrou do lote' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    
    category_a = Category.create!(name: 'TV')
    category_b = Category.create!(name: 'Computadore/Notebooks/Tablets')
    
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV24SAMSUN')
    produto1 = Product.create!(name: 'TV 24', description: 'TV 24 SAMSUNG', 
    weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('NOTEI5ASUS')
    produto2 = Product.create!(name: 'Notebook Asus', description: 'Notebook Asus', 
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
    count_items_after_save = LotItem.where(lot: lot).count
    expect(count_items_after_save).to eq 1
    expect(current_path).to eq lot_path(lot.id)
    expect(page).to have_content 'TV24SAMSUN - TV 24'
  end

  it 'e produto fica bloqueado e não fica disponível para ser inserido em outro lote' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    
    category_a = Category.create!(name: 'TV')
    category_b = Category.create!(name: 'Computadore/Notebooks/Tablets')
    
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV24SAMSUN')
    produto1 = Product.create!(name: 'TV 24', description: 'TV 24 SAMSUNG', 
    weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('NOTEI5ASUS')
    produto2 = Product.create!(name: 'Notebook Asus', description: 'Notebook Asus', 
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
    p1 = Product.find(produto1.id)
    expect(p1.blocked?).to eq true
    expect(page).not_to have_content 'NOTEI5ASUS - Notebook Asus'
  end

  it 'e não vê os produtos cadastrados(bloqueados) para outro lote' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    category_a = Category.create!(name: 'TV')
    category_b = Category.create!(name: 'Computadore/Notebooks/Tablets')
    category_c = Category.create!(name: 'Celulares')
    
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV24SAMSUN')
    produto1 = Product.create!(name: 'TV 24', description: 'TV 24 SAMSUNG', 
    weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('NOTEI5ASUS')
    produto2 = Product.create!(name: 'Notebook Asus', description: 'Notebook Asus', 
        weight: 5000, width: 100, height: 200, depth: 10, category: category_b)  
    
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('CELMOTOG42')
    produto3 = Product.create!(name: 'Celular MotG42',  description: 'Smartphone Motorola Azul',
        weight: 800, width: 10, height: 15, depth: 5, category: category_c) 

    lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, user: user_tereza )

    LotItem.create!(lot: lot, product: produto1)   
    produto1.blocked!
    LotItem.create!(lot: lot, product: produto2)   
    produto2.blocked!

    #Act
    login_as(user_tereza)
    visit root_path
    click_on 'Controle de Lotes'
    click_on 'ABC123456'
    click_on 'Adicionar item'

    #Assert
    expect(current_path).to eq new_lot_lot_item_path(lot.id)
    expect(page).not_to have_content 'TV 24'
    expect(page).not_to have_content 'Notebook Asus'
    expect(page).to have_content 'Celular MotG42'
  end

  it 'e não tem mais produtos disponíveis' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    category_a = Category.create!(name: 'TV')
    
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV24SAMSUN')
    produto1 = Product.create!(name: 'TV 24', description: 'TV 24 SAMSUNG', 
    weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, user: user_tereza )

    LotItem.create!(lot: lot, product: produto1)   
    produto1.blocked!

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