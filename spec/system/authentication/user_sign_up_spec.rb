require 'rails_helper'

describe 'Usuário admin se autentica e faz cadastro' do
  it 'com sucesso' do
    # Arrange
    
    # Act
    visit('/') 
    click_on 'Entrar'
    click_on 'Criar conta'
    within('form') do
      fill_in 'E-mail', with: 'tereza@leilaodogalpao.com.br'
      fill_in 'Senha', with: 'senha1234'
      fill_in 'Confirme sua senha', with: 'senha1234'
      fill_in 'Nome', with: 'Tereza Barros'
      fill_in 'CPF', with: '380.013.572-87'
      click_on 'Criar conta'
    end

    # Assert
    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
    within('nav') do
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
      user = User.last
      expect(user.name).to eq 'Tereza Barros'
      expect(page).to have_content "#{user.name} - tereza@leilaodogalpao.com.br"
      #expect(user.admin).to be true
      expect(page).to have_content 'administrador'
    end
  end

  it 'com dados incompletos' do
    # Arrange
    
    # Act
    visit('/') 
    click_on 'Entrar'
    click_on 'Criar conta'
    within('form') do
      fill_in 'E-mail', with: 'tereza@leilaodogalpao.com.br'
      fill_in 'Senha', with: 'senha1234'
      fill_in 'Confirme sua senha', with: 'senha1234'
      fill_in 'CPF', with: ''
      click_on 'Criar conta'
    end

    # Assert
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'Não foi possível salvar usuário'
    expect(page).not_to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
  end

  it 'com cpf inválido' do
    # Arrange
    
    # Act
    visit('/') 
    click_on 'Entrar'
    click_on 'Criar conta'
    within('form') do
      fill_in 'E-mail', with: 'tereza@leilaodogalpao.com.br'
      fill_in 'Senha', with: 'senha1234'
      fill_in 'Confirme sua senha', with: 'senha1234'
      fill_in 'Nome', with: 'Tereza Barros'
      fill_in 'CPF', with: '380.013.031-41'
      click_on 'Criar conta'
    end

    # Assert
    expect(page).to have_content 'CPF inválido'
    expect(page).not_to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
  end
end
