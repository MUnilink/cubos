SELECT
    SD2.D2_FILIAL as BK_FILIAL,
    SF2.F2_SERIE AS SERIE_DA_NOTA_FISCAL,
    SF2.F2_DOC AS NUMERO_DA_NOTA_FISCAL,
    trim(SD2.D2_CCUSTO) as CC_NF,
    trim(SD2.D2_ITEMCC) as ATIVIDADE_NF,
    SD2.D2_TIPO AS TIPO_NF,
    SD2.D2_ORIGLAN AS ORIGEM_NF,
    
    convert(date, SF2.F2_EMISSAO, 103) as DATA_NF,
    substring(SF2.F2_EMISSAO, 1, 6) PERIODO_NF,
    SF2.F2_ESPECIE as ESPECIE_NF,
    case SF2.F2_SERIE when '003' then 'EST' when '100' then 'EST' else 'FAT' end as MODULO,

    SF2.F2_TPFRETE AS TIPO_DE_FRETE,
    trim(SF3.F3_DESCRET) as MSG_NFE,
    trim(SF3.F3_OBSERV) as OBS_NFE,
    substring(SF3.F3_DTCANC, 1, 6) as PERIODO_CANCELAMENTO,
    convert(date, SF3.F3_DTCANC, 103) as DATA_CANCELAMENTO,
    
    trim(SD2.D2_COD) as PRODUTO,
    trim(SB1.B1_DESC) as DESC_PRODUTO,
    trim(SB1.B1_GRUPO) as GRUPO_PRODUTO,
    trim(SBM.BM_DESC) as DESC_GRUPOPROD,
    
    trim(SD2.D2_TES) as TES,
    trim(SF4.F4_TEXTO) as DESC_TES,
    trim(SD2.D2_CF) as CFOP,
    trim(CFOP.X5_DESCRI) as DESC_CFOP,
    
    trim(SA1.A1_TIPO) as TIPO_CLIENTE,
    trim(SF2.F2_CLIENTE) as BK_CLIENTE,
    trim(SA1.A1_NOME) as CLIENTE,

    trim(SC6.C6_NUM) as PEDIDO,
    trim(SC6.C6_ITEM) as ITEMPV,
    trim(SC6.C6_UM) as UN_PEDIDO,
    trim(SC6.C6_CC) as CC_PEDIDO,
    trim(SC6.C6_ITEMCTA) as ATIVIDADE_PEDIDO,

    SC6.C6_QTDVEN as QTD_PEDIDO,
    SC6.C6_PRCVEN as PRECO_PEDIDO,
    SC6.C6_VALOR as VALOR_PEDIDO,

    SF2.F2_VALBRUT as VALOR_BRUTO,
    cast(coalesce(SD2.D2_QUANT, 0) as decimal(13, 3)) AS QTD_FATURADA_ITEM,
    CAST(COALESCE(SD2.D2_VALBRUT, 0) AS DECIMAL(14, 2)) AS VL_FATURAMENTO_TOTAL,
    CAST(COALESCE(SD2.D2_VALICM, 0) AS DECIMAL(14, 2)) AS VL_ICMS_FATURAMENTO,
    CAST(COALESCE(SD2.D2_VALIPI, 0) AS DECIMAL(14, 2)) AS VL_IPI_FATURAMENTO,
    CAST(COALESCE(SD2.D2_VALFRE, 0) AS DECIMAL(14, 2)) AS VL_FRETE_NF,
    CAST(COALESCE(SD2.D2_DESPESA, 0) AS DECIMAL(14, 2)) AS VL_DESPESA,
    CAST(COALESCE(SD2.D2_TOTAL, 0) AS DECIMAL(14, 2)) AS VL_FATURAMENTO_MERCADORIA,
    CAST(COALESCE(SD2.D2_VALIMP6, 0) AS DECIMAL(14, 2)) AS VL_PIS_FATURAMENTO,
    CAST(COALESCE(SD2.D2_VALIMP5, 0) AS DECIMAL(14, 2)) AS VL_COFINS_FATURAMENTO,
    CAST(COALESCE(SD2.D2_VALISS, 0) AS DECIMAL(14, 2)) AS VL_ISS_FATURAMENTO,
    CAST(COALESCE(SD2.D2_ICMSRET, 0) AS DECIMAL(14, 2)) AS VL_ICMS_SUBST_FATURAMENTO,
    CAST(COALESCE(SD2.D2_DESCON, 0) AS DECIMAL(12, 2)) AS VL_DESCONTO_FATURAMENTO,
    CAST(COALESCE(SD2.D2_VALIRRF, 0) AS DECIMAL(14, 2)) AS VL_IRF_FATURAMENTO,
    CAST(COALESCE(SD2.D2_VALINS, 0) AS DECIMAL(14, 2)) AS VL_INSS_FATURAMENTO,
    CAST(COALESCE(SD2.D2_PESO * SD2.D2_QUANT, 0) AS DECIMAL(12, 4)) AS PESO_LIQUIDO,
    1 AS contador,
    CAST(COALESCE(SD2.D2_PRUNIT, 0) AS DECIMAL(16, 4)) AS VL_UNITARIO,
    CAST(COALESCE(SD2.D2_SEGURO, 0) AS DECIMAL(14, 2)) AS VL_SEGURO,

    trim(ZC2.ZC2_NUM) as OS_PORTUARIA,
    substring(ZC2.ZC2_NUM, 6, 10) as OS,
    substring(ZC1.ZC1_EMISSA, 1, 6) as PERIODO_OS,
    convert(date, ZC1.ZC1_EMISSA, 103) as DATA_OS,
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
    end as STATUS_PEDIDO

FROM SD2010 SD2
    INNER JOIN SF2010 SF2 (nolock)
        ON F2_FILIAL = D2_FILIAL
        AND F2_CLIENTE = D2_CLIENTE
        AND F2_LOJA = D2_LOJA
        AND F2_DOC = D2_DOC
        AND F2_SERIE = D2_SERIE
        AND SF2.D_E_L_E_T_= ' '

        LEFT JOIN SA1010 SA1 (nolock)
            ON A1_FILIAL = '      '
            AND SA1.A1_COD = SF2.F2_CLIENTE
            AND SA1.A1_LOJA = SF2.F2_LOJA
            AND SA1.D_E_L_E_T_= ' '

        left join SF3010 SF3 (nolock)
            on SF3.D_E_L_E_T_ = ''
            and SF3.F3_CLIEFOR = SF2.F2_CLIENTE
            and SF3.F3_LOJA = SF2.F2_LOJA
            and SF3.F3_NFISCAL = SF2.F2_DOC
            and SF3.F3_SERIE = SF2.F2_SERIE

    INNER JOIN SB1010 SB1 (nolock)
        ON B1_FILIAL = '      '
        AND SB1.B1_COD = SD2.D2_COD
        AND SB1.D_E_L_E_T_= ' '
    INNER JOIN SF4010 SF4 (nolock)
        ON F4_FILIAL = '      '
        AND SF4.F4_CODIGO = SD2.D2_TES
        AND SF4.D_E_L_E_T_ = ' '
    LEFT JOIN SBM010 SBM (nolock)
        ON BM_FILIAL = '      '
        AND BM_GRUPO = B1_GRUPO
        AND SBM.D_E_L_E_T_ = ' '
    LEFT JOIN SA3010 SA3 (nolock)
        ON A3_FILIAL = '      '
        AND A3_COD = F2_VEND1
        AND SA3.D_E_L_E_T_ = ' '
    LEFT JOIN SX5010 CFOP (nolock)
        ON X5_FILIAL = '      '
        AND X5_TABELA = '13'
        AND X5_CHAVE = D2_CF
        AND CFOP.D_E_L_E_T_ = ' '
    
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

where
        SD2.D_E_L_E_T_ = ' '
    and SD2.D2_TIPO not in ('B', 'D')
    and SD2.D2_SERIE not in ('003', '100')
