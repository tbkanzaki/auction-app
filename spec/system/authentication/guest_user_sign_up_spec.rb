require 'rails_helper'

describe 'Usuário visitante se autentica e faz cadastro' do
  it 'com sucesso' do
    # Arrange
    
    # Act
    visit('/') 
    click_on 'Entrar'
    click_on 'Criar conta'
    within('form') do
      fill_in 'E-mail', with: 'tereza@provedor.com'
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
      expect(page).to have_content "#{user.name} - tereza@provedor.com"
      #expect(user.admin).to be true
      expect(page).to have_content 'visitante'
    end
  end
end