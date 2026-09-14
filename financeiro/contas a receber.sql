select
	trim(SE1.E1_FILIAL) as FILIAL_TITULO,
	trim(SE1.E1_PREFIXO) as PREFIXO,
	trim(SE1.E1_NUM) as TITULO,
	trim(SE1.E1_TIPO) as TIPO_TITULO,
	cast(SE1.E1_EMISSAO as date) as DATA_TITULO,
	left(SE1.E1_EMISSAO, 6) as PERIODO_TITULO,
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
    trim(DT6.DT6_CHVCTE) as CHAVE_NF,

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

    trim(ZC2.ZC2_NUM) as OS_PORTUARIA,
    substring(ZC2.ZC2_NUM, 6, 10) as OS,
    left(ZC1.ZC1_EMISSA, 6) as PERIODO_OS,
    cast(ZC1.ZC1_EMISSA as date) as DATA_OS,
    (select trim(DA0010.DA0_DESCRI) from DA0010 where DA0010.D_E_L_E_T_ = '' and DA0010.DA0_CODTAB = ZC1.ZC1_TABPRC) as TABELA_PRECO,
    trim(ZC2.ZC2_ITEM) as ITEMOS,
    trim(upper(ZC2.ZC2_NMUSU)) as USUARIO_OS,
    ZC2.ZC2_QTDPRV as QTD_PREV,
    ZC2.ZC2_QTDREA as QTD_REAL,
    ZC2.ZC2_VLUPRV as VAL_PREV,
    ZC2.ZC2_VLUREA as VAL_REAL,
    
    (select trim(ZA3010.ZA3_DESC) from ZA3010 where ZA3010.D_E_L_E_T_ = '' and ZA3010.ZA3_COD = ZC1.ZC1_NAVIO) as DESC_NAVIO,
    (select trim(SX5010.X5_DESCRI) from SX5010 where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = '_1' and SX5010.X5_CHAVE = ZC1.ZC1_PORTO) as DESC_PORTO,
    trim(ZC1.ZC1_VIAGEM) as VIAGEM_PORT,

    case ZC1.ZC1_STATUS
        when 1 then 'ABERTA'
        when 2 then 'SOLICITADO CANCELAMENTO'
        when 3 then 'CANCELADA'
        when 5 then 'CORTESIA'
        when 6 then 'ENCERRADA'
        else 'OUTROS'
    end as STATUS_OS,
    
    case ZC1.ZC1_STATU2
        when 1 then 'PENDENTE'
        when 2 then 'PARCIAL'
        when 3 then 'FINALIZADO'
        else 'OUTROS'
    end as STATUS_PEDIDO,

    coalesce
    (
        DUD.DUD_VIAGEM, /* viagem normal */
        VGA2.DUD_VIAGEM, /* se viagem atrelada ao complemento */
        (
            select distinct DUD010.DUD_VIAGEM /* NF de receita extra da viagem */
            from DUD010 (nolock)
                inner join SC5010 (nolock)
                    on SC5010.D_E_L_E_T_ = ' '
                    and nullif(SC5010.C5_YVIAGEM, '') = DUD010.DUD_VIAGEM
            where
                    DUD010.D_E_L_E_T_ = ''
                and DUD010.DUD_STATUS != 9
                and SD2.D2_FILIAL = SC5010.C5_FILIAL
                and SD2.D2_DOC = SC5010.C5_NOTA
                and SD2.D2_SERIE = SC5010.C5_SERIE
                and SD2.D2_CLIENTE = SC5010.C5_CLIENTE
                and SD2.D2_LOJA = SC5010.C5_LOJACLI
        )
    ) as VIAGEM_TMS,
    
    trim(DF1.DF1_NUMAGE) as AGENDAMENTO,
    trim(DF1.DF1_ITEAGE) as AGENDAMENTO_ITEM,
    trim(DF1.DF1_YOSCLI) as OS_CLIENTE,

    case
        when coalesce(DUD.DUD_STATUS, VGA2.DUD_STATUS) = 1 then upper('Em Aberto')
        when coalesce(DUD.DUD_STATUS, VGA2.DUD_STATUS) = 2 then upper('Em Transito')
        when coalesce(DUD.DUD_STATUS, VGA2.DUD_STATUS) = 3 then upper('Carregado')
        when coalesce(DUD.DUD_STATUS, VGA2.DUD_STATUS) = 4 then upper('Encerrado')
        when coalesce(DUD.DUD_STATUS, VGA2.DUD_STATUS) = 9 then upper('Cancelado')
        else 'Outros'
    end as STATUS_CTE,

    cast(DT6.DT6_DATEMI as date) as DATA_CTE,
    DT6.DT6_VALFRE as VL_CTE,
    DT6.DT6_VALIMP as VL_CTEIMP,
    DT6.DT6_VALTOT as VL_CTETOTAL,
    DT6.DT6_VALMER as VL_MERCAD,
    trim(REG_COL.DUY_EST) as UF_COLETA,
	trim(REG_COL.DUY_DESCRI) as MUN_COLETA,
	trim(REG_ENT.DUY_EST) as UF_ENTREGA,
	trim(REG_ENT.DUY_DESCRI) as MUN_ENTREGA,

    1 as contador

from SE1010 SE1
	left join SA1010 SA1
		on SA1.D_E_L_E_T_ = ''
		and SA1.A1_COD = SE1.E1_CLIENTE
		and SA1.A1_LOJA = SE1.E1_LOJA
	
    left join SD2010 SD2
        on SD2.D2_FILIAL = SE1.E1_FILIAL
        and SD2.D2_DOC = SE1.E1_NUM
        and SD2.D2_CLIENTE = SE1.E1_CLIENTE
        and SD2.D2_LOJA = SE1.E1_LOJA
        and SD2.D_E_L_E_T_ = ''
	
        left join SC6010 SC6
            on SC6.D_E_L_E_T_ = ''
            and SC6.C6_FILIAL = SD2.D2_FILIAL
            and SC6.C6_NUM = SD2.D2_PEDIDO
            and SC6.C6_ITEM = SD2.D2_ITEMPV

            left join ZC2010 ZC2
                on ZC2.D_E_L_E_T_ = ''
                and ZC2.ZC2_FILIAL = SC6.C6_FILIAL
                and ZC2.ZC2_NUM = SC6.C6_YOS
                and ZC2.ZC2_ITEM = SC6.C6_YITOS

                left join ZC1010 ZC1
                    on ZC1.D_E_L_E_T_ = ''
                    and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
                    and ZC1.ZC1_NUM = ZC2.ZC2_NUM

        left join DUD010 DUD
            on DUD.D_E_L_E_T_ = ''
            and DUD.DUD_FILDOC = SD2.D2_FILIAL
            and DUD.DUD_DOC = SD2.D2_DOC
            and DUD.DUD_SERIE = SD2.D2_SERIE
            and DUD.DUD_SERIE != 'COL'

            left join DTC010 DTC
                on DTC.D_E_L_E_T_ = ''
                and DTC.DTC_FILDOC = DUD.DUD_FILDOC
                and DTC.DTC_DOC = DUD.DUD_DOC
                and DTC.DTC_SERIE = DUD.DUD_SERIE

                left join DF1010 DF1
                    on DF1.D_E_L_E_T_ = ''
                    and DF1.DF1_FILDOC = DTC.DTC_FILDOC
                    and DF1.DF1_DOC = DTC.DTC_NUMSOL
            
            left join DT6010 DT6
                on DT6.D_E_L_E_T_ = ''
                and DT6.DT6_FILDOC = DUD.DUD_FILDOC
                and DT6.DT6_DOC = DUD.DUD_DOC
                and DT6.DT6_SERIE = DUD.DUD_SERIE

                left join DUY010 REG_COL
                    on REG_COL.D_E_L_E_T_ = ''
                    and REG_COL.DUY_FILIAL = DT6.DT6_FILIAL
                    and REG_COL.DUY_GRPVEN = DT6.DT6_CDRORI
                left join DUY010 REG_ENT
                    on REG_ENT.D_E_L_E_T_ = ''
                    and REG_ENT.DUY_FILIAL = DT6.DT6_FILIAL
                    and REG_ENT.DUY_GRPVEN = DT6.DT6_CDRCAL

        left join SD2010 COMP
            on COMP.D_E_L_E_T_ = ''
            and COMP.D2_DOC = SD2.D2_NFORI
            and COMP.D2_SERIE = SD2.D2_SERIORI
            and COMP.D2_CLIENTE = SD2.D2_CLIENTE
            and COMP.D2_LOJA = SD2.D2_LOJA

            left join DUD010 VGA2
                on VGA2.D_E_L_E_T_ = ''
                and VGA2.DUD_FILDOC = COMP.D2_FILIAL
                and VGA2.DUD_DOC = COMP.D2_DOC
                and VGA2.DUD_SERIE = COMP.D2_SERIE
        
        left join SB1010 SB1
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD2.D2_COD

            left join SBM010 SBM
                on SBM.D_E_L_E_T_ = ''
                and SBM.BM_GRUPO = SB1.B1_GRUPO
        
    left join CTT010 CTT
        on CTT.D_E_L_E_T_ = ''
        and CTT.CTT_CUSTO = SE1.E1_CCUSTO
    left join CTD010 CTD
        on CTD.D_E_L_E_T_ = ''
        and CTD.CTD_ITEM = SE1.E1_ITEMCTA
	left join SED010 SED
		on SED.D_E_L_E_T_ = ''
		and SED.ED_CODIGO = SE1.E1_NATUREZ
where
        SE1.D_E_L_E_T_ = ''
    and SD2.D2_EMISSAO >=:DATAINI_DOCUMENTO
