require 'rails_helper'

describe 'Usuário visita página inicial' do
  it 'e mesmo não autenticado, vê somente lotes aprovados' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    Lot.create!(code:'TAB000003', start_date: 1.day.from_now , limit_date: 1.month.from_now, 
              minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )

    lot_1 = Lot.create!(code:'TAB000005', start_date: 1.day.from_now , limit_date: 2.months.from_now, 
                minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )

    lot_2 = Lot.create!(code:'TAB000001', start_date: 1.week.from_now , limit_date: 3.weeks.from_now, 
                minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )
  
    lot_1.approved!
    lot_2.cancelled!
    #Act
    visit root_path
 
    #Assert
    expect(page).to have_content 'Em andamento'
    expect(page).to have_content 'Futuros'
    expect(page).to have_content 'Código'
    expect(page).to have_content 'Data inicial'
    expect(page).to have_content 'Data limite'
    expect(page).to have_content 'Lance mínimo'
    expect(page).to have_content 'TAB000005'
    formatted_date1 = I18n.localize(1.day.from_now.to_date)
    expect(page).to have_content "#{formatted_date1}"
    formatted_date2 = I18n.localize(2.months.from_now.to_date)
    expect(page).to have_content "#{formatted_date2}"

    expect(page).not_to have_content 'TAB000001'
    expect(page).not_to have_content 'TAB000003'
  end

  it 'e não vê a lista de lotes que ainda não foram aprovados, fechados ou cancelados ' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    Lot.create!(code:'TAB000001', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                minimum_bid: 100, minimum_difference_bids: 5, status: 'waiting_approval', user: user_tereza )

    Lot.create!(code:'TAB000003', start_date: 1.day.from_now , limit_date: 1.month.from_now, 
                minimum_bid: 100, minimum_difference_bids: 5, status: 'waiting_approval', user: user_tereza )

    Lot.create!(code:'TAB000009', start_date: 1.day.from_now , limit_date: 2.weeks.from_now,
                minimum_bid: 100, minimum_difference_bids: 5, status: 'cancelled', user: user_tereza )
   #Act
    visit root_path
 
    #Assert
    expect(page).to have_content 'Em andamento'
    expect(page).to have_content 'Futuros'
    expect(page).not_to have_content 'TAB000001'
    expect(page).not_to have_content 'TAB000003'
    expect(page).not_to have_content 'TAB000009'
    expect(page).to have_content 'Não existem lotes no momento.'
  end

  it 'e não visualiza lotes Expirados' do
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
    login_as(user_maria)
    visit root_path

    #Assert
    expect(page).not_to have_content 'ABC123456'

  end

  it 'e não existem lotes no momento.' do
    #Arrange
    
    #Act
    visit root_path

    #Assert
    expect(page).to have_content 'Em andamento'
    expect(page).to have_content 'Futuros'
    expect(page).to have_content 'Não existem lotes no momento.'
  end
end
