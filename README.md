<h1 align="center">README</h1>

## :memo: Descrição
Projeto Leilão de Estoque da turma 10 do TreinaDev, para desenvolver uma aplicação web em Ruby on Rails, com a metodologia de Desenvolvimento Guiado por Testes (TDD).

A aplicação conecta o público em geral com o estoque de itens abandonados, permitindo que estes itens sejam comercializados com preços atrativos!
Um visitante ou usuário do sistema podem visualizar a listagem de alguns lotes, mas para fazer os lances ou enviar perguntas sobre um determinado lote, é necessário o cadastro e login na aplicação.

A aplicação foi gerada com "--minimal --skip test -d sqlite3" e algumas tecnologias foram adicionadas posteriormente de acordo com a necessidade.

## :books: Funcionalidades
* <b>Cadastro de usuários</b>: 
A aplicação possui dois perfis de usuário: administradores (cadastrados com domínio "@leilaodogalpao.com.br"), responsáveis pelo cadastro de produtos que estão disponíveis para venda, pela gestão do leilão incluindo a configuração de lotes, e por acompanhar os eventuais lances recebidos nos lotes. Já usuários regulares, poderão criar uma conta na plataforma, buscar por produtos, ver detalhes de produtos e fazer uma oferta caso ainda seja possível.

* <b>Listagem da página inicial do sistema</b>: 
Os visitantes e usuários cadastrados conseguem visualizar em uma listagem separada, os lotes aprovados - em andamento e aprovados - futuros, podendo visualizar seus detalhes e com seus respectivos produtos.

* <b>Cadastro de Categorias</b>: 
Cadastro e edição das categorias dos produtos.

* <b>Cadastro de Produtos</b>: 
Cadastro e edição dos produtos, podendo fazer upload da imagem do produto.

* <b>Controle de Lotes</b>: 
Cadastro e controle dos lotes. 
O adminstrador faz o cadastro inicial do lote para a seguir, incluir os produtos do lote a ser leiloado e posteriormente, alterar o status do lote para que seja disponibilizado para o público.
O adminstrador faz também o gerenciamento dos lotes por status, com uma listagem dos lotes aguardando aprovação, aprovados - em andamento, aprovados - futuros, expirados e cancelados.Podendo finalizar o lote que recebeu lances, ou cancelar os que não tenham recebido nenhum lance.
No detalhamento do lote, 

* <b>Controle de CPF</b>: 
O adminstrador pode bloquear um cpf que ainda nem tenha sido cadastrado no sistema, para impedir possíveis fraudes, e pode também bloquear um cpf de um usuário do sistema, caso achar necessário.
A qualquer momento o administrador pode remover o cpf do bloqueio ou desbloquear um cpf de usuário.
Um usuário com cpf bloqueado não consegue fazer os lances nem enviar perguntas sobre um determinado lote.

* <b>Central de Respostas</b>:
O adminstrador é responsável por responder eventuais dúvidas encviadas pelos usuários.

* <b>Busca</b>: 
É possível fazer a busca por código de lote e nome de produtos.

* <b>Meus lotes</b>: 
Um usuário logado consegue visualizar os lotes para os quais seus lances foram os vencedores.

* <b>Meus Favoritos</b>: 
Um usuário logado consegue visualizar os lotes que incluiu na lista de favoritos, quando verifica o detalhamento do lote, podendo também remover da lista de favoritos.

## :wrench: Tecnologias utilizadas
* Rails 7.0.4.3
* Devise 4.9.2
* Rspec-rails 6.0.1
* Capybara 3.39.0
* SQLite3 1.6.2 (x86_64-linux)
* Bootstrap (5.2.3);

## :rocket: Rodando o projeto
No terminal, clonar o projeto:
```
git clone git@github.com:tbkanzaki/auction-app.git
```

Na pasta da aplicação, instalar as dependências do projeto:
```
bundle install
```

Configurar o banco de dados:
```
rails db:create
rails db:migrate
rails db:seed
```

Executar o servidor Rails:
```
rails server
```

Abra o navegador com do endereço:
```
http://localhost:3000
```

Rodar os testes:
```
rspec
```