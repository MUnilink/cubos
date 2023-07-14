select
    ST9.T9_CODBEM as ESTRUTURA,
    STC.TC_COMPONE as COMPONENTE,
    ST9.T9_CCUSTO as CC,
    ST9.T9_ITEMCTA as ATIVIDADE,
    case when ST9.T9_CODFAMI != 'PN' and (STC.TC_COMPONE is null or STC.TC_COMPONE = '') then 'BEM DESATRELADO' else 
    case when STC.TC_COMPONE = ST9.T9_CODBEM then 'COMPONENTE ATRELADO' else case when STC.TC_CODBEM = ST9.T9_CODBEM then 'ESTRUTURA' else 'BEM DESATRELADO' end end as STATUS,
    isnull(TQT.TQT_DESMED, 'SR') as TQT_DESMED,
    ST9.T9_CODFAMI as FAMILIA,
    case when STC.TC_COMPONE like 'SR%' then 1000 else 1 end as qtd_compone
from STC010 STC (nolock)
    left join ST9010 EST (nolock)
        on EST.D_E_L_E_T_ = ''
        and EST.T9_CODBEM = STC.TC_CODBEM

        left join TQS010 TQS (nolock)
            on TQS.D_E_L_E_T_ = ''
            and TQS.TQS_CODBEM = STC.TC_COMPONE

            left join TQT010 TQT (nolock)
                on TQT.D_E_L_E_T_ = ''
                and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA

    left join ST9010 COM (nolock)
        on COM.D_E_L_E_T_ = ''
        and COM.T9_CODBEM = STC.TC_COMPONE
where STC.D_E_L_E_T_ = ''
