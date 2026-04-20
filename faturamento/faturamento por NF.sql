SELECT
    SD2.D2_FILIAL as BK_FILIAL,
    SF2.F2_SERIE AS SERIE_DA_NOTA_FISCAL,
    SF2.F2_DOC AS NUMERO_DA_NOTA_FISCAL,
    SD2.D2_ITEM as ITEM_NF,
    trim(SD2.D2_CCUSTO) as CC_NF,
    trim(SD2.D2_ITEMCC) as ATIVIDADE_NF,
    SD2.D2_TIPO AS TIPO_NF,
    SD2.D2_ORIGLAN AS ORIGEM_NF,
    
    cast(SF2.F2_EMISSAO as date) as DATA_NF,
    left(SF2.F2_EMISSAO, 6) as PERIODO_NF,
    SF2.F2_ESPECIE as ESPECIE_NF,
    case SF2.F2_SERIE when '003' then 'EST' when '100' then 'EST' else 'FAT' end as MODULO,

    SF2.F2_TPFRETE AS TIPO_DE_FRETE,
    trim(SF3.F3_DESCRET) as MSG_NFE,
    trim(SF3.F3_OBSERV) as OBS_NFE,
    left(SF3.F3_DTCANC, 6) as PERIODO_CANCELAMENTO,
    cast(SF3.F3_DTCANC as date) as DATA_CANCELAMENTO,
    
    trim(SD2.D2_COD) as PRODUTO,
    trim(SB1.B1_DESC) as DESC_PRODUTO,
    trim(SB1.B1_GRUPO) as GRUPO_PRODUTO,
    trim(SBM.BM_DESC) as DESC_GRUPOPROD,
    concat(trim(SB1.B1_YCTREC1), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC1)) as CONTA_REC1,
    concat(trim(SB1.B1_YCTREC2), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC2)) as CONTA_REC2,
    concat(trim(SB1.B1_YCTREC3), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC3)) as CONTA_REC3,
    concat(trim(SB1.B1_YCTREC4), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC4)) as CONTA_REC4,
    concat(trim(SB1.B1_YCTREC5), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC5)) as CONTA_REC5,
    
    trim(SD2.D2_TES) as TES,
    trim(SF4.F4_TEXTO) as DESC_TES,
    trim(SD2.D2_CF) as CFOP,
    trim(CFOP.X5_DESCRI) as DESC_CFOP,
    trim(SF4.F4_CSTCOF) as 'Sit.Trib. COFINS',
    
    trim(SA1.A1_TIPO) as TIPO_CLIENTE,
    SF2.F2_CLIENTE as NUM_CLI,
    SF2.F2_LOJA as LOJA_CLI,
    trim(SA1.A1_NOME) as CLIENTE,

    trim(SC6.C6_NUM) as PEDIDO,
    trim(SC6.C6_ITEM) as ITEMPV,
    trim(SC6.C6_UM) as UN_PEDIDO,
    trim(SC6.C6_CC) as CC_PEDIDO,
    trim(SC6.C6_ITEMCTA) as ATIVIDADE_PEDIDO,
    cast(SC6.C6_ENTREG as date) as DT_ITEMPV,
    cast(SC6.C6_QTDVEN as numeric(15, 2)) as QTD_PEDIDO,
    cast(SC6.C6_PRCVEN as numeric(15, 2)) as PRECO_PEDIDO,
    cast(SC6.C6_VALOR as numeric(15, 2)) as VALOR_PEDIDO,

    case
        /* LP 610-001 */
        when trim(CFOP.X5_CHAVE) like '[5-6]933' and SF4.F4_CSTCOF = '08'
        then concat(trim(SB1.B1_YCTREC4), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC4))
        when trim(CFOP.X5_CHAVE) like '[5-6]933' and SF4.F4_CSTCOF != '08' and SD2.D2_TES = '511'
        then concat(trim(SB1.B1_YCTREC5), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC5))
        when trim(CFOP.X5_CHAVE) like '[5-6]933' and SF4.F4_CSTCOF != '08' and SD2.D2_TES like '50[3-4]'
        then '310101001'
        when trim(CFOP.X5_CHAVE) like '[5-6]933' and SF4.F4_CSTCOF != '08' and (SD2.D2_TES = '522' or SD2.D2_TES = '525')
        then '310101002'
        when trim(CFOP.X5_CHAVE) like '[5-6]933' and SF4.F4_CSTCOF != '08' and SD2.D2_TES != '511'
        then concat(trim(SB1.B1_YCTREC3), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC3))
        
        /* LP 610-040 */
        when trim(CFOP.X5_CHAVE) = 5359
        then concat(trim(SB1.B1_YCTREC1), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC1))
        
        /* LP 610-600 */
        when trim(CFOP.X5_CHAVE) like '[5-6]932' and SD2.D2_TES = '509'
        then concat(trim(SB1.B1_YCTREC2), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC2))
        when trim(CFOP.X5_CHAVE) like '[5-6]932' and SD2.D2_TES != '509'
        then concat(trim(SB1.B1_YCTREC1), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC1))
        
        /* LP 610-010 */
        when trim(CFOP.X5_CHAVE) = '5360' and SD2.D2_TES = '520'
        then concat(trim(SB1.B1_YCTREC1), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC1))
        when trim(CFOP.X5_CHAVE) = '5360' and SD2.D2_TES != '520'
        then concat(trim(SB1.B1_YCTREC2), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC2))
        
        /* LP 610-020 */
        when trim(CFOP.X5_CHAVE) like '[5-6]35[2-3]' and SD2.D2_TES in ('507', '539', '501', '534')
        then concat(trim(SB1.B1_YCTREC1), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC1))
        when trim(CFOP.X5_CHAVE) like '[5-6]35[2-3]' and (SD2.D2_TES != '507' and SD2.D2_TES != '539') and SD2.D2_TES not in ('506', '534', '535', '536', '537')
        then concat(trim(SB1.B1_YCTREC2), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC2))
        
        /* LP 610-030 */
        when trim(CFOP.X5_CHAVE) like '[5-6]35[1-2]' and SD2.D2_TES in ('506', '534', '535', '536', '537')
        then concat(trim(SB1.B1_YCTREC1), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC1))
        when trim(CFOP.X5_CHAVE) like '[5-6]35[1-2]' and SD2.D2_TES not in ('506', '534', '535', '536', '537')
        then concat(trim(SB1.B1_YCTREC2), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC2))
        
        /* LP 610-050 */
        when trim(CFOP.X5_CHAVE) = '7949' and SD2.D2_TES = '522'
        then concat(trim(SB1.B1_YCTREC5), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC5))
        when trim(CFOP.X5_CHAVE) = '7949' and SD2.D2_TES != '522'
        then concat(trim(SB1.B1_YCTREC4), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC4))
        
        /* LP 610-015 */
        when trim(CFOP.X5_CHAVE) like '[5-6]355' and SD2.D2_TES = '520'
        then concat(trim(SB1.B1_YCTREC1), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC1))
        when trim(CFOP.X5_CHAVE) like '[5-6]355' and SD2.D2_TES != '520' and SD2.D2_TES != '558'
        then concat(trim(SB1.B1_YCTREC2), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC2))
        
        /* outros */
        when trim(CFOP.X5_CHAVE) = '5357' and SD2.D2_TES in ('509', '516') then '310101002'
        when trim(CFOP.X5_CHAVE) like '[5-6]357' and SD2.D2_TES = '510' then '310101001'
        when trim(CFOP.X5_CHAVE) = '6355' and SD2.D2_TES = '558' then '310101001'
        when trim(CFOP.X5_CHAVE) = '6353' and SD2.D2_TES = '501' then '310101001'
    else null end as LP_CRE,

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
    1 as contador,
    
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

    case DUD.DUD_STATUS
        when 1 then upper('Em Aberto')
        when 2 then upper('Em Transito')
        when 3 then upper('Carregado')
        when 4 then upper('Encerrado')
        when 9 then upper('Cancelado')
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
	trim(REG_ENT.DUY_DESCRI) as MUN_ENTREGA

from SD2010 SD2 (nolock)
    inner join SF2010 SF2 (nolock)
        on SF2.F2_FILIAL = SD2.D2_FILIAL
        and SF2.F2_CLIENTE = SD2.D2_CLIENTE
        and SF2.F2_LOJA = SD2.D2_LOJA
        and SF2.F2_DOC = SD2.D2_DOC
        and SF2.F2_SERIE = SD2.D2_SERIE
        and SF2.D_E_L_E_T_= ' '

        left join SA1010 SA1 (nolock)
            on SA1.D_E_L_E_T_= ''
            and SA1.A1_COD = SF2.F2_CLIENTE
            and SA1.A1_LOJA = SF2.F2_LOJA
        left join SF3010 SF3 (nolock)
            on SF3.D_E_L_E_T_ = ''
            and SF3.F3_CLIEFOR = SF2.F2_CLIENTE
            and SF3.F3_LOJA = SF2.F2_LOJA
            and SF3.F3_NFISCAL = SF2.F2_DOC
            and SF3.F3_SERIE = SF2.F2_SERIE
        
    left join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_= ''
        and SB1.B1_COD = SD2.D2_COD
    
        left join SBM010 SBM (nolock)
            on SBM.D_E_L_E_T_ = ''
            and SBM.BM_GRUPO = SB1.B1_GRUPO
    
    left join SF4010 SF4 (nolock)
        on SF4.D_E_L_E_T_ = ''
        and SF4.F4_CODIGO = SD2.D2_TES
    left join SX5010 CFOP (nolock)
        on CFOP.D_E_L_E_T_ = ''
        and CFOP.X5_TABELA = '13'
        and CFOP.X5_CHAVE = SD2.D2_CF
    
    left join SC6010 SC6 (nolock)
        on SC6.D_E_L_E_T_ = ''
        and SC6.C6_FILIAL = SD2.D2_FILIAL
        and SC6.C6_NUM = SD2.D2_PEDIDO
        and SC6.C6_ITEM = SD2.D2_ITEMPV
        
        left join ZC2010 ZC2 (nolock)
            on ZC2.D_E_L_E_T_ = ''
            and ZC2.ZC2_FILIAL = SC6.C6_FILIAL
            and ZC2.ZC2_NUM = SC6.C6_YOS
            and ZC2.ZC2_ITEM = SC6.C6_YITOS

            left join ZC1010 ZC1 (nolock)
                on ZC1.D_E_L_E_T_ = ''
                and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
                and ZC1.ZC1_NUM = ZC2.ZC2_NUM
        
    left join DUD010 DUD (nolock)
        on DUD.D_E_L_E_T_ = ''
        and DUD.DUD_FILDOC = SD2.D2_FILIAL
        and DUD.DUD_DOC = SD2.D2_DOC
        and DUD.DUD_SERIE = SD2.D2_SERIE
        and DUD.DUD_SERIE != 'COL'

		left join DT6010 DT6 (nolock)
			on DT6.D_E_L_E_T_ = ''
			and DT6.DT6_FILDOC = DUD.DUD_FILDOC
			and DT6.DT6_DOC = DUD.DUD_DOC
			and DT6.DT6_SERIE = DUD.DUD_SERIE

            left join DUY010 REG_COL (nolock)
                on REG_COL.D_E_L_E_T_ = ''
                and REG_COL.DUY_FILIAL = DT6.DT6_FILIAL
                and REG_COL.DUY_GRPVEN = DT6.DT6_CDRORI
            left join DUY010 REG_ENT (nolock)
                on REG_ENT.D_E_L_E_T_ = ''
                and REG_ENT.DUY_FILIAL = DT6.DT6_FILIAL
                and REG_ENT.DUY_GRPVEN = DT6.DT6_CDRCAL

    left join SD2010 COMP (nolock)
        on COMP.D_E_L_E_T_ = ''
        and COMP.D2_DOC = SD2.D2_NFORI
        and COMP.D2_SERIE = SD2.D2_SERIORI
        and COMP.D2_CLIENTE = SD2.D2_CLIENTE
        and COMP.D2_LOJA = SD2.D2_LOJA

        left join DUD010 VGA2 (nolock)
            on VGA2.D_E_L_E_T_ = ''
            and VGA2.DUD_FILDOC = COMP.D2_FILIAL
            and VGA2.DUD_DOC = COMP.D2_DOC
            and VGA2.DUD_SERIE = COMP.D2_SERIE
where
        SD2.D_E_L_E_T_ = ' '
    and SD2.D2_TIPO not in ('B', 'D')
    and SD2.D2_SERIE not in ('003', '100')
