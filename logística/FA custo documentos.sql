select
    trim(isnull(TS1010.TS1_DTEMIS, '-')) as TS1_DTEMIS,
    trim(isnull(SE2010.E2_VENCREA, '-')) as TS1_DTVENC,
    TS1010.TS1_QTDPAR,
    SE2010.E2_PARCELA,
    TS1010.TS1_VALOR/TS1010.TS1_QTDPAR as VALOR_PARCELA,
    TS1010.TS1_VALOR as VALOR_TAXA,

    trim(isnull(TS0010.TS0_NOMDOC, '-')) as TS0_DOCTO,
    trim(isnull(ST9010.T9_CODBEM, '-')) as T9_CODBEM,

    year(SE2010.E2_VENCREA) as ano_VENCTO,
    month(SE2010.E2_VENCREA) as mes_VENCTO

from TS1010
    left join TS0010
        on TS0010.D_E_L_E_T_ = ''
        and TS0010.TS0_DOCTO = TS1010.TS1_DOCTO
    left join SE2010
        on SE2010.D_E_L_E_T_ = ''
        and trim(SE2010.E2_PREFIXO) = 'MNT'
        and SE2010.E2_NUM = TS1010.TS1_NUMSE2
    left join ST9010
        on ST9010.D_E_L_E_T_ = ''
        and ST9010.T9_CODBEM = TS1010.TS1_CODBEM
where
        TS1010.D_E_L_E_T_ = ''