require 'rails_helper'

describe 'Usuário visita página de Controle de Lotes' do
  it 'a partir da tela inicial como visitante e não tem acesso' do
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

  it 'e precisa estar logado' do
    #Arrange
    
    #Act
    visit root_path
    visit lots_path

    #Assert
    expect(current_path).not_to eq lots_path
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'a partir da tela inicial logado como administrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de Lotes'

    #Assert
    expect(current_path).to eq lots_path
    expect(page).to have_content 'Lotes'
  end

  it 'e vê a lista de lotes aguardando aprovação como administrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user )
    
    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de Lotes'  

    #Assert
    expect(current_path).to eq lots_path
    expect(page).to have_content 'Aguardando aprovação'
    expect(page).to have_content 'Lote'
    expect(page).to have_content 'Data inicial'
    expect(page).to have_content 'Data limite'
    expect(page).to have_content 'Lance mínimo'

    expect(page).to have_content 'ABC123456'
    formatted_date1 = I18n.localize(1.week.from_now.to_date)
    expect(page).to have_content "#{formatted_date1}"
    formatted_date2 = I18n.localize(1.month.from_now.to_date)
    expect(page).to have_content "#{formatted_date2}"
    expect(page).to have_content '100'
  end

  it 'e vê a lista de lotes nos 6 status diferentes, como administrador' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    user_cristina = User.create!(name: 'Cristina Souza', email:'cristina@leilaodogalpao.com.br', password:'senha1234', cpf: '97458446919')
    user_maria = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')

    category_a = Category.create!(name: 'TV')
    category_c = Category.create!(name: 'Computadore/Notebooks/Tablets')

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
        weight: 5000, width: 100, height: 200, depth: 10, category: category_c)  

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('NOTEI7SAMS')
    product_d = Product.create!(name: 'Notebook SAMSUNG', description: 'Notebook SAMSUNG prata GerfoceGTX', 
        weight: 5000, width: 100, height: 200, depth: 10, category: category_c)

    lot1 = Lot.create!(code:'TAB000001', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )

    lot2 = Lot.create!(code:'TAB000002', start_date: 1.day.from_now , limit_date: 2.months.from_now, 
                minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )

    lot3 = Lot.create!(code:'TAB000003', start_date: 1.week.from_now , limit_date: 3.weeks.from_now, 
                minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )

    lot4 = Lot.create!(code:'CAB000001', start_date: 1.day.from_now, limit_date: 2.months.from_now, 
            minimum_bid: 400, minimum_difference_bids: 40, status: 0, user: user_cristina )

    lot5 = Lot.create!(code:'CAB000002', start_date: 2.days.from_now, limit_date: 1.week.from_now, 
            minimum_bid: 100, minimum_difference_bids: 10, status: 0, user: user_cristina )

    lot6 = Lot.create!(code:'CAB000003', start_date: 1.week.from_now, limit_date: 3.weeks.from_now, 
            minimum_bid: 200, minimum_difference_bids: 20, status: 0, user: user_cristina )

    
    LotItem.create!(lot: lot2, product: product_a)  
    product_a.blocked!  
    LotApprover.create!(lot: lot2, user: user_cristina) 
    lot2.approved!
    Lot.find(lot2.id).update(start_date: 1.week.ago)

    LotItem.create!(lot: lot3, product: product_b)  
    product_b.blocked!  
    LotApprover.create!(lot: lot3, user: user_cristina) 
    lot3.approved!

    LotItem.create!(lot: lot4, product: product_c)  
    product_c.blocked!  
    LotApprover.create!(lot: lot4, user: user_tereza) 
    lot4.approved!
    Lot.find(lot4.id).update(start_date: 1.month.ago)
    LotBid.create!(lot: lot4, user: user_maria, bid: 110) 
    Lot.find(lot4.id).update(limit_date: 2.days.ago)
    lot4.closed!
    product_c.sold!
   
    lot_item = LotItem.create!(lot: lot5, product: product_d)  
    product_d.blocked!  
    LotApprover.create!(lot: lot5, user: user_tereza) 
    lot5.approved!
    Lot.find(lot5.id).update(start_date: 1.month.ago)
    Lot.find(lot5.id).update(limit_date: 2.days.ago)
    lot5.cancelled!
    LotItem.delete(lot_item.id)
    product_d.unblocked! 

    lot_item = LotItem.create!(lot: lot6, product: product_d)  
    product_d.blocked!  
    LotApprover.create!(lot: lot6, user: user_tereza) 
    lot6.approved!
    Lot.find(lot6.id).update(start_date: 1.month.ago)
    Lot.find(lot6.id).update(limit_date: 2.days.ago)

    #Act
    login_as(user_tereza)
    visit root_path
    click_on 'Controle de Lotes'  

    #Assert
    expect(current_path).to eq lots_path
    expect(page).to have_content 'Expirados'
    expect(page).to have_content 'CAB000003'
    expect(page).to have_content 'Aguardando aprovação'
    expect(page).to have_content 'TAB000001'
    expect(page).to have_content 'Aprovados - Em andamento'
    expect(page).to have_content 'TAB000002'
    expect(page).to have_content 'Aprovados - Futuros'
    expect(page).to have_content 'TAB000003'
    expect(page).to have_content 'Encerrados'
    expect(page).to have_content 'CAB000001'
    expect(page).to have_content 'Cancelados'
    expect(page).to have_content 'CAB000002'
  end

  it 'e não existem lotes no momento.' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de Lotes' 

    #Assert
    expect(page).to have_content 'Aguardando aprovação'
    expect(page).to have_content 'Em andamento'
    expect(page).to have_content 'Futuros'
    expect(page).to have_content 'Não existem lotes no momento.'
  end
end
