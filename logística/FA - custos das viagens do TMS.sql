select
    'P |01|01' AS BK_EMPRESA,
    CASE
        WHEN DT8_FILIAL IS NULL THEN 'P |01||'
        ELSE 'P |01|01'+ CAST(DT8_FILIAL AS CHAR (8))
    END AS BK_FILIAL,
    VIAGEM.DATAFIM AS DATA_EMISSAO,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CLIREM, ' '))+RTRIM(COALESCE(DT6_LOJREM, ' ')), ' '), '|') AS BK_REMETENTE,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CLIDES, ' '))+RTRIM(COALESCE(DT6_LOJDES, ' ')), ' '), '|') AS BK_DESTINATARIO,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CLIDEV, ' '))+RTRIM(COALESCE(DT6_LOJDEV, ' ')), ' '), '|') AS BK_DEVEDOR,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CDRORI, ' ')), ' '), '|') AS BK_CDRORI,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDES.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CDRDES, ' ')), ' '), '|') AS BK_CDRDES,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CDRCAL, ' ')), ' '), '|') AS BK_CDRCAL,
    'P |01|DT3010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DT3_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT8_CODPAS, ' ')), ' '), '|') AS BK_COMPONENTE,
    'P |01|DDB010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DDB_FILIAL, ' '))+'|'+RTRIM(COALESCE(DDB_CODNEG, ' ')), ' '), '|') AS BK_NEGOCIACAO,
    'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SX5.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_SERVIC, ' ')), ' '), '|') AS BK_SERVICO,
    CASE
        WHEN DT6_FILORI IS NULL THEN 'P |01||'
        ELSE 'P |01|01'+ CAST(DT6_FILORI AS CHAR (8))
    END AS BK_FILIAL_ORIGEM,
    CASE
        WHEN DT6_FILDES IS NULL THEN 'P |01||'
        ELSE 'P |01|01'+ CAST(DT6_FILDES AS CHAR (8))
    END AS BK_FILIAL_DESTINO,
    CASE
        WHEN DT6_FILDOC IS NULL THEN 'P |01||'
        ELSE 'P |01|01'+ CAST(DT6_FILDOC AS CHAR (8))
    END AS BK_FILIAL_DOCTO,
    'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(DT6_DOCTMS, ' ')), ' '), '|') AS BK_DOCTMS,
    'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(DT6_TIPTRA, ' ')), ' '), '|') AS BK_TIPTRA,
    DT8_FILDOC AS FILDOC,
    'CTRC' + DT8.DT8_DOC as ID_DOCUMENTO,
    DT8_CODPRO AS PRODUTO,
    CASE
        WHEN REM.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' ')), ' '), '|')
        ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' '))+RTRIM(COALESCE(REM.A1_COD_MUN, ' ')), ' '), '|')
    END AS BK_REGIAO_REM,
    CASE
        WHEN DES.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' ')), ' '), '|')
        ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' '))+RTRIM(COALESCE(DES.A1_COD_MUN, ' ')), ' '), '|')
    END AS BK_REGIAO_DES,
    CASE
        WHEN DEV.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' ')), ' '), '|')
        ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' '))+RTRIM(COALESCE(DEV.A1_COD_MUN, ' ')), ' '), '|')
    END AS BK_REGIAO_DEV,
    CASE
        WHEN DUYDEV.DUY_CODMUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_EST, ' ')), ' '), '|')
        ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_EST, ' '))+RTRIM(COALESCE(DUYDEV.DUY_CODMUN, ' ')), ' '), '|')
    END AS BK_REGIAO_CDRCAL,
    CASE
        WHEN DUYORI.DUY_CODMUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_EST, ' ')), ' '), '|')
        ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_EST, ' '))+RTRIM(COALESCE(DUYORI.DUY_CODMUN, ' ')), ' '), '|')
    END AS BK_REGIAO_CDRORI,
    CASE
        WHEN DT6_FILORI IS NULL THEN 'P |01||'
        ELSE 'P |01|01'+ CAST(DT6_FILORI AS CHAR (8))
    END AS BK_FILIAL_ORIGEM,
    
    cast(ZE4.ZE4_DATAFI as date) as DATA_FIM,
    left(ZE4.ZE4_DATAFI, 6) as PERIODO_VGA,
    ZE4.ZE4_TOTHR as VGA_HORAS,
    ZE4.ZE4_KMINI as km_ini,
    ZE4.ZE4_KMFIM as km_fim,
    trim(ZE5.ZE5_ITENS) as VGA_COMPLEMENTOS,
    case when nullif(ZE1.ZE1_NOTA, '') is not null then trim(ZE1.ZE1_NOTA) else trim(ZE1.ZE1_COD) end as VGA_CODIGO,
    cast(ZE1.ZE1_DATA as date) as VGA_DATA,
    left(ZE1.ZE1_COMPET, 6) as COMPETENCIA,
    case when ZE1.ZE1_TIPO in (15, 16) then cast(RAT_IMPR.PERC_RATEIO * ZE1.ZE1_TOTAL as numeric(15 ,2)) else 0.00 end as VALOR_IMPR,
    case when ZE1.ZE1_TIPO in (15, 16) then 0.0 else cast(ZE1.ZE1_TOTAL as numeric(15, 2)) end as VALOR_PROD,
    ZE1.ZE1_ITEM as VGA_ITEMCUSTO,

    VIAGEM.ID_VIAGEM,
    VIAGEM.ID_VEICULO_CM,
    VIAGEM.ID_VEICULO_RB1,
    VIAGEM.ID_VEICULO_RB2,
    VIAGEM.ID_VEICULO_RB3,
    VIAGEM.ID_MOTORISTA

from 
    ZE1010 ZE1 (nolock)
    left join ZE5010 ZE5 (nolock)
        on ZE5.D_E_L_E_T_ = ''
        and ZE5.ZE5_FILIAL = ZE1.ZE1_FILIAL
        and ZE5.ZE5_VIAGEM = ZE1.ZE1_NUM
        
        left join ZE4010 ZE4 (nolock)
            on ZE4.D_E_L_E_T_ = ''
            and ZE4.ZE4_FILIAL = ZE5.ZE5_FILIAL
            and ZE4.ZE4_VIAGEM = ZE5.ZE5_VIAGEM

    left join
    (
        select
            ZG1.ZG1_FILORI as FILIAL,
            ZG1.ZG1_COMPET as COMPETENCIA,
            ZG1.ZG1_CODIGO as INSUMO,
            ZG1.ZG1_TIPO as TIPO,
            ZG1.ZG1_VLIMPR as VLIMP_TOT,
            cast(
                ZG1.ZG1_VLIMPR/
                (
                    select sum(ZG1010.ZG1_VLIMPR)
                    from ZG1010
                    where
                        ZG1010.ZG1_VLIMPR != 0
                    and ZG1010.ZG1_FILORI = ZG1.ZG1_FILORI
                    and ZG1010.ZG1_COMPET = ZG1.ZG1_COMPET
                    and ZG1010.ZG1_CODIGO = ZG1.ZG1_CODIGO
                    and ZG1010.D_E_L_E_T_ = ''
                )
                as numeric(15, 2)
            ) as PERC_RATEIO
        from ZG1010 ZG1 (nolock)
        where ZG1.D_E_L_E_T_ = ''
    ) RAT_IMPR
        on case when RAT_IMPR.TIPO in (2, 14) then 15 when RAT_IMPR.TIPO in (3, 6, 9, 12) then 16 else null end = ZE1.ZE1_TIPO
        and RAT_IMPR.FILIAL = ZE1.ZE1_FILIAL
        and RAT_IMPR.COMPETENCIA = left(ZE1.ZE1_COMPET, 6)
        and RAT_IMPR.INSUMO = ZE1.ZE1_COD
    
    INNER JOIN DT6010 DT6
        ON DT6.DT6_FILIAL = DT8_FILIAL
        AND DT6.DT6_FILDOC = DT8.DT8_FILDOC
        AND DT6.DT6_DOC = DT8.DT8_DOC
        AND DT6.DT6_SERIE = DT8.DT8_SERIE
        AND DT6.DT6_SERIE <> 'COL'
        AND DT6.DT6_SERIE <> 'PED'
        AND DT6.D_E_L_E_T_ = ' '

        INNER JOIN SA1010 REM
            ON REM.A1_FILIAL = '      '
            AND REM.A1_COD = DT6.DT6_CLIREM
            AND REM.A1_LOJA = DT6.DT6_LOJREM
            AND REM.D_E_L_E_T_ = ' '
        INNER JOIN SA1010 DES
            ON DES.A1_FILIAL = '      '
            AND DES.A1_COD = DT6.DT6_CLIDES
            AND DES.A1_LOJA = DT6.DT6_LOJDES
            AND DES.D_E_L_E_T_ = ' '
        INNER JOIN SA1010 DEV
            ON DEV.A1_FILIAL = '      '
            AND DEV.A1_COD = DT6.DT6_CLIDEV
            AND DEV.A1_LOJA = DT6.DT6_LOJDEV
            AND DEV.D_E_L_E_T_ = ' '
        LEFT JOIN DUY010 DUYORI
            ON DUYORI.DUY_FILIAL = DT6_FILIAL
            AND DUYORI.DUY_GRPVEN = DT6.DT6_CDRORI
            AND DUYORI.D_E_L_E_T_ = ' '
        LEFT JOIN DUY010 DUYDES
            ON DUYDES.DUY_FILIAL = DT6_FILIAL
            AND DUYDES.DUY_GRPVEN = DT6.DT6_CDRDES
            AND DUYDES.D_E_L_E_T_ = ' '
        LEFT JOIN DUY010 DUYDEV
            ON DUYDEV.DUY_FILIAL = DT6_FILIAL
            AND DUYDEV.DUY_GRPVEN = DT6.DT6_CDRCAL
            AND DUYDEV.D_E_L_E_T_ = ' '
        LEFT JOIN DDB010 DDB
            ON DDB.DDB_FILIAL = DT6_FILIAL
            AND DDB.DDB_CODNEG = DT6.DT6_CODNEG
            AND DDB.D_E_L_E_T_ = ' '
        INNER JOIN SX5010 SX5
            ON SX5.X5_FILIAL = '      ' /*SUBSTRING(DT6_FILIAL, 1, 5) + SUBSTRING(X5_FILIAL, 6, 8)*/
            AND SX5.X5_TABELA = 'L4'
            AND SX5.X5_CHAVE = DT6.DT6_SERVIC
            AND SX5.D_E_L_E_T_ = ' '

        left join
        (
            select
                (select DTQ010.DTQ_DATGER from DTQ010 where DTQ010.D_E_L_E_T_ = '' and DTQ010.DTQ_FILORI = DUD.DUD_FILORI and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM) as DTQ_DATGER,
                (select DTQ010.DTQ_DATFEC from DTQ010 where DTQ010.D_E_L_E_T_ = '' and DTQ010.DTQ_FILORI = DUD.DUD_FILORI and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM) as DTQ_DATFEC,
                (select DTQ010.DTQ_DATENC from DTQ010 where DTQ010.D_E_L_E_T_ = '' and DTQ010.DTQ_FILORI = DUD.DUD_FILORI and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM) as DTQ_DATENC,
                DUD.DUD_FILORI,
                DUD.DUD_FILDOC,
                DUD.DUD_DOC,
                DUD.DUD_SERIE,
                DUD.DUD_VIAGEM,
                (
                    select DTW010.DTW_DATREA
                    from DTW010 (nolock)
                    where
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DUD.DUD_FILORI
                        and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                        and DTW010.DTW_ATIVID = 50
                ) as DATAFIM,

                concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)) as ID_VIAGEM,
                trim(DA4010.DA4_COD) as ID_MOTORISTA,
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODVEI) as ID_VEICULO_CM,
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB1) as ID_VEICULO_RB1,
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB2) as ID_VEICULO_RB2,
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB3) as ID_VEICULO_RB3
            from DUD010 DUD (nolock)
                left join DTR010 DTR (nolock)
                    on DTR.D_E_L_E_T_ = ''
                    and DTR.DTR_FILORI = DUD.DUD_FILORI
                    and DTR.DTR_VIAGEM = DUD.DUD_VIAGEM
                    
                    left join DUP010 (nolock)
                        on DUP010.D_E_L_E_T_ = ''
                        and DUP010.DUP_FILORI = DTR.DTR_FILORI
                        and DUP010.DUP_VIAGEM = DTR.DTR_VIAGEM
                        and DUP010.DUP_ITEDTR = DTR.DTR_ITEM
                        and DUP010.DUP_CODVEI = DTR.DTR_CODVEI

                        left join DA4010 (nolock)
                            on DA4010.D_E_L_E_T_ = ''
                            and DA4010.DA4_COD = DUP010.DUP_CODMOT
            where DUD.D_E_L_E_T_ = ''
        ) VIAGEM
            on VIAGEM.DUD_FILORI = DT6.DT6_FILORI
            and VIAGEM.DUD_FILDOC = DT6.DT6_FILDOC
            and VIAGEM.DUD_DOC = DT6.DT6_DOC
            and VIAGEM.DUD_SERIE = DT6.DT6_SERIE
where ZE1.D_E_L_E_T_ = ''
