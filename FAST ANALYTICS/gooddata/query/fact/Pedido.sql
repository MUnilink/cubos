select
    'P |01|01' AS BK_EMPRESA,
    case when SC5.C5_FILIAL is null then 'P |01||' else 'P |01|01'+ CAST(SC5.C5_FILIAL AS CHAR (6)) end as BK_FILIAL,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC5.C5_CLIENTE, ' '))+RTRIM(COALESCE(SC5.C5_LOJACLI, ' ')), ' '), '|') AS BK_CLIENTE,
    'P |01|SA4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA4.A4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC5.C5_TRANSP, ' ')), ' '), '|') AS BK_TRANSPORTADORA,
    'P |01|SA3010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA3.A3_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC5.C5_VEND1, ' ')), ' '), '|') AS BK_VENDEDOR,
    'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC5.C5_CONDPAG, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO,
    'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC6.C6_PRODUTO, ' ')), ' '), '|') AS BK_ITEM,
    'P |01|SF4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SF4.F4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC6.C6_TES, ' ')), ' '), '|') AS BK_TES,
    case when  SA1.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1.A1_EST, ' ')), ' '), '|') else 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1.A1_EST, ' '))+RTRIM(COALESCE(SA1.A1_COD_MUN, ' ')), ' '), '|') end as BK_REGIAO,
    
    concat(trim(ZC2.ZC2_FILIAL), trim(ZC2.ZC2_NUM)) as ID_OSPORTUARIA,
    concat(trim(SC5.C5_FILIAL), trim(SC5.C5_NUM)) as ID_PEDIDODEVENDA,
    concat('SF2', trim(SD2.D2_FILIAL), trim(SD2.D2_CLIENTE), trim(SD2.D2_LOJA), trim(SD2.D2_DOC), trim(SD2.D2_SERIE)) as ID_NF,

    SC5.C5_NUM AS NUMERO_DO_PEDIDO,
    SC5.C5_EMISSAO AS DATA_DA_VENDA,
    SC6.C6_ENTREG AS DATA_DA_ENTREGA,
    SC6.C6_ITEM AS NUMERO_DO_ITEM,
    SC6.C6_VALOR AS VL_VENDA_TOTAL,
    SC6.C6_QTDVEN AS QTDE_VENDIDA,
    SC6.C6_PRCVEN AS VL_PRECO_UNITARIO,
    SC6.C6_VALOR AS VL_VENDA_MERCADORIA,
    SC6.C6_VALOR AS VL_VENDA_LIQUIDA,
    SC6.C6_PRUNIT AS VL_PRECO_LISTA,
    
    case when SC9.C9_BLEST = ' ' and SC9.C9_BLCRED = '  ' then 'Liberado' else 'Bloqueado' end as STATUS_DO_ITEM_DO_PEDIDO,    
    case
        when SC5.C5_LIBEROK = '' and SC5.C5_NOTA = '' and SC5.C5_BLQ = '' then 'Aberto'
        when SC5.C5_NOTA != '' or SC5.C5_LIBEROK = 'E' and SC5.C5_BLQ = '' then 'Encerrado'
        when (SC5.C5_LIBEROK != '' and SC5.C5_NOTA = '' and SC5.C5_BLQ = '') then 'Liberado'
        when (SC5.C5_BLQ = '1') then 'Bloqueio por Regra'
        when (SC5.C5_BLQ = '2') then 'Bloqueio por Verba'
    end as STATUS_DO_PEDIDO

from SC5010 SC5
    INNER JOIN SC6010 SC6
        ON C6_FILIAL = C5_FILIAL
        AND C6_NUM = C5_NUM
        AND SC6.D_E_L_E_T_ = ' '
    INNER JOIN SF4010 SF4
        ON F4_FILIAL = '      '
        AND SC6.C6_TES = SF4.F4_CODIGO
        AND SF4.D_E_L_E_T_ = ' '
    LEFT JOIN SB1010 SB1
        ON B1_FILIAL = '      '
        AND B1_COD = C6_PRODUTO
        AND SB1.D_E_L_E_T_ = ' '
    LEFT JOIN SA4010 SA4
        ON A4_FILIAL = '      '
        AND A4_COD = C5_TRANSP
        AND SA4.D_E_L_E_T_ = ' '
    LEFT JOIN SA1010 SA1
        ON A1_FILIAL = '      '
        AND A1_COD = C5_CLIENTE
        AND A1_LOJA = C5_LOJACLI
        AND SA1.D_E_L_E_T_ = ' '
    LEFT JOIN SA3010 SA3
        ON A3_FILIAL = '      '
        AND A3_COD = C5_VEND1
        AND SA3.D_E_L_E_T_ = ' '
    LEFT JOIN SE4010 SE4
        ON E4_FILIAL = '      '
        AND E4_CODIGO = C5_CONDPAG
        AND SE4.D_E_L_E_T_ = ' '
    
    LEFT JOIN
    (
        SELECT
            A.C9_BLEST,
            A.C9_BLCRED,
            A.C9_PEDIDO,
            A.C9_PRODUTO,
            A.C9_ITEM,
            A.C9_FILIAL
        FROM SC9010 A
        WHERE
                A.D_E_L_E_T_ = ' '
            AND A.C9_SEQUEN =
            (
                SELECT MAX(C9_SEQUEN)
                FROM SC9010
                WHERE
                        SC9010.C9_FILIAL = A.C9_FILIAL
                    AND SC9010.C9_PEDIDO = A.C9_PEDIDO
                    AND SC9010.C9_PRODUTO = A.C9_PRODUTO
                    AND SC9010.C9_ITEM = A.C9_ITEM
                    AND SC9010.D_E_L_E_T_ = ' '
            )
    ) SC9
        ON SC9.C9_PEDIDO = SC6.C6_NUM
        AND SC9.C9_PRODUTO = SC6.C6_PRODUTO
        AND SC9.C9_ITEM = SC6.C6_ITEM
        AND SC9.C9_FILIAL = SC5.C5_FILIAL
    
    left join ZC2010 ZC2 (nolock)
        on ZC2.D_E_L_E_T_ = ''
        and ZC2.ZC2_FILIAL = SC6.C6_FILIAL
        and ZC2.ZC2_NUM = SC6.C6_YOS
        and ZC2.ZC2_ITEM = SC6.C6_YITOS
            
        left join SD2010 SD2
            on SD2.D_E_L_E_T_ = ''
            and SD2.D2_FILIAL = SC5.C5_FILIAL
            and SD2.D2_PEDIDO = SC5.C5_NUM
where
        SC5.C5_TIPO = 'N'
    and SC5.D_E_L_E_T_ = ''
