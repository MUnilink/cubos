select
	trim(TS0.TS0_DOCTO) as TS0_DOCTO,
	trim(TS0.TS0_NOMDOC) as TS0_NOMDOC,
	trim(TS0.TS0_PREFIX) as TS0_PREFIX,
	trim(TS0.TS0_CONPAG) as TS0_CONPAG,
	
	isnull(trim(SA2.A2_COD) + trim(SA2.A2_LOJA), '-') as ID_FORNECE,
	trim(isnull(SED.ED_CODIGO + ' - ' + SED.ED_DESCRIC, '-')) as NATUREZAFINANC

from TS0010 TS0
	left join SA2010 SA2 
		on SA2.D_E_L_E_T_ = ''
		and SA2.A2_COD = TS0.TS0_FORNEC
		and SA2.A2_LOJA = TS0.TS0_LOJA
	left join SED010 SED
		on SED.D_E_L_E_T_ = ''
		and SED.ED_CODIGO = TS0.TS0_NATURE
	left join TS1010 TS1
		on TS1.D_E_L_E_T_ = ''
		and TS1.TS1_DOCTO = TS0.TS0_DOCTO
where TS0.D_E_L_E_T_ = ''