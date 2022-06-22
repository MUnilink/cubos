select
	trim(isnull(SN1.N1_CBASE, '-')) as N1_CBASE,
	trim(isnull(SN1.N1_DESCRIC, '-')) as N1_DESCRIC,
	trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,

	/*isnull(trim(SN1.N1_FILIAL) + trim(SN1.N1_NFISCAL) + trim(SN1.N1_NSERIE) + trim(SN1.N1_FORNEC) + trim(SN1.N1_LOJA), '-') as ID_NF_ATIVO,*/

	trim(isnull(SNG.NG_DESCRIC, '-')) as NG_DESCRIC,
	trim(isnull(SNG.NG_CCONTAB, '-')) as CONTABEM,
	trim(isnull(SNG.NG_CCDEPR, '-')) as CTDEPRACC,
	trim(isnull(SNG.NG_CDEPREC, '-')) as CTDESPDEPR

from SN1010 as SN1 (nolock)
	inner join SNG010 as SNG (nolock)
		on SNG.D_E_L_E_T_ = ''
		and SNG.NG_GRUPO = SN1.N1_GRUPO/*
	left join SD1010 as SD1 (nolock)
		on SD1.D_E_L_E_T_ = ''
		and SD1.D1_FILIAL = SN1.N1_FILIAL
		and SD1.D1_DOC = SN1.N1_NFISCAL
		and SD1.D1_SDOC = SN1.N1_NSERIE
		and SD1.D1_FORNECE = SN1.N1_FORNEC
		and SD1.D1_LOJA = SN1.N1_LOJA
		and SD1.D1_ITEM = SN1.N1_NFITEM*/
	left join ST9010 as ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = SN1.N1_CODBEM
where SN1.D_E_L_E_T_ = ''