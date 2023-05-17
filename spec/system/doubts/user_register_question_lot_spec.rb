require 'rails_helper'

describe 'Usuário visitante autenticado registra dúvida sobre lote' do 
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
    click_on 'Enviar dúvida'
    fill_in 'Pergunta', with: 'Gostaria de saber se...' 
    click_on 'Salvar'

    #Assert
    expect(current_path).to eq lot_path(lot.id)
    expect(page).to have_content 'Lote ABC123456'
    expect(page).to have_content 'Gostaria de saber se...'
    expect(page).to have_content 'Itens do Lote'
    expect(page).to have_content 'TV01-32SAN - TV-01 SAMSUNG32'
  end

  it 'com dados incompletos, a partir da tela inicial' do
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
    click_on 'Enviar dúvida'
    fill_in 'Pergunta', with: '' 
    click_on 'Salvar'
  
    #Assert
    expect(page).to have_content 'Não foi possível salvar a pergunta.'
    expect(page).not_to have_content 'Lote ABC123456'
  end
end