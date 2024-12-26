select
	trim(SC1.C1_FILIAL) as FILIAL,
	trim(SB1.B1_COD) as PRODUTO,
	trim(SB1.B1_DESC) as NOMEPRODUTO,
	trim(SB1.B1_GRUPO) as GRUPO,
	trim(SB1.B1_UM) as UN,
	trim(CTD.CTD_DESC01) as ATIVIDADE,
	trim(CTT.CTT_DESC01) as CCUSTO,
	trim(SC1.C1_NUM) as SC,
	trim(SC1.C1_ITEM) as ITEM_SC,
	trim(upper(SC1.C1_SOLICIT)) as SOLICITANTE_SC,
	trim(SC1.C1_OBS) as OBS_SC,
	convert(date, SC1.C1_EMISSAO, 103) as DATA_SC,
	substring(SC1.C1_EMISSAO, 1, 6) as PERIODO_SC,
	substring(SC1.C1_OP, 1, 6) as OS,
	trim(FORSC.A2_COD) as FORSC_COD,
	trim(FORSC.A2_LOJA) as FORSC_LOJA,
	trim(FORSC.A2_NOME) as FORSC_DESC,

	trim(SC7.C7_ITEMCTA) as AT,
	trim(SC7.C7_CC) as CC,

	SC1.C1_QUANT as QTD_SC_PEDIDA,
	SC1.C1_QUJE as QTD_SC_ATENDIDA,
	abs(SC1.C1_QUANT - SC1.C1_QUJE) as QTD_SC_PENDENTE,
	case SC1.C1_RESIDUO when 'S' then 'ELIMINADA' else '' end as SC_ELIM,

	case SC1.C1_APROV
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as SITAPR_SC,

	(select top 1 convert(date, SCR010.CR_DATALIB, 103) from SCR010 where SCR010.D_E_L_E_T_ = '' and SCR010.CR_LIBAPRO is not null and SCR010.CR_TIPO = 'SC' and SCR010.CR_NUM = SC1.C1_NUM) as DATAAPROV_SC,
	datediff(day, SC1.C1_EMISSAO, (select top 1 convert(date, SCR010.CR_DATALIB, 103) from SCR010 where SCR010.D_E_L_E_T_ = '' and SCR010.CR_LIBAPRO is not null and SCR010.CR_TIPO = 'SC' and SCR010.CR_NUM = SC1.C1_NUM)) as DIASAPROV_SC,

	SC8.C8_NUM as COTACAO,
    SC8.C8_ITEM as ITEM_COTA,
	SC8.C8_QUANT as QTD_COTADA,
	SC8.C8_PRECO as PRECO_COTADO,
	SC8.C8_TOTAL as VALOR_COTADO,
	convert(date, SC8.C8_EMISSAO, 103) as DATA_COTACAO,
	substring(SC8.C8_EMISSAO, 1, 6) as PERIODO_COTACAO,
	trim(FORCO.A2_COD) as FORCO_COD,
	trim(FORCO.A2_LOJA) as FORCO_LOJA,
	trim(FORCO.A2_NOME) as FORCO_DESC,
	datediff(day, (select top 1 convert(date, SCR010.CR_DATALIB, 103) from SCR010 where SCR010.D_E_L_E_T_ = '' and SCR010.CR_LIBAPRO is not null and SCR010.CR_TIPO = 'SC' and SCR010.CR_NUM = SC1.C1_NUM), SC7.C7_EMISSAO) as DIASAPROV_SC_CO,

	trim(SC7.C7_NUM) as PEDIDO,
	trim(SC7.C7_ITEM) as ITEM_PC,
	trim(FORPC.A2_COD) as FORPC_COD,
	trim(FORPC.A2_LOJA) as FORPC_LOJA,
	trim(FORPC.A2_NOME) as FORPC_DESC,
	trim(SC7.C7_OBS) as OBS_PC,
	trim(SC7.C7_OBSM) as MEMO_PC,

	convert(date, SC7.C7_EMISSAO, 103) as DATA_PEDIDO,
	left(SC7.C7_EMISSAO, 6) as PERIODO_PC,
	trim(upper(SY1.Y1_NOME)) as SOLICITANTE_PC,

	case SC7.C7_CONAPRO
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as APROVACAO_PC,

	(select top 1 convert(date, SCR010.CR_DATALIB, 103) from SCR010 where SCR010.D_E_L_E_T_ = '' and SCR010.CR_LIBAPRO is not null and SCR010.CR_TIPO = 'PC' and SCR010.CR_NUM = SC7.C7_NUM) as DATAAPROV_PC,
	datediff(day, SC7.C7_EMISSAO, (select top 1 convert(date, SCR010.CR_DATALIB, 103) from SCR010 where SCR010.D_E_L_E_T_ = '' and SCR010.CR_LIBAPRO is not null and SCR010.CR_TIPO = 'PC' and SCR010.CR_NUM = SC7.C7_NUM)) as DIASAPROV_PC,
	datediff(day, (select top 1 convert(date, SCR010.CR_DATALIB, 103) from SCR010 where SCR010.D_E_L_E_T_ = '' and SCR010.CR_LIBAPRO is not null and SCR010.CR_TIPO = 'PC' and SCR010.CR_NUM = SC7.C7_NUM), SD1.D1_DTDIGIT) as DIASAPROV_PC_NF,

	SC7.C7_COND as COND,
	trim(SE4.E4_DESCRI) as CONDPGTO,
	SC7.C7_QUANT as QTD_PC_PEDIDA,
	SC7.C7_QUJE as QTD_PC_ATENDIDA,
	abs(SC7.C7_QUANT - SC7.C7_QUJE) as QTD_PC_PENDENTE,
	SC7.C7_PRECO as PRECO,
	SC7.C7_TOTAL as TOTAL,
	case SC7.C7_RESIDUO when 'S' then 'ELIMINADA' else '' end as PC_ELIM,

	case
		when trim(SC7.C7_RESIDUO) = 'S' then 'ELIMINADO' /* CINZA */
		when trim(SC7.C7_CONAPRO) = 'B' and (cast(SC7.C7_QUJE as numeric(15, 2)) < cast(SC7.C7_QUANT as numeric(15, 2))) then 'BLOQUEADO' /* AZUL */
		when cast(SC7.C7_QUJE as numeric(15, 2)) >= cast(SC7.C7_QUANT as numeric(15, 2)) then 'RECEBIDO' /* VERMELHO */
		when cast(SC7.C7_QUJE as numeric(15, 2)) != 0.00 and (cast(SC7.C7_QUJE as numeric(15, 2)) < cast(SC7.C7_QUANT as numeric(15, 2))) then 'REC. PARCIAL' /* AMARELO */
		when cast(SC7.C7_QTDACLA as numeric(15, 2)) > 0.00 then 'PRÉ-NOTA' /* LARANJA */
		when cast(SC7.C7_TIPO as int) = 1 and SC7.C7_RESIDUO = '' then 'APROVADO' /* VERDE */
	else 'OUTROS' end as STATUS_PC,

	case
		when trim(SC1.C1_RESIDUO) = 'S' then 'SC ELIMINADA'
		when trim(SC7.C7_RESIDUO) = 'S' then 'PC ELIMINADO'
		when cast(SC1.C1_QUJE as numeric(15, 2)) = 0.00 then 'SC PENDENTE'
		when cast(SC1.C1_QUJE as numeric(15, 2)) != 0.00 and SC1.C1_QUJE < SC1.C1_QUANT then 'SC PARCIAL'
		when SC1.C1_QUJE >= SC1.C1_QUANT and cast(SC7.C7_QUJE as numeric(15, 2)) = 0.00 then 'SC ATENDIDA'
		when cast(SC1.C1_QUJE as numeric(15, 2)) != 0.00 and SC1.C1_QUJE >= SC1.C1_QUANT and cast(SC7.C7_QUJE as numeric(15, 2)) != 0.00 and SC7.C7_QUJE < SC7.C7_QUANT then 'RECEBIMENTO PARCIAL'
		when cast(SC1.C1_QUJE as numeric(15, 2)) != 0.00 and SC1.C1_QUJE >= SC1.C1_QUANT and cast(SC7.C7_QUJE as numeric(15, 2)) != 0.00 and SC7.C7_QUJE >= SC7.C7_QUANT then 'RECEBIMENTO TOTAL'
	else 'OUTROS' end as STATUS_COMPRA,

	SD1.D1_DOC as NF_DOC,
	SD1.D1_SERIE as NF_SERIE,
	SD1.D1_CC as NF_CC,
	SD1.D1_ITEMCTA as NF_AT,
	SD1.D1_ITEM as NF_ITEM,
	SD1.D1_QUANT as NF_QUANT,
	SD1.D1_VUNIT as NF_VUNIT,
	SD1.D1_TOTAL as NF_TOTAL,
	SD1.D1_TES as NF_TES,
	SD1.D1_CUSTO as NF_CUSTO,
	SD1.D1_QTDPEDI as NF_QTDPEDI,
	cast(SD1.D1_EMISSAO as date) as NF_EMI,
	cast(SD1.D1_DTDIGIT as date) as NF_DATA,
	left(SD1.D1_EMISSAO, 6) as NF_MESEMIT,
	left(SD1.D1_DTDIGIT, 6) as NF_PERIODO,
	coalesce(nullif(SD1.D1_YOS, ''), nullif(SC7.C7_YOS, '')) as OS_PORT,
	case when SC1.C1_OP like '%OS001' then 'OS' else 'OP' end as TIPO_SC,

	STJ.TJ_ORDEM as OS_MNT,
	trim(STJ.TJ_CODBEM) as TJ_CODBEM,
    STJ.TJ_DTMRINI,
    STJ.TJ_DTMRFIM,
	convert(date, STJ.TJ_DTORIGI, 103) as DATA_OS,
	STJ.TJ_USUAINI as USR_INI,
	STJ.TJ_USUAFIM as USR_FIM,
	STJ.TJ_TERMINO as OS_ENCERRADA,
	SC2.C2_NUM as OP

from SC1010 SC1 (nolock)
	left join CTT010 CTT (nolock)
		on CTT.D_E_L_E_T_ = ''
		and CTT.CTT_CUSTO = SC1.C1_CC
	left join CTD010 CTD (nolock)
		on CTD.D_E_L_E_T_ = ''
		and CTD.CTD_ITEM = SC1.C1_ITEMCTA
	inner join SB1010 SB1 (nolock)
		on SB1.D_E_L_E_T_ = ''
		and SB1.B1_COD = SC1.C1_PRODUTO
	left join SC8010 SC8 (nolock)
		on SC8.D_E_L_E_T_ = ''
		and SC8.C8_FILIAL = SC1.C1_FILIAL
		and SC8.C8_NUMSC = SC1.C1_NUM
		and SC8.C8_ITEMSC = SC1.C1_ITEM

		left join SA2010 FORCO (nolock)
			on FORCO.D_E_L_E_T_ = ''
			and FORCO.A2_COD = SC8.C8_FORNECE
			and FORCO.A2_LOJA = SC8.C8_LOJA

	left join SC7010 SC7 (nolock)
		on SC7.D_E_L_E_T_ = ''
		and SC7.C7_FILIAL = SC1.C1_FILIAL
		and SC7.C7_NUMSC = SC1.C1_NUM
		and SC7.C7_ITEMSC = SC1.C1_ITEM

		left join SA2010 FORPC (nolock)
			on FORPC.D_E_L_E_T_ = ''
			and FORPC.A2_COD = SC7.C7_FORNECE
			and FORPC.A2_LOJA = SC7.C7_LOJA
		left join SD1010 SD1 (nolock)
			on SD1.D_E_L_E_T_ = ''
			and SD1.D1_FILIAL = SC7.C7_FILIAL
			and SD1.D1_PEDIDO = SC7.C7_NUM
			and SD1.D1_ITEMPC = SC7.C7_ITEM
		left join SE4010 SE4 (nolock)
			on SE4.D_E_L_E_T_ = ''
			and SE4.E4_CODIGO = SC7.C7_COND
		left join SY1010 SY1 (nolock)
			on SY1.D_E_L_E_T_ = ''
			and SY1.Y1_USER = SC7.C7_USER

	left join SA2010 FORSC (nolock)
		on FORSC.D_E_L_E_T_ = ''
		and FORSC.A2_COD = SC1.C1_FORNECE
		and FORSC.A2_LOJA = SC1.C1_LOJA
	left join STJ010 STJ (nolock)
		on STJ.D_E_L_E_T_ = ''
		and STJ.TJ_FILIAL = SC1.C1_FILIAL
		and concat(STJ.TJ_ORDEM, 'OS') = left(SC1.C1_OP, 8)
		and STJ.TJ_SERVICO not in ('CONSEP', 'REFORP')
	left join SC2010 SC2 (nolock)
		on SC2.D_E_L_E_T_ = ''
		and SC2.C2_FILIAL = SC1.C1_FILIAL
		and concat(SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN) = SC1.C1_OP
where 
		SC1.D_E_L_E_T_ = ''
