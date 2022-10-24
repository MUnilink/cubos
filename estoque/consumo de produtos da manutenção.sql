select
    SD3.D3_FILIAL,
    substring(SD3.D3_EMISSAO, 1, 6) as PERIODO,
    SD3.D3_LOCAL,
    trim(SD3.D3_TM) as TES,
    trim(SD3.D3_DOC) as D3_DOC,
    trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
	trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
	trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
	trim(isnull(SB1.B1_UM, '-')) as UN,
    isnull(SB1.B1_UPRC, '-') as ULT_PRECO,
    case when SB9.B9_QINI = 0 then 0.0 else SB9.B9_VINI1/SB9.B9_QINI end as B9_CM,
    trim(isnull(SCP.CP_NUM, '-')) as CP_NUM,
    isnull(SCP.CP_ITEM, '-') as CP_ITEM
from SD3010 SD3 (nolock)
    inner join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SD3.D3_COD
        and SB1.B1_GRUPO is not null
    left join SCP010 SCP (nolock)
        on SCP.D_E_L_E_T_ = ''
        and SCP.CP_FILIAL = SD3.D3_FILIAL
        and SCP.CP_NUM = SD3.D3_NUMSA
        and SCP.CP_ITEM = SD3.D3_ITEMSA
    left join SB9010 SB9 (nolock)
        on SB9.D_E_L_E_T_ = ''
        and SB9.B9_DATA = eomonth(SD3.D3_EMISSAO)
        and SB9.B9_FILIAL = SD3.D3_FILIAL
        and SB9.B9_LOCAL = SD3.D3_LOCAL
        and SB9.B9_COD = SD3.D3_COD
where SD3.D_E_L_E_T_ = ''
    and SD3.D3_CF not in ('RE3', 'RE4', 'RE7', 'RE8', 'DE3', 'DE4', 'DE7', 'DE8')
