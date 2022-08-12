select
    SD3.D3_FILIAL,
    SD3.D3_CC,
    SD3.D3_LOCAL,
    SD3.D3_GRUPO,
    SD3.D3_COD,
	trim(isnull(SB1.B1_DESC, '-')) as B1_DESC,
    SD3.D3_TM + ' - ' + SF5.F5_TEXTO as D3_TM,
    SD3.D3_DOC,
    substring(SD3.D3_OP, 1, 6) as D3_OP

from SD3010 SD3 (nolock)
	inner join SB1010 SB1 (nolock)
		on SB1.D_E_L_E_T_ = ''
		and SB1.B1_COD = SD3.D3_COD
    inner join SF5010 SF5 (nolock)
        on SF5.D_E_L_E_T_ = ''
        and SF5.F5_CODIGO = SD3.D3_TM
where
        SD3.D_E_L_E_T_ = ''
    and SD3.D3_LOCAL = '01'
