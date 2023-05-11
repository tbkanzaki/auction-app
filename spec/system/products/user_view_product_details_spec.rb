require 'rails_helper'

describe 'Usuário vê detalhes do produto' do 
  it 'a partir da tela inicial como não autenticado' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    user_cristina = User.create!(name: 'Cristina Souza', email:'cristina@leilaodogalpao.com.br', password:'senha1234', cpf: '97458446919')

    category_a = Category.create!(name: 'TV')

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV01-32SAN')
    product_a = Product.create!(name: 'TV-01 SAMSUNG32', 
        description: 'Smart TV LED 32" HD Samsung T3200 com HDR, Sistema Operacional Tizen', 
        weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )
    
    lot_item_1 = LotItem.create!(lot: lot, product: product_a)    
  
    lot.approved!
    lot_approver = LotApprover.create!(lot: lot, user_id: user_cristina.id) 

    visit root_path
    click_on 'ABC123456'
    click_on 'TV01-32SAN - TV-01 SAMSUNG32'

    #Assert
    expect(page).to have_content 'TV-01 SAMSUNG32'
    expect(page).to have_content 'Smart TV LED 32" HD Samsung T3200 com HDR, Sistema Operacional Tizen'
    expect(page).not_to have_content 'Editar'
  end
  
  it 'a partir da tela inicial, como administrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    category = Category.create!(name: 'Celular')

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('MOTOROI5XL')
    Product.create!(name: 'Celular MotG42',  description: 'Smartphone Motorola Moto G42 Azul',
                    weight: 800, width: 10, height: 15, depth: 5, category: category) 

    #Act
    login_as(user)
    visit root_path
    click_on 'Produtos' 
    click_on 'MOTOROI5XL'

    #Assert
    expect(page).to have_content 'MOTOROI5XL'
    expect(page).to have_content 'Celular MotG42'
    expect(page).to have_content 'Celular'
  end 
end
