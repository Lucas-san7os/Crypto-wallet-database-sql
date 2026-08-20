# Link do Bd Fiddle
https://www.db-fiddle.com/f/iEsFLGj659kxxchi7ZVhsH/0

# Diagrama ER
![IMG-20250604-WA0032](https://github.com/user-attachments/assets/80a3c97a-627e-495f-ae37-cd642ea5244a)


# crypto-wallet-database-sql
Este é um projeto de banco de dados para controle de carteiras de criptomoedas, desenvolvido para a UC *Programação de Soluções Computacionais*. A solução modela as entidades essenciais de uma carteira digital e foi implementada usando o ambiente [DB Fiddle](https://www.db-fiddle.com/) (MySQL 8.0).

---

## Funcionalidades
- Cadastro de usuários  
- Criação de carteiras vinculadas a usuários  
- Registro de criptomoedas disponíveis  
- Registro de transações de compra/venda  
- Consultas SQL analíticas  

---

## Tecnologias Utilizadas

- MySQL 8.0 (via DB Fiddle)  
- Modelagem relacional (ER)  
- Consultas SQL (DDL, DML e SELECT)  

---

## Estrutura das Tabelas

### 1. Usuario
Armazena informações dos usuários da plataforma 
- `usuario_id` (PK): Identificador do usuário  
- `nome`: Nome do usuário  
- `email`: E-mail (único)  
- `criado_em`: Data de criação do registro  

### 2. Carteira
Representa as carteiras digitais de cada usuário, onde são armazenadas criptomoedas.
- `carteira_id` (PK): Identificador da carteira  
- `usuario_id` (FK): Chave estrangeira para Usuario  
- `nome`: Nome da carteira  
- `saldo`: Saldo em moeda local  
- `criado_em`: Data de criação  

### 3. Criptomoeda
Contém o cadastro das criptomoedas disponíveis no sistema.
- `cripto_id` (PK): Identificador da criptomoeda  
- `nome`: Nome da cripto  
- `simbolo`: Símbolo único (ex: BTC)  

### 4. Transacao
Registra todas as transações de compra de criptomoedas feitas nas carteiras.
- `transacao_id` (PK): Identificador da transação  
- `carteira_id` (FK): Referência à carteira  
- `cripto_id` (FK): Referência à cripto usada  
- `quantidade`: Quantidade da cripto  
- `valor_total`: Valor total em moeda local  
- `data_transacao`: Data da transação  

---

## Como Executar no DB Fiddle

1. Acesse: [https://www.db-fiddle.com](https://www.db-fiddle.com)  
2. Escolha MySQL 8.0 como versão do banco  
3. Copie e cole o código SQL contendo:
   - Criação de tabelas (DDL)
   - Inserção de dados (DML)
   - Consultas SQL (SELECT)  
4. Clique em **Run** para testar  

---

## 1. DDL – Criação das tabelas

```sql
-- 1. Tabela Usuário
CREATE TABLE Usuario (
  usuario_id   INT AUTO_INCREMENT PRIMARY KEY,
  nome         VARCHAR(100) NOT NULL,
  email        VARCHAR(150) NOT NULL UNIQUE,
  criado_em    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabela Carteira
CREATE TABLE Carteira (
  carteira_id  INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id   INT NOT NULL,
  nome         VARCHAR(100) NOT NULL,
  saldo        DECIMAL(18,8) NOT NULL DEFAULT 0.0,
  criado_em    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id)
);

-- 3. Tabela Criptomoeda
CREATE TABLE Criptomoeda (
  cripto_id    INT AUTO_INCREMENT PRIMARY KEY,
  nome         VARCHAR(50)  NOT NULL,
  simbolo      VARCHAR(10)  NOT NULL UNIQUE
);

-- 4. Tabela Transação
CREATE TABLE Transacao (
  transacao_id    INT AUTO_INCREMENT PRIMARY KEY,
  carteira_id     INT NOT NULL,
  cripto_id       INT NOT NULL,
  quantidade      DECIMAL(18,8) NOT NULL,
  valor_total     DECIMAL(18,2) NOT NULL,  -- em moeda local
  data_transacao DATETIME      NOT NULL,
  FOREIGN KEY (carteira_id) REFERENCES Carteira(carteira_id),
  FOREIGN KEY (cripto_id)   REFERENCES Criptomoeda(cripto_id)
);
```

---

## 2. DML – Inserção de dados de exemplo

```sql
-- 1. Usuários
INSERT INTO Usuario (nome, email) VALUES
  ('Ana Silva',    'ana.silva@example.com'),
  ('Bruno Costa',  'bruno.costa@example.com'),
  ('Carla Pereira','carla.pereira@example.com');

-- 2. Carteiras
INSERT INTO Carteira (usuario_id, nome, saldo) VALUES
  (1, 'Carteira Pessoal',  0.0),
  (1, 'Carteira de Trading', 0.0),
  (2, 'Carteira Principal', 0.0),
  (3, 'Carteira Reserva',   0.0);

-- 3. Criptomoedas
INSERT INTO Criptomoeda (nome, simbolo) VALUES
  ('Bitcoin',  'BTC'),
  ('Ethereum', 'ETH'),
  ('Ripple',   'XRP');

-- 4. Transações
INSERT INTO Transacao (carteira_id, cripto_id, quantidade, valor_total, data_transacao) VALUES
  (1, 1, 0.02500000,  1250.00, '2025-05-20 09:15:00'),
  (1, 2, 0.10000000,   300.00, '2025-05-21 14:30:00'),
  (2, 1, 0.01000000,   500.00, '2025-05-22 11:45:00'),
  (3, 3, 50.00000000,  750.00, '2025-05-23 16:00:00'),
  (4, 2, 0.05000000,   150.00, '2025-05-24 10:20:00');
```

---

## 3. Consultas de Verificação (exemplos)

```sql
-- a) Listar todas as transações de Ana Silva (usuário_id = 1), mostrando data e valor:
SELECT t.data_transacao, c.simbolo, t.quantidade, t.valor_total
FROM Transacao AS t
JOIN Carteira   AS w ON t.carteira_id = w.carteira_id
JOIN Usuario    AS u ON w.usuario_id    = u.usuario_id
JOIN Criptomoeda AS c ON t.cripto_id     = c.cripto_id
WHERE u.usuario_id = 1
ORDER BY t.data_transacao;

Exemplo de resultado:

20/05/2025 às 09:15 — 0.025 BTC por R$ 1.250,00

21/05/2025 às 14:30 — 0.100 ETH por R$ 300,00

22/05/2025 às 11:45 — 0.010 BTC por R$ 500,00

-- b) Total investido por carteira:
SELECT w.nome AS carteira, SUM(t.valor_total) AS total_investido
FROM Transacao AS t
JOIN Carteira   AS w ON t.carteira_id = w.carteira_id
GROUP BY w.carteira_id;

Exemplo de resultado:

Carteira Pessoal: R$ 1.550,00

Carteira de Trading: R$ 500,00

Carteira Principal: R$ 750,00

Carteira Reserva: R$ 150,00

-- c) Quantidade total de cada criptomoeda em todas as carteiras:
SELECT c.simbolo, SUM(t.quantidade) AS total_quantidade
FROM Transacao   AS t
JOIN Criptomoeda AS c ON t.cripto_id = c.cripto_id
GROUP BY c.cripto_id;

Exemplo de resultado:

Bitcoin (BTC): 0.035 unidades

Ethereum (ETH): 0.150 unidades

Ripple (XRP): 50.000 unidades

## Consultas SQL de Exemplo

### a) Transações de Ana Silva
```sql
SELECT t.data_transacao, c.simbolo, t.quantidade, t.valor_total
FROM Transacao AS t
JOIN Carteira AS w ON t.carteira_id = w.carteira_id
JOIN Usuario AS u ON w.usuario_id = u.usuario_id
JOIN Criptomoeda AS c ON t.cripto_id = c.cripto_id
WHERE u.usuario_id = 1
ORDER BY t.data_transacao;

Essa consulta retorna as transações realizadas pelo usuário com ID 1, listando a data da transação, o símbolo da criptomoeda, a quantidade negociada e o valor total da operação.

Exemplo de resultado:

Data da Transação	Criptomoeda	Quantidade	Valor Total (R$)
20/05/2025 09:15	BTC	0.02500000	1.250,00
21/05/2025 14:30	ETH	0.10000000	300,00
22/05/2025 11:45	BTC	0.01000000	500,00

```

## Contribuição

Este projeto foi desenvolvido por:
- Lucas Santos
- Mikaely Esthefany
- Sara Medeiros
- Emilly Mendonça
