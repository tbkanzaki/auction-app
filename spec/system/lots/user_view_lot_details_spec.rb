require 'rails_helper'

describe 'Usuário vê detalhes do lote' do 
  it 'a partir da tela inicial como visitante' do
    #Arrange
    user = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
    
    lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user )

        #Act
    login_as(user)
    visit root_path
    visit lot_path(lot.id)

    #Assert
    expect(current_path).to eq root_path
    expect(page).not_to have_content 'MOTOROI5XL'
    expect(page).to have_content 'Você não possui acesso a este módulo.'
  end

  it 'a partir da tela inicial como administrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user )
    
        #Act
    login_as(user)
    visit root_path
    click_on 'Controle de Lotes'
    click_on 'ABC123456'

    #Assert
    expect(page).to have_content 'Lote ABC123456'

    formatted_date1 = I18n.localize(1.week.from_now.to_date)
    expect(page).to have_content "Data inicial #{formatted_date1}"

    formatted_date2 = I18n.localize(1.month.from_now.to_date)
    expect(page).to have_content "Data limite #{formatted_date2}"

    expect(page).to have_content 'Lance mínimo 100'
    expect(page).to have_content 'Diferença mínima entre lances 5'
  end 

  it 'e vê itens do lote' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    
    category_a = Category.create!(name: 'TV')
    category_b = Category.create!(name: 'Computadore/Notebooks/Tablets')
    category_c = Category.create!(name: 'Celulares')

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV24SAMSUN')
    product_a = Product.create!(name: 'TV 24', description: 'TV 24 SAMSUNG', 
    weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('NOTEI5ASUS')
    product_b = Product.create!(name: 'Notebook Asus', description: 'Notebook Asus SAMSUNG', 
        weight: 5000, width: 100, height: 200, depth: 10, category: category_b)  
    
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('CELMOTOG42')
    product_c = Product.create!(name: 'Celular MotG42',  description: 'Smartphone Motorola Azul',
    weight: 800, width: 10, height: 15, depth: 5, category: category_c) 

    lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user )
    
    LotItem.create!(lot: lot, product: product_a)    
    LotItem.create!(lot: lot, product: product_b)    

        #Act
    login_as(user)
    visit root_path
    click_on 'Controle de Lotes'
    click_on 'ABC123456'

    #Assert
    expect(page).to have_content 'Lote ABC123456'
    expect(page).to have_content 'Itens do Lote'
    expect(page).to have_content 'TV24SAMSUN - TV 24'
    expect(page).to have_content 'NOTEI5ASUS - Notebook Asus'
    expect(page).not_to have_content 'CELMOTOG42 - Celular MotG42'
  end
end