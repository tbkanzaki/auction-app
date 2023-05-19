require 'rails_helper'

describe 'Usuário cadastra lotes' do
  it 'e precisa estar logado' do
    #Arrange
    
    #Act
    visit root_path
    visit lots_path

    #Assert
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'a partir da tela inicial como visitante' do
    #Arrange
    user = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')

    #Act
    login_as(user)
    visit root_path
    visit new_lot_path

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este módulo.'
  end
  
  it 'com sucesso, a partir da tela inicial como administrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de Lotes'
    click_on 'Novo Lote'
    fill_in 'Código', with: 'YYY123456'
    fill_in 'Data inicial', with: 1.week.from_now.to_date
    fill_in 'Data limite',  with: 1.month.from_now.to_date
    fill_in 'Lance mínimo inicial', with: 100
    fill_in 'Diferença mínima entre lances', with: 5
    click_on 'Salvar'

    #Assert
    expect(page).to have_content 'Lote cadastrado com sucesso.'
    expect(page).to have_content 'Lote YYY123456'
    formatted_date1 = I18n.localize(1.week.from_now.to_date)
    expect(page).to have_content "Data inicial #{formatted_date1}"
    formatted_date2 = I18n.localize(1.month.from_now.to_date)
    expect(page).to have_content "Data limite #{formatted_date2}"
    expect(page).to have_content 'Lance mínimo inicial R$ 100,00'
    expect(page).to have_content 'Diferença mínima entre lances R$ 5,00'
  end

  it 'com dados incompletos, como administrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de Lotes'
    click_on 'Novo Lote'
    fill_in 'Código', with: ''
    fill_in 'Data inicial', with: ''  
    fill_in 'Data limite', with: ''
    fill_in 'Lance mínimo inicial', with: ''
    fill_in 'Diferença mínima entre lances', with: ''
    click_on 'Salvar'

    #Assert
    expect(page).to have_content 'Não foi possível cadastrar o lote.'
    expect(page).to have_content 'Código não pode ficar em branco'
    expect(page).to have_content 'Data inicial não pode ficar em branco'
    expect(page).to have_content 'Data limite não pode ficar em branco'
    expect(page).to have_content 'Lance mínimo inicial não pode ficar em branco'
    expect(page).to have_content 'Diferença mínima entre lances não pode ficar em branco'
  end

  it 'com Data inicial menor que a data de hoje, a partir da tela inicial como administrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de Lotes'
    click_on 'Novo Lote'
    fill_in 'Código', with: 'YYY123456'
    fill_in 'Data inicial', with: 2.days.ago.to_date
    fill_in 'Data limite',  with: 1.month.from_now.to_date
    fill_in 'Lance mínimo', with: 100
    fill_in 'Diferença mínima entre lances', with: 5
    click_on 'Salvar'

    #Assert
    expect(page).not_to have_content 'Lote cadastrado com sucesso.'
    expect(page).to have_content 'Não foi possível cadastrar o lote.'
    expect(page).to have_content 'Data inicial deve ser maior que a data de hoje.'
  end
end
