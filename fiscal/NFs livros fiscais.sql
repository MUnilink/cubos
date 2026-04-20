    select
        SF1.F1_FILIAL as FILIAL,
        SF1.F1_SERIE as SERIE,
        SF1.F1_DOC as DOCUMENTO,
        SD1.D1_PEDIDO as PEDIDO,
        SD1.D1_ITEM as DOC_ITEM,
        left(SF1.F1_EMISSAO, 6) as PERIODO_EMI,
        left(SF1.F1_DTDIGIT, 6) as PERIODO,
        cast(SF1.F1_EMISSAO as date) as DT_EMISSAO,
        cast(SF1.F1_DTDIGIT as date) as DT_DIGITAC,
        cast(SF3.F3_DTCANC as date) as DATA_CANCELAMENTO,
        SF1.F1_ESPECIE as ESPECIE_NF,
        SD1.D1_TIPO as DOC_TIPO,
        SD1.D1_ORIGLAN as ORIGEM_LANC,
        SF1.F1_TPFRETE as TIPO_FRETE,
        trim(SF3.F3_DESCRET) as MSG_NFE,
        trim(SF3.F3_OBSERV) as OBS,
        trim(SD1.D1_COD) as PRODUTO,
        trim(SB1.B1_DESC) as DESC_PRODUTO,
        trim(SB1.B1_GRUPO) as GRUPO_PRODUTO,
        trim(SBM.BM_DESC) as DESC_GRUPOPROD,
        trim(SD1.D1_TES) as TES,
        trim(SF4.F4_TEXTO) as DESC_TES,
        trim(SD1.D1_CF) as CFOP,
        trim(CFOP.X5_DESCRI) as DESC_CFOP,
        trim(SA2.A2_TIPO) as TIPO_CLIFOR,
        trim(SF1.F1_FORNECE) as BK_CLIFOR,
        trim(SA2.A2_NOME) as CLIENTE_FORNECEDOR,
        trim(SA2.A2_EST) as UF_CLIFOR,

        cast(SF3.F3_ICMSCOM as numeric(15, 2)) as ICMS_COMPL,
        cast(SF3.F3_DIFAL as numeric(15, 2)) as DIFAL,

        cast(coalesce(SD1.D1_TOTAL, 0) as decimal(14, 2)) as VL_FATURAMENTO_TOTAL,
        cast(coalesce(SD1.D1_VALICM, 0) as decimal(14, 2)) as VL_ICMS_FATURAMENTO,
        cast(coalesce(SD1.D1_VALIPI, 0) as decimal(14, 2)) as VL_IPI_FATURAMENTO,
        cast(coalesce(SD1.D1_VALFRE, 0) as decimal(14, 2)) as VL_FRETE_NF,
        cast(coalesce(SD1.D1_DESPESA, 0) as decimal(14, 2)) as VL_DESPESA,
        cast(coalesce(SD1.D1_TOTAL, 0) as decimal(14, 2)) as VL_FATURAMENTO_MERCADORIA,
        cast(coalesce(SD1.D1_VALIMP6, 0) as decimal(14, 2)) as VL_PIS_FATURAMENTO,
        cast(coalesce(SD1.D1_VALIMP5, 0) as decimal(14, 2)) as VL_COFINS_FATURAMENTO,
        cast(coalesce(SD1.D1_QUANT, 0) as decimal(13, 3)) as QTD_FATURADA_ITEM,
        cast(coalesce(SD1.D1_VALISS, 0) as decimal(14, 2)) as VL_ISS_FATURAMENTO,
        cast(coalesce(SD1.D1_ICMSRET, 0) as decimal(14, 2)) as VL_ICMS_SUBST_FATURAMENTO,
        cast(coalesce(SD1.D1_DESC, 0) as decimal(12, 2)) as VL_DESCONTO_FATURAMENTO,
        cast(coalesce(SD1.D1_VALIRR, 0) as decimal(14, 2)) as VL_IRF_FATURAMENTO,
        cast(coalesce(SD1.D1_VALINS, 0) as decimal(14, 2)) as VL_INSS_FATURAMENTO,
        cast(coalesce(SD1.D1_PESO * SD1.D1_QUANT, 0) as decimal(12, 4)) as PESO_LIQUIDO,
        cast(coalesce(SD1.D1_PESO, 0) as decimal(12, 4)) as PESO_BRUTO,
        cast(coalesce(SD1.D1_VUNIT, 0) as decimal(16, 4)) as VL_UNITARIO,
        cast(coalesce(SD1.D1_SEGURO, 0) as decimal(14, 2)) as VL_SEGURO,
        1 as QTD
    from SF3010 SF3 (nolock)
        left join SF1010 SF1 (nolock)
            on SF1.D_E_L_E_T_ = ''
            and SF1.F1_FORNECE = SF3.F3_CLIEFOR
            and SF1.F1_LOJA = SF3.F3_LOJA
            and SF1.F1_DOC = SF3.F3_NFISCAL
            and SF1.F1_SERIE = SF3.F3_SERIE
            
            left join SD1010 SD1 (nolock)
                on SD1.D_E_L_E_T_ = ''
                and SD1.D1_FILIAL = SF1.F1_FILIAL
                and SD1.D1_FORNECE = SF1.F1_FORNECE
                and SD1.D1_LOJA = SF1.F1_LOJA
                and SD1.D1_DOC = SF1.F1_DOC
                and SD1.D1_SERIE = SF1.F1_SERIE
        
        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_= ''
            and SB1.B1_COD = SD1.D1_COD
        left join SF4010 SF4 (nolock)
            on SF4.D_E_L_E_T_ = ''
            and SF4.F4_CODIGO = SD1.D1_TES
        left join SX5010 CFOP (nolock)
            on CFOP.D_E_L_E_T_ = ''
            and CFOP.X5_TABELA = '13'
            and CFOP.X5_CHAVE = SD1.D1_CF
        left join SA2010 SA2 (nolock)
            on SA2.D_E_L_E_T_= ''
            and SA2.A2_COD = SF1.F1_FORNECE
            and SA2.A2_LOJA = SF1.F1_LOJA
        left join SBM010 SBM (nolock)
            on SBM.D_E_L_E_T_ = ''
            and SBM.BM_GRUPO = SB1.B1_GRUPO
    where SF3.D_E_L_E_T_ = ''
union
    select
        SF2.F2_FILIAL as FILIAL,
        SF2.F2_SERIE as SERIE,
        SF2.F2_DOC as DOCUMENTO,
        SD2.D2_PEDIDO as PEDIDO,
        SD2.D2_ITEM as DOC_ITEM,
        left(SF2.F2_EMISSAO, 6) as PERIODO_EMI,
        left(SF2.F2_EMISSAO, 6) as PERIODO,
        cast(SF2.F2_EMISSAO as date) as DT_EMISSAO,
        cast(SF2.F2_EMISSAO as date) as DT_DIGITAC,
        cast(SF3.F3_DTCANC as date) as DATA_CANCELAMENTO,
        SF2.F2_ESPECIE as ESPECIE_NF,
        SD2.D2_TIPO as DOC_TIPO,
        SD2.D2_ORIGLAN as ORIGEM_LANC,
        SF2.F2_TPFRETE as TIPO_FRETE,
        trim(SF3.F3_DESCRET) as MSG_NFE,
        trim(SF3.F3_OBSERV) as OBS,
        trim(SD2.D2_COD) as PRODUTO,
        trim(SB1.B1_DESC) as DESC_PRODUTO,
        trim(SB1.B1_GRUPO) as GRUPO_PRODUTO,
        trim(SBM.BM_DESC) as DESC_GRUPOPROD,
        trim(SD2.D2_TES) as TES,
        trim(SF4.F4_TEXTO) as DESC_TES,
        trim(SD2.D2_CF) as CFOP,
        trim(CFOP.X5_DESCRI) as DESC_CFOP,
        trim(SA1.A1_TIPO) as TIPO_CLIFOR,
        trim(SF2.F2_CLIENTE) as BK_CLIFOR,
        trim(SA1.A1_NOME) as CLIENTE_FORNECEDOR,
        trim(SA1.A1_EST) as UF_CLIFOR,

        cast(SF3.F3_ICMSCOM as numeric(15, 2)) as ICMS_COMPL,
        cast(SF3.F3_DIFAL as numeric(15, 2)) as DIFAL,
        
        cast(coalesce(SD2.D2_VALBRUT, 0) as decimal(14, 2)) as VL_FATURAMENTO_TOTAL,
        cast(coalesce(SD2.D2_VALICM, 0) as decimal(14, 2)) as VL_ICMS_FATURAMENTO,
        cast(coalesce(SD2.D2_VALIPI, 0) as decimal(14, 2)) as VL_IPI_FATURAMENTO,
        cast(coalesce(SD2.D2_VALFRE, 0) as decimal(14, 2)) as VL_FRETE_NF,
        cast(coalesce(SD2.D2_DESPESA, 0) as decimal(14, 2)) as VL_DESPESA,
        cast(coalesce(SD2.D2_TOTAL, 0) as decimal(14, 2)) as VL_FATURAMENTO_MERCADORIA,
        cast(coalesce(SD2.D2_VALIMP6, 0) as decimal(14, 2)) as VL_PIS_FATURAMENTO,
        cast(coalesce(SD2.D2_VALIMP5, 0) as decimal(14, 2)) as VL_COFINS_FATURAMENTO,
        cast(coalesce(SD2.D2_QUANT, 0) as decimal(13, 3)) as QTD_FATURADA_ITEM,
        cast(coalesce(SD2.D2_VALISS, 0) as decimal(14, 2)) as VL_ISS_FATURAMENTO,
        cast(coalesce(SD2.D2_ICMSRET, 0) as decimal(14, 2)) as VL_ICMS_SUBST_FATURAMENTO,
        cast(coalesce(SD2.D2_DESCON, 0) as decimal(12, 2)) as VL_DESCONTO_FATURAMENTO,
        cast(coalesce(SD2.D2_VALIRRF, 0) as decimal(14, 2)) as VL_IRF_FATURAMENTO,
        cast(coalesce(SD2.D2_VALINS, 0) as decimal(14, 2)) as VL_INSS_FATURAMENTO,
        cast(coalesce(SD2.D2_PESO * SD2.D2_QUANT, 0) as decimal(12, 4)) as PESO_LIQUIDO,
        cast(coalesce(SB1.B1_PESBRU * SD2.D2_QUANT, 0) as decimal(12, 4)) as PESO_BRUTO,
        cast(coalesce(SD2.D2_PRUNIT, 0) as decimal(16, 4)) as VL_UNITARIO,
        cast(coalesce(SD2.D2_SEGURO, 0) as decimal(14, 2)) as VL_SEGURO,
        1 as QTD
    from SF3010 SF3 (nolock)
        inner join SF2010 SF2 (nolock)
            on SF2.F2_SERIE not in ('003', '100')
            and SF2.F2_CLIENTE = SF3.F3_CLIEFOR
            and SF2.F2_LOJA = SF3.F3_LOJA
            and SF2.F2_DOC = SF3.F3_NFISCAL
            and SF2.F2_SERIE = SF3.F3_SERIE

            left join SD2010 SD2 (nolock)
                on SD2.D2_FILIAL = SF2.F2_FILIAL
                and SD2.D2_CLIENTE = SF2.F2_CLIENTE
                and SD2.D2_LOJA = SF2.F2_LOJA
                and SD2.D2_DOC = SF2.F2_DOC
                and SD2.D2_SERIE = SF2.F2_SERIE
                and SD2.D2_TIPO not in ('B', 'D')
        
        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_= ''
            and SB1.B1_COD = SD2.D2_COD
        left join SF4010 SF4 (nolock)
            on SF4.D_E_L_E_T_ = ''
            and SF4.F4_CODIGO = SD2.D2_TES
        left join SX5010 CFOP (nolock)
            on CFOP.D_E_L_E_T_ = ''
            and CFOP.X5_TABELA = '13'
            and CFOP.X5_CHAVE = SD2.D2_CF
        left join SA1010 SA1 (nolock)
            on SA1.D_E_L_E_T_= ''
            and SA1.A1_COD = SF2.F2_CLIENTE
            and SA1.A1_LOJA = SF2.F2_LOJA
        left join SBM010 SBM (nolock)
            on SBM.D_E_L_E_T_ = ''
            and SBM.BM_GRUPO = SB1.B1_GRUPO
    where SF3.D_E_L_E_T_ = ''
