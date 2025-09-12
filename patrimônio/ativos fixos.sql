
select
    trim(SN1.N1_GRUPO) as GRUPO_ATIVO,
	trim(SN1.N1_CBASE) as N1_CBASE,
	trim(SN1.N1_DESCRIC) as N1_DESCRIC,
	trim(SN3.N3_ITEM) as ITEM_ATIVO,
    trim(ST9.T9_CODBEM) as T9_CODBEM,
	cast(SN3.N3_DINDEPR as date) as DATA_INIDEP,
	cast(SN3.N3_AQUISIC as date) as DATA_AQUIS,
	cast(SN3.N3_DTBAIXA as date) as DATA_BAIXA,
	(select trim(SX5010.X5_DESCRI) from SX5010 where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = 'G1' and SX5010.X5_CHAVE = SN3.N3_TIPO) as TIPO_ATIVO,
	SN3.N3_TXDEPR1 /12 as TXDEPRECMENSAL,
	SNG.NG_TXDEPR1 /12 as TXDEPRECMENSALGRUPO,

	trim(SN1.N1_FORNEC) as COD_FOR,
	trim(SN1.N1_LOJA) as LOJA_FOR,
	trim(SN1.N1_NFISCAL) as NFISCAL,
	cast(SN1.N1_DTCLASS as date) as DATA_CLASS,
	trim(SA2.A2_NOME) as FORNECEDOR,

	trim(SN3.N3_CUSTBEM) as CC,
	trim(SN3.N3_SUBCCON) as ATIVIDADE,
	trim(SN3.N3_CCUSTO) as CC_DESPESA,
	trim(SN3.N3_SUBCTA) as ATIV_DESPESA,
	trim(SN3.N3_CCCDEP) as CC_DEPR_ACUM,
	trim(SN3.N3_SUBCCDE) as ATIV_DEPR_ACUM,
	trim(SN3.N3_CCDESP) as CC_DESP_DEPR,
	trim(SN3.N3_SUBCDEP) as ATIV_DESP_DEPR,

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

	trim(SN3.N3_CCONTAB) as CONTA,
	trim(SN3.N3_CDEPREC) as CONTA_DESDEPR,
	trim(SN3.N3_CCDEPR) as CONTA_DEPACUM,
	trim(SN3.N3_CDESP) as CONTA_CORDEPR,
	trim(SN3.N3_CCORREC) as CONTA_CORRBEM,
	trim(SN3.N3_HISTOR) as HISTORICO,
	
	datefromparts(2024, 12, 31) as DATA_BASE,
	datediff(month, SN3.N3_DINDEPR, datefromparts(2024, 12, 31)) as TEMPO_ATIVO,
	case when cast(SN3.N3_TXDEPR1 as numeric(15, 2)) != 0.00 then 100 / (SN3.N3_TXDEPR1 /12) else 0.0 end as TEMPO_DEPREC,
	SN3.N3_VORIG1 * (SN3.N3_TXDEPR1 / 1200) as DEPRECMENSAL,
    case when cast(SN3.N3_TXDEPR1 as numeric(15, 2)) != 0.00 and (12 * (100 / SN3.N3_TXDEPR1)) > datediff(month, SN3.N3_DINDEPR, datefromparts(2024, 12, 31)) then SN3.N3_VORIG1 * (SN3.N3_TXDEPR1 / 1200) else 0.0 end as DEPRECATUAL,
    case when cast(SN3.N3_TXDEPR1 as numeric(15, 2)) != 0.00 and (12 * (100 / SN3.N3_TXDEPR1)) > datediff(month, SN3.N3_DINDEPR, datefromparts(2024, 12, 31)) then ((12 * (100 / SN3.N3_TXDEPR1)) - datediff(month, SN3.N3_DINDEPR, datefromparts(2024, 12, 31))) * SN3.N3_VORIG1 * (SN3.N3_TXDEPR1 / 1200) else 0.0 end as RESIDUAL,
	case when cast(SN3.N3_TXDEPR1 as numeric(15, 2)) != 0.00 and (12 * (100 / SN3.N3_TXDEPR1)) > datediff(month, SN3.N3_DINDEPR, datefromparts(2024, 12, 31)) then (SN3.N3_VORIG1 * (SN3.N3_TXDEPR1 / 1200)) * datediff(month, SN3.N3_DINDEPR, datefromparts(2024, 12, 31)) else SN3.N3_VORIG1 end as ACUMULADO/*,((datediff(day, datefromparts(day(datefromparts(@), 12, 31exercicio), 1, 1), datefromparts(2024, 12, 31)))/30.0) * SN3.N3_VORIG1 * (SN3.N3_TXDEPR1 / 1200) as EXERCICIO*/

from SN1010 SN1 (nolock)
    left join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and ST9.T9_CODBEM = SN1.N1_CODBEM
	left join SNG010 SNG (nolock)
		on SNG.D_E_L_E_T_ = ''
		and SNG.NG_GRUPO = SN1.N1_GRUPO
	left join SN3010 SN3 (nolock)
		on SN3.D_E_L_E_T_ = ''
		and SN3.N3_FILIAL = SN1.N1_FILIAL
		and SN3.N3_CBASE = SN1.N1_CBASE
		and SN3.N3_ITEM = SN1.N1_ITEM
	left join SA2010 SA2 (nolock)
		on SA2.D_E_L_E_T_ = ''
		and SA2.A2_COD = SN1.N1_FORNEC
		and SA2.A2_LOJA = SN1.N1_LOJA
where
        SN1.D_E_L_E_T_ = ''
