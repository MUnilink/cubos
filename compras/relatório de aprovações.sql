select
    trim(isnull(SCP.CP_FILIAL, '-')) as FILIAL,
    substring(SCP.CP_OP, 1, 6) as OS,
    trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
    trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
    trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
    trim(isnull(SB1.B1_UM, '-')) as UN,

    trim(isnull(SCP.CP_ITEMCTA, '-')) as ATIVIDADE,
    trim(isnull(SCP.CP_CC, '-')) as CC,

    trim(isnull(SCP.CP_NUM, '-')) as NUMERO,
    trim(isnull(SCP.CP_ITEM, '-')) as ITEM,
    convert(date, SCP.CP_EMISSAO, 103) as DATA,
    substring(SCP.CP_EMISSAO, 1, 6) as PERIODO,
    trim(isnull(SCP.CP_OBS, '-')) as OBS,
    
    trim(isnull(upper(SC1.C1_SOLICIT), '-')) as SOLICITANTE_SC,

    SCP.CP_QUANT as QTD_PEDIDA,
    SCP.CP_QUJE as QTD_ATENDIDA,

    case SC1.C1_APROV
        when 'B' then 'PENDENTE'
        when 'L' then 'APROVADO'
        when 'R' then 'REJEITADO'
        else 'OUTROS'
    end as SITAPROV,

    (  
        select top 1 convert(date, SCR010.CR_DATALIB, 103)
        from SCR010
        where
                SCR010.D_E_L_E_T_ = ''
            and SCR010.CR_LIBAPRO is not null
            and SCR010.CR_TIPO = 'SA'
            and SCR010.CR_NUM = SCP.CP_NUM
    ) as DATAAPROV

from SCP010 SCP (nolock)
    left join SCR010 SCR (nolock)
        on SCR.D_E_L_E_T_ = ''
        and SCR.CR_FILIAL = SCP.CP_FILIAL
        and SCR.CR_NUM = SCP.CP_NUM
        and SCR.CR_LIBAPRO is not null
        and SCR.CR_TIPO = 'SA'
        
        inner join SAK010 SAK (nolock)
            on SAK.D_E_L_E_T_ = ''
            and SAK.AK_USER = SCR.CR_LIBAPRO
    
    left join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SC7.C7_PRODUTO
    left join SY1010 SY1 (nolock)
        on SY1.Y1_USER = SC7.C7_USER
where SCP.D_E_L_E_T_ = ''
