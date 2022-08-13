select
	ST9.T9_CODBEM as CONTADOR,
	ST9.T9_CODBEM,
	ST9.T9_CCUSTO,
	ST9.T9_ITEMCTA,
	ST9.T9_SITBEM,
    
    STZ.TZ_ORDEM,
    convert(date, STZ.TZ_DATAMOV, 103) as TZ_DATAMOV,
	convert(date, STZ.TZ_DATASAI, 103) as TZ_DATASAI,
	STZ.TZ_BEMPAI,
	STZ.TZ_TIPOMOV,
	STZ.TZ_CAUSA,
	ST8_MV.T8_NOME,

    TR4.TR4_PAREC,
    TR4.TR4_NUMANA,
    convert(date, TR4.TR4_DTANAL, 103) as TR4_DTANAL,
    ST8_AN.T8_NOME,
    TR4.TR4_PRDORI,
    TR4.TR4_LOCORI,
    TR4.TR4_TM,
    TR4.TR4_PRDDES,
    TR4.TR4_LOCDES

from TQS010 TQS (nolock)
    inner join ST9010 ST9
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = TQS.TQS_CODBEM
    inner join STZ010 STZ (nolock)
        on STZ.D_E_L_E_T_ = ''
        and STZ.TZ_CODBEM = TQS.TQS_CODBEM

        inner join ST8010 ST8_MV (nolock)
			on ST8_MV.D_E_L_E_T_ = ''
			and ST8_MV.T8_CODOCOR = TR4.TR4_MOTIVO
    
    inner join TR4010 TR4 (nolock)
        on TR4.D_E_L_E_T_ = ''
        and TR4.TR4_CODBEM = TQS.TQS_CODBEM

        inner join ST8010 ST8_AN (nolock)
			on ST8_AN.D_E_L_E_T_ = ''
			and ST8_AN.T8_CODOCOR = TR4.TR4_MOTIVO
where TQS.D_E_L_E_T_ = ''
