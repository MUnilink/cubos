    select
        'P |01|SF4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(F4_FILIAL, ' '))+'|'+RTRIM(COALESCE(F4_CODIGO, ' ')), ' '), '|') as BK_TES,
        SF4.F4_CODIGO as COD_TES,
        SF4.F4_TEXTO as DESC_TES,
        SF4.F4_DUPLIC as GERA_DUPLICATA_TES,
        SF4.F4_ESTOQUE as GERA_ESTOQUE_TES,
        SF4.F4_TIPOPER as TIPO_OPERACAO_TES
    from SF4010 SF4
    where SF4.D_E_L_E_T_ = ' '
union
    select
        'P |01|SF5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SF5.F5_FILIAL, ' '))+'|'+RTRIM(COALESCE(SF5.F5_CODIGO, ' ')), ' '), '|') as BK_TES,
        SF5.F5_CODIGO as COD_TES,
        SF5.F5_TEXTO as DESC_TES,
        null as GERA_DUPLICATA_TES,
        null as GERA_ESTOQUE_TES,
        null as TIPO_OPERACAO_TES
    from SF5010 SF5
    where SF5.D_E_L_E_T_ = ' '
union
    select 'P |01|SF4010||',
        '01 - INDEFINIDO',
        '01 - INDEFINIDO',
        '01 - INDEFINIDO',
        '01 - INDEFINIDO',
        '01 - INDEFINIDO'
