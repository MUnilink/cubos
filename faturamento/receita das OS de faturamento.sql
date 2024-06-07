select
    ZC1.ZC1_FILIAL as FILIAL,
    concat(trim(ZC1.ZC1_NUM), trim(ZC2.ZC2_ITEM)) as ID_OS,
    ZC1.ZC1_NUM as NUM_OS,
    cast(substring(ZC1.ZC1_NUM, 6, 10) as int) as OS,
    ZC2.ZC2_ITEM as ITEM,
    substring(ZC1.ZC1_NUM, 1, 4) as ANO_OS,
    substring(ZC1.ZC1_EMISSA, 1, 6) as PERIODO_OS,
    convert(date, ZC1.ZC1_EMISSA, 103) as DATA_OS,
    
    ZC1.ZC1_PORTO as PORTO,
    (select trim(SX5010.X5_DESCRI) from SX5010 where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = '_1' and SX5010.X5_CHAVE = ZC1.ZC1_PORTO) as DESC_PORTO,
    ZC1.ZC1_NAVIO as NAVIO,
    (select trim(ZA3010.ZA3_DESC) from ZA3010 where ZA3010.D_E_L_E_T_ = '' and ZA3010.ZA3_COD = ZC1.ZC1_NAVIO) as DESC_NAVIO,
    trim(ZC1.ZC1_VIAGEM) as VIAGEM_PORT,
    
    case ZC2.ZC2_TIPO
        when 1 then 'RECEITA'
        when 2 then 'FUNÇÃO'
        when 3 then 'EQUIPAMENTO'
        when 4 then 'MATERIAIS'
        when 5 then 'COMPRAS'
        when 6 then 'DEPRECIAÇÃO'
        when 7 then 'CONTABILIDADE'
        when 8 then 'DESPESAS FINANCEIRAS'
        when 9 then 'DOCUMENTAÇÃO E TAXAS'
        when 10 then 'COMBUSTIVEL'
        when 11 then 'TAXAS CIPP'
        when 12 then 'SEGURO'
        when 13 then 'PNEUS'
        else 'OUTROS'
    end as TIPO_INSUMO,

    DEV.A1_COD as CLI_CODIGO,
    DEV.A1_LOJA as CLI_LOJA,
    DEV.A1_CGC as CLI_CNPJ,
    trim(DEV.A1_NOME) as CLIENTE,

    ARM.A1_COD as ARM_CODIGO,
    ARM.A1_LOJA as ARM_LOJA,
    ARM.A1_CGC as ARM_CNPJ,
    trim(DEV.A1_NOME) as ARMADORA,

    DES.A2_COD as DESP_CODIGO,
    DES.A2_LOJA as DESP_LOJA,
    DES.A2_CGC as DESP_CNPJ,
    trim(DES.A2_NOME) as DESPACHANTE,
    
    ZC2.ZC2_INCLUS as TIPO_INCLUSAO,
    ZC1.ZC1_TABPRC as TABELADEPRECO,
    (select trim(DA0010.DA0_DESCRI) from DA0010 where DA0010.D_E_L_E_T_ = '' and DA0010.DA0_CODTAB = ZC1.ZC1_TABPRC) as TABELA_PRECO,
    (select trim(SB1010.B1_DESC) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZA9.ZA9_CODTAX)) as TABELA_TAXAS,

    case cast(ZC2.ZC2_TIPO as int)
        when 1 then (select max(case when SB1010.B1_DESC like 'TRANSPORTE PORTUARIO - %' then replace(SB1010.B1_DESC, 'TRANSPORTE PORTUARIO - ', '') else trim(SB1010.B1_DESC) end) from DA1010 (nolock) inner join SB1010 (nolock) on SB1010.D_E_L_E_T_ = '' and SB1010.B1_COD = DA1010.DA1_CODPRO where DA1010.D_E_L_E_T_ = '' and DA1010.DA1_CODTAB = ZC1.ZC1_TABPRC and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 1)
        when 5 then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 5)
        when 11 then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 11)
        when 2 then (select max(trim(SRJ010.RJ_DESC)) from SRJ010 (nolock) where SRJ010.D_E_L_E_T_ = '' and SRJ010.RJ_FUNCAO = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 2)
        when 3 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 3)
        when 4 then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 4)
        when 6 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 6)
        when 7 then (select max(trim(ZA7010.ZA7_DESC)) from ZA7010 (nolock) where ZA7010.D_E_L_E_T_ = '' and trim(ZA7010.ZA7_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 7)
        when 9 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 9)
        when 10 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 10)
        when 12 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 12)
        when 13 then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 13)
        else trim(ZC2.ZC2_DESC)
    end as DESC_RECURSO,

    trim(ZC2.ZC2_COD) as INSUMO,

    case ZC1.ZC1_STATUS
        when 1 then 'ABERTA'
        when 2 then 'SOLICITADO CANCELAMENTO'
        when 3 then 'CANCELADA'
        when 1 then 'ABERTA'
        when 6 then 'ENCERRADA'
        when 9 then 'PEDIDO CRIADO'
        else 'OUTROS'
    end as STATUS_OS,
    
    case ZC1.ZC1_STATU2
        when 1 then 'PENDENTE'
        when 2 then 'PARCIAL'
        when 3 then 'FINALIZADO'
        else 'OUTROS'
    end as STATUS_PEDIDO,
    
    ZC2.ZC2_QTDPRV as QTD_PREV,
    ZC2.ZC2_QTDREA as QTD_REAL,
    ZC2.ZC2_VLUPRV as VAL_PREV,
    ZC2.ZC2_VLUREA as VAL_REAL,
    ZC2.ZC2_QTDREC as QTD_RECURSO,
    
    trim(ZC2.ZC2_CONTEI) as CONTEINER,
    trim(ZC2.ZC2_LACRE) as LACRE,

    convert(date, ZC2.ZC2_DTINI, 103) as DATA_INIAPONT,
    convert(date, ZC2.ZC2_DTFIM, 103) as DATA_FIMAPONT,
    trim(upper(ZC2.ZC2_NMUSU)) as USUARIO,

    SC6.C6_NUM as PEDIDO,
    SC6.C6_ITEM as ITEM_PEDIDO,
    SC6.C6_UM as UN_PEDIDO,
    SC6.C6_QTDVEN as QTD_PEDIDO,
    SC6.C6_PRCVEN as PRECO_PEDIDO,
    SC6.C6_VALOR as VALOR_PEDIDO,
    SC6.C6_CC as CC_PEDIDO,
    SC6.C6_ITEMCTA as ATIVIDADE_PEDIDO,

    convert(date, SD2.D2_EMISSAO, 103) as DATA_NF,
    substring(SD2.D2_EMISSAO, 1, 6) PERIODO_NF,

    SD2.D2_DOC as NF_DOC,
    SD2.D2_SERIE as NF_SERIE,
    SD2.D2_LOCAL as ARMAZEM,
    SD2.D2_TES as TM,
    SD2.D2_CF as CF,

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
    CAST(COALESCE(SD2.D2_PRUNIT, 0) AS DECIMAL(16, 4)) AS VL_UNITARIO,
    CAST(COALESCE(SD2.D2_SEGURO, 0) AS DECIMAL(14, 2)) AS VL_SEGURO

from ZC2010 ZC2 (nolock)
    left join ZC1010 ZC1 (nolock)
        on ZC1.D_E_L_E_T_ = ''
        and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
        and ZC1.ZC1_NUM = ZC2.ZC2_NUM
        
        left join SA1010 DEV (nolock)
            on DEV.D_E_L_E_T_ = ''
            and DEV.A1_COD = ZC1.ZC1_CODSA1
            and DEV.A1_LOJA = ZC1.ZC1_LOJSA1
        left join SA1010 ARM (nolock)
            on ARM.D_E_L_E_T_ = ''
            and ARM.A1_COD = ZC1.ZC1_ARMADO
            and ARM.A1_LOJA = ZC1.ZC1_LJARMA
        left join SA2010 DES (nolock)
            on DES.D_E_L_E_T_ = ''
            and DES.A2_COD = ZC1.ZC1_DESPA
            and DES.A2_LOJA = ZC1.ZC1_LJDESP

    left join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and trim(ST9.T9_CODBEM) = trim(ZC2.ZC2_COD)
    left join ZA7010 ZA7 (nolock)
        on ZA7.D_E_L_E_T_ = ''
        and trim(ZA7.ZA7_COD) = trim(ZC2.ZC2_COD)
    left join DA4010 DA4 (nolock)
        on DA4.D_E_L_E_T_ = ''
        and DA4.DA4_COD = ZC2.ZC2_MOTORI
    left join ZA9010 ZA9 (nolock)
        on ZA9.D_E_L_E_T_ = ''
        and trim(ZA9.ZA9_SERVIC) = trim(ZC2.ZC2_COD)
    
    left join SC6010 SC6 (nolock)
        on SC6.D_E_L_E_T_ = ''
        and SC6.C6_FILIAL = ZC2.ZC2_FILIAL
        and SC6.C6_YOS = ZC2.ZC2_NUM
        and SC6.C6_YITOS = ZC2.ZC2_ITEM

        left join SC5010 SC5 (nolock)
            on SC5.D_E_L_E_T_ = ' '
            and SC5.C5_FILIAL = SC6.C6_FILIAL
            and SC5.C5_NUM = SC6.C6_NUM
                
        left join SD2010 SD2 (nolock)
            on SD2.D_E_L_E_T_ = ''
            and SD2.D2_FILIAL = SC6.C6_FILIAL
            and SD2.D2_PEDIDO = SC6.C6_NUM
            and SD2.D2_ITEMPV = SC6.C6_ITEM
where
        ZC2.D_E_L_E_T_ = ''
