select
    'P |01|01' as BK_EMPRESA,
    'P |01|AC1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(AC2.AC2_FILIAL, ' '))+'|'+RTRIM(COALESCE(AC2.AC2_PROVEN, ' ')), ' '), '|') AS BK_PROCESSOVENDA,
    'P |01|AC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(AC2.AC2_FILIAL, ' '))+'|'+RTRIM(COALESCE(AC2.AC2_PROVEN, ' '))+RTRIM(COALESCE(AC2.AC2_STAGE, ' ')), ' '), '|') AS BK_ESTAGIOVENDA,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA1.A1_COD, ' '))+RTRIM(COALESCE(SA1.A1_LOJA, ' ')), ' '), '|') AS BK_CLIENTE,
    'P |01|SUS010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SUS.US_FILIAL, ' '))+'|'+RTRIM(COALESCE(SUS.US_COD, ' '))+RTRIM(COALESCE(SUS.US_LOJA, ' ')), ' '), '|') AS BK_PROSPECT,
    'P |01|SA3010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA3.A3_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA3.A3_COD, ' ')), ' '), '|') AS BK_VENDEDOR,
    AD1.AD1_DATA as DATA,
    AD1.AD1_NROPOR as OPORTUNIDADE,
    AD1.AD1_REVISA as VERSAO,
    trim(AD1.AD1_DESCRI) as DESCRICAO,
    (select upper(SX5010.X5_DESCRI) from SX5010 (nolock) where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = 'A6' and SX5010.X5_CHAVE = AD1.AD1_FCS) as FATOR_SUCESSO,
    (select upper(SX5010.X5_DESCRI) from SX5010 (nolock) where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = 'A6' and SX5010.X5_CHAVE = AD1.AD1_FCI) as FATOR_INSUCESSO,
    (select SUN010.UN_DESC from SUN010 where SUN010.D_E_L_E_T_ = '' and SUN010.UN_FILIAL = substring(AD1.AD1_FILIAL, 1, 4) and SUN010.UN_ENCERR = AD1.AD1_ENCERR) as ENCERRADO,
    case AD1.AD1_STATUS when 1 then 'ABERTA' when 2 then 'PERDIDA' when 3 then 'SUSPENSA' when 9 then 'GANHA' else 'OUTROS' end as AD1_STATUS,
    case AD1.AD1_FEELIN when 1 then 'BAIXA' when 2 then 'MEDIA' when 3 then 'ALTA' else 'OUTROS' end as AD1_FEELIN,
    case AD1.AD1_PRIOR when 1 then 'BAIXA' when 2 then 'MEDIA' when 3 then 'ALTA' else 'OUTROS' end as AD1_PRIOR,
    AD1.AD1_DTINI as DTINI,
    AD1.AD1_DTFIM as DTFIM,
    trim(AD1.AD1_OBSPRO) as OBS,
    0.01 * AD1.AD1_VERBA * AD2.AD2_PERC as RECEITA_ESTIMADA,
    AD2.AD2_PERC

from AD1010 AD1
    inner join AC2010 AC2
        on AC2.D_E_L_E_T_ = ''
        and AC2.AC2_FILIAL = substring(AD1.AD1_FILIAL, 1, 4)
        and AC2.AC2_PROVEN = AD1.AD1_PROVEN
        and AC2.AC2_STAGE = AD1.AD1_STAGE
    left join SUS010 SUS
        on SUS.D_E_L_E_T_ = ''
        and SUS.US_FILIAL = substring(AD1.AD1_FILIAL, 1, 4)
        and SUS.US_COD = AD1.AD1_PROSPE
        and SUS.US_LOJA = AD1.AD1_LOJPRO
    left join SA1010 SA1
        on SA1.D_E_L_E_T_ = ''
        and SA1.A1_COD = AD1.AD1_CODCLI
        and SA1.A1_LOJA = AD1.AD1_LOJCLI
    left join AD2010 AD2 (nolock)
        on AD2.D_E_L_E_T_ = ''
        and AD2.AD2_NROPOR = AD1.AD1_NROPOR
        and AD2.AD2_REVISA = AD1.AD1_REVISA
        
        left join SA3010 SA3 (nolock)
            on SA3.D_E_L_E_T_ = ''
            and SA3.A3_COD = AD2.AD2_VEND
where
        AD1.D_E_L_E_T_ = ''
    and AD1.AD1_DATA between <<START_DATE>> and <<FINAL_DATE>>
