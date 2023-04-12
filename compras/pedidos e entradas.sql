select
	trim(isnull(SC7.C7_FILIAL, '-')) as FILIAL,
	substring(SC1.C1_OP, 1, 6) as OS,
	trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
	trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
	trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
	trim(isnull(SB1.B1_UM, '-')) as UN,

	trim(isnull(CTD.CTD_DESC01, '-')) as ATIVIDADE,
	trim(isnull(CTT.CTT_DESC01, '-')) as CCUSTO,
	trim(isnull(SC7.C7_ITEMCTA, '-')) as AT,
	trim(isnull(SC7.C7_CC, '-')) as CC,

	trim(isnull(SC1.C1_NUM, '-')) as SC,
	trim(isnull(SC1.C1_ITEM, '-')) as ITEM_SC,
	convert(date, SC1.C1_EMISSAO, 103) as DATA_SC,
	substring(SC1.C1_EMISSAO, 1, 6) as PERIODO_SC,
	trim(isnull(upper(SC1.C1_SOLICIT), '-')) as SOLICITANTE_SC,
	trim(isnull(SC1.C1_OBS, '-')) as OBS_SC,

	SC1.C1_QUANT as QTD_SC_PEDIDA,
	SC1.C1_QUJE as QTD_SC_ATENDIDA,

	case SC1.C1_APROV
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as SITAPR_SC,

	/*case when year(APRSC1.CR_DATALIB) = 1900 then datediff(day, SC1.C1_EMISSAO, getdate()) else datediff(day, SC1.C1_EMISSAO, APRSC1.CR_DATALIB) end as DIAS_SC_APRSC,*/

	(select top 1 convert(date, SCR010.CR_DATALIB, 103) from SCR010 where SCR010.D_E_L_E_T_ = '' and SCR010.CR_LIBAPRO is not null and SCR010.CR_TIPO = 'SC' and SCR010.CR_NUM = SC1.C1_NUM) as DATAAPROV_SC,
	datediff(day, SC1.C1_EMISSAO, (select top 1 convert(date, SCR010.CR_DATALIB, 103) from SCR010 where SCR010.D_E_L_E_T_ = '' and SCR010.CR_LIBAPRO is not null and SCR010.CR_TIPO = 'SC' and SCR010.CR_NUM = SC1.C1_NUM)) as DIASAPROV_SC,

	SC8.C8_NUM as COTACAO,
    SC8.C8_ITEM as ITEM_COTA,
	SC8.C8_QUANT as QTD_COTADA,
	SC8.C8_PRECO as PRECO_COTADO,
	SC8.C8_TOTAL as VALOR_COTADO,
	convert(date, SC8.C8_EMISSAO, 103) as DATA_COTACAO,
	datediff(day, (select top 1 convert(date, SCR010.CR_DATALIB, 103) from SCR010 where SCR010.D_E_L_E_T_ = '' and SCR010.CR_LIBAPRO is not null and SCR010.CR_TIPO = 'SC' and SCR010.CR_NUM = SC1.C1_NUM), SC7.C7_EMISSAO) as DIASAPROV_SC_CO,

	/*case when year(SC7.C7_EMISSAO) = 1900 then datediff(day, APRSC1.CR_DATALIB, getdate()) else datediff(day, APRSC1.CR_DATALIB, SC7.C7_EMISSAO) end as DIAS_APRSC_PC,*/


	trim(isnull(SC7.C7_NUM, '-')) as PEDIDO,
	trim(isnull(SC7.C7_ITEM, '-')) as ITEM_PC,
	trim(isnull(SC7.C7_FORNECE, '-')) as FORNECEDOR,
	trim(isnull(SC7.C7_LOJA, '-')) as LOJA,
	trim(isnull(SA2.A2_NOME, '-')) as NOME_FORNECEDOR,
	trim(isnull(SA2.A2_NREDUZ, '-')) as NOMERED_FORNECEDOR,
	trim(isnull(SA2.A2_CGC, '-')) as CNPJ,
	trim(isnull(SC7.C7_OBS, '-')) as OBS_PC,
	trim(isnull(SC7.C7_OBSM, '-')) as MEMO_PC,

	convert(date, SC7.C7_EMISSAO, 103) as DATA_PEDIDO,
	substring(SC7.C7_EMISSAO, 1, 6) as PERIODO_PC,
	trim(isnull(upper(SY1.Y1_NOME), '-')) as SOLICITANTE_PC,

	case SC7.C7_CONAPRO
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as APROVACAO_PC,

	/*case when year(APRSC7.CR_DATALIB) = 1900 then datediff(day, SC7.C7_EMISSAO, getdate()) else datediff(day, SC7.C7_EMISSAO, APRSC7.CR_DATALIB) end as DIAS_PC_APRPC,*/

	(select top 1 convert(date, SCR010.CR_DATALIB, 103) from SCR010 where SCR010.D_E_L_E_T_ = '' and SCR010.CR_LIBAPRO is not null and SCR010.CR_TIPO = 'PC' and SCR010.CR_NUM = SC7.C7_NUM) as DATAAPROV_PC,
	datediff(day, SC7.C7_EMISSAO, (select top 1 convert(date, SCR010.CR_DATALIB, 103) from SCR010 where SCR010.D_E_L_E_T_ = '' and SCR010.CR_LIBAPRO is not null and SCR010.CR_TIPO = 'PC' and SCR010.CR_NUM = SC7.C7_NUM)) as DIASAPROV_PC,

	SC7.C7_COND as COND,
	trim(SE4.E4_DESCRI) as CONDPGTO,
	SC7.C7_QUANT as QTD_PC_PEDIDA,
	SC7.C7_QUJE as QTD_PC_ATENDIDA,
	SC7.C7_PRECO as PC_PRECO,
	SC7.C7_TOTAL as PC_TOTAL,

	year(SC1.C1_EMISSAO) as ANO_SOLICITA,
	month(SC1.C1_EMISSAO) as MES_SOLICITA,

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

	SD1.D1_DOC as NF_DOC,
	SD1.D1_SERIE as NF_SERIE,
	convert(datetime, SD1.D1_EMISSAO, 103) as NF_EMI,
	convert(datetime, SD1.D1_DTDIGIT, 103) as NF_DATA,
	datediff(day, (select top 1 convert(date, SCR010.CR_DATALIB, 103) from SCR010 where SCR010.D_E_L_E_T_ = '' and SCR010.CR_LIBAPRO is not null and SCR010.CR_TIPO = 'PC' and SCR010.CR_NUM = SC7.C7_NUM), SD1.D1_DTDIGIT) as DIASAPROV_PC_NF,
	SD1.D1_QUANT NF_QUANT,
	SD1.D1_VUNIT NF_VUNIT,
	SD1.D1_TOTAL NF_TOTAL,
	SD1.D1_TES NF_TES,
	SD1.D1_CUSTO NF_CUSTO,
	SD1.D1_QTDPEDI as NF_QTDPEDI,
	SD1.D1_VALDESC as NF_VALDESC,
	SD1.D1_VALFRE as NF_VALFRE,
	SD1.D1_SEGURO as NF_SEGURO,
	SD1.D1_DESPESA as NF_DESPESA

from SC7010 SC7 (nolock)
	left join SC8010 SC8 (nolock)
		on SC8.D_E_L_E_T_ = ''
		and SC8.C8_FILIAL = SC7.C7_FILIAL
		and SC8.C8_NUM = SC7.C7_NUM
		and SC8.C8_ITEM = SC7.C7_ITEM

		left join SC1010 SC1 (nolock)
			on SC1.D_E_L_E_T_ = ''
			and isnull(SC8.C8_FILIAL, SC7.C7_FILIAL) = SC1.C1_FILIAL
			and isnull(SC8.C8_NUMSC, SC7.C7_NUMSC) = SC1.C1_NUM
			and isnull(SC8.C8_ITEMSC, SC7.C7_ITEMSC) = SC1.C1_ITEM

	left join SB1010 SB1 (nolock)
		on SB1.D_E_L_E_T_ = ''
		and SB1.B1_COD = SC7.C7_PRODUTO

		inner join SBM010 SBM (nolock)
			on SBM.D_E_L_E_T_ = ''
			and SBM.BM_GRUPO = SB1.B1_GRUPO

	inner join SA2010 SA2 (nolock)
		on SA2.D_E_L_E_T_ = ''
		and SA2.A2_COD = SC7.C7_FORNECE
		and SA2.A2_LOJA = SC7.C7_LOJA
	left join SE4010 SE4 (nolock)
		on SE4.D_E_L_E_T_ = ''
		and SE4.E4_CODIGO = SC7.C7_COND
	left join SY1010 SY1 (nolock)
		on SY1.Y1_USER = SC7.C7_USER
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
		and SD1.D1_ITEMPC = SC7.C7_ITEM
where SC7.D_E_L_E_T_ = ''
