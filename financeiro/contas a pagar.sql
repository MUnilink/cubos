select
	trim(SE2.E2_FILIAL) as FILIAL_TITULO,
	trim(SE2.E2_PREFIXO) as PREFIXO,
	trim(SE2.E2_NUM) as TITULO,
	trim(SE2.E2_TIPO) as TIPO_TITULO,
	SE2.E2_PARCELA as PARCELA,
	cast(SE2.E2_VALOR as numeric(15, 2)) as VALOR_TITULO,
	trim(SA2.A2_NOME) as NOME_FORNECEDOR,
	trim(SE2.E2_FORNECE) as FORNECEDOR,
	trim(SE2.E2_LOJA) as LOJA,
	trim(SA2.A2_CGC) as CNPJ,
	trim(SA2.A2_EST) as UF,

	cast(SE2.E2_EMISSAO as date) as DATA_TITULO,
	left(SE2.E2_EMISSAO, 6) as PERIODO_TITULO,
	cast(SE2.E2_VENCTO as date) as VENCIMENTO,
	left(SE2.E2_VENCTO, 6) as PERIODO_VENCIMENTO,
	cast(SE2.E2_VENCREA as date) as VENCREAL,
	left(SE2.E2_VENCREA, 6) as PERIODO_VENCREAL,
	cast(SE2.E2_BAIXA as date) as BAIXA,
	left(SE2.E2_BAIXA, 6) as PERIODO_BAIXA,
	month(SE2.E2_EMISSAO) as MES_TITULO,
	year(SE2.E2_EMISSAO) as ANO_TITULO,
	month(SE2.E2_VENCTO) as MES_VENCIMENTO,
	year(SE2.E2_VENCTO) as ANO_VENCIMENTO,
	month(SE2.E2_VENCREA) as MES_VENCREAL,
	year(SE2.E2_VENCREA) as ANO_VENCREAL,
	month(SE2.E2_BAIXA) as MES_BAIXA,
	year(SE2.E2_BAIXA) as ANO_BAIXA,

    trim(SE2.E2_HIST) as HISTORICO,
	trim(CTD.CTD_DESC01) as ATIVIDADE,
	trim(CTT.CTT_DESC01) as CCUSTO,
	trim(SE2.E2_CCUSTO) as CC,
	trim(SE2.E2_ITEMCTA) as AT,
    cast(SE2.E2_SALDO as numeric(15, 2)) as SALDO,
    cast(SE2.E2_DESCONT as numeric(15, 2)) as DESCONT,
    cast(SE2.E2_MULTA as numeric(15, 2)) as MULTA,
    cast(SE2.E2_JUROS as numeric(15, 2)) as JUROS,
    cast(SE2.E2_CORREC as numeric(15, 2)) as CORREC,
    cast(SE2.E2_VALLIQ as numeric(15, 2)) as VALOR_LIQ,
    SE2.E2_NUMBOR as BORDERO,
    trim(SE2.E2_TITORIG) as TITULO_ORI,
    trim(SE2.E2_ORIGEM) as ORIGEM,
    cast(SE2.E2_DATALIB as date) as DT_LIBTIT,
    upper(trim(SE2.E2_APROVA)) as APR_TITULO,
    upper(trim(SE2.E2_USUALIB)) as LIB_TITULO,

	(select top 1 concat(trim(SA6010.A6_COD), ' - ', trim(SA6010.A6_NOME)) from SA6010 where SA6010.D_E_L_E_T_ = '' and SA6010.A6_COD = SE2.E2_PORTADO) as BC_PORTADOR,
	(select top 1 concat(trim(SA6010.A6_COD), ' - ', trim(SA6010.A6_NOME)) from SA6010 where SA6010.D_E_L_E_T_ = '' and SA6010.A6_COD = SE2.E2_BCOPAG) as BC_PAGAMENTO,
	trim(SE2.E2_NATUREZ) as NATUREZA,
	trim(SED.ED_DESCRIC) as DESC_NATUREZA,
    trim(SE2.E2_CONTAD) as CONTA,
    trim(SE2.E2_DEBITO) as CONTA_DEB,
    trim(SE2.E2_CREDIT) as CONTA_CRE,
    trim(SE2.E2_CCD) as CC_DEB,
    trim(SE2.E2_ITEMD) as ITEMC_DEB,
    trim(SE2.E2_CCC) as CC_CRE,
    trim(SE2.E2_ITEMC) as ITEMC_CRE,

	SF1.F1_DOC as NF_DOC,
	SF1.F1_SERIE as NF_SERIE,
	cast(SF1.F1_EMISSAO as date) as NF_EMI,
	cast(SF1.F1_DTDIGIT as date) as NF_DATA,
	left(SF1.F1_DTDIGIT, 6) as NF_PERIODO,
	concat(trim(SF1.F1_COND), ' - ', (select trim(SE4010.E4_COND) from SE4010 where SE4010.D_E_L_E_T_ = '' and SE4010.E4_COND = SF1.F1_COND)) as COND_PGTO,

	cast(SF1.F1_VALBRUT as numeric(14, 2)) as VL_NFENT_BRUTO,
    cast(SF1.F1_VALMERC as numeric(14, 2)) as VL_NFENT_ICMS,
    cast(SF1.F1_VALIPI as numeric(14, 2)) as VL_NFENT_IPI,
    cast(SF1.F1_DESPESA as numeric(14, 2)) as VL_NFENT_DESPESA,
    cast(SF1.F1_VALIMP6 as numeric(14, 2)) as VL_NFENT_PIS,
    cast(SF1.F1_VALIMP5 as numeric(14, 2)) as VL_NFENT_COFINS,
    cast(SF1.F1_ICMSRET as numeric(14, 2)) as VL_NFENT_ICMS_SUBST,
	cast(SF1.F1_SEGURO as numeric(14, 2)) as VL_NFENT_SEGURO,
	cast(SF1.F1_PESOL as numeric(12, 4)) as PESO_LIQUIDO_NFENT

from SE2010 SE2 (nolock)
	left join SA2010 SA2 (nolock)
		on SA2.D_E_L_E_T_ = ''
		and SA2.A2_COD = SE2.E2_FORNECE
		and SA2.A2_LOJA = SE2.E2_LOJA
    left join SF1010 SF1 (nolock)
        on trim(SE2.E2_TIPO) = 'NF'
        and SF1.F1_FILIAL = SE2.E2_FILIAL
        and SF1.F1_DOC = SE2.E2_NUM
        and SF1.F1_FORNECE = SE2.E2_FORNECE
        and SF1.F1_LOJA = SE2.E2_LOJA
        and SF1.D_E_L_E_T_ = ''
    left join CTT010 CTT (nolock)
        on CTT.D_E_L_E_T_ = ''
        and CTT.CTT_CUSTO = SE2.E2_CCUSTO
    left join CTD010 CTD (nolock)
        on CTD.D_E_L_E_T_ = ''
        and CTD.CTD_ITEM = SE2.E2_ITEMCTA
	left join SED010 SED (nolock)
		on SED.D_E_L_E_T_ = ''
		and SED.ED_CODIGO = SE2.E2_NATUREZ

where SE2.D_E_L_E_T_ = ''
