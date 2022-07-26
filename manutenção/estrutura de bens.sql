select
    trim(CTT.CTT_DESC01) as CTT_DESC01,
    isnull(STC.TC_CODBEM, 'PNEU OU SR DESATRELADO') as TC_CODBEM,
    STC.TC_COMPONE,
    case when STC.TC_COMPONE like 'SR%' then 1000 else 1 end as qtd_compone,
    isnull(TQT.TQT_DESMED, 'SR') as TQT_DESMED,
    ST9.T9_CODFAMI
from ST9010 ST9 (nolock)
    left join STC010 STC (nolock)
        on STC.D_E_L_E_T_ = ''
        and STC.TC_CODBEM = ST9.T9_CODBEM

        left join TQS010 TQS (nolock)
            on TQS.D_E_L_E_T_ = ''
            and TQS.TQS_CODBEM = STC.TC_COMPONE

            left join TQT010 TQT (nolock)
                on TQT.D_E_L_E_T_ = ''
                and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA

    inner join CTT010 CTT (nolock)
        on CTT.D_E_L_E_T_ = ''
        and CTT.CTT_CUSTO = ST9.T9_CCUSTO
where ST9.D_E_L_E_T_ = ''
