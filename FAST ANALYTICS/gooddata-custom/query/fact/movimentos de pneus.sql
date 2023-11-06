select
	trim(isnull(STZ.TZ_FILIAL, '-')) as TZ_FILIAL,
	trim(isnull(STZ.TZ_ORDEM, '-')) as TZ_ORDEM,
	trim(isnull(PNEU.T9_CODBEM, '-')) as IDPNEU,
	trim(isnull(STZ.TZ_BEMPAI, '-')) as ESTRUTURA,
	SB1.B1_COD as PRODUTO,
	trim(TQS.TQS_MEDIDA) as TQS_MEDIDA,
	PNEU.T9_STATUS,
	case STZ.TZ_TIPOMOV when 'E' then 'ENTRADA' when 'S' then 'SAIDA' else 'OUTROS' end as TZ_TIPOMOV,
	trim(STZ.TZ_CAUSA) as OCORRENCIA,
    
	STZ.TZ_POSCONT,
	STZ.TZ_CONTSAI,
	concat(STZ.TZ_DATAMOV, ' ', isnull(nullif(STZ.TZ_HORAENT, ''), '00:00')) as TZ_DATAMOV,
	concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI) as TZ_DATASAI,

	STZ.TZ_CONTSAI - STZ.TZ_POSCONT as RODADO,
	datediff(minute, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI))/(60*24) as TEMPO_RODADO,
	PNEU.T9_VALCPA as CUSTO_COMPRA

from STZ010 STZ
	inner join TQS010 TQS
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = STZ.TZ_CODBEM

		inner join ST9010 PNEU
			on PNEU.D_E_L_E_T_ = ''
			and PNEU.T9_CODBEM = TQS.TQS_CODBEM
		inner join TQT010 TQT
			on TQT.D_E_L_E_T_ = ''
			and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
			
			left join SB1010 SB1
				on SB1.D_E_L_E_T_ = ''
				and SB1.B1_XMEDIDA = TQT.TQT_MEDIDA
where
		STZ.D_E_L_E_T_ = ''
	and PNEU.T9_CATBEM = 3
