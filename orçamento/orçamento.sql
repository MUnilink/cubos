select
    AK1.AK1_CODIGO ORCAMENTO,
    AK1.AK1_DESCRI DESC_ORC,
    convert(date, AK1.AK1_INIPER, 103) as DTINI_ORC,
    convert(date, AK1.AK1_FIMPER, 103) as DTFIM_ORC,
    AK2.AK2_ID as ID,
    AK2.AK2_CO as CONTA_ORC,
    AK5.AK5_TIPO as CONTA_TIPO,
    AK3.AK3_NIVEL as CONTA_NIVEL,
    trim(AK5.AK5_DESCRI) as CONTA_DESCRI,
    AK5.AK5_DEBCRE as DEBCRE,
    AK5.AK5_MSBLQL as BLOQUEADO,
    AK5.AK5_CTACTB as CCONTABIL,
    AK2.AK2_PERIOD as PERIODO,
    AK2.AK2_CLASSE as CC_ORC,
    AK2.AK2_OPER as ITCT_ORC,
    convert(date, AK2.AK2_DATAI, 103) as DTINI_ITEM,
    convert(date, AK2.AK2_DATAF, 103) as DTFIM_ITEM,
    
    AK2.AK2_VALOR as VALOR_ORCADO,
    AKD.AKD_VALOR1 as VALOR_LANCAMENTO,
    AKD.AKD_STATUS as STATUS_LANCAMENTO,
    AKD.AKD_LOTE as LOTE_LANCAMENTO,
    AKD.AKD_ID as ID_LANCAMENTO,
    AKD.AKD_CO as CO_LANCAMENTO,
    AKD.AKD_ITEM as ITEM_LANCAMENTO,
    AKD.AKD_SEQ as SEQ,
    convert(date, AKD.AKD_DATA, 103) as DATA_LANCAMENTO,
    AKD.AKD_CLASSE as CC,
    AKD.AKD_OPER as ITCT,
    
    case AKD.AKD_TIPO
        when 1 then 'CREDITO'
        when 2 then 'DEBITO'
        when 3 then 'ESTORNO'
        else 'OUTROS'
    end as TIPO_SALDO,

    AKD.AKD_TPSALD as TIPO_LANCAMENTO,

    case when (select count(*) from AKD010 where AKD010.D_E_L_E_T_ = '' and substring(AKD010.AKD_CHAVE, 1, 19) = substring(AKD.AKD_CHAVE, 1, 19) and AKD010.AKD_TPSALD = 'EM') = 1 then AKD.AKD_VALOR1 else 0.0 end as VALOR_EMPENHADO,
    case when (select count(*) from AKD010 where AKD010.D_E_L_E_T_ = '' and substring(AKD010.AKD_CHAVE, 1, 19) = substring(AKD.AKD_CHAVE, 1, 19) and AKD010.AKD_TPSALD = 'EM') = 2 then AKD.AKD_VALOR1 else 0.0 end as VALOR_REALIZADO,
    
    AKD.AKD_USER as USUARIO,
    trim(AKD.AKD_HIST) as HISTORICO,
    trim(AKD.AKD_CHAVE) as CHAVE,
    len(AKD.AKD_CHAVE),
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
        and AK3.AK3_VERSAO = AK2.AK2_VERSAO
        and AK3.AK3_CO = AK2.AK2_CO

        inner join AK5010 AK5 (nolock)
            on AK5.D_E_L_E_T_ = ''
            and AK5.AK5_CODIGO = AK3.AK3_CO
        inner join AK1010 AK1 (nolock)
            on AK1.D_E_L_E_T_ = ''
            and AK1.AK1_CODIGO = AK3.AK3_ORCAME
            and AK1.AK1_VERSAO = AK3.AK3_VERSAO
where AK2.D_E_L_E_T_ = ''
