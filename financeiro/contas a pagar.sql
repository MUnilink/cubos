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

	trim(SE2.E2_NATUREZ) as NATUREZA,
	trim(SED.ED_DESCRIC) as DESC_NATUREZA,
    trim(SE2.E2_CONTAD) as CONTA,
    trim(SE2.E2_DEBITO) as CONTA_DEB,
    trim(SE2.E2_CREDIT) as CONTA_CRE,
    trim(SE2.E2_CCD) as CC_DEB,
    trim(SE2.E2_ITEMD) as ITEMC_DEB,
    trim(SE2.E2_CCC) as CC_CRE,
    trim(SE2.E2_ITEMC) as ITEMC_CRE,
	
    trim(SC7.C7_FILIAL) as FILIAL,
	trim(SB1.B1_COD) as PRODUTO,
	trim(SB1.B1_DESC) as NOMEPRODUTO,
	trim(SB1.B1_GRUPO) as GRUPO,
	trim(SB1.B1_UM) as UN,
	trim(SC7.C7_ITEMCTA) as PC_AT,
	trim(SC7.C7_CC) as PC_CC,
	left(SC7.C7_OP, 6) as OS,
	trim(SC7.C7_NUM) as PC_NUM,
	trim(SC7.C7_ITEM) as PC_ITEM,
	cast(SC7.C7_EMISSAO as date) as PC_DATA,
	left(SC7.C7_EMISSAO, 6) as PC_PERIODO,

	case SC7.C7_CONAPRO
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as APROVACAO_PC,

	(
		select upper(trim(max(SAK010.AK_LOGIN)))
        from SCR010 SCR
            inner join SAK010
                on SAK010.D_E_L_E_T_ = ''
                and SAK010.AK_COD = SCR.CR_LIBAPRO
		where
				SCR.D_E_L_E_T_ = ''
			and SCR.CR_TIPO = 'PC'
			and SCR.CR_FILIAL = SE2.E2_FILIAL
			and SCR.CR_NUM = SE2.E2_NUM
			and SCR.CR_NIVEL =
		(
			select max(SCR010.CR_NIVEL)
			from SCR010 (nolock)
			where
					SCR010.D_E_L_E_T_ = ''
				and SCR010.CR_TIPO = SCR.CR_TIPO
				and SCR010.CR_FILIAL = SCR.CR_FILIAL
				and SCR010.CR_NUM = SCR.CR_NUM
				and SCR010.CR_STATUS = '3'
		)
	) as APROVADOR,

	concat(trim(SC7.C7_COND), ' - ', trim(SE4.E4_DESCRI)) as CONDPGTO,
	cast(SC7.C7_QUANT as numeric(15, 2)) as QTD_PC_PEDIDA,
	cast(SC7.C7_QUJE as numeric(15, 2)) as QTD_PC_ATENDIDA,
	cast(SC7.C7_PRECO as numeric(15, 2)) as PC_PRECO,
	cast(SC7.C7_TOTAL as numeric(15, 2)) as PC_TOTAL,

	SD1.D1_DOC as NF_DOC,
	SD1.D1_SERIE as NF_SERIE,
	cast(SD1.D1_EMISSAO as date) as NF_EMI,
	cast(SD1.D1_DTDIGIT as date) as NF_DATA,
	left(SD1.D1_DTDIGIT, 6) as NF_PERIODO,
	
	trim(SD1.D1_CC) as NF_CC,
	trim(SD1.D1_ITEMCTA) as NF_AT,
	trim(SD1.D1_ITEM) as NF_ITEM,
	trim(SD1.D1_TES) as NF_TES,
	cast(SD1.D1_QUANT as numeric(15, 2)) as NF_QUANT,
	cast(SD1.D1_VUNIT as numeric(15, 2)) as NF_VUNIT,
	cast(SD1.D1_TOTAL as numeric(15, 2)) as NF_TOTAL,
	cast(SD1.D1_CUSTO as numeric(15, 2)) as NF_CUSTO,
	cast(SD1.D1_VALDESC as numeric(15, 2)) as NF_VALDESC,

    cast(SC7.C7_VALICM as numeric(14, 2)) as VL_PC_ICMS,
    cast(SC7.C7_VALIPI as numeric(14, 2)) as VL_PC_IPI,
    cast(SC7.C7_VALFRE as numeric(14, 2)) as VL_PC_FRETE_NF,
    cast(SC7.C7_DESPESA as numeric(14, 2)) as VL_PC_DESPESA,
    cast(SC7.C7_VALIMP6 as numeric(14, 2)) as VL_PC_PIS,
    cast(SC7.C7_VALIMP5 as numeric(14, 2)) as VL_PC_COFINS,
    cast(SC7.C7_VALISS as numeric(14, 2)) as VL_PC_ISS,
    cast(SC7.C7_ICMSRET as numeric(14, 2)) as VL_PC_ICMS_SUBST,
    cast(SC7.C7_DESC as numeric(12, 2)) as VL_PC_DESCONTO,
    cast(SC7.C7_VALINS as numeric(14, 2)) as VL_PC_INSS,
	cast(SC7.C7_SEGURO as numeric(14, 2)) as VL_PC_SEGURO,
	cast(SC7.C7_QUANT as numeric(13, 3)) as QTD_ITEM_PC,

    cast(SD1.D1_VALICM as numeric(14, 2)) as VL_NFENT_ICMS,
    cast(SD1.D1_VALIPI as numeric(14, 2)) as VL_NFENT_IPI,
    cast(SD1.D1_VALFRE as numeric(14, 2)) as VL_NFENT_FRETE_NF,
    cast(SD1.D1_DESPESA as numeric(14, 2)) as VL_NFENT_DESPESA,
    cast(SD1.D1_VALIMP6 as numeric(14, 2)) as VL_NFENT_PIS,
    cast(SD1.D1_VALIMP5 as numeric(14, 2)) as VL_NFENT_COFINS,
    cast(SD1.D1_VALISS as numeric(14, 2)) as VL_NFENT_ISS,
    cast(SD1.D1_ICMSRET as numeric(14, 2)) as VL_NFENT_ICMS_SUBST,
    cast(SD1.D1_DESC as numeric(12, 2)) as VL_NFENT_DESCONTO,
    cast(SD1.D1_VALIRR as numeric(14, 2)) as VL_NFENT_IRF,
    cast(SD1.D1_VALINS as numeric(14, 2)) as VL_NFENT_INSS,
	cast(SD1.D1_SEGURO as numeric(14, 2)) as VL_NFENT_SEGURO,
	cast(SD1.D1_PESO * SD1.D1_QUANT as numeric(12, 4)) as PESO_LIQUIDO_NFENT

from SE2010 SE2 (nolock)
	left join SA2010 SA2 (nolock)
		on SA2.D_E_L_E_T_ = ''
		and SA2.A2_COD = SE2.E2_FORNECE
		and SA2.A2_LOJA = SE2.E2_LOJA
	
    left join SD1010 SD1 (nolock)
        on trim(SE2.E2_TIPO) = 'NF'
        and SD1.D1_FILIAL = SE2.E2_FILIAL
        and SD1.D1_DOC = SE2.E2_NUM
        and SD1.D1_FORNECE = SE2.E2_FORNECE
        and SD1.D1_LOJA = SE2.E2_LOJA
        and SD1.D_E_L_E_T_ = ''
	
        left join SC7010 SC7 (nolock)
            on SC7.D_E_L_E_T_ = ''
            and SC7.C7_FILIAL = SD1.D1_FILIAL
            and SC7.C7_NUM = SD1.D1_PEDIDO
            and SC7.C7_ITEM = SD1.D1_ITEMPC

            left join SE4010 SE4 (nolock)
                on SE4.D_E_L_E_T_ = ''
                and SE4.E4_CODIGO = SC7.C7_COND
            left join SY1010 SY1 (nolock)
		        on SY1.Y1_USER = SC7.C7_USER
        
        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD1.D1_COD

            left join SBM010 SBM (nolock)
                on SBM.D_E_L_E_T_ = ''
                and SBM.BM_GRUPO = SB1.B1_GRUPO
        
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
