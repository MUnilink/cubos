select
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

	year(STZ.TZ_DATAMOV) as MOV_ANO,
	month(STZ.TZ_DATAMOV) as MOV_MES

from STL010 as STL (nolock)
	inner join STZ010 as STZ
		on 	STL.D_E_L_E_T_ = ''
		and STL.TL_ORDEM = STZ.TZ_ORDEM

		inner join ST9010 as ST9 (nolock)
			on 	ST9.D_E_L_E_T_ = ''
			and ST9.T9_CODBEM = STZ.TZ_CODBEM

			inner join TR4010 as TR4 (nolock)
				on 	TR4.D_E_L_E_T_ = ''
				and TR4.TR4_CODBEM = ST9.T9_CODBEM
			inner join TQR010 as TQR (nolock)
				on 	TQR.D_E_L_E_T_ = ''
				and TQR.TQR_TIPMOD = ST9.T9_TIPMOD
			inner join ST7010 as ST7 (nolock)
				on 	ST7.D_E_L_E_T_ = ''
				and ST7.T7_FABRICA = ST9.T9_FABRICA

	left join ST5010 as ST5 (nolock)
		on 	ST5.D_E_L_E_T_ = ''
		and ST5.T5_CODBEM = STL.TL_CODBEM
		and ST5.T5_TAREFA = STL.TL_TAREFA

	inner join STJ010 as STJ (nolock)
		on 	STJ.D_E_L_E_T_ = ''
		and STJ.TJ_ORDEM = STL.TL_ORDEM
		and STJ.TJ_PLANO = STL.TL_PLANO

		inner join ST4010 as ST4 (nolock)
			on 	ST4.D_E_L_E_T_ = ''
			and ST4.T4_SERVICO = STJ.TJ_SERVICO

			inner join TR7010 as TR7 (nolock)
				on 	TR7.D_E_L_E_T_ = ''
				and TR7.TR7_SERVIC = ST4.T4_SERVICO

where
		STZ.D_E_L_E_T_ = ''