select
	ST9.T9_CODBEM as CONTADOR,
	trim(ST9.T9_CODBEM) as T9_CODBEM,
	ST9.T9_CCUSTO,
	ST9.T9_ITEMCTA,
	ST9.T9_SITBEM,
    
    ST9.T9_STATUS,
    trim(TQY.TQY_DESTAT) as STATUS_PNEU,
    
    STZ.TZ_ORDEM,
    convert(datetime, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), 103) as DATA_ENT,
    STZ.TZ_POSCONT,
	convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 103) as DATA_SAI,
    STZ.TZ_CONTSAI,

    abs(STZ.TZ_CONTSAI - STZ.TZ_POSCONT) as km,

	STZ.TZ_BEMPAI as ESTRUTURA,
	STZ.TZ_TIPOMOV,
	STZ.TZ_CAUSA,
	trim(concat(cast(STZ.TZ_CAUSA as int), ' - ' , ST8.T8_NOME)) as DESTINO_PNEU /* quando com análise sem movimento, retorna o destino do movimento */

from TQS010 TQS (nolock)
    inner join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = TQS.TQS_CODBEM
    inner join TR8010 TR8 (nolock)
        on TR8.D_E_L_E_T_ = ''
        and TR8.TR8_CODBEM = TQS.TQS_CODBEM
    
    inner join TQY010 TQY (nolock)
        on TQY.D_E_L_E_T_ = ''
        and TQY.TQY_STATUS = ST9.T9_STATUS

where TQS.D_E_L_E_T_ = ''
