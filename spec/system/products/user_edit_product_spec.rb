require 'rails_helper'

describe 'Usuário edita um produto' do
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
    visit edit_product_path(product.id)

    #Assert
    expect(current_path).to eq root_path
    expect(page).not_to have_field('Nome')
    expect(page).to have_content 'Você não possui acesso a este módulo.'
  end

  it 'a partir da tela de detalhes como administrador' do
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
    click_on 'Editar' 

    #Assert
    expect(page).to have_content('Editar Produto')
    expect(page).to have_field 'Nome', with: 'Celular MotG42'
    expect(page).to have_field 'Descrição', with: 'Smartphone Motorola Moto G42 Azul'
    expect(page).to have_field 'Peso', with: 800
    expect(page).to have_field 'Largura', with: 10
    expect(page).to have_field 'Altura', with: 15
    expect(page).to have_field 'Profundidade', with: 5
    expect(page).to have_button 'Enviar'
  end

  it 'com sucesso' do
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
    click_on 'Editar'

    fill_in 'Nome', with: 'MotG42 Celular'
    attach_file 'Foto do produto', "#{Rails.root}/app/assets/images/celular_mot_azul.jpg"
    fill_in 'Peso', with: 10000
    fill_in 'Altura', with: 600
    fill_in 'Largura', with: 900
    fill_in 'Profundidade', with: 10
    click_on 'Enviar'

    #Assert
    expect(page).to have_css('img[src*="celular_mot_azul.jpg"]')
    expect(page).to have_content 'MOTOROI5XL'
    expect(page).to have_content 'MotG42 Celular'
    expect(page).to have_content 'Celular'
    expect(page).to have_content 'Produto alterado com sucesso.'
  end
end
