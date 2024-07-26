select
	ZC4.ZC4_FILIAL as FILIAL,
	ZC4.ZC4_CODBEM as VEICULO,
	ZC4.ZC4_VLBEM as VALOR_VEI,
	ZC4.ZC4_VLSEG as VALOR_SEG,
	cast((ZC4.ZC4_VLSEG/(datediff(day, ZC4.ZC4_DTVGIN, ZC4.ZC4_DTVGFI)/365.0))/12 as numeric(15, 2)) as VALOR_SEG_MES,
	cast(ZC4.ZC4_VLSEG/(datediff(day, ZC4.ZC4_DTVGIN, ZC4.ZC4_DTVGFI)/365.0) as numeric(15, 2)) as VALOR_SEG_ANO,
	ZC4.ZC4_PROPRI as PROPRIO,
	convert(date, ZC4.ZC4_DTVGIN, 103) as INI_VIG,
	convert(date, ZC4.ZC4_DTVGFI, 103) as FIM_VIG,
	substring(ZC4.ZC4_DTVGIN, 1, 6) as PERIODO_FIM,
	substring(ZC4.ZC4_DTVGFI, 1, 6) as PERIODO_INI,
	cast(datediff(day, ZC4.ZC4_DTVGIN, ZC4.ZC4_DTVGFI)/365.0 as numeric(15, 5)) as ANOS
from ZC4010 ZC4 (nolock)
where ZC4.D_E_L_E_T_ = ''
