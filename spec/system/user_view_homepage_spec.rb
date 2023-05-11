require 'rails_helper'

describe 'Usuário visita página inicial' do
  it 'e mesmo não autenticado, vê somente lotes aprovados' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    Lot.create!(code:'TAB000003', start_date: 1.day.from_now , limit_date: 1.month.from_now, 
              minimum_bid: 100, minimum_difference_bids: 5, status: 'waiting_approval', user: user_tereza )

    Lot.create!(code:'TAB000005', start_date: 1.day.from_now , limit_date: 2.months.from_now, 
                minimum_bid: 100, minimum_difference_bids: 5, status: 'approved', user: user_tereza )

    Lot.create!(code:'TAB000008', start_date: 2.weeks.from_now , limit_date: 2.months.from_now, 
                minimum_bid: 100, minimum_difference_bids: 5, status: 'approved', user: user_tereza )
    
    Lot.create!(code:'TAB000001', start_date: 1.week.from_now , limit_date: 3.weeks.from_now, 
                minimum_bid: 100, minimum_difference_bids: 5, status: 'cancelled', user: user_tereza )
  
    #Act
    visit root_path
 
    #Assert
    expect(page).to have_content 'Aprovados - em andamento'
    expect(page).to have_content 'Aprovados - futuros'
    expect(page).to have_content 'Código'
    expect(page).to have_content 'Data inicial'
    expect(page).to have_content 'Data limite'
    expect(page).to have_content 'Lance mínimo'
    expect(page).to have_content 'TAB000005'
    formatted_date1 = I18n.localize(1.day.from_now.to_date)
    expect(page).to have_content "#{formatted_date1}"
    formatted_date2 = I18n.localize(2.months.from_now.to_date)
    expect(page).to have_content "#{formatted_date2}"
    expect(page).to have_content 'TAB000008'

    expect(page).not_to have_content 'TAB000001'
    expect(page).not_to have_content 'TAB000003'
  end

  it 'e não vê a lista de lotes que ainda não foram aprovados, fechados ou cancelados ' do
    #Arrange
    user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    Lot.create!(code:'TAB000001', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
                minimum_bid: 100, minimum_difference_bids: 5, status: 'waiting_approval', user: user_tereza )

    Lot.create!(code:'TAB000003', start_date: 1.day.from_now , limit_date: 1.month.from_now, 
                minimum_bid: 100, minimum_difference_bids: 5, status: 'waiting_approval', user: user_tereza )

    Lot.create!(code:'TAB000009', start_date: 1.day.from_now , limit_date: 2.weeks.from_now,
                minimum_bid: 100, minimum_difference_bids: 5, status: 'cancelled', user: user_tereza )
   #Act
    visit root_path
 
    #Assert
    expect(page).to have_content 'Aprovados - em andamento'
    expect(page).to have_content 'Aprovados - futuros'
    expect(page).not_to have_content 'TAB000001'
    expect(page).not_to have_content 'TAB000003'
    expect(page).not_to have_content 'TAB000009'
    expect(page).to have_content 'Não existem lotes no momento.'
  end

  it 'e não existem lotes no momento.' do
    #Arrange
    
    #Act
    visit root_path

    #Assert
    expect(page).to have_content 'Aprovados - em andamento'
    expect(page).to have_content 'Aprovados - futuros'
    expect(page).to have_content 'Não existem lotes no momento.'
  end
end
