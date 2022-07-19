select
	STL.TL_FILIAL,
	STL.TL_ORDEM,
    STJ.TJ_TERMINO,
    STJ.TJ_DTMRINI,
    STJ.TJ_DTMRFIM,
	convert(date, substring(STJ.TJ_DTORIGI, 1 ,8), 103) as TJ_DTORIGI,
	trim(isnull(STJ.TJ_CODBEM, '-')) as TJ_CODBEM,
	trim(isnull(STL.TL_CODIGO, '-')) as PRODUTO,
	trim(isnull(SCP.CP_DESCRI, '-')) as NOME_PRODUTO,

	trim(isnull(SCP.CP_OP, '-')) as CP_OP,
	trim(isnull(SCP.CP_NUM, '-')) as NUM_SA,
	trim(isnull(SCP.CP_ITEM, '-')) as ITEM_SA,
	trim(isnull(SCP.CP_PRODUTO, '-')) as COD_PRODUTO_SA,
	trim(isnull(SCP.CP_SOLICIT, '-')) as SOLICITANTE_SA,

	convert(date, substring(SCP.CP_DATPRF, 1 ,8), 103) as DATA_SA,

	trim(isnull(SC1.C1_OP, '-')) as C1_OP,
	trim(isnull(SC1.C1_NUM, '-')) as NUM_SC,
	trim(isnull(SC1.C1_ITEM, '-')) as ITEM_SC,
	trim(isnull(SC1.C1_PRODUTO, '-')) as COD_PRODUTO_SC,
	trim(isnull(SC1.C1_SOLICIT, '-')) as SOLICITANTE_SC,

	convert(date, substring(SC1.C1_EMISSAO, 1 ,8), 103) as DATA_SC,

	case SC1.C1_APROV
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as APROVASOLICIT,

    SC8.C8_NUM as COTACAO,

	trim(isnull(SC7.C7_OP, '-')) as C7_OP,
	trim(isnull(SC7.C7_NUM, '-')) as NUM_PC,
	trim(isnull(SC7.C7_ITEM, '-')) as ITEM_PC,
	trim(isnull(SC7.C7_PRODUTO, '-')) as COD_PRODUTO_PC,
	trim(isnull(SC7.C7_SOLICIT, '-')) as SOLICITANTE_PC,

	convert(date, substring(SC7.C7_EMISSAO, 1 ,8), 103) as DATA_PC,

	case SC7.C7_CONAPRO
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as APROVAPEDIDO,

	STL.TL_QUANREC,
	STL.TL_QUANTID,
	SCP.CP_QUANT,
	SCP.CP_QUJE,
	SC1.C1_QUANT,
	SC1.C1_QUJE,
	SC7.C7_QUANT,
	SC7.C7_QUJE,

	datediff(day, SCP.CP_DATPRF, SC1.C1_EMISSAO) as DIAS_SA_SC,
	datediff(day, SC1.C1_EMISSAO, SC7.C7_EMISSAO) as DIAS_SC_PEDIDO,

	trim(isnull(SC7.C7_FILIAL, '-')) as C7_FILIAL,
	trim(isnull(SC7.C7_NUM, '-')) as PEDIDO,
	trim(isnull(SC7.C7_ITEM, '-')) as ITEM,
	trim(isnull(SC7.C7_PRODUTO, '-')) as PRODUTO,
	trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
	trim(isnull(SC7.C7_OP, '-')) as C7_OP,
	trim(isnull(SC7.C7_CC, '-')) as C7_CC,
	trim(isnull(SC7.C7_ITEMCTA, '-')) as C7_ITEMCTA,
	trim(isnull(upper(SY1.Y1_NOME), '-')) as SOLICITANTE,
	
	SC7.C7_PRECO,
	SC7.C7_TOTAL,

	convert(date, substring(SC7.C7_EMISSAO, 1 ,8), 103) as DATA_PEDIDO,

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

	convert(date, substring(SD1.D1_DTDIGIT, 1 ,8), 103) as DATA_NF,

	SA2.A2_COD,
	SA2.A2_LOJA,
	SA2.A2_NOME,
	SA2.A2_NREDUZ,
	SA2.A2_CGC,

	datediff(day, SC7.C7_EMISSAO, SD1.D1_DTDIGIT) as DIAS_PEDIDO_CLASS,

	year(SC7.C7_EMISSAO) as ANO_PEDIDO,
	month(SC7.C7_EMISSAO) as MES_PEDIDO,
	year(SD1.D1_DTDIGIT) as ANO_ENTRADA,
	month(SD1.D1_DTDIGIT) as MES_ENTRADA,

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

	year(STJ.TJ_DTORIGI) as ANO_OS,
	month(STJ.TJ_DTORIGI) as MES_OS,
	year(STL.TL_DTINICI) as ANO_INI_SERVICO,
	month(STL.TL_DTINICI) as MES_INI_SERVICO,
	year(STL.TL_DTFIM) as ANO_FIM_SERVICO,
	month(STL.TL_DTFIM) as MES_FIM_SERVICO,

	year(SCP.CP_DATPRF) as ANO_SA,
	month(SCP.CP_DATPRF) as MES_SA,
	year(SCP.CP_EMISSAO) as ANO_SC,
	month(SCP.CP_EMISSAO) as MES_SC,
	year(SC7.C7_EMISSAO) as ANO_PEDIDO,
	month(SC7.C7_EMISSAO) as MES_PEDIDO,

	datediff(day, SD1.D1_DTDIGIT, STL.TL_DTINICI) as DIAS_CLASS_APP

from STL010 as STL (nolock)
	inner join STJ010 as STJ (nolock)
		on STJ.D_E_L_E_T_ = ''
		and STL.TL_ORDEM = STJ.TJ_ORDEM
		and STL.TL_PLANO = STJ.TJ_PLANO
		and STL.TL_FILIAL = STJ.TJ_FILIAL
	inner join SCP010 as SCP (nolock)
		on SCP.D_E_L_E_T_ = ''
		and STL.TL_FILIAL = SCP.CP_FILIAL
		and STL.TL_ORDEM = substring(SCP.CP_OP, 1, 6)
		and STL.TL_CODIGO = SCP.CP_PRODUTO

		left join SC1010 as SC1 (nolock)
			on SC1.D_E_L_E_T_ = ''
			and SC1.C1_FILIAL = SCP.CP_FILIAL
			and SC1.C1_OP = SCP.CP_OP
			and SC1.C1_PRODUTO = SCP.CP_PRODUTO

            left join SC8010 SC8 (nolock)
                on SC8.D_E_L_E_T_ = ''
                and SC8.C8_NUMSC = SC1.C1_NUM
                and SC8.C8_ITEMSC = SC1.C1_ITEM

			left join SC7010 as SC7 (nolock)
				on SC7.D_E_L_E_T_ = ''
				and SC7.C7_FILIAL = SC1.C1_FILIAL
				and SC7.C7_OP = SC1.C1_OP
				and SC7.C7_NUM = SC1.C1_PEDIDO
				and SC7.C7_PRODUTO = SC1.C1_PRODUTO

					left join SD1010 SD1 (nolock)
						on SD1.D_E_L_E_T_ = ''
						and SD1.D1_FILIAL = SC7.C7_FILIAL
						and SD1.D1_PEDIDO = SC7.C7_NUM
						and SD1.D1_FORNECE = SC7.C7_FORNECE
						and SD1.D1_LOJA = SC7.C7_LOJA
						and SD1.D1_COD = SC7.C7_PRODUTO
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
	left join SB1010 SB1 (nolock)
		on SB1.D_E_L_E_T_ = ''
		and SB1.B1_COD = SCP.CP_PRODUTO

where STL.D_E_L_E_T_ = ''