require 'rails_helper'

describe 'Usuário visita tela de categoria' do
  it 'a partir da tela inicial como visitante' do
    #Arrange
    user = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')

    #Act
    login_as(user)
    visit root_path
    visit new_category_path

    # Assert
    expect(page).not_to have_field('Nome')
    expect(page).to have_content 'Você não possui acesso a este módulo.'
  end

  it 'a partir da tela inicial como administrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Cadastrar Categoria'

    # Assert
    expect(page).to have_field('Nome')
  end

  it 'e faz cadastro com sucesso com sucesso' do
    #Arrange
    user = user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Cadastrar Categoria'
    fill_in 'Nome', with: 'Eletrodoméstico'
    click_on 'Salvar'
    
    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Categoria cadastrada com sucesso.'
  end

  it 'com dados incompletos' do
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Cadastrar Categoria'
    fill_in 'Nome', with: ''
    click_on 'Salvar'
    
    #Assert
    expect(page).to have_content 'Categoria não cadastrada.'
    expect(page).to have_content 'Nome não pode ficar em branco'
  end
end
