require 'rails_helper'

RSpec.describe BlockedCpf, type: :model do
  describe '#valid?' do
    it 'false quando o cpf já está em uso' do
      # Arrange
      User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
      user = BlockedCpf.new(name: 'José Sousa', cpf: '66610881090')

      # Act
      user.valid?
      result = user.errors.include?(:cpf)

      # Assert
      expect(user.errors.include?(:cpf)).to be true
      expect(user.errors[:cpf]).to include(" pertence a um usuário do sistema. Faça pelo bloqueio mais abaixo.")
    end
          
    it 'true (errors.include) quando o cpf é vazio' do
      # Arrange
      user = BlockedCpf.new(name: 'José Sousa', cpf: '')
      
      # Act
      user.valid?
      result = user.errors.include?(:cpf)

      # Assert
      expect(result).to be true
      expect(user.errors[:cpf]).to include("não pode ficar em branco")
    end

    it 'true (errors.include) quando o cpf é inválido' do
      # Arrange
      user = BlockedCpf.new(name: 'José Sousa', cpf: '56685728331')
      
      # Act
      user.valid?
      result = user.errors.include?(:cpf)

      # Assert
      expect(user.errors.include?(:cpf)).to be true
      expect(user.errors[:cpf]).to include(" inválido.")
    end

    it 'true (errors.include) quando o cpf já foi cadastrado como bloqueado' do
      # Arrange
      BlockedCpf.create!(cpf: '32430478544', name: 'José Sousa')
      user = BlockedCpf.new(name: 'Serafina Sousa', cpf: '32430478544')

      # Act
      user.valid?
      result = user.errors.include?(:cpf)

      # Assert
      expect(user.errors.include?(:cpf)).to be true
      expect(user.errors[:cpf]).to include("já está em uso")
    end
  end

end
