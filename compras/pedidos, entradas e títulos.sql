select
	trim(isnull(SC7.C7_FILIAL, '-')) as C7_FILIAL,
	trim(isnull(SC7.C7_NUM, '-')) as PEDIDO,
	trim(isnull(SC7.C7_ITEM, '-')) as ITEM,
	trim(isnull(SC7.C7_PRODUTO, '-')) as PRODUTO,
	trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
	SC7.C7_OP,
	SC7.C7_CC,
	SC7.C7_ITEMCTA,
	trim(isnull(upper(SY1.Y1_NOME), '-')) as SOLICITANTE,
	
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

	case SC7.C7_EMISSAO
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else convert(date, substring(SC7.C7_EMISSAO, 1 ,8), 103)
	end as DATA_PEDIDO,

	trim(isnull(SD1.D1_DOC, '-')) as DOC,
	trim(isnull(SD1.D1_SERIE, '-')) as SERIE,
	trim(isnull(SD1.D1_ITEM, '-')) as ITEM,
	trim(isnull(SD1.D1_TES, '-')) as TES,

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

	case SD1.D1_EMISSAO
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else convert(date, substring(SD1.D1_EMISSAO, 1 ,8), 103)
	end as DATA_NF,

	SA2.A2_COD,
	SA2.A2_LOJA,
	SA2.A2_NOME,
	SA2.A2_NREDUZ,
	SA2.A2_CGC,

	SE2.E2_NUM,
	SE2.E2_FORNECE,
	SE2.E2_LOJA,
	SE2.E2_TIPO,
	SE2.E2_PREFIXO,
	SE2.E2_PARCELA,
	SE2.E2_BAIXA,
	SE2.E2_VALOR,
	SE2.E2_VALLIQ,

	case SE2.E2_VENCTO
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else convert(date, substring(SE2.E2_VENCTO, 1 ,8), 103)
	end as VENCIMENTO,

	SE2.E2_MULTA,
	SE2.E2_DESCONT,
	SE2.E2_CORREC,
	SE2.E2_VALJUR,
	SE2.E2_IRRF,
	SE2.E2_INSS,
	SE2.E2_PIS,
	SE2.E2_COFINS,
	SE2.E2_CSLL,
	SE2.E2_ISS,

	year(SC7.C7_EMISSAO) as ANO_PEDIDO,
	month(SC7.C7_EMISSAO) as MES_PEDIDO,
	year(SD1.D1_EMISSAO) as ANO_ENTRADA,
	month(SD1.D1_EMISSAO) as MES_ENTRADA,
	year(SE2.E2_VENCTO) as ANO_VENCTO,
	month(SE2.E2_VENCTO) as MES_VENCTO

from SC7010 SC7 (nolock)
	left join SB1010 SB1 (nolock)
		on SB1.D_E_L_E_T_ = ''
		and SB1.B1_COD = SC7.C7_PRODUTO
	left join SA2010 SA2 (nolock)
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

		left join SE2010 SE2 (nolock)
			on SE2.D_E_L_E_T_ = ''
			and SE2.E2_FILIAL = SD1.D1_FILIAL
			and SE2.E2_NUM = SD1.D1_DOC
			and SE2.E2_FORNECE = SD1.D1_FORNECE
			and SE2.E2_LOJA = SD1.D1_LOJA
			and trim(SE2.E2_TIPO) = 'NF'
where SC7.D_E_L_E_T_ = ''
