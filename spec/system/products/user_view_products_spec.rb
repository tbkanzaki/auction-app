require 'rails_helper'

describe 'Usuário visita página de produtos' do
  it 'a partir da tela inicial como visitante' do
    #Arrange
    user = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')

    #Act
    login_as(user)
    visit root_path
    visit products_path

    # Assert
    expect(current_path).to eq root_path
    expect(page).not_to have_content 'Produtos'
    expect(page).to have_content 'Você não possui acesso a este módulo.'
  end

  it 'a partir da tela inicial como administrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Produtos'

    # Assert
    expect(page).to have_content 'Produtos'
    expect(current_path).to eq products_path
  end

  it 'e vê a lista de produtos cadastrados como administrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    category_a = Category.create!(name: 'Eletrodoméstico')
    category_b = Category.create!(name: 'Celular')

    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('SAMSULP6FA')
    product_a = Product.create!(name: 'TV 32', description: 'TV 32 SAMSUNG', 
                                weight: 10000, width: 600, height: 900, depth: 10, category: category_a)   
    
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('MOTORLP6FA')
    product_a = Product.create!(name: 'Celular MotG42',  description: 'Smartphone Motorola Moto G42 Azul',
                                weight: 800, width: 10, height: 15, depth: 5, category: category_b) 
    
    
    #Act
    login_as(user)
    visit root_path
    click_on 'Produtos'  

    #Assert
    expect(page).to have_content 'Produtos'
    expect(page).to have_content 'SAMSULP6FA'
    expect(page).to have_content 'TV 32'
    expect(page).to have_content 'Eletrodoméstico'
    expect(page).to have_content 'MOTORLP6FA'
    expect(page).to have_content 'Celular MotG42'
    expect(page).to have_content 'Celular'
  end
  
  it 'e não existe produto cadastrado' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Produtos' 

    #Assert
    expect(page).to have_content 'Produtos'
    expect(page).to have_content 'Não existem produtos cadastrados.'
  end
end
