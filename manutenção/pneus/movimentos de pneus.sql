select
	trim(PNE.T9_CODBEM) as PNEU,
	trim(EST.T9_CODBEM) as ESTRUTURA,
	SB1.B1_COD as PRODUTO,
    PNE.T9_LOCPAD as ARMAZEM,
	PNE.T9_SITBEM as SITUACAO,
	TQS.TQS_MEDIDA,
    trim(TQT.TQT_DESMED) as MEDIDA,
	PNE.T9_STATUS as STATUS,
    trim(TQY.TQY_DESTAT) as DESC_STATUS,
    PNE.T9_CONTACU as CONT_ACUM,
	trim(STZ.TZ_FILIAL) as FILIAL,
	trim(STZ.TZ_ORDEM) as OS_MOV,
	
	last_value(STZ.TZ_BEMPAI) over (partition by STZ.TZ_CODBEM order by STZ.TZ_CODBEM) as ESTRUTURA_ANT,
	isnull(nullif(STZ.TZ_CONTSAI, 0), STZ.TZ_POSCONT) - STZ.TZ_POSCONT as km,
	STZ.TZ_POSCONT as CONT_MOV,
	STZ.TZ_CONTSAI as CONT_SAI,
	convert(datetime, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), 103) as DATA_MOV,
	convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 103) as DATA_SAI,
	datediff(minute, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI))/(60*24) as TEMPO_RODADO,
	substring(STZ.TZ_DATAMOV, 1, 6) as PERIODO_ENT,
	substring(STZ.TZ_DATASAI, 1, 6) as PERIODO_SAI,
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
	TQS.TQS_KMOR + TQS.TQS_KMR1 + TQS.TQS_KMR2 + TQS.TQS_KMR3 + TQS.TQS_KMR4 + TQS.TQS_KMR5 + TQS.TQS_KMR6 + TQS.TQS_KMR7 as kmTOT

from STZ010 STZ (nolock)
	inner join TQS010 TQS (nolock)
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = STZ.TZ_CODBEM

		inner join ST9010 PNE (nolock)
			on PNE.D_E_L_E_T_ = ''
			and PNE.T9_CODBEM = TQS.TQS_CODBEM
			and PNE.T9_CATBEM = 3

			inner join TQY010 TQY (nolock)
				on TQY.D_E_L_E_T_ = ''
				and TQY.TQY_STATUS = PNE.T9_STATUS
		
		inner join TQT010 TQT (nolock)
            on TQT.D_E_L_E_T_ = ''
            and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
			
			left join SB1010 SB1 (nolock)
				on SB1.D_E_L_E_T_ = ''
				and SB1.B1_XMEDIDA = TQT.TQT_MEDIDA
	
	inner join ST9010 EST (nolock)
		on EST.D_E_L_E_T_ = ''
		and EST.T9_CODBEM = STZ.TZ_BEMPAI
		and EST.T9_CATBEM != 3
where
		STZ.D_E_L_E_T_ = ''
