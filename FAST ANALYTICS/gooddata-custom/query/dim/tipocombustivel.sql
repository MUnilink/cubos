select
	trim(TQM.TQM_CODCOM) as TQM_CODCOM,
	trim(TQM.TQM_NOMCOM) as TQM_NOMCOM
from TQM010 as TQM
where TQM.D_E_L_E_T_ = ''