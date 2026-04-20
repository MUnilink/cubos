select
    CASE WHEN ZG1.ZG1_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(ZG1.ZG1_FILORI AS CHAR (6)) END AS BK_FILIAL,
    'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(ZC7.ZC7_CC, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
    case when ZC7.ZC7_ORIGEM = 'ST9' then (select concat(trim(ST9010.T9_FILIAL), trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC7.ZC7_CODIGO)) else null end as COD_DA3,
    case when ZC7.ZC7_ORIGEM = 'SQ3' then (select concat(trim(SQ3010.Q3_FILIAL), trim(SQ3010.Q3_CARGO)) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and trim(SQ3010.Q3_CARGO) = trim(ZC7.ZC7_CODIGO)) else null end as COD_SRJ,
    cast(isnull(ZC7.ZC7_HRPAD, 0.0) as numeric(15, 2)) as HORA_PADRAO,
    cast(isnull(ZC7.ZC7_HRPROD, 0.0) as numeric(15, 2)) as HORA_PROD,
    cast(isnull(ZC7.ZC7_HRIMPR, 0.0) as numeric(15, 2)) as HORA_IMPROD,
    cast(ZG1.ZG1_TIPO as int) as ID_TIPO_ITEM,
    cast(isnull(ZG1.ZG1_VLTOTL, 0.0) as numeric(15, 2)) as VL_TOTAL,
    cast(isnull(ZG1.ZG1_VLHORA, 0.0) as numeric(15, 2)) as VL_HORA,
    cast(isnull(ZG1.ZG1_VLPROD, 0.0) as numeric(15, 2)) as VL_PROD,
    cast(isnull(ZG1.ZG1_VLIMPR, 0.0) as numeric(15, 2)) as VL_IMPROD,
    concat(ZC7.ZC7_COMPET, '01') as COMPETENCIA

from ZC7010 ZC7
    inner join CTT010 CTT
        on CTT.D_E_L_E_T_ = ''
        and CTT.CTT_CUSTO = ZC7.ZC7_CC
    inner join ZG1010 ZG1
        on ZG1.D_E_L_E_T_ = ''
        and ZG1.ZG1_CODIGO = ZC7.ZC7_CODIGO
        and ZG1.ZG1_COMPET = ZC7.ZC7_COMPET
        and ZG1.ZG1_TABELA = ZC7.ZC7_ORIGEM
        and ZG1.ZG1_ATIVO = 'S'
where ZC7.D_E_L_E_T_ = ''
