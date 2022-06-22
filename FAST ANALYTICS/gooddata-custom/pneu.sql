select
	trim(isnull(STJ.TJ_FILIAL, '-')) as TJ_FILIAL,
	trim(isnull(STZ.TZ_ORDEM, '-')) as TZ_ORDEM,
	trim(isnull(STJ.TJ_ORDEM, '-')) as TJ_ORDEM,
	trim(isnull(TR8.TR8_LOTE, '-')) as TR8_LOTE,
	trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,
	trim(isnull(ST4.T4_NOME, '-')) as T4_NOME,

	STZ.TZ_POSCONT,
	STZ.TZ_CONTSAI,
	trim(isnull(STZ.TZ_DATAMOV, '-')) as TZ_DATAMOV,
	trim(isnull(STZ.TZ_DATASAI, '-')) as TZ_DATASAI,
	trim(isnull(STZ.TZ_TIPOMOV, '-')) as TZ_TIPOMOV,
	trim(isnull(STZ.TZ_HORAENT, '-')) as TZ_HORAENT,
	trim(isnull(STZ.TZ_HORASAI, '-')) as TZ_HORASAI,

	STJ.TJ_CUSTTER,
	ST9.T9_VALCPA,
	trim(isnull(ST9.T9_DTCOMPR, '-')) as T9_DTCOMPR,

	TQS.TQS_KMOR,
	TQS.TQS_KMR1,
	TQS.TQS_KMR2,
	TQS.TQS_KMR3,
	TQS.TQS_KMR4,
	TQS.TQS_KMR5,
	TQS.TQS_KMR6,
	TQS.TQS_KMR7,
	case when cast(STZ.TZ_CODBEM as int) > 11140 then 'PNEU NOVO' else 'PNEU ANTIGO' end as TIPO_PNEU

from STJ010 as STJ (nolock)
	left join TR8010 as TR8 (nolock)
		on TR8.D_E_L_E_T_ = ''
		and TR8.TR8_FILIAL = STJ.TJ_FILIAL
		and TR8.TR8_ORDEM = STJ.TJ_ORDEM
		and TR8.TR8_PLANO = STJ.TJ_PLANO

		inner join TR7010 as TR7 (nolock)
			on TR7.D_E_L_E_T_ = ''
			and TR7.TR7_FILIAL = TR8.TR8_FILIAL
			and TR7.TR7_LOTE = TR8.TR8_LOTE
			
	inner join TQS010 as TQS (nolock)
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = STJ.TJ_CODBEM

		inner join ST9010 as ST9 (nolock)
			on ST9.D_E_L_E_T_ = ''
			and ST9.T9_CODBEM = TQS.TQS_CODBEM

			inner join STZ010 as STZ (nolock)
				on STZ.D_E_L_E_T_ = ''
				and trim(STZ.TZ_CODBEM) like '[0-9]%'
				and ST9.T9_CODBEM = STZ.TZ_CODBEM

	left join ST4010 as ST4 (nolock)
		on ST4.D_E_L_E_T_ = ''
		and ST4.T4_SERVICO = STJ.TJ_SERVICO

where
		STJ.TJ_DTORIGI between <<START_DATE>> AND <<FINAL_DATE>>
	and STJ.D_E_L_E_T_ = ''