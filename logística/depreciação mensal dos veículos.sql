select
    substring(STP.TP_DTLEITU, 1, 6) as PERIODO,
    STP.TP_DTLEITU,
    SN1.N1_GRUPO,
	trim(isnull(SN1.N1_CBASE, '-')) as N1_CBASE,
    trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,
	convert(date, SN3.N3_DINDEPR, 103) as N3_DINDEPR,
	SNG.NG_TXDEPR1 /12 as NG_MENSAL1,

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

	datediff(day, SN3.N3_DINDEPR, STP.TP_DTLEITU) as DIAS_ATIVO,
	(100 / (SN3.N3_TXDEPR1 / 365.25)) as DIAS_DEPREC,
    datediff(day, SN3.N3_DINDEPR, STP.TP_DTLEITU) /12 MESES_ATIVO,
	(100 / (SN3.N3_TXDEPR1 / 365.25))/12 as MESES_DEPREC,

	SN3.N3_VORIG1 * (SN3.N3_TXDEPR1 / 1200) as DEPRECMENSAL,
    case when (12 * (100 / SN3.N3_TXDEPR1)) > datediff(month, SN3.N3_DINDEPR, STP.TP_DTLEITU) then SN3.N3_VORIG1 * (SN3.N3_TXDEPR1 / 1200) else 0.0 end as DEPRECATUAL
    
from SN1010 SN1 (nolock)
    inner join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and ST9.T9_CODBEM = SN1.N1_CODBEM

        inner join STP010 STP (nolock)
            on STP.D_E_L_E_T_ = ''
            and STP.TP_CODBEM = ST9.T9_CODBEM
            and STP.TP_CODBEM like 'CM502%'

	inner join SNG010 SNG (nolock)
		on SNG.D_E_L_E_T_ = ''
		and SNG.NG_GRUPO = SN1.N1_GRUPO
	left join SN3010 SN3 (nolock)
		on SN3.D_E_L_E_T_ = ''
		and cast(SN3.N3_TIPO as int) = 1
		and SN3.N3_FILIAL = SN1.N1_FILIAL
		and SN3.N3_CBASE = SN1.N1_CBASE
where
        SN1.D_E_L_E_T_ = ''
    and cast(SNG.NG_TXDEPR1 as decimal) > 0
