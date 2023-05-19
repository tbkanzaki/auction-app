user_tereza = User.create!(name: 'Tereza Barros', email:'tereza@leilaodogalpao.com.br', password:'senha1234', cpf: '56685728701')
user_cristina = User.create!(name: 'Cristina Souza', email:'cristina@leilaodogalpao.com.br', password:'senha1234', cpf: '97458446919')
user_beth = User.create!(name: 'Beth Ribeiro', email:'beth@leilaodogalpao.com.br', password:'senha1234', cpf: '02454873443')
user_maria = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
user_joana = User.create!(name: 'Joana Sousa', email:'joana@provedor.com', password:'senha1234', cpf: '85236832241')
        
Category.create!(name: 'Eletro/Eletrônico')
Category.create!(name: 'Informática e acessórios')
category_a = Category.create!(name: 'TV')
category_b = Category.create!(name: 'Celulares')
category_c = Category.create!(name: 'Computadore/Notebooks/Tablets')

product_a = Product.create!(name: 'TV-01 SAMSUNG32', 
    description: 'Smart TV LED 32" HD Samsung T3200 com HDR, Sistema Operacional Tizen', 
    weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  


product_b = Product.create!(name: 'TV-02 SAMSUNG43', 
    description: 'Smart TV LED 43" HD Samsung T4300 com HDR, Sistema Operacional Tizen',
    weight: 10000, width: 600, height: 900, depth: 10, category: category_a)  


product_c = Product.create!(name: 'Notebook Asus', description: 'Notebook Asus', 
    weight: 5000, width: 100, height: 200, depth: 10, category: category_c)  

product_d = Product.create!(name: 'Notebook SAMSUNG', description: 'Notebook SAMSUNG prata GerfoceGTX', 
    weight: 5000, width: 100, height: 200, depth: 10, category: category_c)
                    
lot1 = Lot.create!(code:'TAB000011', start_date: 1.week.from_now , limit_date: 1.month.from_now, 
              minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )

lot2 = Lot.create!(code:'TAB000012', start_date: 1.day.from_now , limit_date: 2.months.from_now, 
            minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )

lot3 = Lot.create!(code:'TAB000013', start_date: 1.week.from_now , limit_date: 3.weeks.from_now, 
            minimum_bid: 100, minimum_difference_bids: 5, status: 0, user: user_tereza )

lot4 = Lot.create!(code:'CAB000011', start_date: 1.day.from_now, limit_date: 2.months.from_now, 
        minimum_bid: 400, minimum_difference_bids: 40, status: 0, user: user_cristina )

lot5 = Lot.create!(code:'CAB000012', start_date: 2.days.from_now, limit_date: 1.week.from_now, 
        minimum_bid: 100, minimum_difference_bids: 10, status: 0, user: user_cristina )

lot6 = Lot.create!(code:'CAB000013', start_date: 1.week.from_now, limit_date: 3.weeks.from_now, 
        minimum_bid: 200, minimum_difference_bids: 20, status: 0, user: user_cristina )
      
LotItem.create!(lot: lot2, product: product_a)  
product_a.blocked!  
LotApprover.create!(lot: lot2, user: user_cristina) 
lot2.approved!
Lot.find(lot2.id).update(start_date: 1.week.ago)

LotItem.create!(lot: lot3, product: product_b)  
product_b.blocked!  
LotApprover.create!(lot: lot3, user: user_cristina) 
lot3.approved!

LotItem.create!(lot: lot4, product: product_c)  
product_c.blocked!  
LotApprover.create!(lot: lot4, user: user_tereza) 
lot4.approved!
Lot.find(lot4.id).update(start_date: 1.month.ago)
LotBid.create!(lot: lot4, user: user_maria, bid: 110) 
Lot.find(lot4.id).update(limit_date: 2.days.ago)
lot4.closed!
product_c.sold!

lot_item = LotItem.create!(lot: lot5, product: product_d)  
product_d.blocked!  
LotApprover.create!(lot: lot5, user: user_tereza) 
lot5.approved!
Lot.find(lot5.id).update(start_date: 1.month.ago)
Lot.find(lot5.id).update(limit_date: 2.days.ago)
lot5.cancelled!
LotItem.delete(lot_item.id)
product_d.unblocked! 

lot_item = LotItem.create!(lot: lot6, product: product_d)  
product_d.blocked!  
LotApprover.create!(lot: lot6, user: user_tereza) 
lot6.approved!
Lot.find(lot6.id).update(start_date: 1.month.ago)
Lot.find(lot6.id).update(limit_date: 2.days.ago)

product1 = Product.create!(name: 'TV 24', description: 'TV 24 SAMSUNG', 
weight: 10000, width: 600, height: 900, depth: 10, category: category_a)   

product2 = Product.create!(name: 'Celular MotG22',  description: 'Smartphone Motorola Moto G22 Bege',
weight: 800, width: 10, height: 15, depth: 5, category: category_b) 

product3 = Product.create!(name: 'Celular MotG42',  description: 'Smartphone Motorola Moto G42 Azul',
weight: 800, width: 10, height: 15, depth: 5, category: category_b) 
  
product4 = Product.create!(name: 'Celular MOTXYZ',  description: 'Smartphone Motorola Moto MOTXYZ Branco',
weight: 800, width: 10, height: 15, depth: 5, category: category_b) 

product5 = Product.create!(name: 'Notebook AsusXYZ', description: 'Notebook Asus XYZ', 
    weight: 5000, width: 100, height: 200, depth: 10, category: category_c)  

lot7 = Lot.create!(code:'TAB000004', start_date: 1.day.from_now, limit_date: 2.months.from_now, 
        minimum_bid: 50, minimum_difference_bids: 5, status: 'waiting_approval', user: user_tereza )
        
lot8 = Lot.create!(code:'TAB000005', start_date: 1.week.from_now, limit_date: 2.weeks.from_now, 
        minimum_bid: 100, minimum_difference_bids: 10, status: 'waiting_approval', user: user_tereza )

lot9 = Lot.create!(code:'CAB000004', start_date: 2.days.from_now, limit_date: 1.week.from_now, 
        minimum_bid: 100, minimum_difference_bids: 10, status: 'waiting_approval', user: user_cristina )

lot10 = Lot.create!(code:'CAB000005', start_date: 1.week.from_now, limit_date: 3.weeks.from_now, 
        minimum_bid: 200, minimum_difference_bids: 20, status: 'waiting_approval', user: user_cristina )

lot11 = Lot.create!(code:'CAB000006', start_date: 1.week.from_now, limit_date: 3.weeks.from_now, 
        minimum_bid: 200, minimum_difference_bids: 20, status: 'waiting_approval', user: user_cristina )

Lot.find(lot10.id).update(start_date: 1.month.ago)
Lot.find(lot10.id).update(limit_date: 2.days.ago)

LotItem.create!(lot: lot7, product: product1)  
product1.blocked!  
LotApprover.create!(lot: lot7, user: user_cristina) 
lot7.approved!
Lot.find(lot7.id).update(start_date: 1.week.ago)

LotItem.create!(lot: lot8, product: product2)  
product2.blocked!  
LotApprover.create!(lot: lot8, user: user_cristina) 
lot8.approved!

LotItem.create!(lot: lot9, product: product3)  
product3.blocked!  
LotApprover.create!(lot: lot9, user: user_cristina) 
lot9.approved!
Lot.find(lot9.id).update(start_date: 1.week.ago)

lot11 = Lot.create!(code:'CAB000007', start_date: 1.week.from_now, limit_date: 3.weeks.from_now, 
        minimum_bid: 100, minimum_difference_bids: 5, status: 'waiting_approval', user: user_cristina )

LotItem.create!(lot: lot11, product: product4)  
product4.blocked!  
LotApprover.create!(lot: lot11, user: user_tereza) 
lot11.approved!
Lot.find(lot11.id).update(start_date: 1.month.ago)
LotBid.create!(lot: lot11, user: user_maria, bid: 110) 
LotBid.create!(lot: lot11, user: user_joana, bid: 120) 
LotBid.create!(lot: lot11, user: user_maria, bid: 130) 
LotBid.create!(lot: lot11, user: user_joana, bid: 140) 
Lot.find(lot11.id).update(limit_date: 2.days.ago)
lot11.closed!
product4.sold!

lot12 = Lot.create!(code:'CAB000008', start_date: 1.week.from_now, limit_date: 3.weeks.from_now, 
        minimum_bid: 100, minimum_difference_bids: 5, status: 'waiting_approval', user: user_cristina )

LotItem.create!(lot: lot12, product: product5)  
product5.blocked!  
LotApprover.create!(lot: lot12, user: user_tereza) 
lot12.approved!
Lot.find(lot12.id).update(start_date: 1.month.ago)
LotBid.create!(lot: lot12, user: user_maria, bid: 110) 
LotBid.create!(lot: lot12, user: user_joana, bid: 120) 
LotBid.create!(lot: lot12, user: user_maria, bid: 130) 
LotBid.create!(lot: lot12, user: user_joana, bid: 140) 
Lot.find(lot12.id).update(limit_date: 2.days.ago)

lot13 = Lot.create!(code:'CAB000009', start_date: 1.week.from_now, limit_date: 3.weeks.from_now, 
        minimum_bid: 100, minimum_difference_bids: 5, status: 'waiting_approval', user: user_cristina )
Lot.find(lot13.id).update(start_date: 2.days.ago)
