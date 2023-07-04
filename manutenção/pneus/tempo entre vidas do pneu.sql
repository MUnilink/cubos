select
	trim(isnull(PNEU.T9_CODBEM, '-')) as PNEU,
    trim(TQY.TQY_DESTAT) as STATUS_PNEU,
	convert(datetime, concat(TQZ.TQZ_DTSTAT, ' ', TQZ.TQZ_HRSTAT), 103) as TQZ_DATAMOV,
	substring(TQZ.TQZ_DTSTAT, 1, 6) as PERIODO

from TQZ010 TQZ (nolock)			
	left join TQS010 TQS (nolock)
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = TQZ.TQZ_CODBEM

		left join ST9010 PNEU (nolock)
			on PNEU.D_E_L_E_T_ = ''
			and PNEU.T9_CODBEM = TQS.TQS_CODBEM
			and trim(PNEU.T9_CODBEM) like '[0-9]%'
    
    inner join TQY010 TQY (nolock)
        on TQY.D_E_L_E_T_ = ''
        and TQY.TQY_STATUS = TQZ.TQZ_STATUS
where
		TQZ.D_E_L_E_T_ = ''
    and TQZ.TQZ_STATUS in (51, 57)
