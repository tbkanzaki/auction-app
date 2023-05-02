require 'rails_helper'

describe 'Usuário visita página inicial' do
  it 'e vê o nome da aplicação' do
    # Arrange
    
    # Act
    visit('/')

    # Assert
    expect(page).to have_content('Leilão de Estoque')
  end
end