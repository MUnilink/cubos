select
    ZC7.ZC7_CODIGO as ENTIDADE,
    ZC7.ZC7_CC as CC,
    ZC7.ZC7_COMPET as COMPETENCIA,
    case when ZC7.ZC7_ORIGEM = 'SQ3' then (select concat(trim(ST9010.T9_FILIAL), trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC7.ZC7_CODIGO) and ZC7.ZC7_ORIGEM = 'SQ3') else null end as COD_DA3,
    case when ZC7.ZC7_ORIGEM = 'ST9' then (select concat(trim(SQ3010.Q3_FILIAL), trim(SQ3010.Q3_CARGO)) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and trim(SQ3010.Q3_CARGO) = trim(ZC7.ZC7_CODIGO) and ZC7.ZC7_ORIGEM = 'ST9') else null end as COD_SRJ,
    cast(ZC7.ZC7_HRPAD as numeric(15, 2)) as HORA_PAD,
    cast(ZC7.ZC7_HRPROD as numeric(15, 2)) as HORA_PROD,
    cast(ZC7.ZC7_HRIMPR as numeric(15, 2)) as HORA_IMPR,
    cast(ZC7.ZC7_CUSTO as numeric(15, 2)) as CUSTO_TOTAL

from ZC7010 ZC7
where
        concat(ZC7.ZC7_COMPET, '01') BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
    and ZC7.D_E_L_E_T_ = ''
