select
	trim(isnull(STZ.TZ_FILIAL, '-')) as TJ_FILIAL,
	trim(isnull(STZ.TZ_ORDEM, '-')) as TZ_ORDEM,
	trim(isnull(PNEU.T9_CODBEM, '-')) as IDPNEU,
	trim(isnull(CARRO.T9_CODBEM, '-')) as IDCARRO,
	SB1.B1_COD as PRODUTO,
    PNEU.T9_LOCPAD,
	TQS.TQS_MEDIDA,
    trim(TQT.TQT_DESMED) as MEDIDA,
	PNEU.T9_MOVIBEM as MOVIMENTA_BEM,

	PNEU.T9_STATUS,
    trim(TQY.TQY_DESTAT) as STATUS_PNEU,

    STZ.TZ_CONTSAI - STZ.TZ_POSCONT as km,

	STZ.TZ_POSCONT,
	STZ.TZ_CONTSAI,
	convert(datetime, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), 103) as TZ_DATAMOV,
	convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 103) as TZ_DATASAI,
	datediff(minute, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI))/(60*24) as TEMPO_RODADO,
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

	substring(STZ.TZ_DATAMOV, 1, 6) as PERIODO_ENT,
	substring(STZ.TZ_DATASAI, 1, 6) as PERIODO_SAI,
	TQS.TQS_KMOR + TQS.TQS_KMR1 + TQS.TQS_KMR2 + TQS.TQS_KMR3 + TQS.TQS_KMR4 + TQS.TQS_KMR5 + TQS.TQS_KMR6 + TQS.TQS_KMR7 as kmTOT

from STZ010 STZ (nolock)			
	inner join TQS010 TQS (nolock)
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = STZ.TZ_CODBEM

		inner join ST9010 PNEU (nolock)
			on PNEU.D_E_L_E_T_ = ''
			and PNEU.T9_CODBEM = TQS.TQS_CODBEM
			and trim(PNEU.T9_CODBEM) like '[0-9]%'

			inner join TQY010 TQY (nolock)
				on TQY.D_E_L_E_T_ = ''
				and TQY.TQY_STATUS = PNEU.T9_STATUS
		
		inner join TQT010 TQT (nolock)
            on TQT.D_E_L_E_T_ = ''
            and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
			
			left join SB1010 SB1 (nolock)
				on SB1.D_E_L_E_T_ = ''
				and SB1.B1_XMEDIDA = TQT.TQT_MEDIDA


	inner join ST9010 CARRO (nolock)
		on CARRO.D_E_L_E_T_ = ''
		and CARRO.T9_CODBEM = STZ.TZ_BEMPAI
		and trim(CARRO.T9_CODBEM) not like '[0-9]%'
where
		STZ.D_E_L_E_T_ = ''
