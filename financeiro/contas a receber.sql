select
	trim(SE1.E1_FILIAL) as FILIAL_TITULO,
	trim(SE1.E1_PREFIXO) as PREFIXO,
	trim(SE1.E1_NUM) as TITULO,
	trim(SE1.E1_TIPO) as TIPO_TITULO,
	cast(SE1.E1_EMISSAO as date) as DATA_TITULO,
	left(SE1.E1_EMISSAO, 6) as PERIODO,
	cast(SE1.E1_VENCTO as date) as VENCIMENTO,
	left(SE1.E1_VENCTO, 6) as PERIODO_VENCIMENTO,
	cast(SE1.E1_VENCREA as date) as VENCREAL,
	left(SE1.E1_VENCREA, 6) as PERIODO_VENCREAL,
	cast(SE1.E1_BAIXA as date) as BAIXA,
	SE1.E1_PARCELA as PARCELA,
	cast(SE1.E1_VALOR as numeric(15 ,2)) as VALOR_TITULO,
	trim(SA1.A1_NOME) as NOME_CLIENTE,
	trim(SE1.E1_CLIENTE) as CLIENTE,
	trim(SE1.E1_LOJA) as LOJA,
	trim(SA1.A1_CGC) as CNPJ,
	trim(SA1.A1_EST) as UF,

	month(SE1.E1_EMISSAO) as TITULO_MES,
	year(SE1.E1_EMISSAO) as TITULO_ANO,
	month(SE1.E1_VENCTO) as VENCIMENTO_MES,
	year(SE1.E1_VENCTO) as VENCIMENTO_ANO,
	month(SE1.E1_VENCREA) as VENCREAL_MES,
	year(SE1.E1_VENCREA) as VENCREAL_ANO,

    trim(SE1.E1_HIST) as HISTORICO,
	trim(CTD.CTD_DESC01) as ATIVIDADE,
	trim(CTT.CTT_DESC01) as CCUSTO,
	trim(SE1.E1_CCUSTO) as CC,
	trim(SE1.E1_ITEMCTA) as AT,
    cast(SE1.E1_SALDO as numeric(15, 2)) as SALDO,
    cast(SE1.E1_DESCONT as numeric(15, 2)) as DESCONT,
    cast(SE1.E1_MULTA as numeric(15, 2)) as MULTA,
    cast(SE1.E1_JUROS as numeric(15, 2)) as JUROS,
    cast(SE1.E1_CORREC as numeric(15, 2)) as CORREC,
    cast(SE1.E1_VALLIQ as numeric(15, 2)) as VALOR_LIQ,
    SE1.E1_NUMBOR as BORDERO,
    trim(SE1.E1_YTITORI) as TITULO_ORI,
    trim(SE1.E1_ORIGEM) as ORIGEM,

	trim(SE1.E1_NATUREZ) as NATUREZA,
	trim(SED.ED_DESCRIC) as DESC_NATUREZA,
    trim(SE1.E1_DEBITO) as CONTA_DEB,
    trim(SE1.E1_CREDIT) as CONTA_CRE,
    trim(SE1.E1_CCD) as CC_DEB,
    trim(SE1.E1_ITEMD) as ITEMC_DEB,
    trim(SE1.E1_CCC) as CC_CRE,
    trim(SE1.E1_ITEMC) as ITEMC_CRE,
	
    trim(SC6.C6_FILIAL) as FILIAL,
	trim(SB1.B1_COD) as PRODUTO,
	trim(SB1.B1_DESC) as NOMEPRODUTO,
	trim(SB1.B1_GRUPO) as GRUPO,
	trim(SB1.B1_UM) as UN,
    trim(SC6.C6_NUM) as PEDIDO,
    trim(SC6.C6_ITEM) as ITEMPV,
    trim(SC6.C6_UM) as UN_PEDIDO,
    trim(SC6.C6_CC) as CC_PEDIDO,
    trim(SC6.C6_ITEMCTA) as ATIVIDADE_PEDIDO,
    cast(SC6.C6_ENTREG as date) as DT_ITEMPV,
    cast(SC6.C6_QTDVEN as numeric(15, 2)) as QTD_PEDIDO,
    cast(SC6.C6_PRCVEN as numeric(15, 2)) as PRECO_PEDIDO,
    cast(SC6.C6_VALOR as numeric(15, 2)) as VALOR_PEDIDO,

	SD2.D2_DOC as NF_DOC,
	SD2.D2_SERIE as NF_SERIE,
	cast(SD2.D2_EMISSAO as date) as NF_DATA,
	substring(SD2.D2_EMISSAO, 1, 6) as NF_PERIODO,
	
	SD2.D2_CCUSTO as NF_CC,
	SD2.D2_ITEMCC as NF_AT,
	SD2.D2_ITEM as NF_ITEM,
	SD2.D2_QUANT as NF_QUANT,
	SD2.D2_PRUNIT as NF_VUNIT,
	SD2.D2_TOTAL as NF_TOTAL,
	SD2.D2_TES as NF_TES,
	SD2.D2_DESCON as NF_VALDESC,

    cast(coalesce(SD2.D2_QUANT, 0) as decimal(13, 3)) AS QTD_FATURADA_ITEM,
    cast(coalesce(SD2.D2_VALBRUT, 0) as decimal(14, 2)) as VL_FATURAMENTO_TOTAL,
    cast(coalesce(SD2.D2_VALICM, 0) as decimal(14, 2)) as VL_ICMS_FATURAMENTO,
    cast(coalesce(SD2.D2_VALIPI, 0) as decimal(14, 2)) as VL_IPI_FATURAMENTO,
    cast(coalesce(SD2.D2_VALFRE, 0) as decimal(14, 2)) as VL_FRETE_NF,
    cast(coalesce(SD2.D2_DESPESA, 0) as decimal(14, 2)) as VL_DESPESA,
    cast(coalesce(SD2.D2_TOTAL, 0) as decimal(14, 2)) as VL_FATURAMENTO_MERCADORIA,
    cast(coalesce(SD2.D2_VALIMP6, 0) as decimal(14, 2)) as VL_PIS_FATURAMENTO,
    cast(coalesce(SD2.D2_VALIMP5, 0) as decimal(14, 2)) as VL_COFINS_FATURAMENTO,
    cast(coalesce(SD2.D2_VALISS, 0) as decimal(14, 2)) as VL_ISS_FATURAMENTO,
    cast(coalesce(SD2.D2_ICMSRET, 0) as decimal(14, 2)) as VL_ICMS_SUBST_FATURAMENTO,
    cast(coalesce(SD2.D2_DESCON, 0) as decimal(12, 2)) as VL_DESCONTO_FATURAMENTO,
    cast(coalesce(SD2.D2_VALIRRF, 0) as decimal(14, 2)) as VL_IRF_FATURAMENTO,
    cast(coalesce(SD2.D2_VALINS, 0) as decimal(14, 2)) as VL_INSS_FATURAMENTO,
    cast(coalesce(SD2.D2_PRUNIT, 0) as decimal(16, 4)) as VL_UNITARIO,
    cast(coalesce(SD2.D2_SEGURO, 0) as decimal(14, 2)) as VL_SEGURO,
    cast(coalesce(SD2.D2_PESO * SD2.D2_QUANT, 0) as decimal(12, 4)) as PESO_LIQUIDO,
    1 as contador

from SE1010 SE1 (nolock)
	left join SA1010 SA1 (nolock)
		on SA1.D_E_L_E_T_ = ''
		and SA1.A1_COD = SE1.E1_CLIENTE
		and SA1.A1_LOJA = SE1.E1_LOJA
	
    left join SD2010 SD2 (nolock)
        on SD2.D2_FILIAL = SE1.E1_FILIAL
        and SD2.D2_DOC = SE1.E1_NUM
        and SD2.D2_CLIENTE = SE1.E1_CLIENTE
        and SD2.D2_LOJA = SE1.E1_LOJA
        and SD2.D_E_L_E_T_ = ''
	
        left join SC6010 SC6 (nolock)
            on SC6.D_E_L_E_T_ = ''
            and SC6.C6_FILIAL = SD2.D2_FILIAL
            and SC6.C6_NUM = SD2.D2_PEDIDO
            and SC6.C6_ITEM = SD2.D2_ITEMPV
        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD2.D2_COD

            left join SBM010 SBM (nolock)
                on SBM.D_E_L_E_T_ = ''
                and SBM.BM_GRUPO = SB1.B1_GRUPO
        
    left join CTT010 CTT (nolock)
        on CTT.D_E_L_E_T_ = ''
        and CTT.CTT_CUSTO = SE1.E1_CCUSTO
    left join CTD010 CTD (nolock)
        on CTD.D_E_L_E_T_ = ''
        and CTD.CTD_ITEM = SE1.E1_ITEMCTA
	left join SED010 SED (nolock)
		on SED.D_E_L_E_T_ = ''
		and SED.ED_CODIGO = SE1.E1_NATUREZ

where SE1.D_E_L_E_T_ = ''
