select
	trim(isnull(STZ.TZ_FILIAL, '-')) as TJ_FILIAL,
	trim(isnull(STZ.TZ_ORDEM, '-')) as TZ_ORDEM,
	trim(isnull(PNEU.T9_CODBEM, '-')) as IDPNEU,
	trim(isnull(CARRO.T9_CODBEM, '-')) as IDCARRO,
	SB1.B1_COD as PRODUTO,
    PNEU.T9_LOCPAD,
	TQS.TQS_MEDIDA,
	PNEU.T9_STATUS,
	trim(isnull(STZ.TZ_TIPOMOV, '-')) as TZ_TIPOMOV,
    
	STZ.TZ_CONTSAI - STZ.TZ_POSCONT as km,
	STZ.TZ_POSCONT,
	STZ.TZ_CONTSAI,
	concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT) as TZ_DATAMOV,
	concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI) as TZ_DATASAI,
	datediff(minute, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI))/(60*24) as TEMPO_RODADO

from STL010 STL (nolock)
	left join STJ010 STJ (nolock)
		on STJ.D_E_L_E_T_ = ''
		and STJ.TJ_FILIAL = STL.TL_FILIAL
		and STJ.TJ_ORDEM = STL.TL_ORDEM
		and STJ.TJ_PLANO = STL.TL_PLANO
		
		left join STZ010 STZ (nolock)
			on STZ.D_E_L_E_T_ = ''
			and STZ.TZ_ORDEM = STJ.TJ_ORDEM
			and STZ.TZ_PLANO = STJ.TJ_PLANO
			and STZ.TZ_BEMPAI = STJ.TJ_CODBEM

			inner join TQS010 TQS (nolock)
				on TQS.D_E_L_E_T_ = ''
				and TQS.TQS_CODBEM = STZ.TZ_CODBEM

				inner join ST9010 PNEU (nolock)
					on PNEU.D_E_L_E_T_ = ''
					and PNEU.T9_CODBEM = TQS.TQS_CODBEM
					and PNEU.T9_CATBEM = 3
				inner join TQT010 TQT (nolock)
					on TQT.D_E_L_E_T_ = ''
					and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
					
					left join SB1010 SB1 (nolock)
						on SB1.D_E_L_E_T_ = ''
						and SB1.B1_XMEDIDA = TQT.TQT_MEDIDA

			inner join ST9010 CARRO (nolock)
				on CARRO.D_E_L_E_T_ = ''
				and CARRO.T9_CODBEM = STZ.TZ_BEMPAI
				and CARRO.T9_CATBEM in (1, 4)
where
		STL.D_E_L_E_T_ = ''
