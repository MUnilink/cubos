select
    trim(STC.TC_CODBEM) as TC_CODBEM,
    trim(TQS.TQS_CODBEM) as TQS_CODBEM,
    trim(SB1.B1_COD) as B1_COD,
    trim(SB1.B1_DESC) as B1_DESC,
    PNEU_CUSTO.B9_CM,

    case SB1.B1_COD
        when '11300001' then 180000
        when '11300002' then 180000
        when '11300003' then 120000
        when '11300004' then 80000

        when '11300018' then 300000
        when '11300011' then 6800
        when '11300014' then 80000
        when '11300051' then 40000
        when '11300048' then 60000
        when '11300056' then 40000
        when '11300098' then 120000
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
                and SB1.B1_XMEDIDA = TQT.TQT_MEDIDA

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
    
    inner join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and ST9.T9_CODBEM = STC.TC_CODBEM
        and ST9.T9_CATBEM != 3
where
        STC.D_E_L_E_T_ = ''
