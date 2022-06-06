select
	trim(isnull(STJ.TJ_CODBEM, '-')) as TJ_CODBEM,
	convert(date, substring(STJ.TJ_DTORIGI, 1 ,8), 103) as TJ_DTORIGI,
	trim(isnull(STJ.TJ_TERMINO, '-')) as TJ_TERMINO,
	STL.TL_FILIAL,
	STL.TL_ORDEM,
	trim(isnull(STL.TL_CODIGO, '-')) as PRODUTO,
	STL.TL_QUANREC,
	STL.TL_QUANTID,

	convert(date, substring(STL.TL_DTINICI, 1 ,8), 103) as TL_DTINICI,
	convert(date, substring(STJ.TJ_DTPRFIM, 1, 8), 103) as TJ_DTPRFIM,

	year(STJ.TJ_DTORIGI) as ANO_OS,
	month(STJ.TJ_DTORIGI) as MES_OS,

	year(STJ.TJ_DTPRFIM) as ANO_PARADA,
	month(STJ.TJ_DTPRFIM) as MES_PARADA,

	year(STL.TL_DTINICI) as ANO_INI_APP,
	month(STL.TL_DTINICI) as MES_INI_APP,
	year(STL.TL_DTFIM) as ANO_FIM_APP,
	month(STL.TL_DTFIM) as MES_FIM_APP,

	case when year(APRSC1.CR_DATALIB) = 1900 then datediff(day, SC1.C1_EMISSAO, getdate()) else datediff(day, SC1.C1_EMISSAO, APRSC1.CR_DATALIB) end as DIAS_SC_APRSC,
	case when year(SC7.C7_EMISSAO) = 1900 then datediff(day, APRSC1.CR_DATALIB, getdate()) else datediff(day, APRSC1.CR_DATALIB, SC7.C7_EMISSAO) end as DIAS_APRSC_PC,

	trim(isnull(SC1.C1_OP, '-')) as C1_OP,
	trim(isnull(SC1.C1_NUM, '-')) as NUM_SC,
	trim(isnull(SC1.C1_ITEM, '-')) as ITEM_SC,
	trim(isnull(SC1.C1_PRODUTO, '-')) as COD_PRODUTO_SC,
	trim(isnull(SC1.C1_SOLICIT, '-')) as SOLICITANTE_SC,

	case SC1.C1_EMISSAO
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else convert(date, substring(SC1.C1_EMISSAO, 1 ,8), 103)
	end as DATA_SC,

	case SC1.C1_APROV
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as APROVASOLICIT,
	convert(date, substring(APRSC1.CR_DATALIB, 1, 8), 103) as DATAAPR_SC,

	SC1.C1_QUANT,
	SC1.C1_QUJE,

	case when year(APRSC7.CR_DATALIB) = 1900 then datediff(day, SC7.C7_EMISSAO, getdate()) else datediff(day, SC7.C7_EMISSAO, APRSC7.CR_DATALIB) end as DIAS_PC_APRPC,
	case when year(SD1.D1_DTDIGIT) = 1900 then datediff(day, APRSC7.CR_DATALIB, getdate()) else datediff(day, APRSC7.CR_DATALIB, SD1.D1_DTDIGIT) end as DIAS_APRPC_NF,

	trim(isnull(SC7.C7_OP, '-')) as C7_OP,
	trim(isnull(SC7.C7_NUM, '-')) as NUM_PC,
	trim(isnull(SC7.C7_ITEM, '-')) as ITEM_PC,
	trim(isnull(SC7.C7_PRODUTO, '-')) as PRODUTO_PC,
	trim(isnull(SC7.C7_SOLICIT, '-')) as SOLICITANTE_PC,
	trim(isnull(upper(SY1.Y1_NOME), '-')) as NOME_SOLICITANTE,
	trim(isnull(SC7.C7_FILIAL, '-')) as C7_FILIAL,
	trim(isnull(SC7.C7_CC, '-')) as C7_CC,
	trim(isnull(SC7.C7_ITEMCTA, '-')) as C7_ITEMCTA,

	case SC7.C7_EMISSAO
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else convert(date, substring(SC7.C7_EMISSAO, 1 ,8), 103)
	end as DATA_PC,

	case SC7.C7_CONAPRO
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as APROVAPEDIDO,
	convert(date, substring(APRSC7.CR_DATALIB, 1, 8), 103) as DATAAPR_PC,

	SC7.C7_QUANT,
	SC7.C7_QUJE,
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

	year(SC7.C7_EMISSAO) as ANO_PEDIDO,
	month(SC7.C7_EMISSAO) as MES_PEDIDO,

	case when cast(SC7.C7_QUJE as decimal) >= cast(SC7.C7_QUANT as decimal) then 'RECEBIDO' /* VERMELHO */
	else
		case when cast(SC7.C7_QUJE as decimal) != 0.0 and cast(SC7.C7_QUJE as decimal) < cast(SC7.C7_QUANT as decimal) then 'REC. PARCIAL' /* AMARELO */
		else
			case when cast(SC7.C7_QTDACLA as decimal) > 0.0 then 'PRÉ-NOTA' /* LARANJA */
			else
				case when trim(SC7.C7_CONAPRO) = 'B' and cast(SC7.C7_QUJE as decimal) < cast(SC7.C7_QUANT as decimal) then 'BLOQUEADO' /* AZUL */
				else 'NÃO COMPRADO'
				end
			end
		end
	end as STATUS_COMPRA,

	case when year(SC7.C7_EMISSAO) = 1900 then datediff(day, SC7.C7_EMISSAO, getdate()) else datediff(day, SC7.C7_EMISSAO, SD1.D1_DTDIGIT) end as DIAS_PEDIDO_NF,

	trim(isnull(SB1.B1_DESC, SC1.C1_DESCRI)) as NOMEPRODUTO,
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

	case SD1.D1_DTDIGIT
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else convert(date, substring(SD1.D1_DTDIGIT, 1 ,8), 103)
	end as DATA_NF,

	year(SD1.D1_DTDIGIT) as ANO_ENTRADA,
	month(SD1.D1_DTDIGIT) as MES_ENTRADA,

	case when year(SD1.D1_DTDIGIT) = 1900 then datediff(day, SC1.C1_EMISSAO, getdate()) else datediff(day, SC1.C1_EMISSAO, SD1.D1_DTDIGIT) end as TEMPODECOMPRA,
	case when year(STL.TL_DTINICI) = 1900 then datediff(day, SD1.D1_DTDIGIT, getdate()) else datediff(day, SD1.D1_DTDIGIT, STL.TL_DTINICI) end as TEMPOEMESTOQUE,
	case when year(STJ.TJ_DTPRFIM) = 1900 then datediff(day, STJ.TJ_DTORIGI, getdate()) else datediff(day, SD1.D1_DTDIGIT, STJ.TJ_DTPRFIM) end as TEMPOMNT2,

	SA2.A2_COD,
	SA2.A2_LOJA,
	SA2.A2_NOME,
	SA2.A2_NREDUZ,
	SA2.A2_CGC

from STJ010 as STJ (nolock)
	inner join STL010 as STL (nolock)
		on STL.D_E_L_E_T_ = ''
		and cast(STL.TL_SEQRELA as int) > 0
		and STL.TL_ORDEM = STJ.TJ_ORDEM
		and STL.TL_PLANO = STJ.TJ_PLANO
		and STL.TL_FILIAL = STJ.TJ_FILIAL

		and year(STL.TL_DTINICI) = 2022

		inner join SD1010 SD1 (nolock)
			on SD1.D_E_L_E_T_ = ''
			and SD1.D1_DOC = STL.TL_DOC
			and SD1.D1_SERIE = STL.TL_SERIE
			and SD1.D1_FORNECE = STL.TL_FORNEC
			and SD1.D1_LOJA = STL.TL_LOJA
			and substring(SD1.D1_OP, 1, 6) = STL.TL_ORDEM

			inner join SC7010 as SC7 (nolock)
				on SC7.D_E_L_E_T_ = ''
				and SC7.C7_NUM = SD1.D1_PEDIDO
				and SC7.C7_ITEM = SD1.D1_ITEMPC
				and SC7.C7_FORNECE = SD1.D1_FORNECE
				and SC7.C7_LOJA = SD1.D1_LOJA
				and SC7.C7_PRODUTO = SD1.D1_COD

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
				left join SCR010 APRSC7 (nolock)
					on APRSC7.D_E_L_E_T_ = ''
					and APRSC7.CR_NUM = SC7.C7_NUM
				inner join SC1010 as SC1 (nolock)
					on SC1.D_E_L_E_T_ = ''
					and SC1.C1_NUM = SC7.C7_NUMSC
					and SC1.C1_ITEM = SC7.C7_ITEMSC
					and SC1.C1_PRODUTO = SC7.C7_PRODUTO
					and SC1.C1_FORNECE = SC7.C7_FORNECE
					and SC1.C1_LOJA = SC7.C7_LOJA

					left join SCR010 APRSC1 (nolock)
						on APRSC1.D_E_L_E_T_ = ''
						and APRSC1.CR_NUM = SC1.C1_NUM
					left join CTT010 CTT (nolock)
						on CTT.D_E_L_E_T_ = ''
						and CTT.CTT_CUSTO = SC1.C1_CC
					left join CTD010 CTD (nolock)
						on CTD.D_E_L_E_T_ = ''
						and CTD.CTD_ITEM = SC1.C1_ITEMCTA
where
		STJ.D_E_L_E_T_ = ''
