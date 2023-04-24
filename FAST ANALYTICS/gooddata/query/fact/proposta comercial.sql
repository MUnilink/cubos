select
    AC2.AC2_DESCRI as ESTAGIO_PROCESSO,
    trim(SA3.A3_NREDUZ) as VENDEDOR,
    convert(datetime, datetimefromparts(year(SUS.US_DTCAD), month(SUS.US_DTCAD), day(SUS.US_DTCAD), substring(SUS.US_HRCAD, 1, 2), substring(SUS.US_HRCAD, 4, 5), 0, 0), 113) as DATA_PROSPECT,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(A1_COD, ' '))+RTRIM(COALESCE(A1_LOJA, ' ')), ' '), '|') AS BK_CLIENTE,
    'P |01|SUS010|'+ COALESCE(NULLIF(RTRIM(COALESCE(US_FILIAL, ' '))+'|'+RTRIM(COALESCE(US_COD, ' '))+RTRIM(COALESCE(US_LOJA, ' ')), ' '), '|') AS BK_PROSPECT,
    AD1.AD1_NROPOR as OPORTUNIDADE,
    AD1.AD1_REVISA as VERSAO,
    trim(AD1.AD1_DESCRI) as DESCRICAO,
    substring(AD1.AD1_DTFIM, 1, 6) as PERIODO_OPORTUNIDADE,
    convert(datetime, datetimefromparts(year(AD1.AD1_DATA), month(AD1.AD1_DATA), day(AD1.AD1_DATA), substring(AD1.AD1_HORA, 1, 2), substring(AD1.AD1_HORA, 4, 5), 0, 0), 113) as DATA_OPORTUNIDADE,
    convert(date, AD1.AD1_DTINI, 103) as DTINI,
    convert(date, AD1.AD1_DTFIM, 103) as DTFIM,
    AD1.AD1_OBSPRO as OBS,
    1 as contador

from AD1010 AD1
    inner join SA3010 SA3
        on SA3.D_E_L_E_T_ = ''
        and SA3.A3_COD = AD1.AD1_VEND
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
where AD1.D_E_L_E_T_ = ''
