require 'rails_helper'

describe 'Usuário visita página de Controle de Lotes' do
  it 'a partir da tela inicial como visitante' do
    #Arrange
    user_maria = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )
    #Act
    login_as(user_maria)
    visit root_path
    visit lots_path

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este módulo.'
  end

  it 'a partir da tela inicial como administrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de Lotes'

    #Assert
    expect(current_path).to eq lots_path
    expect(page).to have_content 'Lotes'
  end

  it 'e vê a lista de lotes aguardando aprovação como administrador' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    Lot.create!(code:'ABC123456', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                  minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user )
    
    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de Lotes'  

    #Assert
    expect(current_path).to eq lots_path
    expect(page).to have_content 'Aguardando aprovação'
    expect(page).to have_content 'Lote'
    expect(page).to have_content 'Data inicial'
    expect(page).to have_content 'Data limite'
    expect(page).to have_content 'Lance mínimo'

    expect(page).to have_content 'ABC123456'
    formatted_date1 = I18n.localize(1.week.from_now.to_date)
    expect(page).to have_content "#{formatted_date1}"
    formatted_date2 = I18n.localize(1.month.from_now.to_date)
    expect(page).to have_content "#{formatted_date2}"
    expect(page).to have_content '100'
  end

  it 'e não existem lotes no momento.' do
    #Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de Lotes' 

    #Assert
    expect(page).to have_content 'Aguardando aprovação'
    expect(page).to have_content 'Em andamento'
    expect(page).to have_content 'Futuros'
    expect(page).to have_content 'Não existem lotes no momento.'
  end
end
