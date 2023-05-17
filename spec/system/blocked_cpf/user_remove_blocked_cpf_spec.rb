
require 'rails_helper'

describe 'Usuário desbloqueia cpf' do
  it 'de não usuário do sistema, como administrador' do
    user_sara = BlockedCpf.create!(name: 'Sara Silva', cpf: '33146852977')
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de CPF'
    find_button('Liberar CPF', id: 'blocked_cpf_1').click()
    
    #Assert
    expect(BlockedCpf.count).to eq 0
    expect(current_path).to eq blocked_cpfs_path
    expect(page).to have_content 'CPF removido do bloqueio.'
    expect(page).not_to have_content '33146852977'
    
  end

  it 'de usuário do sistema, como administrador' do
    user_maria = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
    user_maria.blocked!

    #Act
    login_as(user)
    visit root_path
    click_on 'Controle de CPF'
    find_button('Desbloquear', id: 'user_1').click()
    
    #Assert
    expect(current_path).to eq blocked_cpfs_path
    expect(page).to have_content 'Usuário desbloqueado com sucesso.'
    expect(page).to have_content 'Maria Sousa'
    expect(page).to have_selector(:link_or_button, 'Bloquear', id: 'user_1')
  end
end
