select
    sum(TS1.TS1_VALOR) as VALOR_TAXA,
    trim(isnull(TS0010.TS0_NOMDOC, '-')) as TS0_DOCTO,
    trim(isnull(ST9010.T9_CODBEM, '-')) as T9_CODBEM,
    TS1.ANO_DOCTO,
    TS1.CC
from
    (
        select
            TS1010.TS1_DOCTO,
            TS1010.TS1_CODBEM,
            TS1010.TS1_VALOR,
            TS1010.TS1_YCC as CC,
            year(TS1010.TS1_DTEMIS) as ANO_DOCTO
        from TS1010
        where TS1010.D_E_L_E_T_ = ''
    ) TS1
    left join TS0010
        on TS0010.D_E_L_E_T_ = ''
        and TS0010.TS0_DOCTO = TS1.TS1_DOCTO
    left join ST9010
        on ST9010.D_E_L_E_T_ = ''
        and ST9010.T9_CODBEM = TS1.TS1_CODBEM
group by
    TS0010.TS0_NOMDOC,
    ST9010.T9_CODBEM,
    TS1.ANO_DOCTO,
    TS1.CC
