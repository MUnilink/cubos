select
	trim(isnull(STZ.TZ_ORDEM, '-')) as TZ_ORDEM,
	trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,
	trim(isnull(STZ.TZ_BEMPAI, '-')) as TZ_BEMPAI,

	STZ.TZ_POSCONT,
	STZ.TZ_CONTSAI,
	ST9.T9_CONTACU,
	trim(isnull(STZ.TZ_DATAMOV, '-')) as TZ_DATAMOV,
	trim(isnull(STZ.TZ_DATASAI, '-')) as TZ_DATASAI,
	trim(isnull(STZ.TZ_TIPOMOV, '-')) as TZ_TIPOMOV,
	trim(isnull(STZ.TZ_HORAENT, '-')) as TZ_HORAENT,
	trim(isnull(STZ.TZ_HORASAI, '-')) as TZ_HORASAI,
	trim(isnull(TQT.TQT_DESMED, '-')) as TQT_DESMED,

	ST9.T9_VALCPA as T9_VALCPA,
	ST9.T9_SITBEM,

	TQS.TQS_KMOR,
	TQS.TQS_KMR1,
	TQS.TQS_KMR2,
	TQS.TQS_KMR3,
	TQS.TQS_KMR4,
	TQS.TQS_KMR5,
	TQS.TQS_KMR6,
	TQS.TQS_KMR7,
	TQS.TQS_KMOR + TQS.TQS_KMR1 + TQS.TQS_KMR2 + TQS.TQS_KMR3 + TQS.TQS_KMR4 + TQS.TQS_KMR5 + TQS.TQS_KMR6 + TQS.TQS_KMR7 as kmTOT,
	case when cast(STZ.TZ_CODBEM as int) > 11140 then 'PNEU NOVO' else 'PNEU ANTIGO' end as TIPO_PNEU

from TQS010 as TQS /* pneus */
	left join TQT010 as TQT /* medida do pneu */
		on TQT.D_E_L_E_T_ = ''
		and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
	left join ST9010 as ST9 /* bens da manutenção*/
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = TQS.TQS_CODBEM

		left join STZ010 as STZ /* movimentação de bens*/
			on STZ.D_E_L_E_T_ = ''
			and ST9.T9_CODBEM = STZ.TZ_CODBEM
where
		TQS.D_E_L_E_T_ = ''
