select
	trim(isnull(STJ.TJ_CODBEM, '-')) as TJ_CODBEM,
	STJ.TJ_ORDEM,
	convert(date, substring(STJ.TJ_DTORIGI, 1, 8), 103) as TJ_DTORIGI,
	trim(isnull(STJ.TJ_TERMINO, '-')) as TJ_TERMINO,
	STJ.TJ_FILIAL,
	trim(isnull(STL.TL_CODIGO, '-')) as PRODUTO,
	STL.TL_QUANREC,
	STL.TL_QUANTID,
	STL.TL_DTINICI,
	STJ.TJ_DTPRFIM,

	year(STJ.TJ_DTORIGI) as ANO_OS,
	month(STJ.TJ_DTORIGI) as MES_OS,
	
	trim(isnull(SCP.CP_DESCRI, '-')) as NOME_PRODUTO,
	trim(isnull(SCP.CP_OP, '-')) as CP_OP,
	trim(isnull(SCP.CP_NUM, '-')) as NUM_SA,
	trim(isnull(SCP.CP_ITEM, '-')) as ITEM_SA,
	trim(isnull(SCP.CP_PRODUTO, '-')) as COD_PRODUTO_SA,
	trim(isnull(SCP.CP_SOLICIT, '-')) as SOLICITANTE_SA,
	SCP.CP_QUANT,
	SCP.CP_QUJE,
	convert(date, substring(SCP.CP_DATPRF, 1, 8), 103) as CP_DATPRF,

	case when SCP.CP_QUJE = 0 then 'PENDENTE'
	else
		case when SCP.CP_QUANT = SCP.CP_QUJE then 'TOT. ATENDIDA'
		else 'PAR. ATENDIDA'
		end
	end as CP_ATENDIDA,

	case when year(SCP.CP_DATPRF) = 1900 then datediff(day, STJ.TJ_DTORIGI, getdate()) else datediff(day, STJ.TJ_DTORIGI, SCP.CP_DATPRF) end as TEMPO_INIMNT_SA,
	case when year(SC1.C1_EMISSAO) = 1900 then datediff(day, SCP.CP_DATPRF, getdate()) else datediff(day, SCP.CP_DATPRF, SC1.C1_EMISSAO) end as DIAS_SA_SC,
	case when year(APRSC1.CR_DATALIB) = 1900 then datediff(day, SC1.C1_EMISSAO, getdate()) else datediff(day, SC1.C1_EMISSAO, APRSC1.CR_DATALIB) end as DIAS_SC_APRSC,
	case when year(SC7.C7_EMISSAO) = 1900 then datediff(day, APRSC1.CR_DATALIB, getdate()) else datediff(day, APRSC1.CR_DATALIB, SC7.C7_EMISSAO) end as DIAS_APRSC_PC,

	trim(isnull(SC1.C1_OP, '-')) as C1_OP,
	trim(isnull(SC1.C1_NUM, '-')) as NUM_SC,
	trim(isnull(SC1.C1_ITEM, '-')) as ITEM_SC,
	trim(isnull(SC1.C1_PRODUTO, '-')) as COD_PRODUTO_SC,
	trim(isnull(SC1.C1_SOLICIT, '-')) as SOLICITANTE_SC,

	convert(date, substring(SC1.C1_EMISSAO, 1, 8), 103) as C1_EMISSAO,

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
	convert(date, substring(SC7.C7_EMISSAO, 1, 8), 103) as C7_EMISSAO,

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

	trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
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

	case when year(SD1.D1_DTDIGIT) = 1900 then datediff(day, SCP.CP_DATPRF, getdate()) else datediff(day, SCP.CP_DATPRF, SD1.D1_DTDIGIT) end as TEMPODECOMPRA,
	case when year(STL.TL_DTINICI) = 1900 then datediff(day, SD1.D1_DTDIGIT, getdate()) else datediff(day, SD1.D1_DTDIGIT, STL.TL_DTINICI) end as TEMPOEMESTOQUE,
	case when year(STJ.TJ_DTPRFIM) = 1900 then datediff(day, STJ.TJ_DTORIGI, getdate()) else datediff(day, SD1.D1_DTDIGIT, STJ.TJ_DTPRFIM) end as TEMPO_NF_FIMMNT,

	SA2.A2_COD,
	SA2.A2_LOJA,
	SA2.A2_NOME,
	SA2.A2_NREDUZ,
	SA2.A2_CGC,

	case when STJ.TJ_CODBEM like 'CM%' then 'VP - CM'
	else
		case when STJ.TJ_CODBEM like 'SR%' then 'VP - SR'
		else ST9.T9_CODFAMI
		end
	end as T6_CODFAMI,

	STJ.TJ_DTMRINI,
	STJ.TJ_HOMRINI,
	STJ.TJ_DTMRFIM,
	STJ.TJ_HOMRFIM,

	STJ.TJ_DTPRINI,
	STJ.TJ_HOPRINI,
	STJ.TJ_DTPRFIM,
	STJ.TJ_HOPRFIM,

	year(STJ.TJ_DTPRINI) ANO_PARINI,
	month(STJ.TJ_DTPRINI) MES_PARINI,
	year(STJ.TJ_DTPRFIM) ANO_PARFIM,
	month(STJ.TJ_DTPRFIM) MES_PARFIM,

	convert(datetime, datetimefromparts(year(STJ.TJ_DTMRINI), month(STJ.TJ_DTMRINI), day(STJ.TJ_DTMRINI), substring(STJ.TJ_HOMRINI, 1, 2), substring(STJ.TJ_HOMRINI, 4, 5), 0, 0), 113) as DATAHORA_MNTINI,
	convert(datetime, datetimefromparts(year(STJ.TJ_DTMRFIM), month(STJ.TJ_DTMRFIM), day(STJ.TJ_DTMRFIM), substring(STJ.TJ_HOMRFIM, 1, 2), substring(STJ.TJ_HOMRFIM, 4, 5), 0, 0), 113) as DATAHORA_MNTFIM,

	convert(datetime, datetimefromparts(year(STJ.TJ_DTPRINI), month(STJ.TJ_DTPRINI), day(STJ.TJ_DTPRINI), substring(STJ.TJ_HOPRINI, 1, 2), substring(STJ.TJ_HOPRINI, 4, 5), 0, 0), 113) as DATAHORA_PARINI,
	convert(datetime, datetimefromparts(year(STJ.TJ_DTPRFIM), month(STJ.TJ_DTPRFIM), day(STJ.TJ_DTPRFIM), substring(STJ.TJ_HOPRFIM, 1, 2), substring(STJ.TJ_HOPRFIM, 4, 5), 0, 0), 113) as DATAHORA_PARFIM,

	case ST9.T9_CALENDA
		when '001' then floor(6.2857142 * datediff(day, dateadd(day, 1, eomonth(STJ.TJ_DTPRINI, -1)), eomonth(STJ.TJ_DTPRINI)))
		when '006' then datediff(hour, dateadd(day, 1, eomonth(STJ.TJ_DTPRINI, -1)), eomonth(STJ.TJ_DTPRINI))
		when '24H' then datediff(hour, dateadd(day, 1, eomonth(STJ.TJ_DTPRINI, -1)), eomonth(STJ.TJ_DTPRINI))
		else 0.0
	end as DISPONIBILIDADE,

	case when ST9.T9_CALENDA = '001' and year(STJ.TJ_DTPRFIM) = 1900 and datediff(month, getdate(), STJ.TJ_DTPRINI) = 0 then
		convert(datetime, getdate(), 113)
	else
		case when (ST9.T9_CALENDA = '006' or ST9.T9_CALENDA = '24H') and year(STJ.TJ_DTPRFIM) = 1900 and datediff(month, getdate(), STJ.TJ_DTPRINI) = 0 then
			convert(datetime, getdate(), 113)
		else
			case when ST9.T9_CALENDA = '001' and year(STJ.TJ_DTPRFIM) = 1900 and datediff(month, getdate(), STJ.TJ_DTPRINI) != 0 then
				convert(datetime, dateadd(day, 1, eomonth(STJ.TJ_DTPRINI)), 113)
			else
				case when (ST9.T9_CALENDA = '006' or ST9.T9_CALENDA = '24H') and year(STJ.TJ_DTPRFIM) = 1900 and datediff(month, getdate(), STJ.TJ_DTPRINI) != 0 then
					convert(datetime, dateadd(day, 1, eomonth(STJ.TJ_DTPRINI)), 113)
				else
					case when ST9.T9_CALENDA = '001' then
						convert(datetime, datetimefromparts(year(STJ.TJ_DTPRFIM), month(STJ.TJ_DTPRFIM), day(STJ.TJ_DTPRFIM), substring(STJ.TJ_HOPRFIM, 1, 2), substring(STJ.TJ_HOPRFIM, 4, 5), 0, 0), 113)
					else
						convert(datetime, datetimefromparts(year(STJ.TJ_DTPRFIM), month(STJ.TJ_DTPRFIM), day(STJ.TJ_DTPRFIM), substring(STJ.TJ_HOPRFIM, 1, 2), substring(STJ.TJ_HOPRFIM, 4, 5), 0, 0), 113)
					end
				end
			end
		end
	end as FIMMNT,

	datediff(hour, STJ.TJ_DTORIGI, STJ.TJ_DTMRFIM) as TEMPOMNT,
	datediff(hour, STJ.TJ_DTORIGI, STJ.TJ_DTPRFIM) as TEMPOPAR,

	case STJ.TJ_TERCEIR
		when 1 then 'N'
		when 2 then	'S'
		else '-'
	end as TJ_TERCEIR

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

	left join SCP010 as SCP (nolock)
		on SCP.D_E_L_E_T_ = ''
		and SCP.CP_FILIAL = STL.TL_FILIAL
		and substring(SCP.CP_OP, 1, 6) = STL.TL_ORDEM
		and SCP.CP_PRODUTO = STL.TL_CODIGO

		inner join SC1010 SC1 (nolock)
			on SC1.D_E_L_E_T_ = ''
			and substring(SC1.C1_OP, 1, 6) = substring(SCP.CP_OP, 1, 6)
			and SC1.C1_PRODUTO = SCP.CP_PRODUTO

			left join SCR010 APRSC1 (nolock)
				on APRSC1.D_E_L_E_T_ = ''
				and APRSC1.CR_NUM = SC1.C1_NUM

			left join SC7010 SC7 (nolock)
				on SC7.D_E_L_E_T_ = ''
				and SC7.C7_NUM = SC1.C1_PEDIDO
				and SC7.C7_PRODUTO = SC1.C1_PRODUTO

				left join SCR010 APRSC7 (nolock)
					on APRSC7.D_E_L_E_T_ = ''
					and APRSC7.CR_NUM = SC7.C7_NUM

				left join SD1010 SD1 (nolock)
					on SD1.D_E_L_E_T_ = ''
					and SD1.D1_PEDIDO = SC7.C7_NUM
					and SD1.D1_FORNECE = SC7.C7_FORNECE
					and SD1.D1_LOJA = SC7.C7_LOJA
					and SD1.D1_COD = SC7.C7_PRODUTO
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
where
		STL.D_E_L_E_T_ = ''
	and cast(STL.TL_SEQRELA as int) > 0
