select
	trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,
	trim(isnull(TQR.TQR_DESMOD, '-')) as TQR_DESMOD,
	trim(isnull(ST9.T9_PLACA, '-')) as T9_PLACA,
	trim(isnull(ST9.T9_CODFAMI, '-')) as T9_CODFAMI,

	convert(datetime, ST9.T9_DTCOMPR, 113) as T9_DTCOMPR,

	trim(isnull(ST7.T7_NOME, '-')) as T7_NOME,
	trim(isnull(ST9.T9_CHASSI, '-')) as T9_CHASSI,
	trim(isnull(ST9.T9_ANOMOD, '-')) as T9_ANOMOD,
	trim(isnull(ST9.T9_ANOFAB, '-')) as T9_ANOFAB,
	trim(isnull(ST9.T9_RENAVAM, '-')) as T9_RENAVAM,

	trim(isnull(ST9.T9_ITEMCTA, '-')) as T9_ITEMCTA,
	trim(isnull(ST9.T9_CCUSTO, '-')) as T9_CCUSTO

from ST9010 as ST9 (nolock)
	inner join TQR010 as TQR (nolock)
		on TQR.D_E_L_E_T_ = ''
		and TQR.TQR_TIPMOD = ST9.T9_TIPMOD
		and trim(TQR.TQR_DESMOD) not like 'PNEU%'

		inner join ST7010 as ST7 (nolock)
			on ST7.D_E_L_E_T_ = ''
			and ST7.T7_FABRICA = TQR.TQR_FABRIC
where
		ST9.D_E_L_E_T_ = ''
	and ST9.T9_CODFAMI != 'PN'