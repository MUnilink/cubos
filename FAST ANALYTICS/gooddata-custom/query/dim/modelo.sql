select
	trim(TQR.TQR_TIPMOD) as TQR_TIPMOD,

	case when cast(TQR.TQR_TIPMOD as int) in ('61', '82') then trim(TQR.TQR_DESMOD) + ' - REACH STACKER'
		else
		case when cast(TQR.TQR_TIPMOD as int) in ('10', '37', '63', '64', '65', '68', '69', '70', '71', '72', '73', '89', '117') then trim(TQR.TQR_DESMOD) + ' - FORKLIFT'
			else trim(TQR.TQR_DESMOD)
		end
	end as TQR_DESMOD,

	trim(TQR.TQR_FABRIC) as TQR_FABRIC
from TQR010 as TQR
where TQR.D_E_L_E_T_ = ''