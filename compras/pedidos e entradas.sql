select
	trim(SC7.C7_FILIAL) as FILIAL,
	trim(SB1.B1_COD) as PRODUTO,
	trim(SB1.B1_DESC) as NOMEPRODUTO,
	trim(SB1.B1_GRUPO) as GRUPO,
	trim(SB1.B1_UM) as UN,
	trim(CTD.CTD_DESC01) as ATIVIDADE,
	trim(CTT.CTT_DESC01) as CCUSTO,
	trim(SC7.C7_ITEMCTA) as AT,
	trim(SC7.C7_CC) as CC,
	trim(SC1.C1_NUM) as SC,
	trim(SC1.C1_ITEM) as ITEM_SC,
	trim(upper(SC1.C1_SOLICIT)) as SOLICITANTE_SC,
	trim(SC1.C1_OBS) as OBS_SC,
	cast(SC1.C1_EMISSAO as date) as DATA_SC,
	substring(SC1.C1_EMISSAO, 1, 6) as PERIODO_SC,
	substring(SC1.C1_OP, 1, 6) as OS,
	
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
		select top 1 cast(SCR010.CR_DATALIB as date)
		from SCR010
		where
				SCR010.D_E_L_E_T_ = ''
			and nullif(SCR010.CR_LIBAPRO, '') is not null
			and SCR010.CR_TIPO = 'SC'
			and SCR010.CR_FILIAL = SC1.C1_FILIAL
			and SCR010.CR_NUM = SC1.C1_NUM
	) as DATAAPROV_SC,
	
	datediff(day,
		SC1.C1_EMISSAO,
		(
			select top 1 cast(SCR010.CR_DATALIB as date)
			from SCR010
			where
					SCR010.D_E_L_E_T_ = ''
				and nullif(SCR010.CR_LIBAPRO, '') is not null
				and SCR010.CR_TIPO = 'SC'
				and SCR010.CR_FILIAL = SC1.C1_FILIAL
				and SCR010.CR_NUM = SC1.C1_NUM
		)
	) as DIASAPROV_SC,

	SC8.C8_NUM as COTACAO,
    SC8.C8_ITEM as ITEM_COTA,
	SC8.C8_QUANT as QTD_COTADA,
	SC8.C8_PRECO as PRECO_COTADO,
	SC8.C8_TOTAL as VALOR_COTADO,
	cast(SC8.C8_EMISSAO as date) as DATA_COTACAO,
	
	datediff(day,
		(
			select top 1 cast(SCR010.CR_DATALIB as date)
			from SCR010
			where
					SCR010.D_E_L_E_T_ = ''
				and nullif(SCR010.CR_LIBAPRO, '') is not null
				and SCR010.CR_TIPO = 'SC'
				and SCR010.CR_FILIAL = SC1.C1_FILIAL
				and SCR010.CR_NUM = SC1.C1_NUM
		),
		SC7.C7_EMISSAO
	) as DIASAPROV_SC_CO,

	trim(SC7.C7_NUM) as PEDIDO,
	trim(SC7.C7_ITEM) as ITEM_PC,
	trim(SC7.C7_FORNECE) as FORNECEDOR,
	trim(SC7.C7_LOJA) as LOJA,
	trim(SA2.A2_NOME) as NOME_FORNECEDOR,
	trim(SA2.A2_NREDUZ) as NOMERED_FORNECEDOR,
	trim(SA2.A2_CGC) as CNPJ,
	trim(SA2.A2_EST) as UF,
	replace(replace(SC7.C7_OBS, char(10), ''), char(13), '') as OBS_PC,
	replace(replace(SC7.C7_OBSM, char(10), ''), char(13), '') as MEMO_PC,

	cast(SC7.C7_EMISSAO as date) as DATA_PEDIDO,
	substring(SC7.C7_EMISSAO, 1, 6) as PERIODO_PC,
	trim(upper(SY1.Y1_NOME)) as SOLICITANTE_PC,

	case SC7.C7_CONAPRO
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as APROVACAO_PC,

    (
        select max('P |01|SAK010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAK010.AK_FILIAL, ' '))+'|'+RTRIM(COALESCE(SAK010.AK_COD, ' ')), ' '), '|'))
        from SCR010 SCR
            inner join SAK010
                on SAK010.D_E_L_E_T_ = ''
                and SAK010.AK_COD = SCR.CR_LIBAPRO
        where
                SCR.D_E_L_E_T_ = ''
            and SCR.CR_FILIAL = SC7.C7_FILIAL
            and SCR.CR_NUM = SC7.C7_NUM
            and SCR.CR_STATUS < 6
            and SCR.CR_NIVEL =
            (
                select max(SCR010.CR_NIVEL)
                from SCR010 (nolock)
                where
                        SCR010.D_E_L_E_T_ = ''
                    and SCR010.CR_TIPO = 'PC'
                    and SCR010.CR_FILIAL = SCR.CR_FILIAL
                    and SCR010.CR_TIPO = SCR.CR_TIPO
                    and SCR010.CR_NUM = SCR.CR_NUM
                group by
                    SCR010.CR_FILIAL,
                    SCR010.CR_TIPO,
                    SCR010.CR_NUM
            )
    ) as BK_APROVADOR,

	(
		select top 1 cast(SCR010.CR_DATALIB as date)
		from SCR010
		where
				SCR010.D_E_L_E_T_ = ''
			and nullif(SCR010.CR_LIBAPRO, '') is not null
			and SCR010.CR_TIPO = 'PC'
			and SCR010.CR_FILIAL = SC7.C7_FILIAL
			and SCR010.CR_NUM = SC7.C7_NUM
	) as DATAAPROV_PC,
	
	datediff(day,
		SC7.C7_EMISSAO,
		(
			select top 1 convert(date, SCR010.CR_DATALIB, 103)
			from SCR010
			where
					SCR010.D_E_L_E_T_ = ''
				and SCR010.CR_LIBAPRO is not null
				and SCR010.CR_TIPO = 'PC'
				and SCR010.CR_FILIAL = SC7.C7_FILIAL
				and SCR010.CR_NUM = SC7.C7_NUM)
	) as DIASAPROV_PC,

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
		select upper(trim(max(SAK010.AK_LOGIN)))
        from SCR010
            inner join SAK010
                on SAK010.D_E_L_E_T_ = ''
                and SAK010.AK_COD = SCR010.CR_LIBAPRO
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

	case when trim(SC7.C7_CONAPRO) = 'B' and (cast(SC7.C7_QUJE as numeric(15, 2)) < cast(SC7.C7_QUANT as numeric(15, 2))) then 'BLOQUEADO' /* AZUL */
	else
		case when cast(SC7.C7_QTDACLA as numeric(15, 2)) > 0.0 then 'PRÉ-NOTA' /* LARANJA */
		else
			case when cast(SC7.C7_TIPO as int) = 1 and SC7.C7_RESIDUO = '' then 'APROVADO' /* VERDE */
			else
				case when cast(SC7.C7_QUJE as numeric(15, 2)) != 0.0 and (cast(SC7.C7_QUJE as numeric(15, 2)) < cast(SC7.C7_QUANT as numeric(15, 2))) then 'REC. PARCIAL' /* AMARELO */
				else
					case when cast(SC7.C7_QUJE as numeric(15, 2)) >= cast(SC7.C7_QUANT as numeric(15, 2)) then 'RECEBIDO' /* VERMELHO */
					else
						case when trim(SC7.C7_RESIDUO) = 'S' then 'ELIMINAÇÃO DE RESÍDUO' /* CINZA */
						else 'OUTROS'
						end
					end
				end
			end
		end
	end as STATUS_COMPRA,

	SD1.D1_DOC as NF_DOC,
	SD1.D1_SERIE as NF_SERIE,
	cast(SD1.D1_EMISSAO as date) as NF_EMI,
	cast(SD1.D1_DTDIGIT as date) as NF_DATA,
	substring(SD1.D1_DTDIGIT, 1, 6) as NF_PERIODO,
	
	datediff(day,
		(
			select top 1 cast(SCR010.CR_DATALIB as date)
			from SCR010
			where
					SCR010.D_E_L_E_T_ = ''
				and SCR010.CR_LIBAPRO is not null
				and SCR010.CR_TIPO = 'PC'
				and SCR010.CR_FILIAL = SC7.C7_FILIAL
				and SCR010.CR_NUM = SC7.C7_NUM
		),
		SD1.D1_DTDIGIT
	) as DIASAPROV_PC_NF,
	
	SD1.D1_CC as NF_CC,
	SD1.D1_ITEMCTA as NF_AT,
	SD1.D1_ITEM as NF_ITEM,
	SD1.D1_QUANT NF_QUANT,
	SD1.D1_VUNIT NF_VUNIT,
	SD1.D1_TOTAL NF_TOTAL,
	SD1.D1_TES NF_TES,
	SD1.D1_CUSTO NF_CUSTO,
	SD1.D1_QTDPEDI as NF_QTDPEDI,
	SD1.D1_VALDESC as NF_VALDESC,
	SD1.D1_SEGURO as NF_SEGURO,

	case when trim(SC7.C7_YOS) = '2024/0' then right(left(replace(replace(SC7.C7_OBS, char(10), ''), char(13), ''), 63), 11) else SC7.C7_YOS end as OS_PORT,
	isnull(nullif(SC7.C7_YOSIT, ''), '0') as ITEMOS_PORT,

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
    cast(SD1.D1_TOTAL as numeric(14, 2)) as VL_NFENT_MERCADORIA,
    cast(SD1.D1_VALIMP6 as numeric(14, 2)) as VL_NFENT_PIS,
    cast(SD1.D1_VALIMP5 as numeric(14, 2)) as VL_NFENT_COFINS,
    cast(SD1.D1_VALISS as numeric(14, 2)) as VL_NFENT_ISS,
    cast(SD1.D1_ICMSRET as numeric(14, 2)) as VL_NFENT_ICMS_SUBST,
    cast(SD1.D1_DESC as numeric(12, 2)) as VL_NFENT_DESCONTO,
    cast(SD1.D1_VALIRR as numeric(14, 2)) as VL_NFENT_IRF,
    cast(SD1.D1_VALINS as numeric(14, 2)) as VL_NFENT_INSS,
	cast(SD1.D1_SEGURO as numeric(14, 2)) as VL_NFENT_SEGURO,
	cast(SD1.D1_QUANT as numeric(13, 3)) as QTD_ITEM_NFENT,
	cast(SD1.D1_PESO * SD1.D1_QUANT as numeric(12, 4)) as PESO_LIQUIDO_NFENT,

	case when lag(SC7.C7_NUM, 1, 0) over (partition by SC7.C7_FILIAL, SC7.C7_NUM, SD1.D1_DOC, SD1.D1_SERIE order by SC7.R_E_C_N_O_) = 0 then 1 else 0 end as QTD_PEDIDOS

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

		inner join SBM010 SBM (nolock)
			on SBM.D_E_L_E_T_ = ''
			and SBM.BM_GRUPO = SB1.B1_GRUPO

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
where SC7.D_E_L_E_T_ = ''
