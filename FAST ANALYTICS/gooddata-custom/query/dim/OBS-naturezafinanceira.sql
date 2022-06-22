select
	trim(SED.ED_CODIGO) as ED_CODIGO,
	trim(SED.ED_DESCRIC) as ED_DESCRIC
from SED010 as SED
where SED.D_E_L_E_T_ = ''