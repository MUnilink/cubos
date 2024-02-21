select
	trim(STZ.TZ_FILIAL) as TJ_FILIAL,
	trim(STZ.TZ_ORDEM) as TZ_ORDEM,
	trim(SR.T9_CODBEM) as SR,
	trim(CM.T9_CODBEM) as CM,
	SR.T9_MOVIBEM as MOVIMENTA_BEM,
	STZ.TZ_POSCONT,
	STZ.TZ_CONTSAI,
	convert(datetime, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), 103) as TZ_DATAMOV,
	convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 103) as TZ_DATASAI,

	trim(isnull(STZ.TZ_TIPOMOV, '-')) as TZ_TIPOMOV,
	trim(isnull(STZ.TZ_HORAENT, '-')) as TZ_HORAENT,
	trim(isnull(STZ.TZ_HORASAI, '-')) as TZ_HORASAI,

	substring(STZ.TZ_DATAMOV, 1, 6) as PERIODO_ENT,
	substring(STZ.TZ_DATASAI, 1, 6) as PERIODO_SAI,
    
    STZ.TZ_CONTSAI - STZ.TZ_POSCONT as km,
	case STZ.TZ_TIPOMOV when 'S' then datediff(minute, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI))/(60*24) else 0.0 end as TEMPO_RODADO

from STZ010 STZ (nolock)
	inner join ST9010 SR (nolock)
		on SR.D_E_L_E_T_ = ''
		and SR.T9_CODBEM = STZ.TZ_CODBEM
		and SR.T9_CATBEM != 3
	inner join ST9010 CM (nolock)
		on CM.D_E_L_E_T_ = ''
		and CM.T9_CODBEM = STZ.TZ_BEMPAI
		and CM.T9_CATBEM != 3
where
		STZ.D_E_L_E_T_ = ''
