select
    cast(TS1.TS1_DTEMIS as date) as DT_EMITE,
    cast(SE2.E2_VENCREA as date) as DT_VENCE,
    TS1.TS1_QTDPAR as QTD_PARCELAS,
    concat(trim(TS0.TS0_DOCTO), ' - ', trim(TS0.TS0_NOMDOC)) as DOCUMENTO,
    trim(TS1.TS1_CODBEM) as EQUIPAMENTO,
    left(SE2.E2_VENCREA, 6) as PERIODO_VENCE,
    left(TS1.TS1_DTEMIS, 6) as PERIODO_EMITE,
    TS1.TS1_VALOR/TS1.TS1_QTDPAR as VL_PARCELA,
    TS1.TS1_VALOR as VL_TOTAL,
    TS1.TS1_VALOR/TS1.TS1_QTDPAR/12 as RATEIO
from TS1010 TS1 (nolock)
    left join TS0010 TS0 (nolock)
        on TS0.D_E_L_E_T_ = ''
        and TS0.TS0_DOCTO = TS1.TS1_DOCTO
    left join SE2010 SE2 (nolock)
        on SE2.D_E_L_E_T_ = ''
        and trim(SE2.E2_PREFIXO) = 'MNT'
        and SE2.E2_NUM = TS1.TS1_NUMSE2
where
        TS1.D_E_L_E_T_ = ''
