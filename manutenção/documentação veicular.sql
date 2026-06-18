select
    trim(ST9.T9_CODBEM) as EQUIPAMENTO,
    trim(ST9.T9_CODFAMI) as FAMILIA,
    trim(TS1.TS1_YCC) as CC,
    case ST9.T9_SITBEM when 'A' then 'ATIVO' when 'I' then 'INATIVO' else 'OUTROS' end as SITUACAO,
    cast(TS1.TS1_DTEMIS as date) as DT_EMITE,
    cast(SE2.E2_VENCREA as date) as DT_VENCE,
    TS1.TS1_QTDPAR as QTD_PARCELAS,
    concat(trim(TS0.TS0_DOCTO), ' - ', trim(TS0.TS0_NOMDOC)) as DOCUMENTO,
    year(SE2.E2_VENCREA) as ANO_VENCE,
    year(TS1.TS1_DTEMIS) as ANO_EMITE,
    left(SE2.E2_VENCREA, 6) as PERIODO_VENCE,
    left(TS1.TS1_DTEMIS, 6) as PERIODO_EMITE,
    cast(TS1.TS1_VALOR/TS1.TS1_QTDPAR as numeric(15, 2)) as VL_PARCELA,
    cast(TS1.TS1_VALOR as numeric(15, 2)) as VL_TOTAL,
    cast(TS1.TS1_VALOR/TS1.TS1_QTDPAR/12 as numeric(15, 2)) as VL_MENSAL
from TS1010 TS1 (nolock)
    left join TS0010 TS0 (nolock)
        on TS0.D_E_L_E_T_ = ''
        and TS0.TS0_DOCTO = TS1.TS1_DOCTO
    left join SE2010 SE2 (nolock)
        on SE2.D_E_L_E_T_ = ''
        and SE2.E2_PREFIXO = 'MNT'
        and SE2.E2_NUM = TS1.TS1_NUMSE2
    left join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and ST9.T9_CODBEM = TS1.TS1_CODBEM
where
        TS1.D_E_L_E_T_ = ''
