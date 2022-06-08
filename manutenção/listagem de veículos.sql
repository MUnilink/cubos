select
	trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,
	trim(isnull(TQR.TQR_DESMOD, '-')) as MODELO,
	trim(isnull(ST9.T9_PLACA, '-')) as T9_PLACA,
	trim(isnull(ST9.T9_CODFAMI, '-')) as T9_CODFAMI,
	convert(date, ST9.T9_DTCOMPR, 103) as T9_DTCOMPR,
	trim(isnull(ST7.T7_NOME, '-')) as FABRICANTE,
	trim(isnull(ST9.T9_CHASSI, '-')) as T9_CHASSI,
	trim(isnull(ST9.T9_ANOMOD, '-')) as T9_ANOMOD,
	trim(isnull(ST9.T9_ANOFAB, '-')) as T9_ANOFAB,
	trim(isnull(ST9.T9_RENAVAM, '-')) as T9_RENAVAM,
	trim(isnull(ST9.T9_SITMAN, '-')) as T9_SITMAN,
	trim(isnull(ST9.T9_SITBEM, '-')) as T9_SITBEM,

	trim(isnull(ST9.T9_ITEMCTA, '-')) as T9_ITEMCTA,
	trim(isnull(ST9.T9_CCUSTO, '-')) as T9_CCUSTO,
	trim(isnull(CTT.CTT_DESC01, '-')) as CC,
	trim(isnull(CTD.CTD_DESC01, '-')) as ATIVIDADE

from ST9010 ST9 (nolock)
	inner join TQR010 TQR (nolock)
		on TQR.D_E_L_E_T_ = ''
		and TQR.TQR_TIPMOD = ST9.T9_TIPMOD
		inner join ST7010 ST7 (nolock)
			on ST7.D_E_L_E_T_ = ''
			and ST7.T7_FABRICA = TQR.TQR_FABRIC

	inner join CTT010 CTT (nolock)
		on CTT.D_E_L_E_T_ = ''
		and CTT.CTT_CUSTO = ST9.T9_CCUSTO
	inner join CTD010 CTD (nolock)
		on CTD.D_E_L_E_T_ = ''
		and CTD.CTD_ITEM = ST9.T9_ITEMCTA
where
		ST9.D_E_L_E_T_ = ''
	and ST9.T9_CODFAMI != 'PN'
