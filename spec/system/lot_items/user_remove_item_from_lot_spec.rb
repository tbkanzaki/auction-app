require 'rails_helper'

describe 'Usuário remove itens do lote' do
  # it 'a partir da tela inicial como visitante' do
  #   #Arrange
  #   user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    
  #   category_a = Category.create!(name: 'TV')
  #   category_b = Category.create!(name: 'Computadore/Notebooks/Tablets')

  #   allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV24SAMSUN')
  #   product_1 = Product.create!(name: 'TV 24', description: 'TV 24 SAMSUNG', 
  #   weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

  #   allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('NOTEI5ASUS')
  #   product_2 = Product.create!(name: 'Notebook Asus', description: 'Notebook Asus SAMSUNG', 
  #       weight: 5000, width: 100, height: 200, depth: 10, category: category_b)  
    
  #   lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
  #                 minimum_bid: 100, minimum_difference_bids: 5, user: user )

  #   lot_item = LotItem.create!(lot: lot, product: product_1)    
 
  #   #Act
  #   login_as(user)
  #   visit root_path
  #   visit lot_lot_item_path(lot.id,lot_item.id)

  #   #Assert
  #   expect(current_path).to eq root_path
  #   expect(page).to have_content 'Você não possui acesso a este módulo.'
  # end

  it 'com sucesso, como administrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    
    category_a = Category.create!(name: 'TV')
    category_b = Category.create!(name: 'Computadore/Notebooks/Tablets')

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('TV24SAMSUN')
    product_1 = Product.create!(name: 'TV 24', description: 'TV 24 SAMSUNG', 
    weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('NOTEI5ASUS')
    product_2 = Product.create!(name: 'Notebook Asus', description: 'Notebook Asus SAMSUNG', 
        weight: 5000, width: 100, height: 200, depth: 10, category: category_b)  
    
    lot = Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, user: user )

    LotItem.create!(lot: lot, product: product_1)    
    LotItem.create!(lot: lot, product: product_2)    

    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de Lotes'
    click_on 'ABC123456'
    find_button('Remover item', id: 'lot_item_1').click()

    #Assert
    count_items_after = LotItem.where(lot: lot).count
    expect(count_items_after).to eq 1
    expect(current_path).to eq lot_path(lot.id)
    expect(page).to have_content 'Item removido com sucesso'
    expect(page).to have_content 'ABC123456'
    expect(page).not_to have_content 'TV24SAMSUN - TV 24'
    expect(page).to have_content 'NOTEI5ASUS - Notebook Asus'
  end
end 