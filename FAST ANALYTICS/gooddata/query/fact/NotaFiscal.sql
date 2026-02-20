SELECT
    'P |01|01' AS BK_EMPRESA,
    CASE WHEN SD2.D2_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(SD2.D2_FILIAL AS CHAR (6)) END AS BK_FILIAL,
    concat('SF2', trim(SF2.F2_FILIAL), trim(SF2.F2_CLIENTE), trim(SF2.F2_LOJA), trim(SF2.F2_DOC), trim(SF2.F2_SERIE)) as ID_NF,
    
    SF2.F2_SERIE as SERIE_DA_NOTA_FISCAL,
    SF2.F2_DOC as NUMERO_DA_NOTA_FISCAL,
    SD2.D2_PEDIDO as NUMERO_PEDIDO_VENDA,
    SD2.D2_ITEM as NUMERO_ITEM,
    trim(SF2.F2_EMISSAO) as DATA_DE_EMISSAO,
    trim(SF2.F2_EMINFE) as DATA_SAIDA_NF,
    SD2.D2_TIPO as TIPO_DE_NOTA_FISCAL,
    SD2.D2_ORIGLAN as ORIGEM_DO_LANCAMENTO,
    
    'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD2.D2_COD, ' ')), ' '), '|') AS BK_ITEM,
    'P |01|SBM010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SBM.BM_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_GRUPO, ' ')), ' '), '|') AS BK_GRUPO_DE_ESTOQUE_PRODUTO,
    'P |01|SA3010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA3.A3_FILIAL, ' '))+'|'+RTRIM(COALESCE(SF2.F2_VEND1, ' ')), ' '), '|') AS BK_VENDEDOR,
    'P |01|SF4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SF4.F4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD2.D2_TES, ' ')), ' '), '|') AS BK_NATUREZA_DE_OPERACAO_TES,
    'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CFOP.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD2.D2_CF, ' ')), ' '), '|') AS BK_CFOP,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA1.A1_TIPO, ' ')), ' '), '|') AS BK_GRUPO_DE_CLIENTE,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD2.D2_CLIENTE, ' '))+RTRIM(COALESCE(SD2.D2_LOJA, ' ')), ' '), '|') AS BK_CLIENTE,
    CASE WHEN SA1.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1.A1_EST, ' '))+RTRIM(COALESCE(SA1.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO,
    'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SF2.F2_COND, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO,
    'P |01|ACY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(ACY.ACY_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA1.A1_GRPVEN, ' ')), ' '), '|') AS BK_REGIAO_COMERCIAL,
    'P |01|SAH010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAH.AH_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD2.D2_UM, ' ')), ' '), '|') AS BK_UNIDADE_DE_MEDIDA,
    'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD2.D2_ITEMCC, ' ')), ' '), '|') AS BK_ITEM_CONTABIL,
    'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD2.D2_CCUSTO, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
    'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(ZC1.ZC1_MERCAD, ' ')), ' '), '|') as ID_MERCADORIA,
    
    concat(trim(SC5.C5_FILIAL), trim(SC5.C5_NUM)) as BK_PEDIDODEVENDA,
    concat(trim(ZC1.ZC1_FILIAL), trim(ZC1.ZC1_NUM)) as BK_OSPORTUARIA,
    coalesce
    (
        concat(DUD.DUD_FILORI, DUD.DUD_VIAGEM), /* viagem normal */
        concat(VGA2.DUD_FILORI, VGA2.DUD_VIAGEM), /* se viagem atrelada ao complemento */
        (
            select distinct concat(DUD010.DUD_FILORI, DUD010.DUD_VIAGEM) /* NF de receita extra da viagem */
            from DUD010 (nolock)
                inner join SC5010 (nolock)
                    on SC5010.D_E_L_E_T_ = ' '
                    and nullif(SC5010.C5_YVIAGEM, '') = DUD010.DUD_VIAGEM
            where
                    DUD010.D_E_L_E_T_ = ''
                and SD2.D2_FILIAL = SC5010.C5_FILIAL
                and SD2.D2_DOC = SC5010.C5_NOTA
                and SD2.D2_SERIE = SC5010.C5_SERIE
                and SD2.D2_CLIENTE = SC5010.C5_CLIENTE
                and SD2.D2_LOJA = SC5010.C5_LOJACLI
        )
    ) as ID_VIAGEMTMS,

    case
        when exists (select * from DTQ010 where DTQ010.D_E_L_E_T_ = '' and DTQ010.DTQ_FILORI = DUD.DUD_FILORI and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM and DTQ010.DTQ_STATUS != '3') then null
        when exists (select * from DTQ010 where DTQ010.D_E_L_E_T_ = '' and DTQ010.DTQ_FILORI = DUD.DUD_FILORI and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM and DTQ010.DTQ_STATUS = '3') then
        (
            select DTW010.DTW_DATREA
            from DTW010 (nolock)
            where 
                    DTW010.D_E_L_E_T_ = ''
                and DTW010.DTW_FILIAL = DUD.DUD_FILIAL
                and DTW010.DTW_FILORI = DUD.DUD_FILORI
                and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                and DTW010.DTW_ATIVID = 50
        )
        when ZC1.ZC1_STATUS = 1 then null
        when ZC1.ZC1_DTENCE = '' then ZC1.ZC1_DTFIM
        else ZC1.ZC1_DTENCE end
    as DT_FIMOS,

    case
        when exists (select * from DTQ010 where DTQ010.D_E_L_E_T_ = '' and DTQ010.DTQ_FILORI = DUD.DUD_FILORI and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM and DTQ010.DTQ_STATUS != '3') then null
        when exists (select * from DTQ010 where DTQ010.D_E_L_E_T_ = '' and DTQ010.DTQ_FILORI = DUD.DUD_FILORI and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM and DTQ010.DTQ_STATUS = '3') then
        (
            select DTW010.DTW_DATREA
            from DTW010 (nolock)
            where 
                    DTW010.D_E_L_E_T_ = ''
                and DTW010.DTW_FILIAL = DUD.DUD_FILIAL
                and DTW010.DTW_FILORI = DUD.DUD_FILORI
                and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                and DTW010.DTW_ATIVID = 49
        )
        else ZC1.ZC1_EMISSA end
    as DT_INIOS,
    
    coalesce(SD2.D2_VALBRUT, 0.0) as VL_FATURAMENTO_TOTAL,
    coalesce(SD2.D2_VALICM, 0.0) as VL_ICMS_FATURAMENTO,
    coalesce(SD2.D2_VALIPI, 0.0) as VL_IPI_FATURAMENTO,
    coalesce(SD2.D2_VALFRE, 0.0) as VL_FRETE_NF,
    coalesce(SD2.D2_DESPESA, 0.0) as VL_DESPESA,
    coalesce(SD2.D2_TOTAL, 0.0) as VL_FATURAMENTO_MERCADORIA,
    coalesce(SD2.D2_VALIMP6, 0.0) as VL_PIS_FATURAMENTO,
    coalesce(SD2.D2_VALIMP5, 0.0) as VL_COFINS_FATURAMENTO,
    coalesce(SD2.D2_QUANT, 0.0) as QTD_FATURADA_ITEM,
    coalesce(SD2.D2_VALISS, 0.0) as VL_ISS_FATURAMENTO,
    coalesce(SD2.D2_ICMSRET, 0.0) as VL_ICMS_SUBST_FATURAMENTO,
    coalesce(SD2.D2_DESCON, 0.0) as VL_DESCONTO_FATURAMENTO,
    coalesce(SD2.D2_VALIRRF, 0.0) as VL_IRF_FATURAMENTO,
    coalesce(SD2.D2_VALINS, 0.0) as VL_INSS_FATURAMENTO,
    coalesce(SD2.D2_PESO * SD2.D2_QUANT, 0.0) as PESO_LIQUIDO,
    coalesce(SB1.B1_PESBRU * SD2.D2_QUANT, 0.0) as PESO_BRUTO,
    coalesce(SD2.D2_PRUNIT, 0.0) as VL_UNITARIO,
    coalesce(SD2.D2_SEGURO, 0.0) as VL_SEGURO,
    1 AS QTD

from SD2010 SD2
    inner join SF2010 SF2
        on SF2.D_E_L_E_T_= ' '
        and SF2.F2_FILIAL = SD2.D2_FILIAL
        and SF2.F2_CLIENTE = SD2.D2_CLIENTE
        and SF2.F2_LOJA = SD2.D2_LOJA
        and SF2.F2_DOC = SD2.D2_DOC
        and SF2.F2_SERIE = SD2.D2_SERIE
        and SF2.F2_SERIE not in ('003', '100')

        LEFT JOIN SA1010 SA1
            ON A1_FILIAL = '      '
            AND SA1.A1_COD = SF2.F2_CLIENTE
            AND SA1.A1_LOJA = SF2.F2_LOJA
            AND SA1.D_E_L_E_T_= ' '

    INNER JOIN SB1010 SB1
        ON B1_FILIAL = '      '
        AND SB1.B1_COD = SD2.D2_COD
        AND SB1.D_E_L_E_T_= ' '
    INNER JOIN SF4010 SF4
        ON F4_FILIAL = '      '
        AND SF4.F4_CODIGO = SD2.D2_TES
        AND SF4.D_E_L_E_T_ = ' '
    LEFT JOIN SBM010 SBM
        ON BM_FILIAL = '      '
        AND BM_GRUPO = B1_GRUPO
        AND SBM.D_E_L_E_T_ = ' '
    LEFT JOIN SA3010 SA3
        ON A3_FILIAL = '      '
        AND A3_COD = SF2.F2_VEND1
        AND SA3.D_E_L_E_T_ = ' '
    left join CTD010 CTD
        on CTD.CTD_FILIAL = '      '
        and CTD.CTD_ITEM = SD2.D2_ITEMCC
        and CTD.D_E_L_E_T_ = ' '
    left join CTT010 CTT
        on CTT.D_E_L_E_T_ = ''
        and CTT.CTT_FILIAL = substring(SD2.D2_FILIAL, 1, 4)
        and CTT.CTT_CUSTO = SD2.D2_CCUSTO
    LEFT JOIN SX5010 CFOP
        ON X5_FILIAL = '      '
        AND X5_TABELA = '13'
        AND X5_CHAVE = SD2.D2_CF
        AND CFOP.D_E_L_E_T_ = ' '
    LEFT JOIN SE4010 SE4
        ON E4_FILIAL = '      '
        AND E4_CODIGO = SF2.F2_COND
        AND SE4.D_E_L_E_T_ = ' '
    LEFT JOIN ACY010 ACY
        ON ACY_FILIAL = SUBSTRING(SD2.D2_FILIAL, 1, 4)
        AND ACY_GRPVEN = A1_GRPVEN
        AND ACY.D_E_L_E_T_ = ' '
    LEFT JOIN SAH010 SAH
        ON AH_FILIAL = '      '
        AND AH_UNIMED = SD2.D2_UM
        AND SAH.D_E_L_E_T_ = ' '
    
    left join SC5010 SC5
        on SC5.D_E_L_E_T_ = ''
        and SC5.C5_FILIAL = SD2.D2_FILIAL
        and SC5.C5_NUM = SD2.D2_PEDIDO
    left join ZC1010 ZC1
        on ZC1.D_E_L_E_T_ = ''
        and ZC1.ZC1_FILIAL = SC5.C5_FILIAL
        and ZC1.ZC1_NUM = SC5.C5_YOS

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
        SD2.D2_EMISSAO between <<START_DATE>> and <<FINAL_DATE>>
    and SD2.D2_TIPO not in ('B', 'D')
    and SD2.D_E_L_E_T_ = ' '
