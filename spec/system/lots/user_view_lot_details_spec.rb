require 'rails_helper'

describe 'Usuário vê detalhes do lote' do 
  it 'a partir da tela inicial como não autenticado e o lote está aprovado' do
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

    visit root_path
    click_on 'ABC123456'

    #Assert
    expect(page).to have_content 'Lote ABC123456'
    formatted_date1 = I18n.localize(1.week.from_now.to_date)
    expect(page).to have_content "Data inicial #{formatted_date1}"
    formatted_date2 = I18n.localize(1.month.from_now.to_date)
    expect(page).to have_content "Data limite #{formatted_date2}"
    expect(page).to have_content 'Lance mínimo inicial R$ 100,00'
    expect(page).to have_content 'Diferença mínima entre lances R$ 5,00'
    expect(page).to have_content 'TV-01 SAMSUNG32'
    expect(page).to have_content 'TV-02 SAMSUNG43'
  end
  
  it 'a partir da tela de Controle de Lotes como administrador' do
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
    expect(page).to have_content 'Lance mínimo inicial R$ 100,00'
    expect(page).to have_content 'Diferença mínima entre lances R$ 5,00'
  end 

  it 'e vê itens do lote, como administrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    
    category_a = Category.create!(name: 'TV')

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV01-32SAN')
    product_a = Product.create!(name: 'TV-01 SAMSUNG32', 
        description: 'Smart TV LED 32" HD Samsung T3200 com HDR, Sistema Operacional Tizen', 
        weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV02-43SAN')
    product_b = Product.create!(name: 'TV-02 SAMSUNG43', 
        description: 'Smart TV LED 43" HD Samsung T4300 com HDR, Sistema Operacional Tizen',
        weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV03-50SAN')
    product_c = Product.create!(name: 'TV-03 SAMSUNG50', 
        description: 'Smart TV LED 50" HD Samsung T4300 com HDR, Sistema Operacional Tizen',
        weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user )

    LotItem.create!(lot: lot, product: product_a)  
    product_a.blocked!    
    LotItem.create!(lot: lot, product: product_b)   
    product_b.blocked!  

    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de Lotes'
    click_on 'ABC123456'

    #Assert
    expect(page).to have_content 'Lote ABC123456'
    expect(page).to have_content 'Itens do Lote'
    expect(page).to have_content 'TV01-32SAN - TV-01 SAMSUNG32'
    expect(page).to have_content 'TV02-43SAN - TV-02 SAMSUNG43'
    expect(page).not_to have_content 'TV03-50SAN - TV-03 SAMSUNG50'
  end

  it 'e vê quem aprovou o lote, como adminstrador' do
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
    LotApprover.create!(lot: lot, user: user_cristina) 

    #Act
    login_as(user_cristina)
    visit root_path
    click_on 'Controle de Lotes'
    click_on 'ABC123456'

    #Assert
    expect(page).to have_content 'Lote ABC123456'
    expect(page).to have_content 'Aprovado'
    expect(page).to have_content 'Aprovado por Cristina Souza'
    expect(page).to have_content 'Itens do Lote'
    expect(page).to have_content 'TV01-32SAN - TV-01 SAMSUNG32'
  end
end
