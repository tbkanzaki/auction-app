require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    it 'false quando o cpf já está em uso' do
      # Arrange
      user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '38001357287')
      user_maria = User.new(name: 'Maria Silva', email:'maria@leilaodogalpao.com.br', password:'senha1234', cpf: '38001357287')

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
      user = User.new(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '380.013.031-41')

      # Act
      user.valid?
      result = user.errors.include?(:cpf)

      # Assert
      expect(user.errors.include?(:cpf)).to be true
      expect(user.errors[:cpf]).to include(" inválido.")
    end
  end
end
