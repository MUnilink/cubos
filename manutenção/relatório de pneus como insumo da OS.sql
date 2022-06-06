select
	trim(STL.TL_FILIAL) as TJ_FILIAL,
	trim(STZ.TZ_ORDEM) as TL_ORDEM,
	trim(STL.TL_CODBEM) as TJ_CODBEM,
	trim(STL.TL_CODIGO) as 'COD PRODUTO/SERVIÇO',
	isnull(trim(SA2.A2_NOME), '-') as A2_NOME,
	case STL.TL_SEQRELA
		when 0 then 'PREVISTO'
		else 'REALIZADO'
	end as STATUS,

	STL.TL_QUANTID,
	STL.TL_CUSTO,

	case STL.TL_DTINICI
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else cast(convert(date, substring(STL.TL_DTINICI, 1 ,8), 103) as varchar)
	end as TL_DTINICI,

	case STL.TL_DTFIM
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else cast(convert(date, substring(STL.TL_DTFIM, 1 ,8), 103) as varchar)
	end as TL_DTFIM,

	trim(STL.TL_HOINICI) as TL_HOINICI,
	trim(STL.TL_HOFIM) as TL_HOFIM,

	year(STL.TL_DTINICI) as ANO_INICIO,
	year(STL.TL_DTFIM) as ANO_FIM,
	month(STL.TL_DTINICI) as MES_INICIO,
	month(STL.TL_DTFIM) as MES_FIM,

	trim(STL.TL_ORDEM) as TL_ORDEM,
	case STZ.TZ_DATAMOV
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else cast(convert(date, STZ.TZ_DATAMOV, 103) as varchar)
	end as TZ_DATAMOV,

	trim(STZ.TZ_CODBEM) as TZ_CODBEM,
	trim(STZ.TZ_TIPOMOV) as TZ_TIPOMOV,
	trim(STZ.TZ_BEMPAI) as TZ_BEMPAI,
	trim(STZ.TZ_HORAENT) as TZ_HORAENT,
	trim(STZ.TZ_HORASAI) as TZ_HORASAI,
	case STZ.TZ_DATASAI
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else cast(convert(date, STZ.TZ_DATASAI, 103) as varchar)
	end as TZ_DATASAI,

	STZ.TZ_POSCONT as TZ_POSCONT,
	STZ.TZ_CONTSAI as TZ_CONTSAI,
	trim(ST7.T7_NOME) as T7_NOME,
	trim(TQR.TQR_DESMOD) as TQR_DESMOD,
	trim(ST9.T9_NFCOMPR) as T9_NFCOMPR,
	trim(TR4.TR4_PAREC) as TR4_PAREC,
	trim(TR4.TR4_NUMANA) as TR4_NUMANA,
	case TR4.TR4_DTANAL
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else cast(convert(date, TR4.TR4_DTANAL, 103) as varchar)
	end as TR4_DTANAL,

	trim(TR4.TR4_HRANAL) as TR4_HRANAL,

	case ST9.T9_DTCOMPR
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else cast(convert(date, ST9.T9_DTCOMPR, 103) as varchar)
	end as T9_DTCOMPR,

	ST9.T9_VALCPA,

	TQS.TQS_KMOR,
	TQS.TQS_KMOR + TQS.TQS_KMR1 + TQS.TQS_KMR2 + TQS.TQS_KMR3 + TQS.TQS_KMR4 + TQS.TQS_KMR5 + TQS.TQS_KMR6 + TQS.TQS_KMR7 as VIDA_PNEU,
	case when TQS.TQS_KMOR + TQS.TQS_KMR1 + TQS.TQS_KMR2 + TQS.TQS_KMR3 + TQS.TQS_KMR4 + TQS.TQS_KMR5 + TQS.TQS_KMR6 + TQS.TQS_KMR7 >0
		then 10000 * STL.TL_CUSTO / (TQS.TQS_KMOR + TQS.TQS_KMR1 + TQS.TQS_KMR2 + TQS.TQS_KMR3 + TQS.TQS_KMR4 + TQS.TQS_KMR5 + TQS.TQS_KMR6 + TQS.TQS_KMR7) else 0.0
	end as CPK,

	year(STZ.TZ_DATAMOV) as MOV_ANO,
	month(STZ.TZ_DATAMOV) as MOV_MES,
	STL.TL_LOCAL

from STZ010 as STZ (nolock)
	inner join TQS010 as TQS (nolock)
		on TQS.TQS_CODBEM = STZ.TZ_CODBEM

	left join STJ010 as STJ (nolock)
		on STJ.D_E_L_E_T_ = ''
		and STJ.TJ_ORDEM = STZ.TZ_ORDEM
		and STJ.TJ_CODBEM = STZ.TZ_CODBEM

			inner join ST9010 as ST9 (nolock)
				on ST9.D_E_L_E_T_ = ''
				and ST9.T9_CODBEM = STJ.TJ_CODBEM

				left join TR4010 as TR4 (nolock)
					on 	TR4.D_E_L_E_T_ = ''
					and TR4.TR4_CODBEM = ST9.T9_CODBEM
				left join TQR010 as TQR (nolock)
					on 	TQR.D_E_L_E_T_ = ''
					and TQR.TQR_TIPMOD = ST9.T9_TIPMOD
				left join ST7010 as ST7 (nolock)
					on 	ST7.D_E_L_E_T_ = ''
					and ST7.T7_FABRICA = ST9.T9_FABRICA

			left join STL010 as STL
				on 	STL.D_E_L_E_T_ = ''
				and STJ.TJ_FILIAL = STL.TL_FILIAL
				and STJ.TJ_ORDEM = STL.TL_ORDEM
				and STJ.TJ_PLANO = STL.TL_PLANO

				left join SA2010 as SA2 (nolock)
					on 	SA2.D_E_L_E_T_ = ''
					and SA2.A2_COD = STL.TL_CODIGO
where
		STZ.D_E_L_E_T_ = ''