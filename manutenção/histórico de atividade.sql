select
    STJ.TJ_ORDEM,
    STJ.TJ_CODBEM,
	STL.TL_SEQRELA,
	ST9.T9_ITEMCTA,
    ST9.T9_CCUSTO,
	STJ.TJ_CCUSTO,
	convert(date, STJ.TJ_DTORIGI, 103) as TJ_DTORIGI,
	trim(isnull(STJ.TJ_USUAFIM, '-')) as TJ_USUAFIM,
	
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
	end as CC,
	
    STL.TL_QUANTID,
	STL.TL_CUSTO,

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
	end as TIPO_CUSTO,/*

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
	end as INSUMO,*/
	
	trim(isnull(STL.TL_CODIGO, '-')) as INSUMO,
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
	trim(isnull(SA2.A2_COD, '-')) as A2_COD,
	trim(isnull(SA2.A2_NOME, '-')) as A2_NOME,

	year(STL.TL_DTINICI) as ANO_APP_OS,
	month(STL.TL_DTINICI) as MES_APP_OS

from STJ010 STJ (nolock)
	inner join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = STJ.TJ_CODBEM

		left join TQR010 TQR (nolock)
			on 	TQR.D_E_L_E_T_ = ''
			and TQR.TQR_TIPMOD = ST9.T9_TIPMOD

	inner join ST4010 ST4 (nolock)
		on ST4.D_E_L_E_T_ = ''
		and ST4.T4_SERVICO = STJ.TJ_SERVICO
	left join STL010 STL (nolock)
		on STL.D_E_L_E_T_ = ''
		and STL.TL_ORDEM = STJ.TJ_ORDEM
		and STL.TL_PLANO = STJ.TJ_PLANO
		and STL.TL_FILIAL = STJ.TJ_FILIAL

		left join SCP010 SCP (nolock)
			on SCP.D_E_L_E_T_ = ''
			and STL.TL_FILIAL = SCP.CP_FILIAL
			and STL.TL_ORDEM = substring(SCP.CP_OP, 1, 6)
			and STL.TL_CODIGO = SCP.CP_PRODUTO

		left join ST5010 ST5 (nolock)
			on ST5.D_E_L_E_T_ = ''
			and ST5.T5_CODBEM = STL.TL_CODBEM
			and ST5.T5_TAREFA = STL.TL_TAREFA
		left join SF1010 SF1 (nolock)
			on SF1.D_E_L_E_T_ = ''
			and SF1.F1_DOC + SF1.F1_SERIE = STL.TL_DOC + STL.TL_SDOC
		left join SA2010 SA2 (nolock)
			on SA2.D_E_L_E_T_ = ''
			and SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA
		left join SB1010 SB1 (nolock)
			on SB1.D_E_L_E_T_ = ''
			and SB1.B1_COD = STL.TL_CODIGO
		left join SH4010 SH4 (nolock)
			on SH4.D_E_L_E_T_ = ''
			and SH4.H4_CODIGO = STL.TL_CODIGO
		left join ST0010 ST0 (nolock)
			on ST0.D_E_L_E_T_ = ''
			and ST0.T0_ESPECIA = STL.TL_CODIGO
		left join ST1010 ST1 (nolock)
			on ST1.D_E_L_E_T_ = ''
			and ST1.T1_FILIAL = STL.TL_FILIAL
			and ST1.T1_CODFUNC = STL.TL_CODIGO
		left join STI010 STI (nolock)
			on STI.D_E_L_E_T_ = ''
			and STI.TI_FILIAL = STL.TL_FILIAL
			and STI.TI_PLANO = STL.TL_PLANO
where
		STL.D_E_L_E_T_ = ''
    and STJ.TJ_CODBEM in ('CM4001', 'CM1016')
    and STL.TL_DTINICI > 20220131
