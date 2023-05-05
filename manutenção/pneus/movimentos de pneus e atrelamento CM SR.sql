select
	trim(isnull(STZ.TZ_FILIAL, '-')) as TJ_FILIAL,
	trim(isnull(STZ.TZ_ORDEM, '-')) as TZ_ORDEM,
	trim(isnull(PNEU.T9_CODBEM, '-')) as IDPNEU,
	trim(isnull(CARRO.T9_CODBEM, '-')) as IDCARRO,

	STZ.TZ_POSCONT,
	STZ.TZ_CONTSAI,
	trim(isnull(STZ.TZ_DATAMOV, '-')) as TZ_DATAMOV,
	trim(isnull(STZ.TZ_DATASAI, '-')) as TZ_DATASAI,
	trim(isnull(STZ.TZ_TIPOMOV, '-')) as TZ_TIPOMOV,
	trim(isnull(STZ.TZ_HORAENT, '-')) as TZ_HORAENT,
	trim(isnull(STZ.TZ_HORASAI, '-')) as TZ_HORASAI,

	TQS.TQS_KMOR,
	TQS.TQS_KMR1,
	TQS.TQS_KMR2,
	TQS.TQS_KMR3,
	TQS.TQS_KMR4,
	TQS.TQS_KMR5,
	TQS.TQS_KMR6,
	TQS.TQS_KMR7,

	TQS.TQS_KMOR + TQS.TQS_KMR1 + TQS.TQS_KMR2 + TQS.TQS_KMR3 + TQS.TQS_KMR4 + TQS.TQS_KMR5 + TQS.TQS_KMR6 + TQS.TQS_KMR7 as kmTOT,

	year(STZ.TZ_DATAMOV) as ano_DATAMOV,
	month(STZ.TZ_DATAMOV) as mes_DATAMOV,
	year(STZ.TZ_DATASAI) as ano_DATASAI,
	month(STZ.TZ_DATASAI) as mes_DATASAI,

	case when cast(PNEU.T9_CODBEM as int) > 11140 then 'PNEU NOVO' else 'PNEU ANTIGO' end as TIPO_PNEU

from STZ010 STZ (nolock)			
	inner join TQS010 TQS (nolock)
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = STZ.TZ_CODBEM

		inner join ST9010 PNEU (nolock)
			on PNEU.D_E_L_E_T_ = ''
			and PNEU.T9_CODBEM = TQS.TQS_CODBEM
			and trim(PNEU.T9_CODBEM) like '[0-9]%'

	inner join ST9010 CARRO (nolock)
		on CARRO.D_E_L_E_T_ = ''
		and CARRO.T9_CODBEM = STZ.TZ_BEMPAI
		and trim(CARRO.T9_CODBEM) not like '[0-9]%'
where
		STZ.D_E_L_E_T_ = ''
