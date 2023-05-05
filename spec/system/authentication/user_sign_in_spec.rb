require 'rails_helper'

describe 'Usuário se autentica' do
  it 'como admin' do
    # Arrange
    User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    # Act
    visit('/') 
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'tereza@leilaodogalpao.com.br'
      fill_in 'Senha', with: 'senha1234'
      click_on 'Entrar'
    end

    # Assert
    expect(page).to have_content 'Login efetuado com sucesso.'
    within('nav') do
      expect(page).to have_content 'Cadastrar Categoria'
      expect(page).to have_content 'administrador'
      expect(page).to have_content 'Tereza Barros - tereza@leilaodogalpao.com.br'
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
    end
  end

  it 'como visitante' do
    # Arrange
    User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')

    # Act
    visit('/') 
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'maria@provedor.com'
      fill_in 'Senha', with: 'senha1234'
      click_on 'Entrar'
    end

    # Assert
    expect(page).to have_content 'Login efetuado com sucesso.'
    within('nav') do
      expect(page).not_to have_content 'Cadastrar Categoria'
      expect(page).to have_content 'visitante'
      expect(page).to have_content 'Maria Sousa - maria@provedor.com'
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
    end
  end

  it 'como admin e faz logout' do
    # Arrange
    User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    # Act
    visit('/')
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'tereza@leilaodogalpao.com.br'
      fill_in 'Senha', with: 'senha1234'
      click_on 'Entrar'
    end
    click_on 'Sair'

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'Tereza Barros - tereza@leilaodogalpao.com.br'
    expect(page).not_to have_content 'Cadastrar Categoria'
  end

  it 'como visitante e faz logout' do
    # Arrange
    User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')

    # Act
    visit('/')
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'maria@provedor.com'
      fill_in 'Senha', with: 'senha1234'
      click_on 'Entrar'
    end
    click_on 'Sair'

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'Maria Sousa - maria@provedor.com'
    expect(page).not_to have_content 'Cadastrar Categoria'
  end
end
