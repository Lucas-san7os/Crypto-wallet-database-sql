# 🪙 Crypto Wallet Relational Database

Modelagem e implementação de um banco de dados relacional para gerenciamento de carteiras digitais, transações financeiras e custódia de criptoativos utilizando **MySQL 8.0**.

---

## 📌 Visão Geral do Domínio

O sistema gerencia o ciclo de transações de criptoativos entre usuários e suas respectivas carteiras digitais. A arquitetura de dados prioriza integridade referencial, normalização relacional (3FN) e alta precisão numérica para lidar com unidades fracionárias de moedas descentralizadas.

### Destaques de Arquitetura:
- **Precisão Financeira:** Utilização de `DECIMAL(18,8)` para suportar o fracionamento nativo de satoshis em criptomoedas como Bitcoin e Ethereum.
- **Integridade Referencial:** Restrições de chave estrangeira (`FOREIGN KEY`) com validação estrita de integridade entre usuários, carteiras e ordens.
- **Camada Analítica:** Consultas estruturadas com agregações (`SUM`, `GROUP BY`) e múltiplos `JOINs` para extração de métricas de portfólio.

---

## 🗺️ Diagrama Entidade-Relacionamento (ER)

\`\`\`mermaid
erDiagram
    USUARIO ||--o{ CARTEIRA : "possui"
    CARTEIRA ||--o{ TRANSACAO : "executa"
    CRIPTOMOEDA ||--o{ TRANSACAO : "referenciada em"

    USUARIO {
        int usuario_id PK
        varchar nome
        varchar email UK
        datetime criado_em
    }

    CARTEIRA {
        int carteira_id PK
        int usuario_id FK
        varchar nome
        decimal saldo
        datetime criado_em
    }

    CRIPTOMOEDA {
        int cripto_id PK
        varchar nome
        varchar simbolo UK
    }

    TRANSACAO {
        int transacao_id PK
        int carteira_id FK
        int cripto_id FK
        decimal quantidade
        decimal valor_total
        datetime data_transacao
    }
\`\`\`

---

## 🗄️ Estrutura e Dicionário de Dados

| Tabela | Responsabilidade | Chaves / Restrições |
| :--- | :--- | :--- |
| **`Usuario`** | Cadastro dos titulares das contas | `usuario_id` (PK), `email` (Unique) |
| **`Carteira`** | Contas/carteiras vinculadas ao usuário | `carteira_id` (PK), `usuario_id` (FK) |
| **`Criptomoeda`** | Ativos suportados pela plataforma | `cripto_id` (PK), `simbolo` (Unique) |
| **`Transacao`** | Histórico de ordens de compra/venda | `transacao_id` (PK), `carteira_id` (FK), `cripto_id` (FK) |

---

## 🚀 Como Executar

### Opção 1: Ambiente Local (MySQL CLI / Workbench)
\`\`\`bash
# 1. Clone o repositório
git clone https://github.com/Lucas-san7os/crypto-wallet-database-sql.git
cd crypto-wallet-database-sql

# 2. Execute os scripts em ordem
mysql -u root -p < sql/01_schema.sql
mysql -u root -p < sql/02_seed.sql
mysql -u root -p < sql/03_queries.sql
\`\`\`

### Opção 2: Teste Online (DB Fiddle)
1. Acesse o ambiente online: [DB Fiddle - Crypto Wallet SQL](https://www.db-fiddle.com/f/iEsFLGj659kxxchi7ZVhsH/0)
2. Selecione a versão **MySQL 8.0**.
3. Clique em **Run** para executar o schema e visualizar o resultado das queries analíticas.

---

## 📊 Exemplos de Consultas Analíticas

### 1. Volume Total Investido por Carteira
\`\`\`sql
SELECT 
    w.nome AS carteira, 
    SUM(t.valor_total) AS total_investido
FROM Transacao AS t
JOIN Carteira AS w ON t.carteira_id = w.carteira_id
GROUP BY w.carteira_id, w.nome;
\`\`\`

### 2. Saldo Total Custodiado por Criptoativo
\`\`\`sql
SELECT 
    c.simbolo, 
    c.nome,
    SUM(t.quantidade) AS saldo_total_custodiado
FROM Transacao AS t
JOIN Criptomoeda AS c ON t.cripto_id = c.cripto_id
GROUP BY c.cripto_id, c.simbolo, c.nome;
\`\`\`

---

## 👥 Autores & Colaboradores
- **Lucas Santos**
- **Mikaely Esthefany**
- **Sara Medeiros**
- **Emilly Mendonça**