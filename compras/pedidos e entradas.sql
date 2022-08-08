select
	trim(isnull(SC7.C7_FILIAL, '-')) as C7_FILIAL,
	trim(isnull(SC7.C7_NUM, '-')) as PEDIDO,
	trim(isnull(SC7.C7_ITEM, '-')) as ITEM,
	trim(isnull(SC7.C7_PRODUTO, '-')) as PRODUTO,
	trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
	trim(isnull(SC7.C7_OP, '-')) as C7_OP,
	trim(isnull(SC7.C7_CC, '-')) as C7_CC,
	trim(isnull(SC7.C7_ITEMCTA, '-')) as C7_ITEMCTA,
	trim(isnull(upper(SY1.Y1_NOME), '-')) as SOLICITANTE,
	trim(isnull(SB1.B1_GRUPO, '-')) as B1_GRUPO,
	
	trim(isnull(SC7.C7_OBS, '-')) as OBS,
	trim(isnull(SC7.C7_OBSM, '-')) as MEMO,
	
	case SC7.C7_CONAPRO
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as APROVAPEDIDO,
	
	SC7.C7_QUANT,
	SC7.C7_QUJE,
	SC7.C7_PRECO,
	SC7.C7_TOTAL,
	SC7.C7_VALIPI,
	SC7.C7_VALICM,

	convert(date, substring(SC7.C7_EMISSAO, 1 ,8), 103) as DATA_PEDIDO,

	trim(isnull(SD1.D1_DOC, '-')) as D1_DOC,
	trim(isnull(SD1.D1_SERIE, '-')) as D1_SERIE,
	trim(isnull(SD1.D1_ITEM, '-')) as D1_ITEM,
	trim(isnull(SD1.D1_TES, '-')) as D1_TES,

	SD1.D1_CC,
	SD1.D1_ITEMCTA,
	SD1.D1_LOCAL,

	SD1.D1_QUANT,
	SD1.D1_TOTAL,
	SD1.D1_CUSTO,
	SD1.D1_IPI,
	SD1.D1_VALIPI,
	SD1.D1_PICM,
	SD1.D1_VALICM,
	SD1.D1_DESC,
	SD1.D1_VALDESC,

	convert(date, substring(SD1.D1_DTDIGIT, 1 ,8), 103) as DATA_NF,

	SA2.A2_COD,
	SA2.A2_LOJA,
	SA2.A2_NOME,
	SA2.A2_NREDUZ,
	SA2.A2_CGC,

	datediff(day, SC7.C7_EMISSAO, SD1.D1_DTDIGIT) as DIAS_SC_PEDIDO,

	year(SC7.C7_EMISSAO) as ANO_PEDIDO,
	month(SC7.C7_EMISSAO) as MES_PEDIDO,
	substring(SC7.C7_EMISSAO, 1, 6) as PERIODO_PEDIDO,
	year(SD1.D1_DTDIGIT) as ANO_ENTRADA,
	month(SD1.D1_DTDIGIT) as MES_ENTRADA,
	substring(SD1.D1_DTDIGIT, 1, 6) as PERIODO_ENTRADA

from SC7010 SC7 (nolock)
	left join SB1010 SB1 (nolock)
		on SB1.D_E_L_E_T_ = ''
		and SB1.B1_COD = SC7.C7_PRODUTO
	inner join SA2010 SA2 (nolock)
		on SA2.D_E_L_E_T_ = ''
		and SA2.A2_COD = SC7.C7_FORNECE
		and SA2.A2_LOJA = SC7.C7_LOJA
	left join SY1010 SY1 (nolock)
		on SY1.D_E_L_E_T_ = ''
		and SY1.Y1_USER = SC7.C7_USER
	left join CTT010 CTT (nolock)
		on CTT.D_E_L_E_T_ = ''
		and CTT.CTT_CUSTO = SC7.C7_CC
	left join CTD010 CTD (nolock)
		on CTD.D_E_L_E_T_ = ''
		and CTD.CTD_ITEM = SC7.C7_ITEMCTA
	left join SD1010 SD1 (nolock)
		on SD1.D_E_L_E_T_ = ''
		and SD1.D1_FILIAL = SC7.C7_FILIAL
		and SD1.D1_PEDIDO = SC7.C7_NUM
		and SD1.D1_FORNECE = SC7.C7_FORNECE
		and SD1.D1_LOJA = SC7.C7_LOJA
		and SD1.D1_COD = SC7.C7_PRODUTO
where SC7.D_E_L_E_T_ = ''
