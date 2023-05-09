user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
user_cristina = User.create!(name: 'Cristina Souza', email:'cristina@leilaodogalpao.com.br', password:'senha1234', cpf: '97458446919')
user_beth = User.create!(name: 'Beth Ribeiro', email:'beth@leilaodogalpao.com.br', password:'senha1234', cpf: '02454873443')
User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')

Category.create!(name: 'Esporte/Lazer')
Category.create!(name: 'Informática e acessórios')
Category.create!(name: 'Computadore/Notebooks/Tablets')

category_a = Category.create!(name: 'TV')
category_b = Category.create!(name: 'Celulares')

Product.create!(name: 'TV 24', description: 'TV 24 SAMSUNG', 
                weight: 10000, width: 600, height: 900, depth: 10, category: category_a)   
Product.create!(name: 'TV 32', description: 'TV 32 SAMSUNG', 
                weight: 10000, width: 600, height: 900, depth: 10, category: category_a)   
 
Product.create!(name: 'Celular MotG22',  description: 'Smartphone Motorola Moto G22 Bege',
                weight: 800, width: 10, height: 15, depth: 5, category: category_b) 
Product.create!(name: 'Celular MotG42',  description: 'Smartphone Motorola Moto G42 Azul',
                weight: 800, width: 10, height: 15, depth: 5, category: category_b) 
    
Lot.create!(code:'TAB000001', start_date: 1.month.from_now, limit_date: 2.months.from_now, 
            minimum_bid: 50, minimum_difference_bids: 5, status: 'closed', user: user_tereza )

Lot.create!(code:'TAB000002', start_date: 1.week.from_now, limit_date: 2.weeks.from_now, 
            minimum_bid: 100, minimum_difference_bids: 10, status: 'closed', user: user_tereza )

Lot.create!(code:'TAB000003', start_date: 1.day.from_now, limit_date: 1.month.from_now, 
            minimum_bid: 200, minimum_difference_bids: 20, status: 'waiting_approval', user: user_tereza )

Lot.create!(code:'TAB000004', start_date: 1.day.from_now, limit_date: 2.months.from_now, 
            minimum_bid: 300, minimum_difference_bids: 30, status: 'waiting_approval', user: user_tereza )

Lot.create!(code:'TAB000005', start_date: 1.day.from_now , limit_date: 1.month.from_now, 
            minimum_bid: 400, minimum_difference_bids: 40, status: 'approved', user: user_tereza )

Lot.create!(code:'TAB000006', start_date: 1.day.from_now, limit_date: 2.months.from_now, 
            minimum_bid: 100, minimum_difference_bids: 40, status: 'approved', user: user_tereza )

Lot.create!(code:'TAB000007', start_date: 5.days.from_now, limit_date: 1.month.from_now, 
            minimum_bid: 100, minimum_difference_bids: 30, status: 'approved', user: user_tereza )

Lot.create!(code:'TAB000008', start_date: 2.weeks.from_now , limit_date: 2.month.from_now, 
            minimum_bid: 100, minimum_difference_bids: 20, status: 'approved', user: user_tereza )

Lot.create!(code:'TAB000009', start_date: 1.day.from_now, limit_date: 2.weeks.from_now,
            minimum_bid: 100, minimum_difference_bids: 10, status: 'cancelled', user: user_tereza )

Lot.create!(code:'TAB000010', start_date: 1.month.from_now, limit_date: 2.months.from_now, 
            minimum_bid: 100, minimum_difference_bids: 5, status: 'cancelled', user: user_tereza )

Lot.create!(code:'CAB000001', start_date: 2.days.from_now, limit_date: 1.week.from_now, 
            minimum_bid: 100, minimum_difference_bids: 10, status: 'closed', user: user_cristina )

Lot.create!(code:'CAB000002', start_date: 1.week.from_now, limit_date: 3.weeks.from_now, 
            minimum_bid: 200, minimum_difference_bids: 20, status: 'closed', user: user_cristina )

Lot.create!(code:'CAB000003', start_date: 1.day.from_now, limit_date: 1.month.from_now, 
            minimum_bid: 300, minimum_difference_bids: 30, status: 'waiting_approval', user: user_cristina )

Lot.create!(code:'CAB000004', start_date: 1.day.from_now, limit_date: 2.months.from_now, 
            minimum_bid: 400, minimum_difference_bids: 40, status: 'waiting_approval', user: user_cristina )

Lot.create!(code:'CAB000005', start_date: 1.day.from_now, limit_date: 1.month.from_now, 
            minimum_bid: 100, minimum_difference_bids: 5, status: 'approved', user: user_cristina )

Lot.create!(code:'CAB000006', start_date: 1.day.from_now, limit_date: 2.months.from_now, 
            minimum_bid: 100, minimum_difference_bids: 10, status: 'approved', user: user_cristina )

Lot.create!(code:'CAB000007', start_date: 3.days.from_now, limit_date: 1.month.from_now, 
            minimum_bid: 100, minimum_difference_bids: 15, status: 'approved', user: user_cristina )

Lot.create!(code:'CAB000008', start_date: 1.month.from_now, limit_date: 2.months.from_now, 
            minimum_bid: 100, minimum_difference_bids: 20, status: 'approved', user: user_cristina )

Lot.create!(code:'CAB000009', start_date: 1.day.from_now, limit_date: 2.weeks.from_now,
            minimum_bid: 100, minimum_difference_bids: 25, status: 'cancelled', user: user_cristina )

Lot.create!(code:'CAB000010', start_date: 1.week.from_now, limit_date: 1.month.from_now, 
            minimum_bid: 100, minimum_difference_bids: 30, status: 'cancelled', user: user_cristina )

Lot.create!(code:'BAB000001', start_date: 2.weeks.from_now, limit_date: 1.month.from_now, 
            minimum_bid: 100, minimum_difference_bids: 10, status: 'closed', user: user_beth )

Lot.create!(code:'BAB000002', start_date: 1.day.from_now, limit_date: 2.weeks.from_now, 
            minimum_bid: 200, minimum_difference_bids: 20, status: 'closed', user: user_beth )

Lot.create!(code:'BAB000003', start_date: 1.day.from_now, limit_date: 1.month.from_now, 
            minimum_bid: 300, minimum_difference_bids: 30, status: 'waiting_approval', user: user_beth )

Lot.create!(code:'BAB000004', start_date: 1.day.from_now, limit_date: 2.months.from_now, 
            minimum_bid: 400, minimum_difference_bids: 40, status: 'waiting_approval', user: user_beth )

Lot.create!(code:'BAB000005', start_date: 1.day.from_now, limit_date: 1.month.from_now, 
            minimum_bid: 100, minimum_difference_bids: 5, status: 'approved', user: user_beth )

Lot.create!(code:'BAB000006', start_date: 1.day.from_now, limit_date: 2.months.from_now, 
            minimum_bid: 100, minimum_difference_bids: 5, status: 'approved', user: user_beth )

Lot.create!(code:'BAB000007', start_date: 1.week.from_now, limit_date: 1.month.from_now, 
            minimum_bid: 100, minimum_difference_bids: 10, status: 'approved', user: user_beth )

Lot.create!(code:'BAB000008', start_date: 2.weeks.from_now, limit_date: 2.months.from_now, 
            minimum_bid: 100, minimum_difference_bids: 10, status: 'approved', user: user_beth )

Lot.create!(code:'BAB000009', start_date: 1.day.from_now, limit_date: 2.weeks.from_now,
            minimum_bid: 100, minimum_difference_bids: 20, status: 'cancelled', user: user_beth )

Lot.create!(code:'BAB000010', start_date: 1.week.from_now, limit_date: 1.month.from_now, 
            minimum_bid: 100, minimum_difference_bids: 20, status: 'cancelled', user: user_beth )

