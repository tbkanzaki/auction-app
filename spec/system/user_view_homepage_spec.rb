require 'rails_helper'

describe 'Usuário visita página inicial' do
  it 'e vê o nome da aplicação' do
    # Arrange
    
    # Act
    visit('/')

    # Assert
    expect(page).to have_content('Leilão de Estoque')
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_content 'Cadastrar Categoria'
  end
end