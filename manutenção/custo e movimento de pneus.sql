select
	trim(STJ.TJ_FILIAL) as TJ_FILIAL,
	trim(STZ.TZ_ORDEM) as TZ_ORDEM,
	trim(STZ.TZ_CODBEM) as TZ_CODBEM,
	trim(STJ.TJ_ORDEM) as TJ_ORDEM,
	trim(STJ.TJ_CODBEM) as TJ_CODBEM,

	case when cast(STZ.TZ_CODBEM as int) > 11140 then 'PNEU NOVO' else 'PNEU ANTIGO' end as TIPO_PNEU,

	case STZ.TZ_DATAMOV
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else cast(convert(date, STZ.TZ_DATAMOV, 103) as varchar)
	end as TZ_DATAMOV,

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

	STJ.TJ_CUSTTER,
	ST9.T9_VALCPA,

	TQS.TQS_KMOR,
	TQS.TQS_KMOR + TQS.TQS_KMR1 + TQS.TQS_KMR2 + TQS.TQS_KMR3 + TQS.TQS_KMR4 + TQS.TQS_KMR5 + TQS.TQS_KMR6 + TQS.TQS_KMR7 as VIDA_PNEU,

	year(STZ.TZ_DATAMOV) as MOV_ANO,
	month(STZ.TZ_DATAMOV) as MOV_MES
from STJ010 as STJ (nolock)
	inner join STZ010 as STZ (nolock)
		on STZ.D_E_L_E_T_ = ''
		and STJ.TJ_CODBEM = STZ.TZ_CODBEM

	inner join TQS010 as TQS (nolock)
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = STJ.TJ_CODBEM

		inner join ST9010 as ST9 (nolock)
			on ST9.D_E_L_E_T_ = ''
			and ST9.T9_CODBEM = TQS.TQS_CODBEM

			left join TR4010 as TR4 (nolock)
				on 	TR4.D_E_L_E_T_ = ''
				and TR4.TR4_CODBEM = ST9.T9_CODBEM
			left join TQR010 as TQR (nolock)
				on 	TQR.D_E_L_E_T_ = ''
				and TQR.TQR_TIPMOD = ST9.T9_TIPMOD
			left join ST7010 as ST7 (nolock)
				on 	ST7.D_E_L_E_T_ = ''
				and ST7.T7_FABRICA = ST9.T9_FABRICA
where
		STJ.D_E_L_E_T_ = ''
	and trim(STZ.TZ_CODBEM) like '[0-9]%'