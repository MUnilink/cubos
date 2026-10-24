select
    'P |01|01' AS BK_EMPRESA,
    case when SD3.D3_FILIAL is null then 'P |01||' else 'P |01|01'+ CAST(SD3.D3_FILIAL as char (6)) end as BK_FILIAL,
    'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_COD, ' ')), ' '), '|') AS BK_ITEM,
    'P |01|SAH010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAH.AH_FILIAL, ' '))+'|'+RTRIM(COALESCE(SAH.AH_UNIMED, ' ')), ' '), '|') AS BK_UNIDADE_DE_MEDIDA,
    'P |01|SBM010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SBM.BM_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_GRUPO, ' ')), ' '), '|') AS BK_GRUPO_ESTOQUE,
    'P |01|NNR010|'+ COALESCE(NULLIF(RTRIM(COALESCE(NNR.NNR_FILIAL, ' '))+'|'+RTRIM(COALESCE(NNR.NNR_CODIGO, ' ')), ' '), '|') as ID_ARMAZEM,
    'P |01|CT1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CT1.CT1_FILIAL, ' '))+'|'+RTRIM(COALESCE(CT1.CT1_CONTA, ' ')), ' '), '|') AS BK_CONTA,
    'P |01|SF5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SF5.F5_FILIAL, ' '))+'|'+RTRIM(COALESCE(SF5.F5_CODIGO, ' ')), ' '), '|') as BK_TES,
    'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT.CTT_CUSTO, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
    'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD.CTD_ITEM, ' ')), ' '), '|') AS BK_ITEM_CONTABIL,
    null as ID_NFE,
    SD3.D3_CF as CF,
    SD3.D3_EMISSAO as EMISSAO,
    SD3.D3_DOC as DOC,
    SD3.D3_NUMSEQ as SEQ,
    SD3.D3_ESTORNO as ESTORNO,
    cast(SD3.D3_QUANT as numeric(15, 2)) as QTD,
    cast(SD3.D3_CUSTO1 as numeric(15, 2)) as CUSTO,
    case when SD3.D3_CF like 'R%' then 'SAI' when SD3.D3_CF like 'D%' then 'ENT' else 'NF' end as TIPO_MOV
    
from SD3010 SD3
    left join NNR010 NNR
        on NNR.D_E_L_E_T_ = ''
        and NNR.NNR_FILIAL = SD3.D3_FILIAL
        and NNR.NNR_CODIGO = SD3.D3_LOCAL
    left join SF5010 SF5
        on SF5.D_E_L_E_T_ = ''
        and SF5.F5_CODIGO = SD3.D3_TM
    inner join SB1010 SB1
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SD3.D3_COD
        and SB1.B1_GRUPO like '1%'

        left join SBM010 SBM
            on SBM.D_E_L_E_T_ = ' '
            and SBM.BM_GRUPO = SB1.B1_GRUPO
        left join SAH010 SAH
            on SAH.D_E_L_E_T_ = ''
            and SAH.AH_UNIMED = SB1.B1_COD
        left join ACV010 ACV
            on ACV.D_E_L_E_T_ = ' '
            and coalesce(nullif(ACV.ACV_FILIAL, ''), '0101') = coalesce(nullif(SB1.B1_FILIAL, ''), '0101')
            and ACV.ACV_CODPRO = SB1.B1_COD

            left join ACU010 ACU
                on ACU.D_E_L_E_T_ = ' '
                and ACU.ACU_FILIAL = coalesce(nullif(ACV.ACV_FILIAL, ''), '0101')
                and ACU.ACU_COD = ACV.ACV_CATEGO
    
    left join CTT010 CTT
        on CTT.D_E_L_E_T_ = ' '
        and CTT.CTT_FILIAL = SUBSTRING(SD3.D3_FILIAL, 1, 4)
        and CTT.CTT_CUSTO = SD3.D3_CC
    left join CTD010 CTD
        on CTD.D_E_L_E_T_ = ' '
        and CTD.CTD_FILIAL = '      '
        and CTD.CTD_ITEM = SD3.D3_ITEMCTA
    left join CT1010 CT1
        on CT1.D_E_L_E_T_ = ''
        and CT1.CT1_CONTA = SD3.D3_CONTA
where
        SD3.D_E_L_E_T_ = ''
    and SD3.D3_EMISSAO like '2026%'
