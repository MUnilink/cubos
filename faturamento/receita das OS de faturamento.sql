select
    (select trim(max(SX6010.X6_CONTEUD)) from SX6010 where SX6010.X6_FIL = ZC2.FILIAL and SX6010.X6_VAR like 'UN_ULTOS%') as PERIODO_ATUAL,
    ZC2.*,
    (select max(trim(ST9010.T9_CCUSTO)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and ST9010.T9_CODBEM = ZC2.INSUMO) as CC,
    
    ZC2.QTDxVALORUNI as VALOR_PROD,
    case when lag(ZC2.ITEM, 1, null) over(partition by ZC2.FILIAL, ZC2.PERIODO, ZC2.TIPO, ZC2.INSUMO order by ZC2.ITEM) is null then (select sum(ZG1010.ZG1_VLIMPR) from ZG1010 (nolock) where ZG1010.D_E_L_E_T_ = '' and ZC2.PERIODO = ZG1010.ZG1_COMPET and ZC2.FILIAL = ZG1010.ZG1_FILORI and ZC2.INSUMO = trim(ZG1010.ZG1_CODIGO) and ZC2.TIPO = cast(ZG1010.ZG1_TIPO as int)) else 0.0 end as CUSTO_IMPR,
    case when lag(ZC2.ITEM, 1, null) over(partition by ZC2.FILIAL, ZC2.PERIODO, ZC2.TIPO, ZC2.INSUMO order by ZC2.ITEM) is null then (select sum(ZG1010.ZG1_VLPROD) from ZG1010 (nolock) where ZG1010.D_E_L_E_T_ = '' and ZC2.PERIODO = ZG1010.ZG1_COMPET and ZC2.FILIAL = ZG1010.ZG1_FILORI and ZC2.INSUMO = trim(ZG1010.ZG1_CODIGO) and ZC2.TIPO = cast(ZG1010.ZG1_TIPO as int)) else 0.0 end as CUSTO_PROD,
    case when lag(ZC2.ITEM, 1, null) over(partition by ZC2.FILIAL, ZC2.PERIODO, ZC2.TIPO, ZC2.INSUMO order by ZC2.FILIAL, ZC2.PERIODO, ZC2.INSUMO, ZC2.ITEM) is null then (select sum(ZC7010.ZC7_HRPAD) from ZC7010 where ZC7010.D_E_L_E_T_ = '' and ZC7010.ZC7_CODIGO = ZC2.INSUMO and ZC7010.ZC7_COMPET = ZC2.PERIODO) else 0.0 end as HORA_PAD,
    case when lag(ZC2.ITEM, 1, null) over(partition by ZC2.FILIAL, ZC2.PERIODO, ZC2.TIPO, ZC2.INSUMO order by ZC2.FILIAL, ZC2.PERIODO, ZC2.INSUMO, ZC2.ITEM) is null then (select sum(ZC7010.ZC7_HRIMPR) from ZC7010 where ZC7010.D_E_L_E_T_ = '' and ZC7010.ZC7_CODIGO = ZC2.INSUMO and ZC7010.ZC7_COMPET = ZC2.PERIODO) else 0.0 end as HORAS_IMPR,
    case when lag(ZC2.ITEM, 1, null) over(partition by ZC2.FILIAL, ZC2.PERIODO, ZC2.TIPO, ZC2.INSUMO order by ZC2.FILIAL, ZC2.PERIODO, ZC2.INSUMO, ZC2.ITEM) is null then (select ZC7010.ZC7_HRPAD from ZC7010 where ZC7010.ZC7_CC = 305 and ZC7010.D_E_L_E_T_ = '' and ZC7010.ZC7_CODIGO = ZC2.INSUMO and ZC7010.ZC7_COMPET = ZC2.PERIODO) else 0.0 end as HORA_OPP,
    case when lag(ZC2.ITEM, 1, null) over(partition by ZC2.FILIAL, ZC2.PERIODO, ZC2.TIPO, ZC2.INSUMO order by ZC2.FILIAL, ZC2.PERIODO, ZC2.INSUMO, ZC2.ITEM) is null then (select ZC7010.ZC7_HRPAD from ZC7010 where ZC7010.ZC7_CC = 304 and ZC7010.D_E_L_E_T_ = '' and ZC7010.ZC7_CODIGO = ZC2.INSUMO and ZC7010.ZC7_COMPET = ZC2.PERIODO) else 0.0 end as HORA_TMS,
    
    (select trim(SX5010.X5_DESCRI) from SX5010 where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = '_1' and SX5010.X5_CHAVE = ZC2.PORTO) as DESC_PORTO,
    (select trim(ZA3010.ZA3_DESC) from ZA3010 where ZA3010.D_E_L_E_T_ = '' and ZA3010.ZA3_COD = ZC2.NAVIO) as DESC_NAVIO,
    (select trim(DA0010.DA0_DESCRI) from DA0010 where DA0010.D_E_L_E_T_ = '' and DA0010.DA0_CODTAB = ZC2.TABELADEPRECO) as DESC_TABPRECO,
    
    case
        when ZC2.TIPO in (1, 4, 5, 11) then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = ZC2.INSUMO and ZC2.TIPO in (1, 4, 5, 11))
        when ZC2.TIPO in (2, 14, 15) then (select trim(SQ3010.Q3_DESCSUM) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and SQ3010.Q3_CARGO = ZC2.INSUMO and ZC2.TIPO in (2, 14))
        when ZC2.TIPO in (3, 6, 9, 10, 12, 13, 16) then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = ZC2.INSUMO and ZC2.TIPO in (3, 6, 9, 10, 12, 13, 16))
        when ZC2.TIPO = 7 then (select trim(ZA7010.ZA7_DESC) from ZA7010 (nolock) where ZA7010.D_E_L_E_T_ = '' and trim(ZA7010.ZA7_COD) = ZC2.INSUMO and ZC2.TIPO = 7)
    else null end as DESC_RECURSO,

    case when ZC2.TIPO in (1, 4, 5, 11) then (select max(trim(SAH010.AH_DESCPO)) from SB1010 (nolock) inner join SAH010 (nolock) on SAH010.D_E_L_E_T_ = '' and SAH010.AH_UNIMED = SB1010.B1_UM where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = ZC2.INSUMO and ZC2.TIPO in (1, 4, 5, 11))
        when ZC2.TIPO in (7) then 'q'
        else 'h'
    end as UN,

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

    SC6.C6_NUM as PEDIDO,
    SC6.C6_ITEM as ITEM_PEDIDO,
    SC6.C6_UM as UN_PEDIDO,
    SC6.C6_QTDVEN as QTD_PEDIDO,
    SC6.C6_PRCVEN as PRECO_PEDIDO,
    SC6.C6_VALOR as VALOR_PEDIDO,
    SC6.C6_CC as CC_PEDIDO,
    SC6.C6_ITEMCTA as ATIVIDADE_PEDIDO,

    cast(SD2.D2_EMISSAO as date) as DATA_NF,
    substring(SD2.D2_EMISSAO, 1, 6) PERIODO_NF,

    SD2.D2_DOC as NF_DOC,
    SD2.D2_SERIE as NF_SERIE,
    SD2.D2_ITEM as NF_ITEM,
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
from
    (
        select
            ZC1010.ZC1_FILIAL as FILIAL,
            concat(trim(ZC1010.ZC1_NUM), trim(ZC2010.ZC2_ITEM)) as ID_OS,
            ZC1010.ZC1_NUM as NUM_OS,
            cast(substring(ZC1010.ZC1_NUM, 6, 10) as int) as OS,
            ZC2010.ZC2_FILORI as FILORI,
            ZC2010.ZC2_ITEM as ITEM,
            lag(ZC2010.ZC2_ITEM, 1, null) over(partition by ZC2010.ZC2_FILIAL, ZC2010.ZC2_COMPET, ZC2010.ZC2_COD order by ZC2010.ZC2_FILIAL, ZC2010.ZC2_COMPET, ZC2010.ZC2_NUM, ZC2010.ZC2_ITEM) as ITEM_ANT,
            left(ZC1010.ZC1_NUM, 4) as ANO_OS,
            left(ZC1010.ZC1_EMISSA, 6) as PERIODO_OS,
            cast(ZC1010.ZC1_EMISSA as date) as DATA_OS,
            left(ZC2010.ZC2_COMPET, 6) as PERIODO,

            case ZC1010.ZC1_STATUS
                when 1 then 'ABERTA'
                when 2 then 'SOLICITADO CANCELAMENTO'
                when 3 then 'CANCELADA'
                when 1 then 'ABERTA'
                when 6 then 'ENCERRADA'
                when 9 then 'PEDIDO CRIADO'
                else 'OUTROS'
            end as STATUS_OS,
            
            case ZC1010.ZC1_STATU2
                when 1 then 'PENDENTE'
                when 2 then 'PARCIAL'
                when 3 then 'FINALIZADO'
                else 'OUTROS'
            end as STATUS_PEDIDO,

            convert(
                datetime,
                case isdate(concat(substring(ZC1010.ZC1_HRINI, 1, 2), ':', substring(ZC1010.ZC1_HRINI, 3, 2)))
                    when 1 then concat(ZC1010.ZC1_DTINI, ' ', isnull(nullif(trim(concat(substring(ZC1010.ZC1_HRINI, 1, 2), ':', substring(ZC1010.ZC1_HRINI, 3, 2), ':', '00')), ':  :00'), '00:00'))
                    else concat(ZC1010.ZC1_DTINI, ' ', '12:00')
                end, 113
            ) as DTINI_OS,
            
            convert(
                datetime,
                case isdate(concat(substring(ZC1010.ZC1_HRFIM, 1, 2), ':', substring(ZC1010.ZC1_HRFIM, 3, 2)))
                    when 1 then concat(ZC1010.ZC1_DTFIM, ' ', isnull(nullif(trim(concat(substring(ZC1010.ZC1_HRFIM, 1, 2), ':', substring(ZC1010.ZC1_HRFIM, 3, 2), ':', '00')), ':  :00'), '00:00'))
                    else concat(ZC1010.ZC1_DTFIM, ' ', '12:00')
                end, 113
            ) as DTFIM_OS,

            ZC1010.ZC1_CODSA1,
            ZC1010.ZC1_LOJSA1,
            ZC1010.ZC1_ARMADO,
            ZC1010.ZC1_LJARMA,
            ZC1010.ZC1_DESPA,
            ZC1010.ZC1_LJDESP,
            
            trim(ZC1010.ZC1_PORTO) as PORTO,
            trim(ZC1010.ZC1_NAVIO) as NAVIO,
            trim(ZC1010.ZC1_TABPRC) as TABELADEPRECO,
            trim(ZC1010.ZC1_VIAGEM) as VIAGEM_PORT,
            trim(ZC2010.ZC2_CONTEI) as CONTEINER,
            trim(ZC2010.ZC2_LACRE) as LACRE,
            cast(ZC2010.ZC2_DATA as date) as DATA_ITEM,
            cast(ZC2010.ZC2_DTINI as date) as DATA_INIAPONT,
            cast(ZC2010.ZC2_DTFIM as date) as DATA_FIMAPONT,
            
            cast(ZC2010.ZC2_TIPO as int) as TIPO,
            
            case cast(ZC2010.ZC2_TIPO as int)
                when 1 then 'RECEITA'
                when 2 then 'FOLHA'
                when 3 then 'MANUTENÇÃO'
                when 4 then 'MATERIAIS'
                when 5 then 'COMPRAS'
                when 6 then 'DEPRECIAÇÃO'
                when 7 then 'CONTABILIDADE'
                when 8 then 'DESPESAS FINANCEIRAS'
                when 9 then 'OUTROS CUSTOS - TAXAS'
                when 10 then 'COMBUSTIVEL'
                when 11 then 'SERVIÇOS TOMADOS'
                when 12 then 'SEGURO'
                when 13 then 'PNEUS'
                when 14 then 'PROVISÕES'
                when 15 then 'TIPO RH IMPROD'
                when 16 then 'TIPO MNT IMPROD'
                else 'OUTROS'
            end as TIPO_INSUMO,

            trim(ZC2010.ZC2_COD) as INSUMO,
            cast(ZC2010.ZC2_QTDPRV as numeric(15, 2)) as QTD_PREV_ITEM,
            cast(ZC2010.ZC2_QTDREA as numeric(15, 2)) as QTD_REAL_ITEM,
            cast(ZC2010.ZC2_VLUPRV as numeric(15, 2)) as VAL_PREV_ITEM,
            cast(ZC2010.ZC2_VLUREA as numeric(15, 2)) as VAL_REAL_ITEM,
            ZC2010.ZC2_QTDREC as QTD_RECURSO,
            
            cast(ZC2010.ZC2_QTDREA as numeric(15, 2)) as HORAS_PROD,
            cast(ZC2010.ZC2_QTDPRV as numeric(15, 2)) * cast(ZC2010.ZC2_VLUPRV as numeric(15, 2)) as VAL_PREV_TOTAL,
            cast(ZC2010.ZC2_QTDREA as numeric(15, 2)) * cast(ZC2010.ZC2_VLUREA as numeric(15, 2)) as VAL_REAL_TOTAL,
            cast(ZC2010.ZC2_TOTAL as numeric(15, 2)) as QTDxVALORUNI,
            trim(upper(ZC2010.ZC2_NMUSU)) as USUARIO
        
        from ZC2010 (nolock)
            left join ZC1010 (nolock)
                on ZC1010.D_E_L_E_T_ = ''
                and ZC1010.ZC1_FILIAL = ZC2010.ZC2_FILIAL
                and ZC1010.ZC1_NUM = ZC2010.ZC2_NUM
        where
                left(ZC2010.ZC2_COMPET, 4) > 2023
            and ZC2010.D_E_L_E_T_ = ''
    ) ZC2

        left join SA1010 DEV (nolock)
            on DEV.D_E_L_E_T_ = ''
            and DEV.A1_COD = ZC2.ZC1_CODSA1
            and DEV.A1_LOJA = ZC2.ZC1_LOJSA1
        left join SA1010 ARM (nolock)
            on ARM.D_E_L_E_T_ = ''
            and ARM.A1_COD = ZC2.ZC1_ARMADO
            and ARM.A1_LOJA = ZC2.ZC1_LJARMA
        left join SA2010 DES (nolock)
            on DES.D_E_L_E_T_ = ''
            and DES.A2_COD = ZC2.ZC1_DESPA
            and DES.A2_LOJA = ZC2.ZC1_LJDESP

    left join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and trim(ST9.T9_CODBEM) = ZC2.INSUMO
    left join ZA7010 ZA7 (nolock)
        on ZA7.D_E_L_E_T_ = ''
        and trim(ZA7.ZA7_COD) = ZC2.INSUMO
    
    left join SC6010 SC6 (nolock)
        on SC6.D_E_L_E_T_ = ''
        and SC6.C6_FILIAL = ZC2.FILIAL
        and SC6.C6_YOS = ZC2.NUM_OS
        and SC6.C6_YITOS = ZC2.ITEM

        left join SC5010 SC5 (nolock)
            on SC5.D_E_L_E_T_ = ' '
            and SC5.C5_FILIAL = SC6.C6_FILIAL
            and SC5.C5_NUM = SC6.C6_NUM
                
        left join SD2010 SD2 (nolock)
            on SD2.D_E_L_E_T_ = ''
            and SD2.D2_FILIAL = SC6.C6_FILIAL
            and SD2.D2_PEDIDO = SC6.C6_NUM
            and SD2.D2_ITEMPV = SC6.C6_ITEM

where ZC2.PERIODO=:PERIODO_CUSTO
