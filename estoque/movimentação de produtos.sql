select
    SB1.B1_COD as contador,
    trim(SB1.B1_COD) as PRODUTO,
    trim(SB1.B1_DESC) as NOMEPRODUTO,
    trim(SB1.B1_UM) as UN,
    
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
    
    case
        when left(SD3.D3_CC, 1) = '3' then concat(trim(SB1.B1_YCTCUST), ' ',(select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTCUST))
        else concat(trim(SB1.B1_YCTDEAD), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTDEAD))
    end as LP_DEB
    
from SD3010 SD3 (nolock)
    inner join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SD3.D3_COD
        and SB1.B1_GRUPO like '1%'
where
        SD3.D_E_L_E_T_ = ''
