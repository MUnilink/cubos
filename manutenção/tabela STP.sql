select
	substring(STP.TP_DTLEITU, 1, 6) AS PERIODO,
        (
                select concat(STZ010.TZ_TIPOMOV, ' - ', STZ010.TZ_BEMPAI)
                from STZ010
                where
                        ((concat(STP.TP_DTLEITU, STP.TP_HORA) = concat(STZ010.TZ_DATAMOV, STZ010.TZ_HORAENT)) or (concat(STP.TP_DTLEITU, STP.TP_HORA) = concat(STZ010.TZ_DATASAI, STZ010.TZ_HORASAI)))
                        and STP.TP_CODBEM = STZ010.TZ_CODBEM
                        and STZ010.D_E_L_E_T_ = ''
                        and STP.D_E_L_E_T_ = ''
        ) as CM,
    	(
                select TOP 1 concat(STZ010.TZ_TIPOMOV, ' - ', STZ010.TZ_CODBEM)
                from STZ010
                where
                        ((concat(STP.TP_DTLEITU, STP.TP_HORA) = concat(STZ010.TZ_DATAMOV, STZ010.TZ_HORAENT)) or (concat(STP.TP_DTLEITU, STP.TP_HORA) = concat(STZ010.TZ_DATASAI, STZ010.TZ_HORASAI)))
                        and STP.TP_CODBEM = STZ010.TZ_BEMPAI
                        and STZ010.TZ_ORDEM = ''
                and STZ010.D_E_L_E_T_ = ''
                and STP.D_E_L_E_T_ = ''
        ) as SR,*
from STP010 STP (nolock)
where lower(STP.TP_CODBEM) =:BEM or upper(STP.TP_CODBEM) =:BEM
