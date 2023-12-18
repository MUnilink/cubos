select distinct
    STC.TC_CODBEM,
    TQS.TQS_CODBEM,
    SB1.B1_COD,
    SB1.B1_DESC,
    PNEU_CUSTO.B9_CM,

    case SB1.B1_COD
        when '11300001' then 180000
        when '11300002' then 180000
        when '11300003' then 120000
        when '11300004' then 80000
        when '11300048' then 60000
        when '11300056' then 40000
        else 0
    end as km

from STC010 STC (nolock)
    inner join TQS010 TQS (nolock)
        on TQS.D_E_L_E_T_ = ''
        and TQS.TQS_CODBEM = STC.TC_COMPONE

        inner join TQT010 TQT (nolock)
            on TQT.D_E_L_E_T_ = ''
            and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA

            inner join SB1010 SB1 (nolock)
                on SB1.D_E_L_E_T_ = ''
                and substring(SB1.B1_DESC, 6, len(TQT.TQT_DESMED)) = TQT.TQT_DESMED

                left join
                (
                    select
                        SB9010.B9_COD,
                        avg(SB9010.B9_CM1) as B9_CM
                    from SB9010 (nolock)
                    where
                            SB9010.D_E_L_E_T_ = ''
                        and SB9010.B9_LOCAL = '20'
                        and SB9010.B9_COD like '1130%'
                        and SB9010.B9_DATA like '2022%'
                    group by
                        SB9010.B9_COD
                ) PNEU_CUSTO
                    on PNEU_CUSTO.B9_COD = SB1.B1_COD
where
        STC.D_E_L_E_T_ = ''
    and
        (
                STC.TC_CODBEM like 'CM%'
            or STC.TC_CODBEM like 'SR%'
            or STC.TC_CODBEM like 'VM%'
        )
