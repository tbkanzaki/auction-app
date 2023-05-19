require 'rails_helper'

describe 'Usuário faz busca do lote' do 
  it 'a partir da tela inicial como visitante' do
    #Arrange
    
    #Act
    visit root_path

    #Assert
    expect(page).to have_button 'Buscar'
  end

  it 'e encontra um lote pelo código' do
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
    
    #Act 
    visit root_path
    fill_in 'Buscar', with: lot1.code
    click_on 'Buscar'

    #Assert
    expect(page).to have_content 'Resultado da busca para: ABC123456'
    expect(page).to have_content '1 lote encontrado'
    expect(page).to have_content 'ABC123456'
    expect(page).to have_content 'Itens do Lote'
    expect(page).to have_content 'TV-01 SAMSUNG32'
    expect(page).not_to have_content 'XYZ123456'
    expect(page).not_to have_content 'TV-02 SAMSUNG43'
  end

  it 'e encontra múltiplos lotes bucado por parte do código do lote' do
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

    lot1 = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
    minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )

    lot2 = Lot.create!(code:'XYZ123456', start_date: 1.week.from_now, limit_date: 3.weeks.from_now, 
            minimum_bid: 100, minimum_difference_bids: 10, status: 0, user: user_tereza )

    Lot.create!(code:'TAB000001', start_date: 1.day.from_now, limit_date: 2.months.from_now, 
    minimum_bid: 50, minimum_difference_bids: 5, status: 0, user: user_tereza )

    LotItem.create!(lot: lot1, product: product_a)  
    product_a.blocked!    
    LotItem.create!(lot: lot2, product: product_b)   
    product_b.blocked!   
    lot1.approved!
    lot_approver = LotApprover.create!(lot: lot1, user: user_cristina) 
    lot2.approved!
    lot_approver = LotApprover.create!(lot: lot2, user: user_cristina) 

    #Act
    visit root_path
    fill_in 'Buscar', with: '2345'
    click_on 'Buscar'

    #Assert
    expect(page).to have_content 'Resultado da busca para: 2345'
    expect(page).to have_content '2 lotes encontrados'
    expect(page).to have_content 'Código do lote'
    expect(page).to have_content 'Itens do Lote'
    expect(page).to have_content 'XYZ123456'
    expect(page).to have_content 'TV-02 SAMSUNG43'
    expect(page).to have_content 'ABC123456'
    expect(page).to have_content 'TV-01 SAMSUNG32'
    expect(page).not_to have_content 'TAB000001'
  end

  it 'e encontra múltiplos lotes bucado por parte do nome do produto' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    user_cristina = User.create!(name: 'Cristina Souza', email:'cristina@leilaodogalpao.com.br', password:'senha1234', cpf: '97458446919')

    category_a = Category.create!(name: 'TV')
    category_b = Category.create!(name: 'Computadore/Notebooks/Tablets')

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV01-32SAN')
    product_a = Product.create!(name: 'TV-01 SAMSUNG32', 
        description: 'Smart TV LED 32" HD Samsung T3200 com HDR, Sistema Operacional Tizen', 
        weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV02-43SAN')
    product_b = Product.create!(name: 'TV-02 SAMSUNG43', 
        description: 'Smart TV LED 43" HD Samsung T4300 com HDR, Sistema Operacional Tizen',
        weight: 10000, width: 600, height: 900, depth: 10, category: category_a) 

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('NOTEI5ASUS')
    product_c = Product.create!(name: 'Notebook Asus', description: 'Notebook Asus', 
          weight: 5000, width: 100, height: 200, depth: 10, category: category_b)  

    lot1 = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
    minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )

    lot2 = Lot.create!(code:'XYZ123456', start_date: 1.week.from_now, limit_date: 3.weeks.from_now, 
            minimum_bid: 100, minimum_difference_bids: 10, status: 0, user: user_tereza )

    LotItem.create!(lot: lot1, product: product_a) 
    product_a.blocked!    
    LotItem.create!(lot: lot1, product: product_b)   
    product_b.blocked! 
    lot1.approved!
    lot_approver = LotApprover.create!(lot: lot1, user: user_cristina) 

    LotItem.create!(lot: lot2, product: product_c)  
    product_c.blocked!  
    lot2.approved!
    lot_approver = LotApprover.create!(lot: lot2, user: user_cristina) 

    #Act
    visit root_path
    fill_in 'Buscar', with: 'TV'
    click_on 'Buscar'

    #Assert
    expect(page).to have_content 'Resultado da busca para: TV'
    expect(page).to have_content '2 lotes encontrados'
    expect(page).to have_content 'Código do lote'
    expect(page).to have_content 'Itens do Lote'
    expect(page).to have_content 'ABC123456'
    expect(page).to have_content 'TV-01 SAMSUNG32'
    expect(page).to have_content 'TV-02 SAMSUNG43'
    expect(page).not_to have_content 'XYZ123456'
  end

  it 'e não encontra lote' do
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
    
    LotItem.create!(lot: lot, product: product_a)  
    product_a.blocked!    
    LotItem.create!(lot: lot, product: product_b)   
    product_b.blocked!    
    lot.approved!
    LotApprover.create!(lot: lot, user_id: user_cristina.id) 

    #Act
    visit root_path
    fill_in 'Buscar', with: "Celular"
    click_on 'Buscar'

    #Assert
    expect(page).to have_content 'Resultado da busca para: Celular'
    expect(page).to have_content 'Não existem lotes para essa busca.'
    expect(page).not_to have_content 'ABC123456'
  end
end
