require 'rails_helper'

describe 'Usuário se cadastra' do
  it 'com sucesso como admin' do
    # Arrange
    
    # Act
    visit('/') 
    click_on 'Entrar'
    click_on 'Criar conta'
    within('form') do
      fill_in 'Nome', with: 'Tereza Barros'
      fill_in 'CPF', with: '56685728701'
      fill_in 'E-mail', with: 'tereza@leilaodogalpao.com.br'
      fill_in 'Senha', with: 'senha1234'
      fill_in 'Confirme sua senha', with: 'senha1234'
     click_on 'Criar conta'
    end

    # Assert
    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
    within('nav') do
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
      expect(page).to have_content "Tereza Barros"
      expect(page).to have_content "tereza@leilaodogalpao.com.br"
      expect(page).to have_content 'administrador'
      expect(page).to have_content 'Categorias'
    end
  end

  it 'com sucesso como visitante' do
    # Arrange
    
    # Act
    visit('/') 
    click_on 'Entrar'
    click_on 'Criar conta'
    within('form') do
      fill_in 'Nome', with: 'Maria Sousa'
      fill_in 'CPF', with: '66610881090'
      fill_in 'E-mail', with: 'maria@provedor.com'
      fill_in 'Senha', with: 'senha1234'
      fill_in 'Confirme sua senha', with: 'senha1234'
      click_on 'Criar conta'
    end

    # Assert
    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
    within('nav') do
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
      expect(page).to have_content "Maria Sousa"
      expect(page).to have_content "maria@provedor.com"
      expect(page).to have_content 'visitante'
      expect(page).not_to have_content 'Cadastrar Categoria'
    end
  end

  it 'com dados incompletos' do
    # Arrange
    
    # Act
    visit('/') 
    click_on 'Entrar'
    click_on 'Criar conta'
    within('form') do
      fill_in 'Nome', with: ''
      fill_in 'CPF', with: ''
      fill_in 'E-mail', with: 'tereza@leilaodogalpao.com.br'
      fill_in 'Senha', with: 'senha1234'
      fill_in 'Confirme sua senha', with: 'senha1234'

      click_on 'Criar conta'
    end

    # Assert
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'Não foi possível salvar usuário'
    expect(page).not_to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
  end

  it 'com cpf inválido' do
    # Arrange
    
    # Act
    visit('/') 
    click_on 'Entrar'
    click_on 'Criar conta'
    within('form') do
      fill_in 'Nome', with: 'Tereza Barros'
      fill_in 'CPF', with: '56685723301'
      fill_in 'E-mail', with: 'tereza@leilaodogalpao.com.br'
      fill_in 'Senha', with: 'senha1234'
      fill_in 'Confirme sua senha', with: 'senha1234'
      click_on 'Criar conta'
    end

    # Assert
    expect(page).to have_content 'CPF inválido'
    expect(page).to have_content 'Não foi possível salvar usuário'
    expect(page).not_to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
  end

  it 'com cpf já existente' do
    # Arrange
    User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    # Act
    visit('/') 
    click_on 'Entrar'
    click_on 'Criar conta'
    within('form') do
      fill_in 'Nome', with: 'Maria Sousa'
      fill_in 'CPF', with: '56685723301'
      fill_in 'E-mail', with: 'maria@provedor.com'
      fill_in 'Senha', with: 'senha1234'
      fill_in 'Confirme sua senha', with: 'senha1234'
      click_on 'Criar conta'
    end

    # Assert
    expect(page).to have_content 'CPF inválido'
    expect(page).to have_content 'Não foi possível salvar usuário'
    expect(page).not_to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
  end

  it 'com cpf bloqueado' do
    # Arrange
    BlockedCpf.create!(cpf: '12933524112', name: 'José Sousa')

    # Act
    visit('/') 
    click_on 'Entrar'
    click_on 'Criar conta'
    within('form') do
      fill_in 'Nome', with: 'José Sousa'
      fill_in 'CPF', with: '12933524112'
      fill_in 'E-mail', with: 'jose@provedor.com'
      fill_in 'Senha', with: 'senha1234'
      fill_in 'Confirme sua senha', with: 'senha1234'
      click_on 'Criar conta'
    end

    # Assert
    expect(page).to have_content 'Não foi possível salvar usuário'
    expect(page).to have_content 'CPF bloqueado.'
    expect(page).not_to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
  end
end
