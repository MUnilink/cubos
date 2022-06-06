select
	C1_RESIDUO,
	C1_APROV,
	C1_QUJE,
	C1_QUANT,
	*
from SC1010 as SC1 (nolock)
where cast(SC1.C1_NUM as int) > 769