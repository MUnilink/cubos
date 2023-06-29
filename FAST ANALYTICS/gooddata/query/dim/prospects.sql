    select
        'P |01|SUS010|'+ COALESCE(NULLIF(RTRIM(COALESCE(US_FILIAL, ' '))+'|'+RTRIM(COALESCE(US_COD, ' '))+RTRIM(COALESCE(US_LOJA, ' ')), ' '), '|') AS BK_PROSPECT,
        SUS.US_COD,
        SUS.US_LOJA,
        trim(SUS.US_NOME) as US_NOME,
        (select trim(SX5010.X5_DESCRI) from SX5010 where SX5010.D_E_L_E_T_ = '' and SUS.US_SATIV = SX5010.X5_CHAVE and SX5010.X5_TABELA = 'T3') AS SEGMENTACAO_ATIVIDADE_1
    from SUS010 SUS
    where SUS.D_E_L_E_T_ = ''
union
    select
        'P |01|SUS010||',
        '01 - INDEFINIDO',
        '01 - INDEFINIDO',
        '01 - INDEFINIDO',
        '01 - INDEFINIDO'