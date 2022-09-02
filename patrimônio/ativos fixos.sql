select
    SN1.N1_GRUPO,
	trim(isnull(SN1.N1_CBASE, '-')) as N1_CBASE,
	trim(isnull(SN1.N1_DESCRIC, '-')) as N1_DESCRIC,
    trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,
	convert(date, SN3.N3_DINDEPR, 103) as N3_DINDEPR,
	SNG.NG_TXDEPR1 /12 as TXDEPRECMENSAL,

	SN1.N1_QUANTD,
	SN3.N3_VORIG1,
	SN3.N3_VORIG2,
	SN3.N3_VORIG3,
	SN3.N3_VORIG4,
	SN3.N3_VORIG5,

    SN1.N1_NFISCAL,

	SN3.N3_TXDEPR1,
	SN3.N3_TXDEPR2,
	SN3.N3_TXDEPR3,
	SN3.N3_TXDEPR4,
	SN3.N3_TXDEPR5,

	datediff(month, SN3.N3_DINDEPR, cast('20220731' as date)) TEMPO_ATIVO,
	100 / (SNG.NG_TXDEPR1 /12) as TEMPO_DEPREC,
	SN3.N3_VORIG1 * (SNG.NG_TXDEPR1 / 1200) as DEPRECMENSAL,
    case when (12 * (100 / SNG.NG_TXDEPR1)) > datediff(month, SN3.N3_DINDEPR, cast('20220731' as date)) then SN3.N3_VORIG1 * (SNG.NG_TXDEPR1 / 1200) else 0.0 end as DEPRECATUAL,
    case when (12 * (100 / SNG.NG_TXDEPR1)) > datediff(month, SN3.N3_DINDEPR, cast('20220731' as date)) then ((12 * (100 / SNG.NG_TXDEPR1)) - datediff(month, SN3.N3_DINDEPR, cast('20220731' as date))) * SN3.N3_VORIG1 * (SNG.NG_TXDEPR1 / 1200) else 0.0 end as RESIDUAL
    
from SN1010 SN1 (nolock)
    left join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and ST9.T9_CODBEM = SN1.N1_CODBEM
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
