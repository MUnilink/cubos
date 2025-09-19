select
    CASE WHEN ZG1.ZG1_FILORI IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(ZG1.ZG1_FILORI AS CHAR (6)) END AS BK_FILIAL,
    'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(ZG1.ZG1_CC, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
    case when ZG1.ZG1_TABELA = 'ST9' then (select concat(trim(ST9010.T9_FILIAL), trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZG1.ZG1_CODIGO)) else null end as COD_DA3,
    case when ZG1.ZG1_TABELA = 'SQ3' then (select concat(trim(SQ3010.Q3_FILIAL), trim(SQ3010.Q3_CARGO)) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and trim(SQ3010.Q3_CARGO) = trim(ZG1.ZG1_CODIGO)) else null end as COD_SRJ,
    concat(trim(ZG1.ZG1_TIPO), ' ', trim(ZG1.ZG1_CODIGO)) as ID_RECURSO,
    cast(ZG1.ZG1_TIPO as int) as ID_TIPO_ITEM,
    cast(isnull(ZG1.ZG1_HRPAD, 0.0) as numeric(15, 2)) as HORA_PADRAO,
    cast(isnull(ZG1.ZG1_HRPRO, 0.0) as numeric(15, 2)) as HORA_PROD,
    cast(isnull(ZG1.ZG1_HRIMPR, 0.0) as numeric(15, 2)) as HORA_IMPROD,
    cast(isnull(ZG1.ZG1_VLTOTL, 0.0) as numeric(15, 2)) as VL_TOTAL,
    cast(isnull(ZG1.ZG1_VLHORA, 0.0) as numeric(15, 2)) as VL_HORA,
    cast(isnull(ZG1.ZG1_VLPROD, 0.0) as numeric(15, 2)) as VL_PROD,
    cast(isnull(ZG1.ZG1_VLIMPR, 0.0) as numeric(15, 2)) as VL_IMPROD,
    cast(isnull(ZG1.ZG1_IMPR1, 0.0) as numeric(15, 2)) as HR_IMPR1,
    cast(isnull(ZG1.ZG1_IMPR2, 0.0) as numeric(15, 2)) as HR_IMPR2,
    cast(isnull(ZG1.ZG1_IMPR3, 0.0) as numeric(15, 2)) as HR_IMPR3,
    concat(ZG1.ZG1_COMPET, '01') as COMPETENCIA,
    case when ZG1.ZG1_TABELA = 'SQ3' and ZG1.ZG1_CC = '305' then (select max(SRJ010.RJ_YHRPADR) from SRJ010 where SRJ010.D_E_L_E_T_ = '' and SRJ010.RJ_CARGO = ZG1.ZG1_CODIGO) when ZG1.ZG1_TABELA = 'SQ3' and ZG1.ZG1_CC = '304' then '220' else ZG1.ZG1_HRPAD end as QTD_UNI,

    /* PARA RM */
    ZG1.ZG1_FILORI as FILIAL,
    ZG1.ZG1_COMPET as PERIODO,
    ZG1.ZG1_TABELA as TABELA,
    ZG1.ZG1_CC as CC,
    trim(ZG1.ZG1_CODIGO) as RECURSO,
    
    case ZG1.ZG1_TABELA
        when 'ST9' then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = ZG1.ZG1_CODIGO and ZG1.ZG1_TIPO in (3, 6, 9, 12))
        when 'SQ3' then (select trim(SQ3010.Q3_DESCSUM) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and SQ3010.Q3_CARGO = ZG1.ZG1_CODIGO and ZG1.ZG1_TIPO in (2, 14))
    else null end as DESC_RECURSO,

    case cast(ZG1.ZG1_TIPO as int)
        when 1 then 'RECEITA'
        when 2 then 'FOLHA'
        when 3 then 'MANUTENÇÃO'
        when 4 then 'MATERIAIS'
        when 5 then 'COMPRAS'
        when 6 then 'DEPRECIAÇÃO'
        when 7 then 'CONTABILIDADE'
        when 8 then 'DESPESAS FINANCEIRAS'
        when 9 then 'DOCUMENTAÇÃO'
        when 10 then 'COMBUSTIVEL'
        when 11 then 'SERVIÇOS TOMADOS'
        when 12 then 'SEGURO EQUIPAMENTO'
        when 13 then 'PNEUS'
        when 14 then 'PROVISÕES'
        when 15 then 'TIPO RH IMPROD'
        when 16 then 'TIPO MNT IMPROD'
        else 'OUTROS'
    end as TIPO_INSUMO,

    case
        when ZG1.ZG1_FILORI = '010101' and trim(ZG1.ZG1_CC) = '304' then 'TMS'
        when ZG1.ZG1_FILORI = '010101' and trim(ZG1.ZG1_CC) = '305' then 'OPP MATRIZ'
        when ZG1.ZG1_FILORI = '010102' and trim(ZG1.ZG1_CC) = '304' then 'TMS PECEM'
        when ZG1.ZG1_FILORI = '010102' and trim(ZG1.ZG1_CC) = '305' then 'OPP'
    else 'OUTROS' end as TIPO_RODA,
    
    ZG1.ZG1_TIPO as TIPO,

    ZG1.ZG1_VLIMPR/
    (
        select sum(ZG1010.ZG1_VLIMPR)
        from ZG1010
        where
            ZG1010.D_E_L_E_T_ = ''
        and ZG1010.ZG1_VLIMPR != 0
        and ZG1010.ZG1_FILORI = ZG1.ZG1_FILORI
        and ZG1010.ZG1_COMPET = ZG1.ZG1_COMPET
        and ZG1010.ZG1_CODIGO = ZG1.ZG1_CODIGO
    ) as RAT_VLIMP

from ZG1010 ZG1 (nolock)
    left join CTT010 CTT
        on CTT.D_E_L_E_T_ = ''
        and CTT.CTT_CUSTO = ZG1.ZG1_CC
where ZG1.D_E_L_E_T_ = ''
