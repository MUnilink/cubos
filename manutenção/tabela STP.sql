select
	substring(STP.TP_DTLEITU, 1, 6) AS PERIODO,
	(
        select STZ010.TZ_BEMPAI
        from STZ010
        where
                STP.TP_CODBEM = STZ010.TZ_CODBEM
            and (STP.TP_DTLEITU = STZ010.TZ_DATAMOV or STP.TP_DTLEITU = STZ010.TZ_DATASAI)
            and (STP.TP_HORA = STZ010.TZ_HORAENT or STP.TP_HORA = STZ010.TZ_HORASAI)
            and STZ010.D_E_L_E_T_ = ''
            and STP.D_E_L_E_T_ = ''
    ) as CM,*
from STP010 STP (nolock)
where STP.TP_CODBEM =:BEM
