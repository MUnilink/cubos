select
	trim(TQT.TQT_MEDIDA) as TQT_MEDIDA,
	trim(TQT.TQT_DESMED) as TQT_DESMED
from TQT010 TQT
where TQT.D_E_L_E_T_ = ''
