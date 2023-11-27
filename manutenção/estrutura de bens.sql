select
    trim(ST9.T9_CODBEM) as ESTRUTURA,
    trim(STC.TC_COMPONE) as COMPONENTE,
    trim(ST9.T9_CCUSTO) as CC,
    trim(ST9.T9_ITEMCTA) as ATIVIDADE,
    
    case when STC.TC_COMPONE = (select ST9010.T9_CODBEM from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and ST9010.T9_CODFAMI = 'VP' and ST9010.T9_CODBEM = STC.TC_COMPONE) then 'CM ATRELADO'
        else
        case when STC.TC_COMPONE = (select ST9010.T9_CODBEM from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and ST9010.T9_CODFAMI = 'PN' and ST9010.T9_CODBEM = STC.TC_COMPONE) then 'PNEUS'
            else
            'OUTROS'
        end
    end as ATRELAMENTO,    
    isnull(trim(TQT.TQT_DESMED), 'SR') as MEDIDA,
    ST9.T9_CODFAMI as FAMILIA

from ST9010 ST9 (nolock)
    left join STC010 STC (nolock)
        on ST9.D_E_L_E_T_ = ''
        and ST9.T9_CODBEM = STC.TC_CODBEM

        left join TQS010 TQS (nolock)
            on TQS.D_E_L_E_T_ = ''
            and TQS.TQS_CODBEM = STC.TC_COMPONE

            left join TQT010 TQT (nolock)
                on TQT.D_E_L_E_T_ = ''
                and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA

where STC.D_E_L_E_T_ = ''
