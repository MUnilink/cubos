select
	trim(isnull(TR4.TR4_PAREC, '-')) as TR4_PAREC,
	trim(isnull(TR4.TR4_NUMANA, '-')) as TR4_NUMANA,
	trim(isnull(TR4.TR4_DTANAL, '-')) as TR4_DTANAL,
	trim(isnull(TR4.TR4_HRANAL, '-')) as TR4_HRANAL
from TR4010 as TR4
where TR4.D_E_L_E_T_ = ''