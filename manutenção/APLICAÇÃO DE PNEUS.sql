select
	STL.TL_SEQRELA,
	ST9.T9_ITEMCTA,
	STJ.TJ_CCUSTO,
	convert(date, STJ.TJ_DTORIGI, 103) as TJ_DTORIGI,
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
	end as CC,
	
	STL.TL_QUANTID,

	case when STL.TL_QUANTID != 0.0 then STL.TL_CUSTO / STL.TL_QUANTID else 0.0 end as TL_UNI,

	STL.TL_CUSTO,

	convert(datetime, datetimefromparts(year(STL.TL_DTINICI), month(STL.TL_DTINICI), day(STL.TL_DTINICI), substring(STL.TL_HOINICI, 1, 2), substring(STL.TL_HOINICI, 4, 5), 0, 0), 113) as TL_DTINICI,
	convert(datetime, datetimefromparts(year(STL.TL_DTFIM), month(STL.TL_DTFIM), day(STL.TL_DTFIM), substring(STL.TL_HOFIM, 1, 2), substring(STL.TL_HOFIM, 4, 5), 0, 0), 113) as TL_DTINFIM,

	STL.TL_LOCAL,
	SB1.B1_UPRC,
	case when substring(ST9.T9_DTCOMPR, 1, 6) = substring(STL.TL_DTINICI, 1, 6) then ST9.T9_VALCPA else 0.0 end as T9_VALCPA,

	case when STL.TL_CODIGO = ST0.T0_ESPECIA or STL.TL_CODIGO = ST1.T1_CODFUNC then 'MÃO-DE-OBRA'
	else
		case when STL.TL_CODIGO = SB1.B1_COD and SB1.B1_COD like '1%' then 'PEÇAS'
		else 'OUTROS'
		end
	end as TIPO_CUSTO,
	
	trim(isnull(STL.TL_CODIGO, '-')) as INSUMO,
	case when STL.TL_CODIGO = ST0.T0_ESPECIA or STL.TL_CODIGO = ST1.T1_CODFUNC then trim(isnull(ST1.T1_NOME, isnull(ST0.T0_NOME, '-')))
	else
		case when STL.TL_CODIGO = SB1.B1_COD and SB1.B1_COD like '1%' then trim(SB1.B1_DESC)
		else 'OUTROS'
		end
	end as DESC_INSUMO,

	trim(isnull(STJ.TJ_ORDEM, '-')) as TJ_ORDEM,
	trim(isnull(STL.TL_TAREFA, '-')) as TL_TAREFA,
	trim(isnull(ST5.T5_DESCRIC, isnull(TT9.TT9_DESCRI, '-'))) as T5_TAREFA,
	trim(isnull(STJ.TJ_CODBEM, '-')) as TJ_CODBEM,
	trim(isnull(ST0.T0_ESPECIA, '-')) as T0_ESPECIA,
	trim(isnull(ST1.T1_CODFUNC, '-')) as T1_CODFUNC,
	trim(isnull(STI.TI_PLANO, '-')) as TI_PLANO,
	trim(isnull(STJ.TJ_FILIAL, '-')) as COD_FILIAL,
	trim(isnull(ST4.T4_NOME, '-')) as T4_NOME,

	trim(isnull(SB1.B1_GRUPO, '-')) as B1_GRUPO,
	trim(isnull(SB1.B1_COD, '-')) as B1_COD,
	trim(isnull(SB1.B1_DESC, '-')) as B1_DESC,

	STZ.TZ_ORDEM,
	STZ.TZ_BEMPAI,
	STZ.TZ_CODBEM,
    convert(date, STZ.TZ_DATAMOV, 103) as TZ_DATAMOV,
	convert(date, STZ.TZ_DATASAI, 103) as TZ_DATASAI,
	STZ.TZ_TIPOMOV,
	STZ.TZ_CAUSA,
	ST8.T8_NOME,

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

		left join ST5010 ST5
			on ST5.D_E_L_E_T_ = ''
			and ST5.T5_TAREFA = STL.TL_TAREFA
		left join TT9010 TT9
			on TT9.D_E_L_E_T_ = ''
			and TT9.TT9_TAREFA = STL.TL_TAREFA
		left join SB1010 SB1
			on SB1.D_E_L_E_T_ = ''
			and SB1.B1_COD = STL.TL_CODIGO
		left join ST1010 ST1
			on ST1.D_E_L_E_T_ = ''
			and ST1.T1_FILIAL = STL.TL_FILIAL
			and ST1.T1_CODFUNC = STL.TL_CODIGO
		left join STI010 STI
			on STI.D_E_L_E_T_ = ''
			and STI.TI_FILIAL = STL.TL_FILIAL
			and STI.TI_PLANO = STL.TL_PLANO
	
	left join STZ010 STZ
		on STZ.D_E_L_E_T_ = ''
		and STZ.TZ_BEMPAI = STJ.TJ_CODBEM
		and STZ.TZ_ORDEM = STJ.TJ_ORDEM
		and STZ.TZ_PLANO = STJ.TJ_PLANO

		left join ST8010 ST8 (nolock)
			on ST8.D_E_L_E_T_ = ''
			and ST8.T8_CODOCOR = STZ.TZ_CAUSA
where
		STL.D_E_L_E_T_ = ''
    and STJ.TJ_SERVICO = 'PNEMOV'
