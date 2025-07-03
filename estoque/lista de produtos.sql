select
    concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO)) as GRUPO,
    trim(SB1.B1_COD) as PRODUTO,
    trim(SB1.B1_COD) as contador,
    cast(SB1.B1_DATREF as date) as DATA_CRI,
    cast(SB1.B1_CONINI as date) as DATA_INI,
    cast(SB1.B1_UCOM as date) as DATA_COM,
    case SB1.B1_MSBLQL when 1 then 'S' else 'N' end as BLOQUEADO,
    trim(SB1.B1_DESC) as DESCRICAO,
    trim(SB1.B1_UM) as UN,
    trim(SB1.B1_SEGUM) as UN_2,
    trim(SB1.B1_LOCPAD) as ARMAZEM,
    cast(SB1.B1_UPRC as numeric(15, 2)) as ULT_PRECO,
    trim(SB1.B1_YDESCRI) as DESC_FROTA,
    trim(SB1.B1_YMARCA) as OP_MARCA,
    trim(SB1.B1_YPARTNU) as PARTNUMBER,

    case SB1.D_E_L_E_T_ when '*' then 'S' else 'N' end as EXCLUIDO
from SB1010 SB1 (nolock)
