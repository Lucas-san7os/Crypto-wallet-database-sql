-- =============================================================================
-- Analytical Queries: Relatórios e Extração de Métricas
-- =============================================================================

-- 1. Histórico de transações detalhado por usuário (Exemplo: Usuário ID 1)
SELECT 
    t.data_transacao, 
    u.nome AS usuario,
    w.nome AS carteira,
    c.simbolo AS cripto, 
    t.quantidade, 
    t.valor_total
FROM Transacao AS t
JOIN Carteira   AS w ON t.carteira_id = w.carteira_id
JOIN Usuario    AS u ON w.usuario_id  = u.usuario_id
JOIN Criptomoeda AS c ON t.cripto_id  = c.cripto_id
WHERE u.usuario_id = 1
ORDER BY t.data_transacao DESC;

-- 2. Volume financeiro total investido agrupado por carteira
SELECT 
    w.carteira_id,
    w.nome AS carteira, 
    u.nome AS titular,
    SUM(t.valor_total) AS total_investido
FROM Transacao AS t
JOIN Carteira AS w ON t.carteira_id = w.carteira_id
JOIN Usuario  AS u ON w.usuario_id  = u.usuario_id
GROUP BY w.carteira_id, w.nome, u.nome
ORDER BY total_investido DESC;

-- 3. Volume consolidado e custodiado de cada criptoativo na plataforma
SELECT 
    c.cripto_id,
    c.simbolo, 
    c.nome,
    SUM(t.quantidade) AS total_quantidade_custodiada,
    SUM(t.valor_total) AS total_movimentado_reais
FROM Transacao AS t
JOIN Criptomoeda AS c ON t.cripto_id = c.cripto_id
GROUP BY c.cripto_id, c.simbolo, c.nome
ORDER BY total_movimentado_reais DESC;