select distinct
	STL.TL_SEQRELA,
	ST9.T9_ITEMCTA,
	STJ.TJ_CCUSTO,
	trim(isnull(STJ.TJ_USUAFIM, '-')) as TJ_USUAFIM,
	STJ.TJ_ORDEM as CONTADOR_OS,
	
	case when STJ.TJ_CCUSTO = 304 or STJ.TJ_CCUSTO = 302 then 'MATRIZ'
	else
		case when STJ.TJ_CCUSTO = 305 or STJ.TJ_CCUSTO = 306 or STJ.TJ_CCUSTO = 303 then 'PECÉM'
		else 'OUTRO'
		end
	end as ORIGEM_CUSTO,

	case when STL.TL_DTINICI > '20220315' then STJ.TJ_CCUSTO
	else
		case when STJ.TJ_CODBEM in ('CM3010', 'SR10057', 'SR11003') and STJ.TJ_CCUSTO != 304 then 304
		else
			case when STJ.TJ_CODBEM in ('VL33', 'SR15004', 'SR15005') and STJ.TJ_CCUSTO != 302 then 302
			else
				case when STJ.TJ_CODBEM in ('VL54') and STJ.TJ_CCUSTO != 303 then 303
				else
					case when STJ.TJ_CODBEM in ('VM06', 'LHM 400') and STJ.TJ_CCUSTO != 306 then 306
					else
						case when STJ.TJ_CODBEM in ('BOBCAT01', 'KAL04', 'VL04', 'CP03', 'CP07', 'CP09', 'EP08', 'EP09', 'EP11', 'EP12', 'EP13', 'EP14', 'EP15', 'GHMK6407B', 'GMK4100', 'GMK4100 GD', 'H01', 'KAL02', 'KAL03', 'KAL05', 'KAL06', 'KAL07', 'RS11', 'RS12', 'RS14', 'RS15', 'VL44', 'GR01', 'GR02', 'GRAB01', 'GRAB02', 'GRAB 02', 'LHM 400', 'MOG01', 'MOG02') and STJ.TJ_CCUSTO != 305 then 305
						else STJ.TJ_CCUSTO
						end
					end
				end
			end
		end
	end as CC,/*

	case when STL.TL_DTINICI > '20220315' then ST9.T9_ITEMCTA
	else
		case when STJ.TJ_CODBEM in ('GR01', 'GR02', 'GRAB01', 'GRAB02', 'GRAB 02', 'MOG01', 'MOG02') then ST9.T9_ITEMCTA
		case when ('LHM 400', 'VM06') then 
	end*/
	STL.TL_QUANTID,

	case when trim(STL.TL_CODIGO) in ('11380003', '11380004', '11380005') and STL.TL_LOCAL = '80' then ADESIVO_CUSTO.B9_CM * STL.TL_QUANTID
	else
		case when trim(STL.TL_CODIGO) in ('T05', 'T12', 'T15', 'T16', 'T17') then ST1.T1_SALARIO * STL.TL_QUANTID
		else
			STL.TL_CUSTO
		end
	end as TL_CUSTO,

	case when trim(STL.TL_CODIGO) = PECAS_RECONDICIONADAS.SERV_COD and STL.TL_LOCAL = '04' then (PECAS_RECONDICIONADAS.SERV_TOTAL/PECAS_RECONDICIONADAS.D1_QUANT)
		else STL.TL_CUSTO
	end -1 as CUSTO_RECONDICIONADAS,

	convert(datetime, datetimefromparts(year(STL.TL_DTINICI), month(STL.TL_DTINICI), day(STL.TL_DTINICI), substring(STL.TL_HOINICI, 1, 2), substring(STL.TL_HOINICI, 4, 5), 0, 0), 113) as TL_DTINICI,
	convert(datetime, datetimefromparts(year(STL.TL_DTFIM), month(STL.TL_DTFIM), day(STL.TL_DTFIM), substring(STL.TL_HOFIM, 1, 2), substring(STL.TL_HOFIM, 4, 5), 0, 0), 113) as TL_DTINFIM,

	STL.TL_LOCAL,
	STJ.TJ_POSCONT,
	ST1.T1_SALARIO,
	SB1.B1_UPRC,
	case when substring(ST9.T9_DTCOMPR, 1, 6) = substring(STL.TL_DTINICI, 1, 6) then ST9.T9_VALCPA else 0.0 end as T9_VALCPA,
	STJ.TJ_CUSTMDO,
	STJ.TJ_CUSTMAT,
	STJ.TJ_CUSTMAA,
	STJ.TJ_CUSTMAS,
	STJ.TJ_CUSTTER,

	case when STL.TL_CODIGO = ST0.T0_ESPECIA or STL.TL_CODIGO = ST1.T1_CODFUNC then 'MÃO-DE-OBRA'
	else
		case when STL.TL_CODIGO = SB1.B1_COD and SB1.B1_COD like '1%' then 'PEÇAS'
		else
			case when SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA then 'TERCEIROS'
			else
				case when STL.TL_CODIGO = SH4.H4_CODIGO then 'FERRAMENTA'
				else 'OUTROS'
				end
			end
		end
	end as TIPO_CUSTO,

	case when STL.TL_CODIGO = ST0.T0_ESPECIA or STL.TL_CODIGO = ST1.T1_CODFUNC then trim(isnull(ST0.T0_ESPECIA, isnull(ST1.T1_CODFUNC, '-')))
	else
		case when STL.TL_CODIGO = SB1.B1_COD and SB1.B1_COD like '1%' then trim(SB1.B1_COD)
		else
			case when SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA then isnull(trim(SA2.A2_COD) + '-' + trim(SA2.A2_LOJA), '-')
			else
				case when STL.TL_CODIGO = SH4.H4_CODIGO then trim(SH4.H4_CODIGO)
				else 'OUTROS'
				end
			end
		end
	end as INSUMO,

	case when STL.TL_CODIGO = ST0.T0_ESPECIA or STL.TL_CODIGO = ST1.T1_CODFUNC then trim(isnull(ST1.T1_NOME, isnull(ST0.T0_NOME, '-')))
	else
		case when STL.TL_CODIGO = SB1.B1_COD and SB1.B1_COD like '1%' then trim(SB1.B1_DESC)
		else
			case when SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA then trim(SA2.A2_NOME)
			else
				case when STL.TL_CODIGO = SH4.H4_CODIGO then trim(SH4.H4_DESCRI)
				else 'OUTROS'
				end
			end
		end
	end as DESC_INSUMO,

	trim(isnull(STJ.TJ_ORDEM, '-')) as TJ_ORDEM,
	trim(isnull(ST5.T5_TAREFA, '-')) as T5_TAREFA,
	trim(isnull(STJ.TJ_CODBEM, '-')) as TJ_CODBEM,
	trim(isnull(SH4.H4_CODIGO, '-')) as H4_CODIGO,
	trim(isnull(ST0.T0_ESPECIA, '-')) as T0_ESPECIA,
	trim(isnull(ST1.T1_CODFUNC, '-')) as T1_CODFUNC,
	trim(isnull(STI.TI_PLANO, '-')) as TI_PLANO,
	trim(isnull(STJ.TJ_FILIAL, '-')) as COD_FILIAL,
	trim(isnull(ST4.T4_NOME, '-')) as T4_NOME,

	trim(isnull(SB1.B1_GRUPO, '-')) as B1_GRUPO,
	trim(isnull(SB1.B1_COD, '-')) as B1_COD,
	trim(isnull(SB1.B1_DESC, '-')) as B1_DESC,
	trim(isnull(SA2.A2_COD, '-')) as A2_COD,
	trim(isnull(SA2.A2_NOME, '-')) as A2_NOME,

	trim(isnull(SF1.F1_DOC, '-')) as F1_DOC,
	trim(isnull(SF1.F1_SERIE, '-')) as F1_SERIE,

	PECAS_RECONDICIONADAS.D2_COD,
	PECAS_RECONDICIONADAS.DATAEMISSAO_SERVICO,
	PECAS_RECONDICIONADAS.DATAENTRADA_SERVICO,
	PECAS_RECONDICIONADAS.SERV_DOC,
	PECAS_RECONDICIONADAS.SERV_SERIE,
	PECAS_RECONDICIONADAS.SERV_ITEM,
	PECAS_RECONDICIONADAS.SERV_TES,
	PECAS_RECONDICIONADAS.SERV_TOTAL,
	PECAS_RECONDICIONADAS.SERV_VUNIT,
	PECAS_RECONDICIONADAS.D1_QUANT,
	PECAS_RECONDICIONADAS.D1_TOTAL,
	PECAS_RECONDICIONADAS.D2_TOTAL,

	year(STL.TL_DTINICI) as ANO_APP_OS,
	month(STL.TL_DTINICI) as MES_APP_OS


from STJ010 STJ
	inner join ST9010 ST9
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = STJ.TJ_CODBEM

		left join TQR010 TQR
			on 	TQR.D_E_L_E_T_ = ''
			and TQR.TQR_TIPMOD = ST9.T9_TIPMOD

	inner join ST4010 ST4
		on ST4.D_E_L_E_T_ = ''
		and ST4.T4_SERVICO = STJ.TJ_SERVICO
	inner join STL010 STL
		on STL.D_E_L_E_T_ = ''
		and STL.TL_ORDEM = STJ.TJ_ORDEM
		and STL.TL_PLANO = STJ.TJ_PLANO
		and STL.TL_FILIAL = STJ.TJ_FILIAL

		left join SCP010 SCP
			on SCP.D_E_L_E_T_ = ''
			and STL.TL_FILIAL = SCP.CP_FILIAL
			and STL.TL_ORDEM = substring(SCP.CP_OP, 1, 6)
			and STL.TL_CODIGO = SCP.CP_PRODUTO

		left join ST5010 ST5
			on ST5.D_E_L_E_T_ = ''
			and ST5.T5_CODBEM = STL.TL_CODBEM
			and ST5.T5_TAREFA = STL.TL_TAREFA
		left join SF1010 SF1
			on SF1.D_E_L_E_T_ = ''
			and SF1.F1_DOC + SF1.F1_SERIE = STL.TL_DOC + STL.TL_SDOC
		left join SA2010 SA2
			on SA2.D_E_L_E_T_ = ''
			and SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA
		left join SB1010 SB1
			on SB1.D_E_L_E_T_ = ''
			and SB1.B1_COD = STL.TL_CODIGO/*

			left join SB2010 SB2 (nolock)
				on SB2.D_E_L_E_T_ = ''
				and SB2.B2_COD = SB1.B1_COD
				and SB2.B2_LOCAL = STL.TL_LOCAL
			left join SB9010 SB9 (nolock)
				on SB9.D_E_L_E_T_ = ''
				and SB9.B9_COD = SB1.B1_COD
				and SB9.B9_LOCAL = STL.TL_LOCAL*/

		left join
		(
			select
				SB9010.B9_COD,
				min(SB9010.B9_VINI1/SB9010.B9_QINI) as B9_CM,
				min(SB9010.B9_DATA) as B9_DATA
			from SB9010
			where
					SB9010.D_E_L_E_T_ = ''
				and SB9010.B9_LOCAL = '01'
				and SB9010.B9_COD in ('11380003', '11380004', '11380005')
				and SB9010.B9_QINI != 0
			group by
				SB9010.B9_COD
		) ADESIVO_CUSTO
			on ADESIVO_CUSTO.B9_COD = STL.TL_CODIGO

		left join
		(
			select
				SERVICO.D1_COD as SERV_COD,
				trim(isnull(SERVICO.D1_FILIAL, '-')) as SERV_FILIAL,
				trim(isnull(SERVICO.D1_DOC, '-')) as SERV_DOC,
				trim(isnull(SERVICO.D1_SERIE, '-')) as SERV_SERIE,
				trim(isnull(SERVICO.D1_ITEM, '-')) as SERV_ITEM,
				trim(isnull(SERVICO.D1_TES, '-')) as SERV_TES,
				trim(isnull(SERVICO.D1_DTDIGIT, '-')) as DATAENTRADA_SERVICO,
				trim(isnull(SERVICO.D1_EMISSAO, '-')) as DATAEMISSAO_SERVICO,
				SERVICO.D1_QUANT as SERV_QUANT,
				SERVICO.D1_VUNIT as SERV_VUNIT,
				SERVICO.D1_TOTAL as SERV_TOTAL,
				SERVICO.D1_CUSTO as SERV_CUSTO,
				SERVICO.D1_VALDESC as SERV_VALDESC,
				SERVICO.D1_LOCAL as SERV_LOCAL,
				SERVICO.D1_PEDIDO as SERV_PEDIDO,
				trim(isnull(SERVICO.D1_FORNECE, '-')) + '-' + trim(isnull(SERVICO.D1_LOJA, '-')) as FORNECEDOR_SERV,

				trim(isnull(RETORNO.D1_FILIAL, '-')) as D1_FILIAL,
				trim(isnull(RETORNO.D1_DOC, '-')) as D1_DOC,
				trim(isnull(RETORNO.D1_SERIE, '-')) as D1_SERIE,
				trim(isnull(RETORNO.D1_ITEM, '-')) as D1_ITEM,
				trim(isnull(RETORNO.D1_TES, '-')) as D1_TES,
				trim(isnull(RETORNO.D1_DTDIGIT, '-')) as DATAENTRADA_RETORNO,
				trim(isnull(RETORNO.D1_EMISSAO, '-')) as DATAEMISSAO_RETORNO,
				RETORNO.D1_QUANT,
				RETORNO.D1_VUNIT,
				RETORNO.D1_TOTAL,
				RETORNO.D1_CUSTO,
				RETORNO.D1_VALDESC,
				RETORNO.D1_LOCAL,

				REMESSA.D2_COD,
				trim(isnull(REMESSA.D2_FILIAL, '-')) as D2_FILIAL,
				trim(isnull(REMESSA.D2_DOC, '-')) as D2_DOC,
				trim(isnull(REMESSA.D2_SERIE, '-')) as D2_SERIE,
				trim(isnull(REMESSA.D2_ITEM, '-')) as D2_ITEM,
				trim(isnull(REMESSA.D2_TES, '-')) as D2_TES,
				trim(isnull(REMESSA.D2_EMISSAO, '-')) as DATA_SAIDA,
				REMESSA.D2_QUANT,
				REMESSA.D2_TOTAL,
				REMESSA.D2_LOCAL,
				trim(isnull(REMESSA.D2_CLIENTE, '-')) + '-' + trim(isnull(REMESSA.D2_LOJA, '-')) as FORNECEDOR_PECA
			from SD1010 SERVICO (nolock)
				left join SD1010 RETORNO (nolock)
					on RETORNO.D_E_L_E_T_ = ''
					and RETORNO.D1_FILIAL = SERVICO.D1_FILIAL
					and RETORNO.D1_DOC = SERVICO.D1_NFORI
					and RETORNO.D1_SERIE = SERVICO.D1_SERIORI
					and RETORNO.D1_ITEM = SERVICO.D1_ITEMORI
					and RETORNO.D1_FORNECE = SERVICO.D1_FORNECE
					and RETORNO.D1_LOJA = SERVICO.D1_LOJA
					and (RETORNO.D1_COD = SERVICO.D1_COD or SERVICO.D1_COD = '000332')

					left join SD2010 REMESSA (nolock)
						on REMESSA.D_E_L_E_T_ = ''
						and REMESSA.D2_FILIAL = RETORNO.D1_FILIAL
						and REMESSA.D2_COD = RETORNO.D1_COD
						and REMESSA.D2_DOC = RETORNO.D1_NFORI
						and REMESSA.D2_SERIE = RETORNO.D1_SERIORI
						and REMESSA.D2_ITEM = RETORNO.D1_ITEMORI
						and REMESSA.D2_CLIENTE = RETORNO.D1_FORNECE
						and REMESSA.D2_LOJA = RETORNO.D1_LOJA
			where SERVICO.D_E_L_E_T_ = ''
		) PECAS_RECONDICIONADAS
			on PECAS_RECONDICIONADAS.D2_COD = STL.TL_CODIGO
			and PECAS_RECONDICIONADAS.D1_LOCAL = STL.TL_LOCAL
		left join SH4010 SH4
			on SH4.D_E_L_E_T_ = ''
			and SH4.H4_CODIGO = STL.TL_CODIGO
		left join ST0010 ST0
			on ST0.D_E_L_E_T_ = ''
			and ST0.T0_ESPECIA = STL.TL_CODIGO
		left join ST1010 ST1
			on ST1.D_E_L_E_T_ = ''
			and ST1.T1_FILIAL = STL.TL_FILIAL
			and ST1.T1_CODFUNC = STL.TL_CODIGO
		left join STI010 STI
			on STI.D_E_L_E_T_ = ''
			and STI.TI_FILIAL = STL.TL_FILIAL
			and STI.TI_PLANO = STL.TL_PLANO
where
		STL.D_E_L_E_T_ = ''
