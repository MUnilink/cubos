select
	trim(STJ.TJ_ORDEM) as TJ_ORDEM,
	trim(STJ.TJ_DTORIGI) as TJ_DTORIGI
from STJ010 as STJ
where
		STJ.D_E_L_E_T_ = ''
	and (year(STJ.TJ_DTORIGI) = 2021 or year(STJ.TJ_DTORIGI) = 2020)