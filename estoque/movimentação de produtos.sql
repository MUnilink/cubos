select
    SB1.B1_COD as contador,
    trim(SB1.B1_COD) as PRODUTO,
    trim(SB1.B1_DESC) as NOMEPRODUTO,
    concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO)) as GRUPO,
    trim(SB1.B1_UM) as UN,
    
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
    and left(SD3.D3_EMISSAO, 6) =:PERIODO
