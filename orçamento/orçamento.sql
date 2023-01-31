select
    AK1.AK1_CODIGO as ORCAMENTO,
    AK2.AK2_VERSAO as VERSAO,
    AK1.AK1_DESCRI as DESC_ORC,
    AK2.AK2_ID as ID,
    AK2.AK2_CO as CONTA_ORC,
    AK2.AK2_PERIOD as PERIODO,
    AK2.AK2_CLASSE as CC,
    AK2.AK2_OPER as ATIV,
    
    convert(date, AK2.AK2_DATAI, 103) as DTINI_ITEM,
    convert(date, AK2.AK2_DATAF, 103) as DTFIM_ITEM,
    
    AK2.AK2_VALOR as VALORES_ORCAMENTO,
    AKD.AKD_VALOR1 as VALOR_LANCAMENTO,
    AKD.AKD_STATUS as STATUS_LANCAMENTO,
    AKD.AKD_ID as ID_LANCAMENTO,
    AKD.AKD_CO as CO_LANCAMENTO,
    AK5.AK5_CTACTB as CONTACONTABIL,
    AKD.AKD_ITEM as ITEM_LANCAMENTO,
    AKD.AKD_SEQ as SEQ,
    
    convert(date, AKD.AKD_DATA, 103) as DATA_LANCAMENTO,
    AKD.AKD_DATA as PERIODO_ORCAMENTO,
        
    case AKD.AKD_TIPO
        when 1 then 'CREDITO'
        when 2 then 'DEBITO'
        when 3 then 'ESTORNO'
        else 'OUTROS'
    end as TIPO_SALDO,

    AKD.AKD_TPSALD as TIPO_LANCAMENTO,
    AKD.AKD_LOTE as LOTE_LANCAMENTO,
    
    case when AKD.AKD_CHAVE like 'SD2%' then concat(substring(AKD.AKD_CHAVE, 1, 9), substring(AKD.AKD_HIST, 10, 9))
    else
        case when AKD.AKD_CHAVE like 'SC7%' then substring(AKD.AKD_CHAVE, 1, 19)
        else AKD.AKD_CHAVE
        end
    end as REF_LANCAMENTO,

    case when AKD.AKD_TPSALD = 'RE' then AKD.AKD_VALOR1 else 0.0 end as VALOR_REALIZADO,
    
    case when AKD.AKD_TPSALD = 'EM' and AKD.AKD_TIPO = 2 then AKD.AKD_VALOR1*-1
    else
        case when AKD.AKD_TPSALD = 'EM' and AKD.AKD_TIPO = 1 then AKD.AKD_VALOR1
        else
            case when AKD.AKD_TPSALD = 'RE' then 0.0
            else 0.0
            end
        end
    end as VALOR_EMPENHADO,
    
    case when AKD.AKD_TIPO = 1 and AKD.AKD_TPSALD = '0R' then AKD.AKD_VALOR1 else 0.0 end as VALOR_ORCADO,
    
    AKD.AKD_USER as USUARIO,
    trim(AKD.AKD_HIST) as HISTORICO,
    trim(AKD.AKD_CHAVE) as CHAVE,
    AK8.AK8_FUNCAO as ROTINA,
    trim(AK8.AK8_DESCRI) as DESC_ROTINA

from AK2010 AK2 (nolock)
    left join AKD010 AKD (nolock)
        on AKD.D_E_L_E_T_ = ''
        and AKD.AKD_CO = AK2.AK2_CO
        and AKD.AKD_CLASSE = AK2.AK2_CLASSE
        and AKD.AKD_OPER = AK2.AK2_OPER
        and substring(AKD.AKD_DATA, 1, 6) = substring(AK2.AK2_PERIOD, 1, 6)

        inner join AK8010 AK8 (nolock)
            on AK8.D_E_L_E_T_ = ''
            and AK8.AK8_CODIGO = AKD.AKD_PROCES

    inner join AK3010 AK3 (nolock)
        on AK3.D_E_L_E_T_ = ''
        and AK3.AK3_FILIAL = AK2.AK2_FILIAL
        and AK3.AK3_ORCAME = AK2.AK2_ORCAME
        and AK3.AK3_CO = AK2.AK2_CO

        inner join AK5010 AK5 (nolock)
            on AK5.D_E_L_E_T_ = ''
            and AK5.AK5_CODIGO = AK3.AK3_CO
        inner join AK1010 AK1 (nolock)
            on AK1.D_E_L_E_T_ = ''
            and AK1.AK1_CODIGO = AK3.AK3_ORCAME
where AK2.D_E_L_E_T_ = ''
