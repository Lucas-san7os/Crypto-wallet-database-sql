-- =============================================================================
-- Schema DDL: Sistema de Carteira de Criptoativos
-- Engine: MySQL 8.0
-- =============================================================================

-- 1. Tabela de Usuários
CREATE TABLE IF NOT EXISTS Usuario (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabela de Carteiras Digitais
CREATE TABLE IF NOT EXISTS Carteira (
    carteira_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    saldo DECIMAL(18,8) NOT NULL DEFAULT 0.0,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_carteira_usuario FOREIGN KEY (usuario_id) 
        REFERENCES Usuario(usuario_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- 3. Tabela de Criptomoedas Suportadas
CREATE TABLE IF NOT EXISTS Criptomoeda (
    cripto_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    simbolo VARCHAR(10) NOT NULL UNIQUE
);

-- 4. Tabela de Transações / Ordens
CREATE TABLE IF NOT EXISTS Transacao (
    transacao_id INT AUTO_INCREMENT PRIMARY KEY,
    carteira_id INT NOT NULL,
    cripto_id INT NOT NULL,
    quantidade DECIMAL(18,8) NOT NULL,
    valor_total DECIMAL(18,2) NOT NULL, -- Valor em moeda fiduciária local
    data_transacao DATETIME NOT NULL,
    CONSTRAINT fk_transacao_carteira FOREIGN KEY (carteira_id) 
        REFERENCES Carteira(carteira_id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    CONSTRAINT fk_transacao_cripto FOREIGN KEY (cripto_id) 
        REFERENCES Criptomoeda(cripto_id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);