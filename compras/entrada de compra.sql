select
	trim(isnull(SD1.D1_FILIAL, '-')) as D1_FILIAL,
	trim(isnull(SD1.D1_DOC, '-')) as DOC,
	trim(isnull(SD1.D1_SERIE, '-')) as SERIE,
	trim(isnull(SD1.D1_ITEM, '-')) as ITEM,
	trim(isnull(SD1.D1_TES, '-')) as TES,
	trim(isnull(SF4.F4_TIPO, '-')) + ' - ' + trim(isnull(SF4.F4_TEXTO, '-')) as DESC_TES,
	trim(isnull(SD1.D1_COD, '-')) as PRODUTO,
	trim(isnull(SB1.B1_DESC, '-')) as DESC_PRODUTO,
	SD1.D1_CC,
	SD1.D1_ITEMCTA,
	SD1.D1_QUANT,
	SD1.D1_TOTAL,
	SD1.D1_CUSTO,
	SD1.D1_VALDESC,
	SD1.D1_LOCAL,

	SB2.B2_CM1,

	case SD1.D1_EMISSAO
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else cast(convert(date, substring(SD1.D1_EMISSAO, 1 ,8), 103) as varchar)
	end as DATA_ENTRADA,

	year(SD1.D1_EMISSAO) as ANO_ENTRADA,
	month(SD1.D1_EMISSAO) as MES_ENTRADA

from SD1010 SD1 (nolock)
	left join SB2010 SB2 (nolock)
		on SB2.D_E_L_E_T_ = ''
		and SB2.B2_FILIAL = SD1.D1_FILIAL
		and SB2.B2_COD = SD1.D1_COD
		and SB2.B2_LOCAL = SD1.D1_LOCAL
	left join SB1010 SB1 (nolock)
		on SB1.D_E_L_E_T_ = ''
		and SB1.B1_COD = SD1.D1_COD
	left join CTT010 CTT (nolock)
		on CTT.D_E_L_E_T_ = ''
		and CTT.CTT_CUSTO = SD1.D1_CC
	left join CTD010 CTD (nolock)
		on CTD.D_E_L_E_T_ = ''
		and CTD.CTD_ITEM = SD1.D1_ITEMCTA
	left join SF4010 SF4 (nolock)
		on SF4.D_E_L_E_T_ = ''
		and SF4.F4_CODIGO = SD1.D1_TES
where SD1.D_E_L_E_T_ = ''