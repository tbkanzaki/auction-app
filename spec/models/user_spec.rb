require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#perfil' do
  it 'exibe o perfil do usuário administrador' do
    # Arrange
    user = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')

    # Act
    result = user.perfil()

    # Assert
    expect(result).to eq('administrador')
  end

  it 'exibe o perfil do usuário visitante' do
    # Arrange
    user = user = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')

    # Act
    result = user.perfil()

    # Assert
    expect(result).to eq('visitante')
  end
end

  describe '#valid?' do
    it 'false quando o cpf já está em uso' do
      # Arrange
      user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
      user_maria = User.new(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '56685728701')

      # Act
      result = user_maria.valid?

      # Assert
      expect(result).to eq false
    end
    
    it 'true (errors.include) quando o cpf é vazio' do
      # Arrange
      user = User.new(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '')

      # Act
      user.valid?
      result = user.errors.include?(:cpf)

      # Assert
      expect(result).to be true
    end

    it 'true (errors.include) quando o cpf é inválido' do
      # Arrange
      user = User.new(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728331')

      # Act
      user.valid?
      result = user.errors.include?(:cpf)

      # Assert
      expect(user.errors.include?(:cpf)).to be true
      expect(user.errors[:cpf]).to include(" inválido.")
    end

    it 'true (errors.include) quando o cpf está bloqueado' do
      # Arrange
      BlockedCpf.create!(cpf: '32430478544', name: 'José Sousa')

      user = User.new(name: 'José Sousa', email:'jose@provedor.com', password:'senha1234', cpf: '32430478544')

      # Act
      user.valid?
      result = user.errors.include?(:cpf)

      # Assert
      expect(user.errors.include?(:cpf)).to be true
      expect(user.errors[:cpf]).to include(" bloqueado.")
    end
  end
end
