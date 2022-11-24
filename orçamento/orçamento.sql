select
    AK1.AK1_CODIGO ORCAMENTO,
    AK1.AK1_DESCRI DESC_ORC,
    convert(date, AK1.AK1_INIPER, 103) as DTINI_ORC,
    convert(date, AK1.AK1_FIMPER, 103) as DTFIM_ORC,
    AK2.AK2_ID as ID,
    AK2.AK2_CO as CONTA_ORC,
    AK5.AK5_TIPO as CONTA_TIPO,
    AK3.AK3_NIVEL as CONTA_NIVEL,
    AK5.AK5_DESCRI as CONTA_DESCRI,
    AK5.AK5_DEBCRE as DEBCRE,
    AK5.AK5_MSBLQL as BLOQUEADO,
    AK5.AK5_CTACTB as CCONTABIL,
    AK2.AK2_PERIOD as PERIODO,
    AK2.AK2_CLASSE as CC_ORC,
    AK2.AK2_OPER as ITCT_ORC,
    convert(date, AK2.AK2_DATAI, 103) as DTINI_ITEM,
    convert(date, AK2.AK2_DATAF, 103) as DTFIM_ITEM,
    
    AK2.AK2_VALOR,
    AKD.AKD_VALOR1,
    AKD.AKD_STATUS as STATUS,
    AKD.AKD_LOTE as LOTE,
    AKD.AKD_ID as ID,
    AKD.AKD_CO as CO,
    AKD.AKD_ITEM as ITEM,
    AKD.AKD_SEQ as SEQ,
    convert(date, AKD.AKD_DATA, 103) as DATA_LANCAMENTO,
    AKD.AKD_CLASSE as CC,
    AKD.AKD_OPER as ITCT,
    AKD.AKD_TPSALD as TIPO_LANCAMENTO,
    AKD.AKD_TIPO as TIPO,
    AKD.AKD_USER as USUARIO,
    AKD.AKD_HIST as HISTORICO,
    AKD.AKD_CHAVE as CHAVE,
    AK8.AK8_FUNCAO as ROTINA,
    AK8.AK8_DESCRI as DESC_ROTINA

from AKD010 AKD (nolock)
    right join AK2010 AK2 (nolock)
        on AK2.D_E_L_E_T_ = ''
        and AK2.AK2_ID = AKD.AKD_ID
        and AK2.AK2_CO = AKD.AKD_CO

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
    
    inner join AK8010 AK8 (nolock)
        on AK8.D_E_L_E_T_ = ''
        and AK8.AK8_CODIGO = AKD.AKD_PROCES
where AKD.D_E_L_E_T_ = ''
