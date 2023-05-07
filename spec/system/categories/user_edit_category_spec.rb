require 'rails_helper'

describe 'Usuário edita uma categoria' do
  it 'a partir da tela de edição como visitante' do
    #Arrange
    user = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
    category = Category.create!(name: 'Esporte/Lazer')

    #Act
    login_as(user)
    visit root_path
    visit edit_category_path(category.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).not_to have_field('Nome')
    expect(page).to have_content 'Você não possui acesso a este módulo.'
  end

  it 'a partir da lista das categorias como adminstrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    Category.create!(name: 'Esporte/Lazer')

    #Act
    login_as(user)
    visit root_path
    click_on 'Categorias'
    click_on 'Esporte/Lazer'

    #Assert
    expect(page).to have_content 'Editar Categoria'
    expect(page).to have_field('Nome', with:'Esporte/Lazer')
  end

  it 'com sucesso como adminstrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    Category.create!(name: 'Esporte/Lazer')

    #Act
    login_as(user)
    visit root_path
    click_on 'Categorias'
    click_on 'Esporte/Lazer'
    fill_in 'Nome', with: 'Esporte & Lazer'
    click_on 'Salvar'
    
    #Assert
    expect(current_path).to eq categories_path
    expect(page).to have_link 'Esporte & Lazer'
    expect(page).to have_content 'Categoria alterada com sucesso.'
  end
end
