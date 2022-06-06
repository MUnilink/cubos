select distinct
	STJ.TJ_FILIAL,
	trim(isnull(STJ.TJ_CODBEM, '-')) as TJ_CODBEM,
	STJ.TJ_SERVICO,
	STJ.TJ_ORDEM,
	STJ.TJ_DTORIGI,
	trim(isnull(STJ.TJ_TERMINO, '-')) as TJ_TERMINO,
	case when STL.TL_SEQRELA = 0 then null else STL.TL_DTINICI end as TL_DTINICI,
	STJ.TJ_DTPRFIM,

	STL.TL_CODIGO,

	SCP.CP_LOCAL,
	trim(isnull(SCP.CP_NUM, '-')) as NUM_SA,
	trim(SCP.CP_ITEM) as ITEM_SA,
	trim(isnull(SCP.CP_SOLICIT, '-')) as SOLICITANTE_SA,
	SCP.CP_DATPRF,

	case when SCP.CP_QUJE = 0 then 'PENDENTE'
	else
		case when SCP.CP_QUANT = SCP.CP_QUJE then 'TOT. ATENDIDA'
		else 'PAR. ATENDIDA'
		end
	end as STATUS_SA,

	case when year(SCP.CP_DATPRF) = 1900 then datediff(day, STJ.TJ_DTORIGI, getdate()) else datediff(day, STJ.TJ_DTORIGI, SCP.CP_DATPRF) end as DIAS_INIMNT_SA,
	case when year(SC1.C1_EMISSAO) = 1900 then datediff(day, SCP.CP_DATPRF, getdate()) else datediff(day, SCP.CP_DATPRF, SC1.C1_EMISSAO) end as DIAS_SA_SC,
	case when year(APRSC1.CR_DATALIB) = 1900 then datediff(day, SC1.C1_EMISSAO, getdate()) else datediff(day, SC1.C1_EMISSAO, APRSC1.CR_DATALIB) end as DIAS_SC_APRSC,
	case when year(SC7.C7_EMISSAO) = 1900 then datediff(day, APRSC1.CR_DATALIB, getdate()) else datediff(day, APRSC1.CR_DATALIB, SC7.C7_EMISSAO) end as DIAS_APRSC_PC,

	trim(isnull(SC1.C1_NUM, '-')) as NUM_SC,
	trim(SC1.C1_ITEM) as ITEM_SC,
	trim(isnull(SC1.C1_SOLICIT, '-')) as SOLICITANTE_SC,
	SC1.C1_EMISSAO,
	case SC1.C1_APROV
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as SITAPR_SC,

	NOMEAPRSC1.AK_LOGIN as APROVA_SC,
	APRSC1.CR_DATALIB as DATAAPR_SC,

	case when year(APRSC7.CR_DATALIB) = 1900 then datediff(day, SC7.C7_EMISSAO, getdate()) else datediff(day, SC7.C7_EMISSAO, APRSC7.CR_DATALIB) end as DIAS_PC_APRPC,
	case when year(SD1.D1_DTDIGIT) = 1900 then datediff(day, APRSC7.CR_DATALIB, getdate()) else datediff(day, APRSC7.CR_DATALIB, SD1.D1_DTDIGIT) end as DIAS_APRPC_NF,

	trim(isnull(SC7.C7_NUM, '-')) as NUM_PC,
	trim(SC7.C7_ITEM) as ITEM_PC,

	trim(isnull(SY1.Y1_NOME, '-')) as SOLICITANTE_PC,
	
	SC7.C7_EMISSAO,
	case SC7.C7_CONAPRO
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as SITAPR_PC,

	NOMEAPRSC7.AK_LOGIN as APROVA_PC,
	APRSC7.CR_DATALIB as DATAAPR_PC,

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
	end as STATUS_PC,

	trim(isnull(SD1.D1_DOC, '-')) as D1_DOC,
	trim(isnull(SD1.D1_SERIE, '-')) as D1_SERIE,
	SD1.D1_EMISSAO,
	SD1.D1_DTDIGIT as DATA_NF,

	case when year(STL.TL_DTINICI) = 1900 then datediff(day, SD1.D1_DTDIGIT, getdate()) else datediff(day, SD1.D1_DTDIGIT, STL.TL_DTINICI) end as DIAS_NF_TLINI,
	case when year(STJ.TJ_DTPRFIM) = 1900 then datediff(day, STL.TL_DTINICI, getdate()) else datediff(day, STL.TL_DTINICI, STJ.TJ_DTPRFIM) end as DIAS_TLINI_FIMMNT,
	case when year(SD1.D1_DTDIGIT) = 1900 then datediff(day, SCP.CP_DATPRF, getdate()) else datediff(day, SC1.C1_EMISSAO, SD1.D1_DTDIGIT) end as TEMPODECOMPRA,

	case STJ.TJ_TERCEIR
		when 1 then 'N'
		when 2 then	'S'
		else '-'
	end as TJ_TERCEIR,

	case when SD1.D1_DOC is not null then 'NF CLASSIFICADA'
	else
		case when APRSC7.CR_LIBAPRO is not null then 'PEDIDO APROVADO'
		else
			case when SC7.C7_NUM is not null then 'APROVAÇÃO PEDIDO PENDENTE'
			else
				case when APRSC1.CR_LIBAPRO is not null then 'SOLICITAÇÃO APROVADA'
				else
					case when SC1.C1_NUM is not null then 'APROVAÇÃO SOLICITAÇÃO PENDENTE'
					else 'OUTROS'
					end
				end
			end
		end
	end as STATUS_SERVICO,

	isnull(trim(SB1.B1_COD) + ' - ' + trim(SB1.B1_DESC), '-') as PRODUTO

from STL010 STL (nolock)
	inner join STJ010 STJ (nolock)
		on STJ.D_E_L_E_T_ = ''
		and STJ.TJ_ORDEM = STL.TL_ORDEM
		and STJ.TJ_PLANO = STL.TL_PLANO
		and STJ.TJ_FILIAL = STL.TL_FILIAL
	inner join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = STJ.TJ_CODBEM

		left join CTT010 CTT (nolock)
			on CTT.D_E_L_E_T_ = ''
			and CTT.CTT_CUSTO = ST9.T9_CCUSTO
		left join CTD010 CTD (nolock)
			on CTD.D_E_L_E_T_ = ''
			and CTD.CTD_ITEM = ST9.T9_ITEMCTA
	
	inner join SB1010 SB1 (nolock)
		on SB1.D_E_L_E_T_ = ''
		and SB1.B1_COD = STL.TL_CODIGO

	left join SCP010 as SCP (nolock)
		on SCP.D_E_L_E_T_ = ''
		and SCP.CP_FILIAL = STL.TL_FILIAL
		and substring(SCP.CP_OP, 1, 6) = STL.TL_ORDEM
		and SCP.CP_PRODUTO = STL.TL_CODIGO

		left join SC1010 SC1 (nolock)
			on SC1.D_E_L_E_T_ = ''
			and substring(SC1.C1_OP, 1, 6) = substring(SCP.CP_OP, 1, 6)
			and SC1.C1_PRODUTO = SCP.CP_PRODUTO

			left join SCR010 APRSC1 (nolock)
				on APRSC1.D_E_L_E_T_ = ''
				and APRSC1.CR_NUM = SC1.C1_NUM
				
				left join SAK010 NOMEAPRSC1 (nolock)
					on NOMEAPRSC1.D_E_L_E_T_ = ''
					and NOMEAPRSC1.AK_COD = APRSC1.CR_LIBAPRO

			left join SC7010 SC7 (nolock)
				on SC7.D_E_L_E_T_ = ''
				and SC7.C7_NUM = SC1.C1_PEDIDO
				and SC7.C7_PRODUTO = SC1.C1_PRODUTO

				left join SCR010 APRSC7 (nolock)
					on APRSC7.D_E_L_E_T_ = ''
					and APRSC7.CR_NUM = SC7.C7_NUM
					
					left join SAK010 NOMEAPRSC7 (nolock)
						on NOMEAPRSC7.D_E_L_E_T_ = ''
						and NOMEAPRSC7.AK_COD = APRSC7.CR_LIBAPRO

				left join SD1010 SD1 (nolock)
					on SD1.D_E_L_E_T_ = ''
					and SD1.D1_PEDIDO = SC7.C7_NUM
					and SD1.D1_FORNECE = SC7.C7_FORNECE
					and SD1.D1_LOJA = SC7.C7_LOJA
					and SD1.D1_COD = SC7.C7_PRODUTO
				left join SY1010 SY1 (nolock)
					on SY1.D_E_L_E_T_ = ''
					and SY1.Y1_USER = SC7.C7_USER
where
		STL.D_E_L_E_T_ = ''
