require 'rails_helper'

describe 'Usuário bloqueia cpf ainda não cadastrado no sistema' do
  it 'a partir da tela inicial, como visitante' do
    #Arrange
    user = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')

    #Act
    login_as(user)
    visit root_path
    visit blocked_cpfs_path

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este módulo.'
  end

  it 'a partir da tela inicial, como administrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de CPF'

    # Assert
    expect(page).to have_content 'Cadastrar CPF para bloqueio'
    expect(page).to have_field('CPF')
    expect(page).to have_field('Nome')
  end

  it 'com sucesso, como administrador ' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de CPF'
    fill_in 'CPF', with: '04837505732'
    fill_in 'Nome', with: 'Carlos Souza'
    click_on 'Salvar'
    
    #Assert
    expect(current_path).to eq blocked_cpfs_path
    expect(page).to have_content 'CPF cadastrado com sucesso.'
  end

  it 'de um usuário já cadastrado no sistema, como administrador ' do
    #Arrange
    User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de CPF'
    fill_in 'CPF', with: '66610881090'
    fill_in 'Nome', with: 'Maria Sousa'
    click_on 'Salvar'
    
    #Assert
    expect(current_path).to eq blocked_cpfs_path
    expect(page).to have_content 'CPF não cadastrado.'
    expect(page).to have_content 'CPF pertence a um usuário do sistema. Faça pelo bloqueio mais abaixo.'
  end

  it 'com dados incompletos, como administrador' do
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de CPF'
    fill_in 'CPF', with: ''
    fill_in 'Nome', with: ''
    click_on 'Salvar'
    
    #Assert
    expect(current_path).to eq blocked_cpfs_path
    expect(page).to have_content 'CPF não cadastrado.'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'CPF inválido.'
  end

  it 'com cpf invalido, como administrador' do
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de CPF'
    fill_in 'CPF', with: '04837505700'
    click_on 'Salvar'
    
    #Assert
    expect(current_path).to eq blocked_cpfs_path
    expect(page).to have_content 'CPF não cadastrado.'
    expect(page).to have_content 'CPF inválido.'
  end
end

describe 'Usuário bloqueia cpf de usuário do sistema' do
  it 'com sucesso, como administrador' do
    user_maria = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de CPF'
    find_button('Bloquear', id: 'user_1').click()
    
    #Assert
    expect(current_path).to eq blocked_cpfs_path
    expect(page).to have_content 'Usuário bloqueado com sucesso.'
    expect(page).to have_content 'Maria Sousa'
    expect(page).to have_selector(:link_or_button, 'Desbloquear', id: 'user_1')
  end
end 
