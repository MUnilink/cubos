select
    substring(SD3.D3_EMISSAO, 1, 6) as PERIODO,
    trim(SD3.D3_TM) as TES,
    trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
	trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
	trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
	trim(isnull(SB1.B1_UM, '-')) as UN,
from SD3010 SD3 (nolock)
    inner join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SD3.D3_COD
    left join SCP010 (nolock)
        on SCP010.D_E_L_E_T_ = ''
        and SCP010.
    left join SDB010 (nolock)

where SD3.D_E_L_E_T_ = ''
    and SD3.D3_CF not in ('RE3', 'RE4', 'RE7', 'RE8', 'DE3', 'DE4', 'DE7', 'DE8')
