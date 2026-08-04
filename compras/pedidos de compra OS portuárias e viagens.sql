select
	trim(SC7.C7_FILIAL) as FILIAL,
	trim(SB1.B1_COD) as PRODUTO,
	trim(SB1.B1_DESC) as NOMEPRODUTO,
	concat(trim(SB1.B1_COD), ' - ', trim(SB1.B1_DESC)) as PROD_NOME,
	trim(SB1.B1_GRUPO) as GRUPO,
	(select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO) as NOMEGRUPO,
	concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO)) as GRUPO_PROD,
	trim(SB1.B1_UM) as UN,
	trim(SC7.C7_ITEMCTA) as AT,
	trim(SC7.C7_CC) as CC,
	trim(SC1.C1_NUM) as SC,
	trim(SC1.C1_ITEM) as ITEM_SC,
	trim(upper(SC1.C1_SOLICIT)) as SOLICITANTE_SC,
	convert(datetime, concat(SC1.C1_EMISSAO, ' ', isnull(nullif(SC1.C1_YHORASC, ''), '00:00:00')), 113) as DATA_SC,
	left(SC1.C1_EMISSAO, 6) as PERIODO_SC,
	
	SC1.C1_QUANT as QTD_SC_PEDIDA,
	SC1.C1_QUJE as QTD_SC_ATENDIDA,
	case SC1.C1_RESIDUO when 'S' then 'ELIMINADA' else '' end as C1_RESIDUO,

	case SC1.C1_APROV
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as SITAPR_SC,

	trim(SC7.C7_NUM) as PEDIDO,
	trim(SC7.C7_ITEM) as ITEM_PC,
	trim(SC7.C7_FORNECE) as FORNECEDOR,
	trim(SC7.C7_LOJA) as LOJA,
	trim(SA2.A2_NOME) as NOME_FORNECEDOR,
	trim(SA2.A2_CGC) as CNPJ,
	trim(SA2.A2_EST) as UF,
	trim(replace(replace(SC7.C7_OBS, char(10), ''), char(13), '')) as OBS_PC,
	trim(replace(replace(SC7.C7_OBSM, char(10), ''), char(13), '')) as MEMO_PC,

	convert(datetime, concat(SC7.C7_EMISSAO, ' ', isnull(nullif(SC7.C7_YHORAPC, ''), '00:00:00')), 113) as DATA_PEDIDO,
	left(SC7.C7_EMISSAO, 6) as PERIODO_PC,
	(select trim(upper(SY1010.Y1_NOME)) from SY1010 where SY1010.Y1_COD = SC7.C7_COMPRA) as SOLICITANTE_PC,
	trim(upper(SY1.Y1_NOME)) as DIGITACAO_PC,

	case SC7.C7_CONAPRO
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as APROVACAO_PC,

	SC7.C7_COND as COND,
	trim(SE4.E4_DESCRI) as CONDPGTO,
	SC7.C7_QUANT as QTD_PC_PEDIDA,
	SC7.C7_QUJE as QTD_PC_ATENDIDA,
	SC7.C7_PRECO as PC_PRECO,
	SC7.C7_TOTAL as PC_TOTAL,

	SD1.D1_DOC as NF_DOC,
	SD1.D1_SERIE as NF_SERIE,
	cast(SD1.D1_EMISSAO as date) as NF_EMI,
	cast(SD1.D1_DTDIGIT as date) as NF_DATA,
	left(SD1.D1_DTDIGIT, 6) as NF_PERIODO,
	case when exists (select * from SD2010 where SD2010.D_E_L_E_T_ = '' and SD2010.D2_TIPO = 'D' and SD2010.D2_NFORI = SD1.D1_DOC and SD2010.D2_SERIORI = SD1.D1_SERIE and SD2010.D2_ITEMORI = SD1.D1_ITEM and SD2010.D2_CLIENTE = SD1.D1_FORNECE and SD2010.D2_LOJA = SD1.D1_LOJA)
		then 'R' else SD1.D1_TIPO end as NF_TIPO,
	
	trim(SD1.D1_CC) as NF_CC,
	trim(SD1.D1_ITEMCTA) as NF_AT,
	trim(SD1.D1_ITEM) as NF_ITEM,
	trim(SD1.D1_TES) as NF_TES,
	(select concat(trim(SD1.D1_CF), ' - ', trim(SX5010.X5_DESCRI)) from SX5010 (nolock) where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = '13' and SX5010.X5_CHAVE = SD1.D1_CF) as CFOP,
	SD1.D1_QUANT as NF_QUANT,
	SD1.D1_VUNIT as NF_VUNIT,
	cast(SD1.D1_CUSTO as numeric(15, 2)) as NF_CUSTO,
	cast(SD1.D1_VALDESC as numeric(15, 2)) as NF_VALDESC,
	cast(SD1.D1_VALDEV as numeric(15, 2)) as NF_VALDEV,
	cast(SD1.D1_TOTAL as numeric(15, 2)) as NF_TOTAL,

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

	ZC1.ZC1_FILIAL as FILIAL_OS,
	cast(substring(ZC1.ZC1_NUM, 6, 10) as int) as OS,
	ZC2.ZC2_NUM as NUM_OS,
	ZC1.ZC1_CC as CC_OS,
	ZC1.ZC1_ATIVD as ATIVIDADE_OS,
	cast(ZC2.ZC2_DATA as date) as DATA_ITEMOS,
	left(ZC2.ZC2_DATA, 6) as PERIODO_ITEMOS,
	left(ZC2.ZC2_COMPET, 6) as COMPET_OS,
	cast(coalesce(ZC2.ZC2_TOTAL, 0) as decimal (14, 2)) as VALOR_TAXA

from SC7010 SC7 (nolock)
	left join SC1010 SC1 (nolock)
		on SC1.D_E_L_E_T_ = ''
		and SC1.C1_FILIAL = SC7.C7_FILIAL
		and SC1.C1_NUM = SC7.C7_NUMSC
		and SC1.C1_ITEM = SC7.C7_ITEMSC
	inner join SB1010 SB1 (nolock)
		on SB1.D_E_L_E_T_ = ''
		and SB1.B1_COD = SC7.C7_PRODUTO
		and SB1.B1_GRUPO = '2301'
	inner join SA2010 SA2 (nolock)
		on SA2.D_E_L_E_T_ = ''
		and SA2.A2_COD = SC7.C7_FORNECE
		and SA2.A2_LOJA = SC7.C7_LOJA
	left join SE4010 SE4 (nolock)
		on SE4.D_E_L_E_T_ = ''
		and SE4.E4_CODIGO = SC7.C7_COND
	left join SY1010 SY1 (nolock)
		on SY1.Y1_USER = SC7.C7_USER
	left join SD1010 SD1 (nolock)
		on SD1.D_E_L_E_T_ = ''
		and SD1.D1_FILIAL = SC7.C7_FILIAL
		and SD1.D1_PEDIDO = SC7.C7_NUM
		and SD1.D1_ITEMPC = SC7.C7_ITEM
	
	left join ZC2010 ZC2 (nolock)
		on ZC2.D_E_L_E_T_ = ''
		and ZC2.ZC2_FILIAL = SC7.C7_FILIAL
		and ZC2.ZC2_NUM = case when trim(SC7.C7_YOS) = '2024/0' then right(left(replace(replace(SC7.C7_OBS, char(10), ''), char(13), ''), 63), 11) else SC7.C7_YOS end
		and ZC2.ZC2_ITEM = isnull(nullif(SC7.C7_YOSIT, ''), '0')

		left join ZC1010 ZC1 (nolock)
            on ZC1.D_E_L_E_T_ = ''
            and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
            and ZC1.ZC1_NUM = ZC2.ZC2_NUM
where
		SC7.D_E_L_E_T_ = ''
	and SC7.C7_CC in ('304', '305')
