require 'rails_helper'

describe 'Usuário admin se autentica' do
  it 'com sucesso' do
    # Arrange
    User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '38001357287')

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
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'Tereza Barros - tereza@leilaodogalpao.com.br'
    end
  end

  it 'e faz logout' do
    # Arrange
    User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '38001357287')

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
    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'Tereza Barros - tereza@leilaodogalpao.com.br'
  end
end