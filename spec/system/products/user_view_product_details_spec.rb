require 'rails_helper'

describe 'Usuário vê detalhes do produto' do 
  it 'a partir da tela inicial como visitante' do
    #Arrange
    user = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
    
    category = Category.create!(name: 'Celular')

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('MOTOROI5XL')
    product = Product.create!(name: 'Celular MotG42',  description: 'Smartphone Motorola Moto G42 Azul',
                    weight: 800, width: 10, height: 15, depth: 5, category: category)
    #Act
    login_as(user)
    visit root_path
    visit product_path(product.id)

    #Assert
    expect(current_path).to eq root_path
    expect(page).not_to have_content 'MOTOROI5XL'
    expect(page).to have_content 'Você não possui acesso a este módulo.'
  end
  
  it 'a partir da tela inicial' do
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