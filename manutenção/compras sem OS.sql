select
	trim(isnull(SC1.C1_FILIAL, '-')) as FILIAL,
	substring(SC7.C7_OP, 1, 6) as OS,
	trim(isnull(SC1.C1_NUM, '-')) as SOLICITACAO,
	trim(isnull(SC1.C1_ITEM, '-')) as ITEM_SC,
	trim(isnull(SC7.C7_NUM, '-')) as PEDIDO,
	trim(isnull(SC7.C7_ITEM, '-')) as ITEM_PC,
	trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
	trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
	trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
	trim(isnull(SC7.C7_FORNECE, '-')) as FORNECEDOR,
	trim(isnull(SC7.C7_LOJA, '-')) as LOJA,
	trim(isnull(SA2.A2_NOME, '-')) as NOME_FORNECEDOR,
	trim(isnull(SA2.A2_NREDUZ, '-')) as NOMERED_FORNECEDOR,
	trim(isnull(SA2.A2_CGC, '-')) as CNPJ,

	trim(isnull(CTD.CTD_DESC01, '-')) as ATIVIDADE,
	trim(isnull(CTT.CTT_DESC01, '-')) as CC,

	convert(date, SC1.C1_EMISSAO, 103) as DATA_SOLICITA,
	substring(SC1.C1_EMISSAO, 1, 6) as PERIODO_SC,
	trim(isnull(upper(SC1.C1_SOLICIT), '-')) as SOLIC_SC,
	
	case SC7.C7_CONAPRO
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as APROVACAO,

	convert(date, SC7.C7_EMISSAO, 103) as DATA_PEDIDO,
	substring(SC7.C7_EMISSAO, 1, 6) as PERIODO_PC,
	trim(isnull(upper(SY1.Y1_NOME), '-')) as SOLIC_PC,

	SC7.C7_QUANT as QTD_PEDIDA,
	SC7.C7_QUJE as QTD_ENTREGUE,
	SC7.C7_PRECO,
	SC7.C7_TOTAL,
	trim(isnull(SC7.C7_OBS, '-')) as OBS,
	trim(isnull(SC7.C7_OBSM, '-')) as MEMO,

	case when trim(SC7.C7_CONAPRO) = 'B' and (cast(SC7.C7_QUJE as numeric(15, 2)) < cast(SC7.C7_QUANT as numeric(15, 2))) then 'BLOQUEADO' /* AZUL */
	else
		case when cast(SC7.C7_QTDACLA as numeric(15, 2)) > 0.0 then 'PRÉ-NOTA' /* LARANJA */
		else
			case when cast(SC7.C7_TIPO as int) = 1 and SC7.C7_RESIDUO = '' then 'APROVADO' /* VERDE */
			else
				case when cast(SC7.C7_QUJE as numeric(15, 2)) != 0.0 and (cast(SC7.C7_QUJE as numeric(15, 2)) < cast(SC7.C7_QUANT as numeric(15, 2))) then 'REC. PARCIAL' /* AMARELO */
				else
					case when cast(SC7.C7_QUJE as numeric(15, 2)) >= cast(SC7.C7_QUANT as numeric(15, 2)) then 'RECEBIDO' /* VERMELHO */
					else
						case when trim(SC7.C7_RESIDUO) = 'S' then 'ELIMINAÇÃO DE RESÍDUO' /* CINZA */
						else 'OUTROS'
						end
					end
				end
			end
		end
	end as STATUS_COMPRA,

	trim(isnull(SD1.D1_DOC, '-')) as D1_DOC,
	trim(isnull(SD1.D1_SERIE, '-')) as D1_SERIE,
	convert(date, SD1.D1_DTDIGIT, 103) DATA_EMINF,
	convert(date, SD1.D1_DTDIGIT, 103) DATA_NF

from SC1010 SC1 (nolock)
	left join SB1010 SB1 (nolock)
		on SB1.D_E_L_E_T_ = ''
		and SB1.B1_COD = SC1.C1_PRODUTO
		and SB1.B1_GRUPO like '1%'
	left join SC7010 SC7 (nolock)
		on SC7.D_E_L_E_T_ = ''
		and SC7.C7_FILIAL = SC1.C1_FILIAL
		and SC7.C7_PRODUTO = SC1.C1_PRODUTO
		and SC7.C7_NUMSC = SC1.C1_NUM
		and SC7.C7_ITEMSC = SC1.C1_ITEM

		left join SA2010 SA2 (nolock)
			on SA2.D_E_L_E_T_ = ''
			and SA2.A2_COD = SC7.C7_FORNECE
			and SA2.A2_LOJA = SC7.C7_LOJA
		left join SD1010 SD1 (nolock)
			on SD1.D_E_L_E_T_ = ''
			and SD1.D1_FILIAL = SC7.C7_FILIAL
			and SD1.D1_COD = SC7.C7_PRODUTO
			and SD1.D1_FORNECE = SC7.C7_FORNECE
			and SD1.D1_LOJA = SC7.C7_LOJA
			and SD1.D1_PEDIDO = SC7.C7_NUM
		left join SY1010 SY1 (nolock)
			on SY1.D_E_L_E_T_ = ''
			and SY1.Y1_USER = SC7.C7_USER

	left join CTT010 CTT (nolock)
		on CTT.D_E_L_E_T_ = ''
		and CTT.CTT_CUSTO = SC1.C1_CC
	left join CTD010 CTD (nolock)
		on CTD.D_E_L_E_T_ = ''
		and CTD.CTD_ITEM = SC1.C1_ITEMCTA
where
		SC1.D_E_L_E_T_ = ''
