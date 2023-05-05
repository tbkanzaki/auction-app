require 'rails_helper'

describe 'Usuário visita página inicial' do
  it 'e vê a imagem com o atributo alt com o nome da aplicação' do
    # Arrange
    
    # Act
    visit('/')

    # Assert
    expect(page).to have_link 'Entrar'
    expect(page).to have_selector('img[alt="Leilão de Estoque"]')
    expect(page).not_to have_content 'Categorias'
  end
end
