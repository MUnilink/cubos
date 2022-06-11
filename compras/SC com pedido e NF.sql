select
	trim(isnull(SC7.C7_FILIAL, '-')) as C7_FILIAL,
	trim(isnull(SC7.C7_NUM, '-')) as PEDIDO,
	trim(isnull(SC7.C7_ITEM, '-')) as ITEM,
	trim(isnull(SC7.C7_PRODUTO, '-')) as COD_PRODUTO,
	trim(isnull(SB1.B1_DESC, '-')) as PRODUTO,
	trim(isnull(SC7.C7_FORNECE, '-')) as FORNECEDOR,
	trim(isnull(SC7.C7_LOJA, '-')) as LOJA,
	trim(isnull(SA2.A2_NOME, '-')) as NOME_FORNECEDOR,
	trim(isnull(SA2.A2_NREDUZ, '-')) as NOMERED_FORNECEDOR,
	trim(isnull(SB1.B1_GRUPO, '-')) as B1_GRUPO,

	substring(SC1.C1_OP, 1, 6) as OS,
	trim(isnull(SC1.C1_NUM, '-')) as SOLICITACAO,
	trim(isnull(CTD.CTD_DESC01, '-')) as ATIVIDADE,
	trim(isnull(CTT.CTT_DESC01, '-')) as CENTRO_CUSTO,
	trim(isnull(upper(SY1.Y1_NOME), '-')) as SOLICITANTE,
	
	case SC7.C7_CONAPRO
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as APROVACAO,

	SC7.C7_QUANT,
	SC7.C7_QUJE,
	SC7.C7_PRECO,
	SC7.C7_TOTAL,

	case SC7.C7_EMISSAO
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else cast(convert(date, substring(SC7.C7_EMISSAO, 1 ,8), 103) as varchar)
	end as DATA_EMISSAO,

	year(SC7.C7_EMISSAO) as ANO_PEDIDO,
	month(SC7.C7_EMISSAO) as MES_PEDIDO,

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
	
 	case when cast(SC7.C7_QUJE as numeric(15, 2)) >= cast(SC7.C7_QUANT as numeric(15, 2)) then 'RECEBIDO' /* VERMELHO */
	else
		case when cast(SC7.C7_QUJE as numeric(15, 2)) != 0.0 and cast(SC7.C7_QUJE as numeric(15, 2)) < cast(SC7.C7_QUANT as numeric(15, 2)) then 'REC. PARCIAL' /* AMARELO */
		else
			case when cast(SC7.C7_QTDACLA as numeric(15, 2)) > 0.0 then 'PRÉ-NOTA' /* LARANJA */
			else
				case when trim(SC7.C7_CONAPRO) = 'B' and cast(SC7.C7_QUJE as numeric(15, 2)) < cast(SC7.C7_QUANT as numeric(15, 2)) then 'BLOQUEADO' /* AZUL */
				else 'OUTROS'
				end
			end
		end
	end as STATUS_COMPRA

from SC7010 SC7 (nolock)
	left join SB1010 SB1 (nolock)
		on SB1.D_E_L_E_T_ = ''
		and SB1.B1_COD = SC7.C7_PRODUTO*+03120
	left join SY1010 SY1 (nolock)
		on SY1.D_E_L_E_T_ = ''
		and SY1.Y1_USER = SC7.C7_USER
	left join CTT010 CTT (nolock)
		on CTT.D_E_L_E_T_ = ''
		and CTT.CTT_CUSTO = SC7.C7_CC
	left join CTD010 CTD (nolock)
		on CTD.D_E_L_E_T_ = ''
		and CTD.CTD_ITEM = SC7.C7_ITEMCTA
	left join SA2010 SA2 (nolock)
		on SA2.D_E_L_E_T_ = ''
		and SA2.A2_COD = SC7.C7_FORNECE
		and SA2.A2_LOJA = SC7.C7_LOJA
	left join SC1010 SC1 (nolock)
		on SC1.D_E_L_E_T_ = ''
		and SC1.C1_FILIAL = SC7.C7_FILIAL
		and SC1.C1_PRODUTO = SC7.C7_PRODUTO
		and SC1.C1_NUM = SC7.C7_NUMSC
		and SC1.C1_ITEM = SC7.C7_ITEMSC
where SC7.D_E_L_E_T_ = ''