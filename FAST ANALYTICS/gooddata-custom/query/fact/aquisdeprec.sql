select
	trim(isnull(SN1.N1_CBASE, '-')) as N1_CBASE,
	SN3.N3_DINDEPR,
	SNG.NG_TXDEPR1 /12 as DEPRECMENSAL,
	SN1.N1_QUANTD,
	
	SN3.N3_VORIG1,
	SN3.N3_VORIG2,
	SN3.N3_VORIG3,
	SN3.N3_VORIG4,
	SN3.N3_VORIG5,

	SN3.N3_TXDEPR1,
	SN3.N3_TXDEPR2,
	SN3.N3_TXDEPR3,
	SN3.N3_TXDEPR4,
	SN3.N3_TXDEPR5,

	trim(isnull(CTT.CTT_CUSTO, '-')) as CTT_CUSTO,
	trim(isnull(CTD.CTD_ITEM, '-')) as CTD_ITEM,

	case when (12 * (100 / SNG.NG_TXDEPR1)) > datediff(month, SN3.N3_DINDEPR, getdate()) then SN3.N3_VORIG1 * (SNG.NG_TXDEPR1 / 1200) else 0.0 end as VALDEP

from SN1010 as SN1 (nolock)
	inner join SNG010 as SNG (nolock)
		on SNG.D_E_L_E_T_ = ''
		and SNG.NG_GRUPO = SN1.N1_GRUPO
	left join SN3010 as SN3 (nolock)
		on SN3.D_E_L_E_T_ = ''
		and cast(SN3.N3_TIPO as int) = 1
		and SN3.N3_FILIAL = SN1.N1_FILIAL
		and SN3.N3_CBASE = SN1.N1_CBASE

		left join CTT010 as CTT (nolock)
			on CTT.D_E_L_E_T_ = ''
			and CTT.CTT_CUSTO = SN3.N3_CUSTBEM
			and CTT.CTT_CUSTO = SN3.N3_CCUSTO
		left join CTD010 as CTD (nolock)
			on CTD.D_E_L_E_T_ = ''
			and CTD.CTD_ITEM = SN3.N3_SUBCCON

	left join SD1010 as SD1 (nolock)
		on SD1.D_E_L_E_T_ = ''
		and SN1.N1_FILIAL = SD1.D1_FILIAL
		and SN1.N1_FORNEC = SD1.D1_FORNECE
		and SN1.N1_LOJA = SD1.D1_LOJA
		and SN1.N1_NFISCAL = SD1.D1_DOC
		and SN1.N1_NSERIE = SD1.D1_SDOC
		and SN1.N1_NFITEM = SD1.D1_ITEM

where
		SN3.N3_DINDEPR between <<START_DATE>> AND <<FINAL_DATE>>
	and cast(SNG.NG_TXDEPR1 as decimal) > 0
	and SN1.D_E_L_E_T_ = ''