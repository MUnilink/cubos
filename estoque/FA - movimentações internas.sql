select
SELECT
    'P |01|01' AS BK_EMPRESA,
    concat('SD1', trim(SD1.D1_FILIAL), trim(SD1.D1_FORNECE), trim(SD1.D1_LOJA), trim(SD1.D1_DOC), trim(SD1.D1_SERIE)) as ID_NFE,
    concat(trim(SC7.C7_FILIAL), trim(SC7.C7_NUM)) as ID_PEDIDO,
    concat(trim(SC1.C1_FILIAL), trim(SC1.C1_NUM)) as ID_SOLICITACOM,
    concat(trim(SCP.CP_FILIAL), trim(SCP.CP_NUM)) as ID_SOLICITAARM,
    case when SC7.C7_FILIAL is null then 'P |01||' else 'P |01|01'+ CAST(SC7.C7_FILIAL as char (6)) end as BK_FILIAL,
    case when SA2.A2_COD_MUN = ' ' then 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_EST, ' ')), ' '), '|') else 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_EST, ' '))+RTRIM(COALESCE(SA2.A2_COD_MUN, ' ')), ' '), '|') end as BK_REGIAO,
    'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_FORNECE, ' '))+RTRIM(COALESCE(SC7.C7_LOJA, ' ')), ' '), '|') AS BK_FORNECEDOR,
    'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_PRODUTO, ' ')), ' '), '|') AS BK_ITEM,
    'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_COND, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO,
    'P |01|SAH010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAH.AH_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_UM, ' ')), ' '), '|') AS BK_UNIDADE_DE_MEDIDA,
    'P |01|SF4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SF4.F4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_TES, ' ')), ' '), '|') AS BK_TES,
    'P |01|ACU010|'+ COALESCE(NULLIF(RTRIM(COALESCE(ACU.ACU_FILIAL, ' '))+'|'+RTRIM(COALESCE(ACU.ACU_COD, ' ')), ' '), '|') AS BK_FAMILIA_COMERCIAL,
    'P |01|CT1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_CONTA, ' ')), ' '), '|') AS BK_CONTA,
    'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_CC, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
    'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SCP.CP_ITEMCTA, ' ')), ' '), '|') AS BK_ITEM_CONTABIL,
    'P |01|SBM010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SBM.BM_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_GRUPO, ' ')), ' '), '|') AS BK_GRUPO_ESTOQUE,
    
    case when trim(SB1.B1_COD) in ('14010070', '14010071', '14010027', '14010211', '14010215', '12040014', '14010069', '14010101', '14010422', '14010421', '14010028', '14010136', '14010167', '14010170', '14010248', '14010592', '14010512', '14010453', '14010587', '14010601', '14010164', '14010165', '14010195', '14010194', '14010193', '14010192', '14010600', '14010599', '14010598', '14010516', '14010203', '14010206', '14010209', '14010208', '14010207', '14010235', '14010233', '14010232', '14010231', '14010230', '14010229', '14010212', '14010466', '14010259', '14010257', '14010595', '14010594', '14010001', '12040013', '14010258', '14010217', '14010216', '14010605', '14010602', '14010423', '14010618', '14010617', '14010172', '14010249', '14010513', '14010687', '14010404', '14010406', '12040018', '14010527', '14010426', '14010715', '14010714', '14010400', '14010712', '14010531', '14010435', '14010434', '14010433', '14010514', '14010468', '14010405', '14010730', '14010731', '14010732', '14010741', '14010487', '14010958', '14010483', '14010758', '14010467', '14010504', '14010541', '14010528', '14010518', '14010559', '14010517', '14010540', '14010171', '14010812', '14010811', '14010826', '14010856', '14010672', '14010873', '14010887', '14010936', '14010515', '14010872', '14010962', '14010925', '14010975', '14010968', '14010894', '14010403')
        then '1401 içamento de materiais'
        else concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO))
    end as GRUPO,
    
    substring(SD3.D3_EMISSAO, 1, 6) as PERIODO,
    cast(SD3.D3_EMISSAO as date) as EMISSAO,
    case when substring(SD3.D3_OP, 7, 2) != 'OS' then left(SD3.D3_OP, 6) else null end as OP,
    case when substring(SD3.D3_OP, 7, 2) = 'OS' then left(SD3.D3_OP, 6) else null end as OS_MNT,
    SD3.D3_YOS as OS_PORT,
    SD3.D3_NUMSA as SA,
    SD3.D3_FILIAL as FILIAL,
    SD3.D3_LOCAL as ARMAZEM,
    SD3.D3_TM as TM,
    SD3.D3_CF as CF,
    SD3.D3_DOC as DOC,
    SD3.D3_NUMSEQ as SEQ,
    SD3.D3_ESTORNO as ESTORNO,
    trim(SD3.D3_CC) as CCUSTO,
    trim(SD3.D3_ITEMCTA) as ATIVIDADE,
    
    SD3.D3_QUANT as QTD,
    cast(SD3.D3_CUSTO1 as numeric(15, 2)) as CUSTO,
    case when SD3.D3_CF like 'R%' then 'SAI' when SD3.D3_CF like 'D%' then 'ENT' else 'NF' end as TIPO_MOV,
    SD3.D3_CONTA as CONTA_MOV,
    
    case
        when left(SD3.D3_CC, 1) = '3' then concat(trim(SB1.B1_YCTCUST), ' ',(select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTCUST))
        else concat(trim(SB1.B1_YCTDEAD), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTDEAD))
    end as LP_DEB
    
from SD3010 SD3 (nolock)
    inner join SB1010 SB1 (nolock)
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
        and CTT.CTT_FILIAL = SUBSTRING(SC7.C7_FILIAL, 1, 4)
        and CTT.CTT_CUSTO = SCP.CP_CC
    left join CTD010 CTD
        on CTD.D_E_L_E_T_ = ' '
        and CTD.CTD_FILIAL = '      '
        and CTD.CTD_ITEM = SCP.CP_ITEMCTA
where
        SD3.D_E_L_E_T_ = ''
    and SD3.D3_EMISSAO between <<START_DATE>> and <<FINAL_DATE>>
