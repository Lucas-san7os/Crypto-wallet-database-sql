-- =============================================================================
-- Seed DML: Inserção de Registros de Teste
-- =============================================================================

-- 1. Inserção de Usuários
INSERT INTO Usuario (nome, email) VALUES
    ('Ana Silva', 'ana.silva@example.com'),
    ('Bruno Costa', 'bruno.costa@example.com'),
    ('Carla Pereira', 'carla.pereira@example.com');

-- 2. Inserção de Carteiras Digitais
INSERT INTO Carteira (usuario_id, nome, saldo) VALUES
    (1, 'Carteira Pessoal', 0.0),
    (1, 'Carteira de Trading', 0.0),
    (2, 'Carteira Principal', 0.0),
    (3, 'Carteira Reserva', 0.0);

-- 3. Cadastro de Criptoativos
INSERT INTO Criptomoeda (nome, simbolo) VALUES
    ('Bitcoin', 'BTC'),
    ('Ethereum', 'ETH'),
    ('Ripple', 'XRP');

-- 4. Registro de Transações
INSERT INTO Transacao (carteira_id, cripto_id, quantidade, valor_total, data_transacao) VALUES
    (1, 1, 0.02500000, 1250.00, '2025-05-20 09:15:00'),
    (1, 2, 0.10000000, 300.00, '2025-05-21 14:30:00'),
    (2, 1, 0.01000000, 500.00, '2025-05-22 11:45:00'),
    (3, 3, 50.00000000, 750.00, '2025-05-23 16:00:00'),
    (4, 2, 0.05000000, 150.00, '2025-05-24 10:20:00');