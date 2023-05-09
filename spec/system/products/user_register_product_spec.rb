require 'rails_helper'

describe 'Usuário cadastra produto' do
  it 'a partir da tela inicial como visitante' do
    #Arrange
    user = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
    Category.create!(name: 'Eletrodoméstico')

    #Act
    login_as(user)
    visit root_path
    visit new_product_path

    # Assert
    expect(current_path).to eq root_path
    expect(page).not_to have_field('Nome')
    expect(page).not_to have_field('Categoria', with:'Eletrodoméstico')
    expect(page).to have_content 'Você não possui acesso a este módulo.'
  end

  it 'a partir da tela inicial como administrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    Category.create!(name: 'Celular')
    
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('MOTOROI5XL')

    #Act
    login_as(user)
    visit root_path
    click_on 'Produtos' 
    click_on 'Novo Produto' 
    fill_in 'Nome', with: 'Celular MotG42'
    attach_file 'Foto do produto', "#{Rails.root}/app/assets/images/Celular.jpg"
    fill_in 'Descrição', with: 'Smartphone Motorola Moto G42 Azul'
    fill_in 'Peso', with: 10000
    fill_in 'Altura', with: 600
    fill_in 'Largura', with: 900
    fill_in 'Profundidade', with: 10
    select 'Celular', from: 'Categoria'
    click_on 'Salvar'

    #Assert
    expect(page).to have_css('img[src*="Celular.jpg"]')
    expect(page).to have_content 'MOTOROI5XL'
    expect(page).to have_content 'Celular MotG42'
    expect(page).to have_content 'Celular'
    expect(page).to have_content 'Produto cadastrado com sucesso'
  end

  it 'com dados incompletos' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    Category.create!(name: 'Celular')
    
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('MOTOROI5XL')

    #Act
    login_as(user)
    visit root_path
    click_on 'Produtos' 
    click_on 'Novo Produto' 
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    select 'Selecione', from: 'Categoria'
    click_on 'Salvar'

    #Assert
    expect(page).not_to have_content 'MOTOROI5XL'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Categoria é obrigatório(a)'
    expect(page).to have_content 'Não foi possível cadastrar o produto'
  end
end
