SELECT
    SF2.F2_FILIAL as FILIAL,
    SF2.F2_SERIE AS SERIE,
    SF2.F2_DOC AS DOCUMENTO,
    SD2.D2_PEDIDO AS PEDIDO,
    SD2.D2_ITEM AS DOC_ITEM,
    convert(date, SF2.F2_EMISSAO, 103) as EMISSAO,
    convert(date, SF2.F2_EMINFE, 103) as DOC_SAIDA,
    SF2.F2_TPFRETE AS TIPO_FRETE,
    SD2.D2_TIPO AS DOC_TIPO,
    SD2.D2_ORIGLAN AS ORIGEM_LANC,
    

    trim(SF3.F3_DESCRET) as MSG_NFE,
    trim(SF3.F3_OBSERV) as OBS,
    convert(date, SF3.F3_DTCANC, 103) as DATA_CANCELAMENTO,
    
    trim(SD2.D2_COD) as PRODUTO,
    trim(SB1.B1_DESC) as DESC_PRODUTO,
    trim(ZC1.ZC1_NUM) as OS_PORTUARIA,
    substring(ZC1.ZC1_NUM, 6, 10) as OS,
    left(ZC1.ZC1_EMISSA, 6) as PERIODO_OS,
    cast(ZC1.ZC1_EMISSA as date) as DATA_OS,
    trim(ZC2.ZC2_ITEM) as ITEMOS,
    
    trim(SB1.B1_GRUPO) as GRUPO_PRODUTO,
    trim(SBM.BM_DESC) as DESC_GRUPOPROD,
    
    trim(SD2.D2_TES) as TES,
    trim(SF4.F4_TEXTO) as DESC_TES,
    
    trim(SD2.D2_CF) as CFOP,
    trim(CFOP.X5_DESCRI) as DESC_CFOP,
    
    trim(SA1.A1_TIPO) as TIPO_CLIENTE,
    
    trim(SF2.F2_CLIENTE) as BK_CLIENTE,
    trim(SA1.A1_NOME) as CLIENTE,

    SF2.F2_VALBRUT as VALOR_BRUTO,

    CAST(COALESCE(SD2.D2_VALBRUT, 0) AS DECIMAL(14, 2)) AS VL_FATURAMENTO_TOTAL,
    CAST(COALESCE(SD2.D2_VALICM, 0) AS DECIMAL(14, 2)) AS VL_ICMS_FATURAMENTO,
    CAST(COALESCE(SD2.D2_VALIPI, 0) AS DECIMAL(14, 2)) AS VL_IPI_FATURAMENTO,
    CAST(COALESCE(SD2.D2_VALFRE, 0) AS DECIMAL(14, 2)) AS VL_FRETE_NF,
    CAST(COALESCE(SD2.D2_DESPESA, 0) AS DECIMAL(14, 2)) AS VL_DESPESA,
    CAST(COALESCE(SD2.D2_TOTAL, 0) AS DECIMAL(14, 2)) AS VL_FATURAMENTO_MERCADORIA,
    CAST(COALESCE(SD2.D2_VALIMP6, 0) AS DECIMAL(14, 2)) AS VL_PIS_FATURAMENTO,
    CAST(COALESCE(SD2.D2_VALIMP5, 0) AS DECIMAL(14, 2)) AS VL_COFINS_FATURAMENTO,
    CAST(COALESCE(SD2.D2_QUANT, 0) AS DECIMAL(13, 3)) AS QTD_FATURADA_ITEM,
    CAST(COALESCE(SD2.D2_VALISS, 0) AS DECIMAL(14, 2)) AS VL_ISS_FATURAMENTO,
    CAST(COALESCE(SD2.D2_ICMSRET, 0) AS DECIMAL(14, 2)) AS VL_ICMS_SUBST_FATURAMENTO,
    CAST(COALESCE(SD2.D2_DESCON, 0) AS DECIMAL(12, 2)) AS VL_DESCONTO_FATURAMENTO,
    CAST(COALESCE(SD2.D2_VALIRRF, 0) AS DECIMAL(14, 2)) AS VL_IRF_FATURAMENTO,
    CAST(COALESCE(SD2.D2_VALINS, 0) AS DECIMAL(14, 2)) AS VL_INSS_FATURAMENTO,
    CAST(COALESCE(SD2.D2_PESO * SD2.D2_QUANT, 0) AS DECIMAL(12, 4)) AS PESO_LIQUIDO,
    CAST(COALESCE(SB1.B1_PESBRU * SD2.D2_QUANT, 0) AS DECIMAL(12, 4)) AS PESO_BRUTO,
    1 AS QTD,
    CAST(COALESCE(SD2.D2_PRUNIT, 0) AS DECIMAL(16, 4)) AS VL_UNITARIO,
    CAST(COALESCE(SD2.D2_SEGURO, 0) AS DECIMAL(14, 2)) AS VL_SEGURO,

    case
        /* LP 610-001 */
        when trim(CFOP.X5_CHAVE) = 5933 and SF4.F4_CSTCOF = '08' then trim(SB1.B1_YCTREC4)
        when trim(CFOP.X5_CHAVE) = 5933 and SF4.F4_CSTCOF != '08' and SD2.D2_TES = '511' then trim(SB1.B1_YCTREC5)
        when trim(CFOP.X5_CHAVE) = 5933 and SF4.F4_CSTCOF != '08' and SD2.D2_TES != '511' then trim(SB1.B1_YCTREC3)
        /* LP 610-040 */
        when trim(CFOP.X5_CHAVE) = 5359 then trim(SB1.B1_YCTREC1)
        /* LP 610-600 */
        when trim(CFOP.X5_CHAVE) = 5932 and SD2.D2_TES = '509' then trim(SB1.B1_YCTREC2)
        when trim(CFOP.X5_CHAVE) = 5932 and SD2.D2_TES != '509' then trim(SB1.B1_YCTREC1)
        /* LP 610-010 */
        when trim(CFOP.X5_CHAVE) = 5360 and SD2.D2_TES = '520' then trim(SB1.B1_YCTREC1)
        when trim(CFOP.X5_CHAVE) = 5360 and SD2.D2_TES != '520' then trim(SB1.B1_YCTREC2)
        /* LP 610-020 */
        when trim(CFOP.X5_CHAVE) in (5352, 5353) and (SD2.D2_TES = '507' or SD2.D2_TES = '539') then trim(SB1.B1_YCTREC1)
        when trim(CFOP.X5_CHAVE) in (5352, 5353) and (SD2.D2_TES != '507' and SD2.D2_TES != '539') then trim(SB1.B1_YCTREC2)
        /* LP 610-030 */
        when trim(CFOP.X5_CHAVE) in (5352, 5351) and SD2.D2_TES in ('506', '534', '535', '536', '537') then trim(SB1.B1_YCTREC1)
        when trim(CFOP.X5_CHAVE) in (5352, 5351) and SD2.D2_TES not in ('506', '534', '535', '536', '537') then trim(SB1.B1_YCTREC2)
    else null end as CONTA
from SF3010 SF3 (nolock)
    inner join SF2010 SF2 (nolock)
        on SF2.F2_SERIE not in ('003', '100')
        and SF2.F2_CLIENTE = SF3.F3_CLIEFOR
        and SF2.F2_LOJA = SF3.F3_LOJA
        and SF2.F2_DOC = SF3.F3_NFISCAL
        and SF2.F2_SERIE = SF3.F3_SERIE

        left join SD2010 SD2 (nolock)
            on SD2.D2_TIPO not in ('B', 'D')
            and SD2.D2_FILIAL = SF2.F2_FILIAL
            and SD2.D2_CLIENTE = SF2.F2_CLIENTE
            and SD2.D2_LOJA = SF2.F2_LOJA
            and SD2.D2_DOC = SF2.F2_DOC
            and SD2.D2_SERIE = SF2.F2_SERIE

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
        
        left join SA1010 SA1 (nolock)
            on SA1.D_E_L_E_T_= ''
            and SA1.A1_COD = SF2.F2_CLIENTE
            and SA1.A1_LOJA = SF2.F2_LOJA
where
        SF3.D_E_L_E_T_ = ''
