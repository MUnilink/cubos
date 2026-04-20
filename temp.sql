SELECT
    DATA_INI,
    DATA_FIM,
    DATEDIFF(DAY, DATA_INI, DATA_FIM) AS DiferencaDias,
    
    -- Exibe a média e desvio padrão como referência
    (SELECT AVG(DATEDIFF(DAY, DATA_INI, DATA_FIM)) FROM sua_tabela) AS Media,
    (SELECT STDEV(DATEDIFF(DAY, DATA_INI, DATA_FIM)) FROM sua_tabela) AS DesvioPadrao,
    
    -- Limites para 2 desvios padrão
    (SELECT AVG(DATEDIFF(DAY, DATA_INI, DATA_FIM)) - 2 * STDEV(DATEDIFF(DAY, DATA_INI, DATA_FIM)) FROM sua_tabela) AS LimiteInferior_2DP,
    (SELECT AVG(DATEDIFF(DAY, DATA_INI, DATA_FIM)) + 2 * STDEV(DATEDIFF(DAY, DATA_INI, DATA_FIM)) FROM sua_tabela) AS LimiteSuperior_2DP,
    
    -- Limites para 3 desvios padrão
    (SELECT AVG(DATEDIFF(DAY, DATA_INI, DATA_FIM)) - 3 * STDEV(DATEDIFF(DAY, DATA_INI, DATA_FIM)) FROM sua_tabela) AS LimiteInferior_3DP,
    (SELECT AVG(DATEDIFF(DAY, DATA_INI, DATA_FIM)) + 3 * STDEV(DATEDIFF(DAY, DATA_INI, DATA_FIM)) FROM sua_tabela) AS LimiteSuperior_3DP,
    
    -- Classificação detalhada
    CASE
        WHEN DATEDIFF(DAY, DATA_INI, DATA_FIM) < (
                SELECT AVG(DATEDIFF(DAY, DATA_INI, DATA_FIM)) - 2 * STDEV(DATEDIFF(DAY, DATA_INI, DATA_FIM)) FROM sua_tabela
             ) THEN 'Muito abaixo'
        WHEN DATEDIFF(DAY, DATA_INI, DATA_FIM) > (
                SELECT AVG(DATEDIFF(DAY, DATA_INI, DATA_FIM)) + 2 * STDEV(DATEDIFF(DAY, DATA_INI, DATA_FIM)) FROM sua_tabela
             ) THEN 'Muito acima'
        ELSE 'Normal'
    END AS Classificacao
FROM sua_tabela
