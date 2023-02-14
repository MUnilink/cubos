select
    (
        select substring(DTW010.DTW_DATREA, 1, 6)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = VIAGEM.DTQ_FILORI
            and DTW010.DTW_VIAGEM = VIAGEM.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as COMPETENCIA,

    'P |01|01' AS BK_EMPRESA,
    VIAGEM.ID_VIAGEM,
    VIAGEM.DTQ_VIAGEM,
    
    VIAGEM.CHE_CLIDEV,
    VIAGEM.SAI_CLIDEV,
    VIAGEM.CHE_VIAGEM,
    VIAGEM.SAI_VIAGEM,
    VIAGEM.km_fim,
    VIAGEM.km_ini,
   
    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    DT6.DT6_DATEMI,
    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,

    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIREM, ' '))+RTRIM(COALESCE(DT6.DT6_LOJREM, ' ')), ' '), '|') AS BK_REMETENTE,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIDES, ' '))+RTRIM(COALESCE(DT6.DT6_LOJDES, ' ')), ' '), '|') AS BK_DESTINATARIO,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIDEV, ' '))+RTRIM(COALESCE(DT6.DT6_LOJDEV, ' ')), ' '), '|') AS BK_DEVEDOR,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRORI, ' ')), ' '), '|') AS BK_CDRORI,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDES.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRDES, ' ')), ' '), '|') AS BK_CDRDES,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRCAL, ' ')), ' '), '|') AS BK_CDRCAL,
    'P |01|DDB010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DDB.DDB_FILIAL, ' '))+'|'+RTRIM(COALESCE(DDB.DDB_CODNEG, ' ')), ' '), '|') AS BK_NEGOCIACAO,
    'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SX5.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_SERVIC, ' ')), ' '), '|') AS BK_SERVICO,
    'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(DT6.DT6_DOCTMS, ' ')), ' '), '|') AS BK_DOCTMS,
    'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(DT6.DT6_TIPTRA, ' ')), ' '), '|') AS BK_TIPTRA,
    CASE WHEN DT6.DT6_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILIAL AS CHAR (8)) END AS BK_FILIAL,
    CASE WHEN DT6.DT6_FILORI IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILORI AS CHAR (8)) END AS BK_FILIAL_ORIGEM,
    CASE WHEN DT6.DT6_FILDES IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILDES AS CHAR (8)) END AS BK_FILIAL_DESTINO,
    CASE WHEN REM.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' '))+RTRIM(COALESCE(REM.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_REM,
    CASE WHEN DES.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' '))+RTRIM(COALESCE(DES.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DES,
    CASE WHEN DEV.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' '))+RTRIM(COALESCE(DEV.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DEV,
    CASE WHEN DT6.DT6_FILDOC IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILDOC AS CHAR (8)) END AS BK_FILIAL_DOCTO,
    trim(DTC.DTC_CODPRO) as PRODUTO,

    MANUTENCAO.TJ_CODBEM,
    MANUTENCAO.TJ_ORDEM,
    MANUTENCAO.TIPO_CUSTO,
    MANUTENCAO.TL_TIPOREG,
    MANUTENCAO.TL_DTINICI,
    MANUTENCAO.INSUMO,
    MANUTENCAO.DESC_INSUMO,
    MANUTENCAO.TL_CUSTO,
    
    COMBUSTIVEL.CUSTO_ABA,
    COMBUSTIVEL.ZD3_VLUNI,
    COMBUSTIVEL.ZD3_DATA,

    DOCUMENTACAO.TS0_DOCTO,
    DOCUMENTACAO.VALOR_PARCELA,
    DOCUMENTACAO.VALOR_TAXA,

    FOLHA.RA_FILIAL,
    FOLHA.PERIODO,
    FOLHA.MATRICULA,
    FOLHA.CONTA,
    FOLHA.ATIVIDADE,
    FOLHA.CENTRO_CUSTO,
    FOLHA.NOME,
    FOLHA.FUNCAO,
    FOLHA.VALOR_FOLHA,

    DEPRECIACAO.N4_VLROC1 as DEPRECIACAO,

    null as AUTOTRAC,
    null as SEGURO_VEICULO,
    null as OUTROS_CUSTOS_VEICULO

from
    (
        select
            DTQ.DTQ_FILIAL,
            DTQ.DTQ_FILORI,
            DTQ.DTQ_VIAGEM,
            DTQ.DTQ_DATGER,
            DTQ.DTQ_DATFEC,
            DTQ.DTQ_DATENC,

            (
                select top 1 substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT))
                from DTW010
                    inner join ZB1010
                        on ZB1010.D_E_L_E_T_ = ''
                        and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                        and
                            dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                            =
                            datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
                    and DTW010.DTW_ATIVID = 50
            ) as km_fim,
            (
                select top 1 substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT))
                from DTW010
                    inner join ZB1010
                        on ZB1010.D_E_L_E_T_ = ''
                        and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                        and
                            dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                            =
                            datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
                where
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
                    and DTW010.DTW_ATIVID = 49
            ) as km_ini,
            
            concat(trim(DTQ.DTQ_FILORI), trim(DTQ.DTQ_VIAGEM)) as ID_VIAGEM,
            concat(trim(DA4010.DA4_FILATU), trim(DA4010.DA4_COD)) as ID_MOTORISTA,
            DA4010.DA4_COD as COD_MOT,
            
            (select concat(trim(DA3010.DA3_FILATU), trim(DA3010.DA3_COD)) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_FILATU = DTR.DTR_FILORI and DA3010.DA3_COD = DTR.DTR_CODVEI) as ID_VEICULO_CM,
            DTR.DTR_CODVEI as COD_CM,
            
            (select concat(trim(DA3010.DA3_FILATU), trim(DA3010.DA3_COD)) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_FILATU = DTR.DTR_FILORI and DA3010.DA3_COD = DTR.DTR_CODRB1) as ID_VEICULO_RB1,
            DTR.DTR_CODRB1 as COD_RB1,
            
            (select concat(trim(DA3010.DA3_FILATU), trim(DA3010.DA3_COD)) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_FILATU = DTR.DTR_FILORI and DA3010.DA3_COD = DTR.DTR_CODRB2) as ID_VEICULO_RB2,
            DTR.DTR_CODRB2 as COD_RB2,
            
            (select concat(trim(DA3010.DA3_FILATU), trim(DA3010.DA3_COD)) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_FILATU = DTR.DTR_FILORI and DA3010.DA3_COD = DTR.DTR_CODRB3) as ID_VEICULO_RB3,
            DTR.DTR_CODRB3 as COD_RB3,

            (
                select
                        top 1 concat(DTW010.DTW_SYSDAT, ' ', concat(substring(DTW010.DTW_SYSHOR, 1, 2), ':', substring(DTW010.DTW_SYSHOR, 3, 2), ':', substring(DTW010.DTW_SYSHOR, 5, 2)))
                from DTW010
                where
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and DTW010.DTW_SYSHOR != ''
                    and DTW010.DTW_SYSDAT != ''
                    and DTW010.DTW_ATIVID = 57 /*58 PONTO DE APOIO*/
                    and DTW010.DTW_CODCLI != 761
                order by DTW010.DTW_SEQUEN
            ) as CHE_CLIDEV,
            (
                select
                        top 1 concat(DTW010.DTW_SYSDAT, ' ', concat(substring(DTW010.DTW_SYSHOR, 1, 2), ':', substring(DTW010.DTW_SYSHOR, 3, 2), ':', substring(DTW010.DTW_SYSHOR, 5, 2)))
                from DTW010
                where
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and DTW010.DTW_SYSHOR != ''
                    and DTW010.DTW_SYSDAT != ''
                    and DTW010.DTW_ATIVID = 56 /*58 PONTO DE APOIO*/
                    and DTW010.DTW_CODCLI != 761
                order by DTW010.DTW_SEQUEN
            ) as SAI_CLIDEV,

            (
                select
                        concat(DTW010.DTW_SYSDAT, ' ', concat(substring(DTW010.DTW_SYSHOR, 1, 2), ':', substring(DTW010.DTW_SYSHOR, 3, 2), ':', substring(DTW010.DTW_SYSHOR, 5, 2)))
                from DTW010
                where
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and DTW010.DTW_SYSHOR != ''
                    and DTW010.DTW_SYSDAT != ''
                    and DTW010.DTW_ATIVID = 49
            ) as SAI_VIAGEM,
            (
                select
                        concat(DTW010.DTW_SYSDAT, ' ', concat(substring(DTW010.DTW_SYSHOR, 1, 2), ':', substring(DTW010.DTW_SYSHOR, 3, 2), ':', substring(DTW010.DTW_SYSHOR, 5, 2)))
                from DTW010
                where
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and DTW010.DTW_SYSHOR != ''
                    and DTW010.DTW_SYSDAT != ''
                    and DTW010.DTW_ATIVID = 50
            ) as CHE_VIAGEM

        from DTQ010 DTQ
            inner join DTR010 DTR
                on DTR.D_E_L_E_T_ = ''
                and DTR.DTR_FILORI = DTQ.DTQ_FILORI
                and DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM
                
                inner join DUP010
                    on DUP010.D_E_L_E_T_ = ''
                    and DUP010.DUP_FILORI = DTR.DTR_FILORI
                    and DUP010.DUP_VIAGEM = DTR.DTR_VIAGEM
                    and DUP010.DUP_ITEDTR = DTR.DTR_ITEM
                    and DUP010.DUP_CODVEI = DTR.DTR_CODVEI

                    inner join DA4010
                        on DA4010.D_E_L_E_T_ = ''
                        and DA4010.DA4_COD = DUP010.DUP_CODMOT

        where DTQ.D_E_L_E_T_ = ''
    ) VIAGEM
        
    left join DUD010 DUD
        on DUD.D_E_L_E_T_ = ''
        and DUD.DUD_FILORI = VIAGEM.DTQ_FILORI
        and DUD.DUD_VIAGEM = VIAGEM.DTQ_VIAGEM
        
        left join DT6010 DT6
            on DT6.D_E_L_E_T_ = ''
            and DT6.DT6_FILDOC = DUD.DUD_FILDOC
            and DT6.DT6_DOC = DUD.DUD_DOC
            and DT6.DT6_SERIE = DUD.DUD_SERIE

            left join SA1010 REM
                on REM.A1_FILIAL = '      '
                and REM.A1_COD = DT6.DT6_CLIREM
                and REM.A1_LOJA = DT6.DT6_LOJREM
                and REM.D_E_L_E_T_ = ' '
            left join SA1010 DES
                on DES.A1_FILIAL = '      '
                and DES.A1_COD = DT6.DT6_CLIDES
                and DES.A1_LOJA = DT6.DT6_LOJDES
                and DES.D_E_L_E_T_ = ' '
            left join SA1010 DEV
                on DEV.A1_FILIAL = '      '
                and DEV.A1_COD = DT6.DT6_CLIDEV
                and DEV.A1_LOJA = DT6.DT6_LOJDEV
                and DEV.D_E_L_E_T_ = ' '
            left join DUY010 DUYORI
                on DUYORI.DUY_FILIAL = DT6.DT6_FILIAL
                and DUYORI.DUY_GRPVEN = DT6.DT6_CDRORI
                and DUYORI.D_E_L_E_T_ = ' '
            left join DUY010 DUYDES
                on DUYDES.DUY_FILIAL = DT6.DT6_FILIAL
                and DUYDES.DUY_GRPVEN = DT6.DT6_CDRDES
                and DUYDES.D_E_L_E_T_ = ' '
            left join DUY010 DUYDEV
                on DUYDEV.DUY_FILIAL = DT6.DT6_FILIAL
                and DUYDEV.DUY_GRPVEN = DT6.DT6_CDRCAL
                and DUYDEV.D_E_L_E_T_ = ' '
            left join DDB010 DDB
                on DDB.DDB_FILIAL = DT6.DT6_FILIAL
                and DDB.DDB_CODNEG = DT6.DT6_CODNEG
                and DDB.D_E_L_E_T_ = ' '
            inner join SX5010 SX5
                on SX5.X5_FILIAL = '      ' /*SUBSTRING(DT6_FILIAL, 1, 5) + SUBSTRING(X5_FILIAL, 6, 8)*/
                and SX5.X5_TABELA = 'L4'
                and SX5.X5_CHAVE = DT6.DT6_SERVIC
                and SX5.D_E_L_E_T_ = ' '
            left join DTC010 DTC
                on DTC.D_E_L_E_T_ = ''
                and DTC.DTC_FILORI = DT6.DT6_FILDOC
                and DTC.DTC_DOC = DT6.DT6_DOC
                and DTC.DTC_SERIE = DT6.DT6_SERIE
    
    left join
    (
        select
            STJ.TJ_CODBEM,
            STJ.TJ_ORDEM,
            STL.TL_DTINICI,
            STL.TL_QUANTID,
 
            trim(isnull(STL.TL_CODIGO, '-')) as INSUMO,

            case STL.TL_TIPOREG
                when 'M' then 'MÃO-DE-OBRA'
                when 'E' then 'MÃO-DE-OBRA'
                when 'P' then 'PEÇAS'
                when 'T' then 'TERCEIROS'
                else 'OUTROS'
            end as TL_TIPOREG,

            case STL.TL_TIPOREG
                when 'M' then trim(ST1.T1_NOME)
                when 'E' then trim(ST0.T0_NOME)
                when 'P' then trim(SB1.B1_DESC)
                when 'T' then trim(SA2.A2_NOME)
                else 'OUTROS'
            end as DESC_INSUMO,

            substring(STL.TL_DTINICI, 1, 6) as PERIODO_MNT,

            case when STJ.TJ_SERVICO = 'PNEMOV' then 'PNEU' else 'MANUTENÇÃO' end as TIPO_CUSTO,

            case when trim(STL.TL_CODIGO) in ('11380003', '11380004', '11380005') and STL.TL_LOCAL = '80' then ADESIVO_CUSTO.B9_CM * STL.TL_QUANTID
            else
                case when trim(STL.TL_CODIGO) like '1130%' then PNEU_CUSTO.B9_CM * STL.TL_QUANTID
                else
                    STL.TL_CUSTO
                end
            end as TL_CUSTO
        
        from STJ010 STJ (nolock)
            inner join ST9010 ST9 (nolock)
                on ST9.D_E_L_E_T_ = ''
                and ST9.T9_CODBEM = STJ.TJ_CODBEM

            inner join STL010 STL (nolock)
                on STL.D_E_L_E_T_ = ''
                and STL.TL_ORDEM = STJ.TJ_ORDEM
                and STL.TL_PLANO = STJ.TJ_PLANO
                and STL.TL_FILIAL = STJ.TJ_FILIAL

                left join SA2010 SA2 (nolock)
                    on SA2.D_E_L_E_T_ = ''
                    and SA2.A2_COD = STL.TL_FORNEC
                    and SA2.A2_LOJA = STL.TL_LOJA
                left join SB1010 SB1 (nolock)
                    on SB1.D_E_L_E_T_ = ''
                    and SB1.B1_COD = STL.TL_CODIGO
                left join
                (
                    select
                        SB9010.B9_COD,
                        min(SB9010.B9_VINI1/SB9010.B9_QINI) as B9_CM,
                        min(SB9010.B9_DATA) as B9_DATA
                    from SB9010 (nolock)
                    where
                            SB9010.D_E_L_E_T_ = ''
                        and SB9010.B9_LOCAL = '01'
                        and SB9010.B9_COD in ('11380003', '11380004', '11380005')
                        and SB9010.B9_QINI != 0
                    group by
                        SB9010.B9_COD
                ) ADESIVO_CUSTO
                    on ADESIVO_CUSTO.B9_COD = STL.TL_CODIGO
                left join
                (
                    select
                        SB9010.B9_COD,
                        min(SB9010.B9_VINI1/SB9010.B9_QINI) as B9_CM,
                        min(SB9010.B9_DATA) as B9_DATA
                    from SB9010 (nolock)
                    where
                            SB9010.D_E_L_E_T_ = ''
                        and SB9010.B9_LOCAL = '20'
                        and SB9010.B9_COD like '1130%'
                        and SB9010.B9_QINI != 0
                    group by
                        SB9010.B9_COD
                ) PNEU_CUSTO
                    on PNEU_CUSTO.B9_COD = STL.TL_CODIGO
                left join SH4010 SH4 (nolock)
                    on SH4.D_E_L_E_T_ = ''
                    and SH4.H4_CODIGO = STL.TL_CODIGO
                left join ST0010 ST0 (nolock)
                    on ST0.D_E_L_E_T_ = ''
                    and ST0.T0_ESPECIA = STL.TL_CODIGO
                left join ST1010 ST1 (nolock)
                    on ST1.D_E_L_E_T_ = ''
                    and ST1.T1_FILIAL = STL.TL_FILIAL
                    and ST1.T1_CODFUNC = STL.TL_CODIGO
        where
                STJ.D_E_L_E_T_ = ''
            and STL.TL_TIPOREG in ('P', 'T')
            and ST9.T9_CODFAMI in ('VP', 'VM')
            and STL.TL_SEQRELA > 0
            and STL.TL_DTINICI > 20211231
            and STJ.TJ_CCUSTO = 304 /* ver veículo portuário do BRANDAO */

    ) MANUTENCAO
        on MANUTENCAO.PERIODO_MNT = substring(VIAGEM.CHE_VIAGEM, 1, 6)
        and
        (
            MANUTENCAO.TJ_CODBEM = VIAGEM.COD_CM or
            MANUTENCAO.TJ_CODBEM = VIAGEM.COD_RB1 or
            MANUTENCAO.TJ_CODBEM = VIAGEM.COD_RB2 or
            MANUTENCAO.TJ_CODBEM = VIAGEM.COD_RB3
        )
    
    left join
    (
        select
            case when ZD3.ZD3_LITROS = 0 then 'PARCIAL' else 'COMPLETO' end as TIPO_ABA,
            ZD3.ZD3_LITROS,
            ZD3.ZD3_VLUNI,
            ZD3.ZD3_HODOM,
            ZD3.ZD3_KMRD,
            ZD3.ZD3_KML,
            ZD3.ZD3_TOTAL as CUSTO,
            trim(ZD3.ZD3_DATA) as ZD3_DATA,

            trim(isnull(TQI.TQI_TANQUE, '-')) as TQI_TANQUE,
            trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,
            trim(isnull(TQM.TQM_CODCOM, '-')) as TQM_CODCOM,
            trim(isnull(ZD3.TQN_CCUSTO, '-')) as TQN_CCUSTO
        from
            (
                select
                    case cast(ZD3010.ZD3_TANQUE as int)
                        when 12 then '010102'
                        else trim(isnull(ZD3010.ZD3_FILIAL, '-'))
                    end as ZD3_FILIAL,
                    ZD3010.ZD3_KM as ZD3_HODOM,

                    ZD3010.ZD3_VEICUL,
                    ZD3010.ZD3_LITROS,
                    ZD3010.ZD3_VLUNI,
                    ZD3010.ZD3_TOTAL,
                    
                    ZD3010.ZD3_TANQUE as ZD3_TANQUE,
                    ZD3010.ZD3_COMB,
                    substring(ZD3010.ZD3_DATA, 1, 8) as ZD3_DATA,
                    ZD3010.ZD3_KML,
                    ZD3010.ZD3_KMRD,
                    TQN010.TQN_CCUSTO
                from ZD3010 (nolock)
                    inner join TQN010 (nolock)
                        on TQN010.D_E_L_E_T_ = ''
                        and TQN010.TQN_FROTA = ZD3010.ZD3_VEICUL
                        and TQN010.TQN_DTABAS + TQN010.TQN_HRABAS = substring(ZD3010.ZD3_DATA, 1, 8) + substring(ZD3010.ZD3_DATA, 10, 14)
                where ZD3010.D_E_L_E_T_ = ''
            ) as ZD3

            left join
            (
                select
                    case cast(TQI010.TQI_CODPOS as int)
                        when 59 then '010102'
                        else trim(isnull(TQI010.TQI_FILIAL, '-'))
                    end as TQI_FILIAL,

                    TQI010.TQI_CODPOS,
                    TQI010.TQI_LOJA,
                    TQI010.TQI_TANQUE as TQI_TANQUE,
                    TQI010.TQI_YDETAN,
                    TQI010.TQI_CODCOM,
                    TQI010.TQI_PRODUT,
                    TQI010.TQI_FABRIC
                from TQI010
                where TQI010.D_E_L_E_T_ = ''
            ) as TQI
                on TQI.TQI_FILIAL = ZD3.ZD3_FILIAL
                and TQI.TQI_TANQUE = ZD3.ZD3_TANQUE

                left join
                (
                    select
                        case cast(TQF010.TQF_CODIGO as int)
                            when 59 then '010102'
                            else trim(isnull(TQF010.TQF_CODFIL, '-'))
                        end as TQF_FILIAL,
                        TQF010.TQF_CODIGO,
                        TQF010.TQF_LOJA
                    from TQF010
                    where TQF010.D_E_L_E_T_ = ''
                ) as TQF
                    on TQF.TQF_FILIAL = TQI.TQI_FILIAL
                    and TQF.TQF_CODIGO + TQF.TQF_LOJA = TQI.TQI_CODPOS + TQI.TQI_LOJA

            left join ST9010 as ST9
                on ST9.D_E_L_E_T_ = ''
                and ST9.T9_CODBEM = ZD3.ZD3_VEICUL
            left join TQM010 as TQM
                on TQM.D_E_L_E_T_ = ''
                and TQM.TQM_CODCOM = ZD3.ZD3_COMB
        where
                ZD3.TQN_CCUSTO = 304 /* ver veículo portuário do BRANDAO */
            and ZD3.ZD3_DATA > 20211231
    ) COMBUSTIVEL
        on COMBUSTIVEL.T9_CODBEM = VIAGEM.COD_CM
        and substring(COMBUSTIVEL.ZD3_DATA, 1, 6) = substring(VIAGEM.CHE_VIAGEM, 1, 6)
    
    left join /* ver amortização das taxas dos veículos */
    (
        select
            trim(isnull(TS1010.TS1_DTEMIS, '-')) as TS1_DTEMIS,
            trim(isnull(SE2010.E2_VENCREA, '-')) as TS1_DTVENC,
            TS1010.TS1_QTDPAR,
            SE2010.E2_PARCELA,
            TS1010.TS1_VALOR/TS1010.TS1_QTDPAR as VALOR_PARCELA,
            TS1010.TS1_VALOR as VALOR_TAXA,

            trim(isnull(TS0010.TS0_NOMDOC, '-')) as TS0_DOCTO,
            trim(isnull(ST9010.T9_CODBEM, '-')) as T9_CODBEM,

            year(SE2010.E2_VENCREA) as ano_VENCTO,
            month(SE2010.E2_VENCREA) as mes_VENCTO

        from TS1010
            left join TS0010
                on TS0010.D_E_L_E_T_ = ''
                and TS0010.TS0_DOCTO = TS1010.TS1_DOCTO
            left join SE2010
                on SE2010.D_E_L_E_T_ = ''
                and trim(SE2010.E2_PREFIXO) = 'MNT'
                and SE2010.E2_NUM = TS1010.TS1_NUMSE2
            left join ST9010
                on ST9010.D_E_L_E_T_ = ''
                and ST9010.T9_CODBEM = TS1010.TS1_CODBEM
            left join CTT010
                on CTT010.D_E_L_E_T_ = ''
                and CTT010.CTT_CUSTO = TS1010.TS1_YCC
            left join CTD010
                on CTD010.D_E_L_E_T_ = ''
                and CTD010.CTD_ITEM = TS1010.TS1_YITEM
        where
                TS1010.D_E_L_E_T_ = ''
            and SE2010.E2_VENCREA > 20211231
            and ST9010.T9_CCUSTO = 304 /* ver veículo portuário do BRANDAO */
    ) DOCUMENTACAO
        on substring(DOCUMENTACAO.TS1_DTVENC, 1, 6) = substring(VIAGEM.CHE_VIAGEM, 1, 6)
        and
        (
            DOCUMENTACAO.T9_CODBEM = VIAGEM.COD_CM or
            DOCUMENTACAO.T9_CODBEM = VIAGEM.COD_RB1 or
            DOCUMENTACAO.T9_CODBEM = VIAGEM.COD_RB2 or
            DOCUMENTACAO.T9_CODBEM = VIAGEM.COD_RB3
        )
    left join /* ver depreciação */
    (
        select
            ST9010.T9_CODBEM,
            SN1010.N1_CBASE,
            SN4010.N4_DATA,
            SN4010.N4_VLROC1
        from SN4010
            left join SN1010 (nolock)
                on SN1010.D_E_L_E_T_ = ''
                and SN1010.N1_CBASE = SN4010.N4_CBASE
            
                inner join ST9010 (nolock)
                    on ST9010.D_E_L_E_T_ = ''
                    and ST9010.T9_CODBEM = SN1010.N1_CODBEM
        where
                SN4010.D_E_L_E_T_ = ''
            and SN4010.N4_LA = 'S'
    ) DEPRECIACAO
        on substring(DEPRECIACAO.N4_DATA, 1, 6) = substring(VIAGEM.CHE_VIAGEM, 1, 6)
        and
        (
            DEPRECIACAO.T9_CODBEM = VIAGEM.COD_CM or
            DEPRECIACAO.T9_CODBEM = VIAGEM.COD_RB1 or
            DEPRECIACAO.T9_CODBEM = VIAGEM.COD_RB2 or
            DEPRECIACAO.T9_CODBEM = VIAGEM.COD_RB3
        )
    inner join
        (
            select
                SRA.RA_FILIAL + VERBAS.PERIODO + VERBAS.MATRICULA + substring(VERBAS.CONTA, 1, 2) as ID_LANCAMENTO,
                SRA.RA_FILIAL,
                VERBAS.PERIODO,
                VERBAS.MATRICULA,

                substring(VERBAS.CONTA, 4, len(VERBAS.CONTA)) as CONTA,

                trim(CTD.CTD_DESC01) as ATIVIDADE,
                trim(CTT.CTT_DESC01) as CENTRO_CUSTO,
                trim(SRA.RA_NOME) as NOME,
                trim(SRJ.RJ_DESC) as FUNCAO,
                
                sum(VERBAS.VALOR) as VALOR

            from SRA010 SRA (nolock)
                inner join SRJ010 SRJ (nolock)
                    on SRJ.D_E_L_E_T_ = ''
                    and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                    and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
                inner join CTT010 CTT (nolock)
                    on CTT.D_E_L_E_T_ = ''
                    and CTT.CTT_CUSTO = SRA.RA_CC
                inner join CTD010 CTD (nolock)
                    on CTD.D_E_L_E_T_ = ''
                    and CTD.CTD_ITEM = SRA.RA_ITEM
                inner join
                (
                    select
                        isnull(SRD010.RD_FILIAL, SRT010.RT_FILIAL) as FILIAL,
                        isnull(SRD010.RD_PERIODO, SRT010.RT_DATACAL) as PERIODO,
                        isnull(SRD010.RD_MAT, SRT010.RT_MAT) as MATRICULA,
                        case when SRD010.RD_PD in ('008', '020', '025', '031', '039', '041', '051', '072', '094', '106', '201', '215', '220', '223', '343', '365', '783') then '02 Salários e Ordenados'
                        else
                            case when SRD010.RD_PD in ('029', '111', '113') then '03 Hora Extra'
                            else
                                case when SRD010.RD_PD in ('038', '711', '719', '738', '749', '796') then '04 Benefícios'
                                else
                                    case when SRD010.RD_PD in ('739', '759', '760', '800', '817', '950', '955', '960', '961', '962') then '05 Encargos Sociais'
                                    else
                                        case when SRT010.RT_VERBA in ('845', '846') then '06 13º Salário'
                                        else
                                            case when SRT010.RT_VERBA in ('833', '834', '847', '848') then '07 Encargos Sociais (13º e Férias)'
                                            else
                                                case when SRT010.RT_VERBA in ('830', '831', '832') then '08 Férias'
                                                else '01 N/A Custo'
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end as CONTA,
                        isnull(SRD010.RD_VALOR, SRT010.RT_VALOR) as VALOR
                    from SRV010 (nolock)
                        left join SRD010 (nolock)
                            on SRD010.D_E_L_E_T_ = ''
                            and SRV010.RV_FILIAL = substring(SRD010.RD_FILIAL, 1, 4)
                            and SRV010.RV_COD = SRD010.RD_PD
                            and SRD010.RD_PERIODO > '20211231'
                        left join SRT010 (nolock)
                            on SRT010.D_E_L_E_T_ = ''
                            and SRV010.RV_FILIAL = substring(SRT010.RT_FILIAL, 1, 4)
                            and SRV010.RV_COD = SRT010.RT_VERBA
                            and SRT010.RT_DATACAL > '20211231'
                    where SRV010.D_E_L_E_T_ = ''
                ) VERBAS
                    on VERBAS.FILIAL = SRA.RA_FILIAL
                    and VERBAS.MATRICULA = SRA.RA_MAT
                    and VERBAS.CONTA != '01 N/A Custo'
            where
                    SRA.D_E_L_E_T_ = ''
                and (SRA.RA_CC = 304 or SRA.RA_MAT = '002282')
            group by
                SRA.RA_FILIAL,
                VERBAS.PERIODO,
                VERBAS.MATRICULA,
                VERBAS.CONTA,
                CTD.CTD_DESC01,
                CTT.CTT_DESC01,
                SRA.RA_NOME,
                SRJ.RJ_DESC
        ) FOLHA
            on FOLHA.RA_FILIAL = VIAGEM.DTQ_FILORI
            and FOLHA.PERIODO = substring(VIAGEM.CHE_VIAGEM, 1, 6)
            and FOLHA.MATRICULA = VIAGEM.COD_MOT
