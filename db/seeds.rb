User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
Category.create!(name: 'Esporte/Lazer')
category_a = Category.create!(name: 'Eletrodoméstico')
category_b = Category.create!(name: 'Celular')

Product.create!(code:'SAMSULP6FA', name: 'TV 32', description: 'TV 32 SAMSUNG', 
                                weight: 10000, width: 600, height: 900, depth: 10, category: category_a)   
    
Product.create!(code:'MOTOROI5XL', name: 'Celular MotG42',  description: 'Smartphone Motorola Moto G42 Azul',
                                weight: 800, width: 10, height: 15, depth: 5, category: category_b) 
