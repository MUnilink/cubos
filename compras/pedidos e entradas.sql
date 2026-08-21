select
	trim(SC7.C7_FILIAL) as FILIAL,
	trim(SB1.B1_COD) as PRODUTO,
	trim(SB1.B1_DESC) as NOMEPRODUTO,
	concat(trim(SB1.B1_COD), ' - ', trim(SB1.B1_DESC)) as PROD_NOME,
	trim(SB1.B1_GRUPO) as GRUPO,
	(select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO) as NOMEGRUPO,
	concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO)) as GRUPO_PROD,
	trim(SB1.B1_UM) as UN,
	trim(CTD.CTD_DESC01) as ATIVIDADE,
	trim(CTT.CTT_DESC01) as CCUSTO,
	trim(SC7.C7_ITEMCTA) as AT,
	trim(SC7.C7_CC) as CC,
	trim(SC1.C1_NUM) as SC,
	trim(SC1.C1_ITEM) as ITEM_SC,
	trim(upper(SC1.C1_SOLICIT)) as SOLICITANTE_SC,
	convert(datetime, concat(SC1.C1_EMISSAO, ' ', isnull(nullif(SC1.C1_YHORASC, ''), '00:00:00')), 113) as DATA_SC,
	left(SC1.C1_EMISSAO, 6) as PERIODO_SC,
	left(SC1.C1_OP, 6) as OS,
	
	SC1.C1_QUANT as QTD_SC_PEDIDA,
	SC1.C1_QUJE as QTD_SC_ATENDIDA,
	case SC1.C1_RESIDUO when 'S' then 'ELIMINADA' else '' end as C1_RESIDUO,

	case SC1.C1_APROV
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as SITAPR_SC,

	(
		select top 1 convert(datetime, concat(SCR010.CR_DATALIB, ' ', SCR010.CR_YHRLIB), 113)
		from SCR010
		where
				SCR010.D_E_L_E_T_ = ''
			and nullif(SCR010.CR_LIBAPRO, '') is not null
			and SCR010.CR_TIPO = 'SC'
			and SCR010.CR_FILIAL = SC1.C1_FILIAL
			and SCR010.CR_NUM = SC1.C1_NUM
	) as DATAAPROV_SC,
	
	datediff(minute,
		SC1.C1_EMISSAO,
		(
			select top 1 convert(datetime, concat(SCR010.CR_DATALIB, ' ', SCR010.CR_YHRLIB), 113)
			from SCR010
			where
					SCR010.D_E_L_E_T_ = ''
				and nullif(SCR010.CR_LIBAPRO, '') is not null
				and SCR010.CR_TIPO = 'SC'
				and SCR010.CR_FILIAL = SC1.C1_FILIAL
				and SCR010.CR_NUM = SC1.C1_NUM
		)
	)/(60*24.0) as DIASAPROV_SC,

	SC8.C8_NUM as COTACAO,
    SC8.C8_ITEM as ITEM_COTA,
	SC8.C8_QUANT as QTD_COTADA,
	SC8.C8_PRECO as PRECO_COTADO,
	SC8.C8_TOTAL as VALOR_COTADO,
	cast(SC8.C8_EMISSAO as date) as DATA_COTACAO,
	
	datediff(minute,
		(
			select top 1 convert(datetime, concat(SCR010.CR_DATALIB, ' ', SCR010.CR_YHRLIB), 113)
			from SCR010
			where
					SCR010.D_E_L_E_T_ = ''
				and nullif(SCR010.CR_LIBAPRO, '') is not null
				and SCR010.CR_TIPO = 'SC'
				and SCR010.CR_FILIAL = SC1.C1_FILIAL
				and SCR010.CR_NUM = SC1.C1_NUM
		),
		concat(SC7.C7_EMISSAO, ' ', isnull(nullif(SC7.C7_YHORAPC, ''), '00:00:00'))
	)/(60*24.0) as DIASAPROV_SC_CO,

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

	(
		select top 1 convert(datetime, concat(SCR010.CR_DATALIB, ' ', SCR010.CR_YHRLIB), 113)
		from SCR010
		where
				SCR010.D_E_L_E_T_ = ''
			and nullif(SCR010.CR_LIBAPRO, '') is not null
			and SCR010.CR_TIPO = 'PC'
			and SCR010.CR_FILIAL = SC7.C7_FILIAL
			and SCR010.CR_NUM = SC7.C7_NUM
	) as DATAAPROV_PC,
	
	datediff(minute,
		concat(SC7.C7_EMISSAO, ' ', isnull(nullif(SC7.C7_YHORAPC, ''), '00:00:00')),
		(
			select top 1 convert(date, SCR010.CR_DATALIB, 103)
			from SCR010
			where
					SCR010.D_E_L_E_T_ = ''
				and SCR010.CR_LIBAPRO is not null
				and SCR010.CR_TIPO = 'PC'
				and SCR010.CR_FILIAL = SC7.C7_FILIAL
				and SCR010.CR_NUM = SC7.C7_NUM)
	)/(60*24.0) as DIASAPROV_PC,

	(
		select cast(max(SCR010.CR_NIVEL) as int)
		from SCR010 (nolock)
		where
				SCR010.D_E_L_E_T_ = ''
			and SCR010.CR_TIPO = 'PC'
			and SCR010.CR_FILIAL = SC7.C7_FILIAL
            and SCR010.CR_NUM = SC7.C7_NUM
	) as NUM_NIVEL,

	(
        select max('P |01|SAK010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAK010.AK_FILIAL, ' '))+'|'+RTRIM(COALESCE(SAK010.AK_COD, ' ')), ' '), '|'))
         from SCR010 SCR
            inner join SAK010
                on SAK010.D_E_L_E_T_ = ''
                and SAK010.AK_COD = SCR.CR_LIBAPRO
		where
				SCR.D_E_L_E_T_ = ''
			and SCR.CR_TIPO = 'PC'
			and SCR.CR_FILIAL = SC7.C7_FILIAL
			and SCR.CR_NUM = SC7.C7_NUM
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
    ) as BK_APROVADOR,

	(
		select upper(trim(max(SAK010.AK_LOGIN)))
        from SCR010 SCR
            inner join SAK010
                on SAK010.D_E_L_E_T_ = ''
                and SAK010.AK_COD = SCR.CR_LIBAPRO
		where
				SCR.D_E_L_E_T_ = ''
			and SCR.CR_TIPO = 'PC'
			and SCR.CR_FILIAL = SC7.C7_FILIAL
			and SCR.CR_NUM = SC7.C7_NUM
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

	SC7.C7_COND as COND,
	trim(SE4.E4_DESCRI) as CONDPGTO,
	SC7.C7_QUANT as QTD_PC_PEDIDA,
	SC7.C7_QUJE as QTD_PC_ATENDIDA,
	SC7.C7_PRECO as PC_PRECO,
	SC7.C7_TOTAL as PC_TOTAL,

	year(SC1.C1_EMISSAO) as ANO_SOLICITA,
	month(SC1.C1_EMISSAO) as MES_SOLICITA,

	year(SC7.C7_EMISSAO) as ANO_PEDIDO,
	month(SC7.C7_EMISSAO) as MES_PEDIDO,

	case
		when trim(SC7.C7_RESIDUO) = 'S' then 'ELIMINADO' /* CINZA */
		when trim(SC7.C7_CONAPRO) = 'B' and (cast(SC7.C7_QUJE as numeric(15, 2)) < cast(SC7.C7_QUANT as numeric(15, 2))) then 'BLOQUEADO' /* AZUL */
		when cast(SC7.C7_QUJE as numeric(15, 2)) >= cast(SC7.C7_QUANT as numeric(15, 2)) then 'RECEBIDO' /* VERMELHO */
		when cast(SC7.C7_QUJE as numeric(15, 2)) != 0.00 and (cast(SC7.C7_QUJE as numeric(15, 2)) < cast(SC7.C7_QUANT as numeric(15, 2))) then 'REC. PARCIAL' /* AMARELO */
		when cast(SC7.C7_QTDACLA as numeric(15, 2)) > 0.00 then 'PRÉ-NOTA' /* LARANJA */
		when cast(SC7.C7_TIPO as int) = 1 and SC7.C7_RESIDUO = '' then 'APROVADO' /* VERDE */
	else 'OUTROS' end as STATUS_COMPRA,

	SD1.D1_DOC as NF_DOC,
	SD1.D1_SERIE as NF_SERIE,
	cast(SD1.D1_EMISSAO as date) as NF_EMI,
	cast(SD1.D1_DTDIGIT as date) as NF_DATA,
	left(SD1.D1_DTDIGIT, 6) as NF_PERIODO,
	case when exists (select * from SD2010 where SD2010.D_E_L_E_T_ = '' and SD2010.D2_TIPO = 'D' and SD2010.D2_NFORI = SD1.D1_DOC and SD2010.D2_SERIORI = SD1.D1_SERIE and SD2010.D2_ITEMORI = SD1.D1_ITEM and SD2010.D2_CLIENTE = SD1.D1_FORNECE and SD2010.D2_LOJA = SD1.D1_LOJA)
		then 'R' else SD1.D1_TIPO end as NF_TIPO,
	
	datediff(minute,
		(
			select top 1 convert(datetime, concat(SCR010.CR_DATALIB, ' ', SCR010.CR_YHRLIB), 113)
			from SCR010
			where
					SCR010.D_E_L_E_T_ = ''
				and SCR010.CR_LIBAPRO is not null
				and SCR010.CR_TIPO = 'PC'
				and SCR010.CR_FILIAL = SC7.C7_FILIAL
				and SCR010.CR_NUM = SC7.C7_NUM
		),
		SD1.D1_DTDIGIT
	)/(60*24.0) as DIASAPROV_PC_NF,

	datediff(minute, convert(datetime, concat(SC1.C1_EMISSAO, ' ', isnull(nullif(SC1.C1_YHORASC, ''), '00:00:00')), 113), SD1.D1_DTDIGIT)/(60*24.0) as LEADTIME_COMPRAS,
	
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
    cast(SC7.C7_VLDESC as numeric(12, 2)) as VL_PC_DESCONTO,
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
	cast(SD1.D1_PESO * SD1.D1_QUANT as numeric(12, 4)) as PESO_LIQUIDO_NFENT,

	trim(SE2.E2_FILIAL) as FILIAL_TITULO,
	trim(SE2.E2_PREFIXO) as PREFIXO,
	trim(SE2.E2_NUM) as TITULO,
	trim(SE2.E2_TIPO) as TIPO_TITULO,
	cast(SE2.E2_EMISSAO as date) as DATA_TITULO,
	cast(SE2.E2_VENCTO as date) as VENCIMENTO,
	cast(SE2.E2_VENCREA as date) as VENCREAL,
	cast(SE2.E2_BAIXA as date) as BAIXA,
	SE2.E2_PARCELA as PARCELA,
	SE2.E2_VALOR as VALOR_TITULO,

	case
		when SB1.B1_GRUPO like '51%' then 'DESPESAS'
		when SB1.B1_GRUPO like '4%' then 'ATIVO FIXO'
		when SB1.B1_GRUPO like '3%' then 'PRODUTOS TMS'
		when SB1.B1_GRUPO like '2%' then 'SERVIÇOS'
		when SB1.B1_GRUPO like '12%' then 'MATERIAL DE CONSUMO'
		when SB1.B1_GRUPO like '1110%' then 'COMBUSTÍVEL'
		when SB1.B1_GRUPO like '1130%' then 'PNEUS'
		when SB1.B1_GRUPO like '1%' then 'PEÇAS E ACESSÓRIOS'
	else 'OUTROS' end as CLASSIFICACAO,

	case when trim(SC7.C7_YOS) = '2024/0' then right(left(replace(replace(SC7.C7_OBS, char(10), ''), char(13), ''), 63), 11) else SC7.C7_YOS end as OS_PORT,
	isnull(nullif(SC7.C7_YOSIT, ''), '0') as ITEMOS_PORT,

	STJ.TJ_ORDEM as OS_MNT,
	trim(ST9.T9_CODBEM) as EQUIPAMENTO,
	trim(TQR.TQR_DESMOD) as MODELO,
    cast(STJ.TJ_DTPRINI as date) as DATA_INIOS,
    cast(STJ.TJ_DTPRFIM as date) as DATA_FIMOS,
	cast(STJ.TJ_DTORIGI as date) as DATA_OS,
	trim(STJ.TJ_USUAINI) as USR_INI,
	trim(STJ.TJ_USUAFIM) as USR_FIM,
	STJ.TJ_TERMINO as OSMNT_ENCERRADA

from SC7010 SC7 (nolock)
	left join SC8010 SC8 (nolock)
		on SC8.D_E_L_E_T_ = ''
		and SC8.C8_FILIAL = SC7.C7_FILIAL
		and SC8.C8_NUM = SC7.C7_NUM
		and SC8.C8_ITEM = SC7.C7_ITEM

		left join SC1010 SC1 (nolock)
			on SC1.D_E_L_E_T_ = ''
			and isnull(SC8.C8_FILIAL, SC7.C7_FILIAL) = SC1.C1_FILIAL
			and isnull(SC8.C8_NUMSC, SC7.C7_NUMSC) = SC1.C1_NUM
			and isnull(SC8.C8_ITEMSC, SC7.C7_ITEMSC) = SC1.C1_ITEM

	left join SB1010 SB1 (nolock)
		on SB1.D_E_L_E_T_ = ''
		and SB1.B1_COD = SC7.C7_PRODUTO
	inner join SA2010 SA2 (nolock)
		on SA2.D_E_L_E_T_ = ''
		and SA2.A2_COD = SC7.C7_FORNECE
		and SA2.A2_LOJA = SC7.C7_LOJA
	left join SE4010 SE4 (nolock)
		on SE4.D_E_L_E_T_ = ''
		and SE4.E4_CODIGO = SC7.C7_COND
	left join SY1010 SY1 (nolock)
		on SY1.Y1_USER = SC7.C7_USER
	left join CTT010 CTT (nolock)
		on CTT.D_E_L_E_T_ = ''
		and CTT.CTT_CUSTO = SC7.C7_CC
	left join CTD010 CTD (nolock)
		on CTD.D_E_L_E_T_ = ''
		and CTD.CTD_ITEM = SC7.C7_ITEMCTA
	left join SD1010 SD1 (nolock)
		on SD1.D_E_L_E_T_ = ''
		and SD1.D1_FILIAL = SC7.C7_FILIAL
		and SD1.D1_PEDIDO = SC7.C7_NUM
		and SD1.D1_ITEMPC = SC7.C7_ITEM
		
		left join SE2010 SE2 (nolock)
			on SE2.E2_TIPO = 'PA'
			and SE2.E2_FILIAL = SD1.D1_FILIAL
			and SE2.E2_NUM = SD1.D1_DOC
			and SE2.E2_FORNECE = SD1.D1_FORNECE
			and SE2.E2_LOJA = SD1.D1_LOJA
			and SE2.D_E_L_E_T_ = ''

	left join STJ010 STJ (nolock)
		on STJ.D_E_L_E_T_ = ''
		and STJ.TJ_FILIAL = SC1.C1_FILIAL
		and STJ.TJ_ORDEM + 'OS' + '001' = SC7.C7_OP

		left join ST9010 ST9 (nolock)
			on ST9.D_E_L_E_T_ = ''
			and ST9.T9_CODBEM = STJ.TJ_CODBEM

			left join TQR010 TQR (nolock)
				on TQR.D_E_L_E_T_ = ''
				and TQR.TQR_TIPMOD = ST9.T9_TIPMOD
where
		SC7.D_E_L_E_T_ = ''
	and SC7.C7_EMISSAO >=:PEDIDOS_DESDE
