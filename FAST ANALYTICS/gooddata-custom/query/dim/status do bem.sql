select
	trim(TQY.TQY_STATUS) as TQY_STATUS,
	trim(TQY.TQY_DESTAT) as TQY_DESTAT
from TQY010 TQY
where TQY.D_E_L_E_T_ = ''
