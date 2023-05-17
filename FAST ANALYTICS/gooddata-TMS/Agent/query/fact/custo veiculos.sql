    select
        'P |01|01' AS BK_EMPRESA,
        VIAGEM.ID_VIAGEM,
        
        VIAGEM.CHE_CLIDEV,
        VIAGEM.SAI_CLIDEV,
        VIAGEM.CHE_VIAGEM,
        VIAGEM.SAI_VIAGEM,
        VIAGEM.km_fim,
        VIAGEM.km_ini,

        DT6.DT6_DOC,
        DT6.DT6_DATEMI,

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

        VIAGEM.ID_VEICULO_CM,
        VIAGEM.ID_VEICULO_RB1,
        VIAGEM.ID_VEICULO_RB2,
        VIAGEM.ID_VEICULO_RB3,
        VIAGEM.ID_MOTORISTA,

        case MANUTENCAO.TIPO_VEICULO when 'CM' then MANUTENCAO.TJ_ORDEM else null end as MNT_TJ_ORDEM,
        case MANUTENCAO.TIPO_VEICULO when 'CM' then MANUTENCAO.TIPO_CUSTO else null end as MNT_TIPO_CUSTO,
        case MANUTENCAO.TIPO_VEICULO when 'CM' then MANUTENCAO.TL_TIPOREG else null end as MNT_TL_TIPOREG,
        case MANUTENCAO.TIPO_VEICULO when 'CM' then MANUTENCAO.TL_CUSTO else null end as MNT_TL_CUSTO,
        
        COMBUSTIVEL.km as COMB_km,
        COMBUSTIVEL.TQM_NOMCOM as COMB_NOME,
        COMBUSTIVEL.CUSTO as COMB_CUSTO,

        case DOCUMENTACAO.TIPO_VEICULO when 'CM' then DOCUMENTACAO.TS0_DOCTO else null end as TAX_TS0_DOCTO,
        case DOCUMENTACAO.TIPO_VEICULO when 'CM' then DOCUMENTACAO.VALOR_TAXA else null end as TAX_CUSTO,

        case DEPRECIACAO.TIPO_VEICULO when 'CM' then DEPRECIACAO.VALOR_MOV else null end as DEPRECIACAO,

        0.0 as AUTOTRAC,
        0.0 as SEGURO_VEICULO,
        0.0 as OUTROS_CUSTOS_VEICULO

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
                trim(DA4010.DA4_COD) as ID_MOTORISTA,
                DA4010.DA4_COD,
                DA4010.DA4_MAT,
                
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODVEI) as ID_VEICULO_CM,
                DTR.DTR_CODVEI as COD_CM,
                
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB1) as ID_VEICULO_RB1,
                DTR.DTR_CODRB1 as COD_RB1,
                
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB2) as ID_VEICULO_RB2,
                DTR.DTR_CODRB2 as COD_RB2,
                
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB3) as ID_VEICULO_RB3,
                DTR.DTR_CODRB3 as COD_RB3,

                (
                    select
                            top 1 concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))
                    from DTW010
                    where
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                        and DTW010.DTW_HORREA != ''
                        and DTW010.DTW_DATREA != ''
                        and DTW010.DTW_ATIVID = 57 /*58 PONTO DE APOIO*/
                        and DTW010.DTW_CODCLI != 761
                    order by DTW010.DTW_SEQUEN
                ) as CHE_CLIDEV,
                (
                    select
                            top 1 concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))
                    from DTW010
                    where
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                        and DTW010.DTW_HORREA != ''
                        and DTW010.DTW_DATREA != ''
                        and DTW010.DTW_ATIVID = 56 /*58 PONTO DE APOIO*/
                        and DTW010.DTW_CODCLI != 761
                    order by DTW010.DTW_SEQUEN
                ) as SAI_CLIDEV,

                (
                    select
                            concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))
                    from DTW010
                    where
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                        and DTW010.DTW_HORREA != ''
                        and DTW010.DTW_DATREA != ''
                        and DTW010.DTW_ATIVID = 49
                ) as SAI_VIAGEM,
                (
                    select
                            concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))
                    from DTW010
                    where
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                        and DTW010.DTW_HORREA != ''
                        and DTW010.DTW_DATREA != ''
                        and DTW010.DTW_ATIVID = 50
                ) as CHE_VIAGEM,
                (
                    select substring(DTW010.DTW_DATREA, 1, 6)
                    from DTW010
                    where 
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                        and DTW010.DTW_ATIVID = 50
                ) as COMPETENCIA

            from DTQ010 DTQ
                inner join DTR010 DTR
                    on DTR.D_E_L_E_T_ = ''
                    and DTR.DTR_FILORI = DTQ.DTQ_FILORI
                    and DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM
                    
                    left join DUP010
                        on DUP010.D_E_L_E_T_ = ''
                        and DUP010.DUP_FILORI = DTR.DTR_FILORI
                        and DUP010.DUP_VIAGEM = DTR.DTR_VIAGEM
                        and DUP010.DUP_ITEDTR = DTR.DTR_ITEM
                        and DUP010.DUP_CODVEI = DTR.DTR_CODVEI

                        left join DA4010
                            on DA4010.D_E_L_E_T_ = ''
                            and DA4010.DA4_COD = DUP010.DUP_CODMOT

            where
                    DTQ.D_E_L_E_T_ = ''
                and year(DTQ.DTQ_DATENC) > 2021
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
                STL.TL_TIPOREG,
                STL.PERIODO_MNT,
                STL.TIPO_CUSTO,
                STJ.TJ_CCUSTO,
                STL.TL_UNIDADE,
                sum(STL.TL_QUANTID) as TL_QUANTID,
                sum(STL.TL_CUSTO) as TL_CUSTO,
                case when STJ.TJ_CODBEM like 'CM%' then 'CM' when STJ.TJ_CODBEM like 'SR%' then 'SR' else 'OUTROS' end as TIPO_VEICULO

            from STJ010 STJ
                inner join ST9010 ST9
                    on ST9.D_E_L_E_T_ = ''
                    and ST9.T9_CODBEM = STJ.TJ_CODBEM

                inner join
                (
                    select
                        STL010.TL_ORDEM,
                        STL010.TL_PLANO,
                        STL010.TL_FILIAL,
                        substring(STL010.TL_DTINICI, 1, 6) as PERIODO_MNT,
                        STL010.TL_CODIGO,
                        STL010.TL_UNIDADE,
                        STL010.TL_QUANTID,

                        case STL010.TL_TIPOREG
                            when 'M' then 'MAO-DE-OBRA'
                            when 'E' then 'MAO-DE-OBRA'
                            when 'P' then 'PECAS'
                            when 'T' then 'TERCEIROS'
                            else 'OUTROS'
                        end as TL_TIPOREG,

                        case when STL010.TL_LOCAL in ('20', '21', '22', '23', '24', '26') then 'PNEU' else 'MANUTENCAO' end as TIPO_CUSTO,
                        case when STL010.TL_LOCAL in ('20', '21', '22', '23', '24', '26') then PNEU_CUSTO.B9_CM * STL010.TL_QUANTID else STL010.TL_CUSTO end as TL_CUSTO

                    from STL010
                        left join
                        (
                            select
                                SB9010.B9_COD,
                                min(SB9010.B9_VINI1/SB9010.B9_QINI) as B9_CM,
                                min(SB9010.B9_DATA) as B9_DATA
                            from SB9010
                            where
                                    SB9010.D_E_L_E_T_ = ''
                                and SB9010.B9_LOCAL = '20'
                                and SB9010.B9_COD like '1130%'
                                and SB9010.B9_QINI != 0
                            group by
                                SB9010.B9_COD
                        ) PNEU_CUSTO /* custo médio de pneu novo do período */
                            on PNEU_CUSTO.B9_COD = STL010.TL_CODIGO
                    where
                            STL010.D_E_L_E_T_ = ''
                        and STL010.TL_TIPOREG in ('P', 'T')
                        and STL010.TL_SEQRELA > 0
                ) STL
                    on STL.TL_FILIAL = STJ.TJ_FILIAL
                    and STL.TL_ORDEM = STJ.TJ_ORDEM
                    and STL.TL_PLANO = STJ.TJ_PLANO
            where
                    STJ.D_E_L_E_T_ = ''
                and ST9.T9_CODFAMI in ('VP', 'VM')
            group by
                STJ.TJ_CODBEM,
                STJ.TJ_ORDEM,
                STL.TL_TIPOREG,
                STL.PERIODO_MNT,
                STL.TIPO_CUSTO,
                STJ.TJ_CCUSTO,
                STL.TL_UNIDADE

        ) MANUTENCAO
            on MANUTENCAO.PERIODO_MNT = VIAGEM.COMPETENCIA
            and MANUTENCAO.TJ_CODBEM = VIAGEM.COD_CM
        
        left join
        (
            select
                ZD3.ZD3_VEICUL,
                ZD3.TQN_CCUSTO,
                sum(ZD3.ZD3_KMRD) as km,
                sum(ZD3.ZD3_TOTAL) as CUSTO,
                ZD3.PERIODO_ABA,
                trim(isnull(TQM.TQM_NOMCOM, '-')) as TQM_NOMCOM
            from
                (
                    select
                        case cast(ZD30.ZD3_TANQUE as int)
                            when 12 then '010102'
                            else trim(isnull(ZD30.ZD3_FILIAL, '-'))
                        end as ZD3_FILIAL,
                        ZD30.ZD3_KM as ZD3_HODOM,
                        ZD30.ZD3_VEICUL,
                        ZD30.ZD3_LITROS,
                        ZD30.ZD3_TOTAL,
                        ZD30.ZD3_TANQUE,
                        ZD30.ZD3_COMB,
                        substring(ZD30.ZD3_DATA, 1, 8) as PERIODO_ABA,
                        substring(ZD30.ZD3_DATA, 1, 8) as ZD3_DATA,
                        ZD30.ZD3_KML,
                        ZD30.ZD3_KMRD,

                        (
                            select TQN010.TQN_CCUSTO
                            from TQN010
                            where
                                    TQN010.D_E_L_E_T_ = ''
                                and TQN010.TQN_FROTA = ZD30.ZD3_VEICUL
                                and TQN010.TQN_DTABAS = substring(ZD30.ZD3_DATA, 1, 8)
                                and TQN010.TQN_HRABAS = substring(ZD30.ZD3_DATA, 10, 5)
                        ) as TQN_CCUSTO,
                        (
                            select
                                case when TQN010.TQN_YITMCT is not null and TQN010.TQN_YITMCT != '' then TQN010.TQN_YITMCT
                                else
                                    case TQN010.TQN_CCUSTO
                                        when 302 then 11
                                        when 304 then 11
                                        when 303 then 21
                                        when 305 then 21
                                        when 306 then 21
                                        else 90
                                    end
                                end
                            from TQN010
                            where
                                    TQN010.D_E_L_E_T_ = ''
                                and TQN010.TQN_FROTA = ZD30.ZD3_VEICUL
                                and TQN010.TQN_DTABAS = substring(ZD30.ZD3_DATA, 1, 8)
                                and TQN010.TQN_HRABAS = substring(ZD30.ZD3_DATA, 10, 5)
                        ) as TQN_YITMCT
                    from ZD3010 ZD30
                    where ZD30.D_E_L_E_T_ = ''
                ) as ZD3

                    left join ST9010 as ST9
                        on ST9.D_E_L_E_T_ = ''
                        and ST9.T9_CODBEM = ZD3.ZD3_VEICUL
                        and ST9.T9_CODFAMI in ('VP', 'VM')
                    left join TQM010 as TQM
                        on TQM.D_E_L_E_T_ = ''
                        and TQM.TQM_CODCOM = ZD3.ZD3_COMB
            group by
                ZD3.ZD3_VEICUL,
                ZD3.TQN_CCUSTO,
                ZD3.PERIODO_ABA,
                TQM.TQM_NOMCOM

        ) COMBUSTIVEL
            on COMBUSTIVEL.ZD3_VEICUL = VIAGEM.COD_CM
            and COMBUSTIVEL.PERIODO_ABA = VIAGEM.COMPETENCIA
        
        left join
        (
            select
                sum(TS1.TS1_VALOR) as VALOR_TAXA,
                trim(isnull(TS0010.TS0_NOMDOC, '-')) as TS0_DOCTO,
                trim(isnull(ST9010.T9_CODBEM, '-')) as T9_CODBEM,
                TS1.ANO_DOCTO,
                case when ST9010.T9_CODBEM like 'CM%' then 'CM' when ST9010.T9_CODBEM like 'SR%' then 'SR' else 'OUTROS' end as TIPO_VEICULO
            from
                (
                    select
                        TS1010.TS1_DOCTO,
                        TS1010.TS1_CODBEM,
                        TS1010.TS1_VALOR,
                        year(TS1010.TS1_DTEMIS) as ANO_DOCTO
                    from TS1010
                    where TS1010.D_E_L_E_T_ = ''
                ) TS1
                left join TS0010
                    on TS0010.D_E_L_E_T_ = ''
                    and TS0010.TS0_DOCTO = TS1.TS1_DOCTO
                left join ST9010
                    on ST9010.D_E_L_E_T_ = ''
                    and ST9010.T9_CODBEM = TS1.TS1_CODBEM
            group by
                TS0010.TS0_NOMDOC,
                ST9010.T9_CODBEM,
                TS1.ANO_DOCTO

        ) DOCUMENTACAO
            on DOCUMENTACAO.ANO_DOCTO = substring(VIAGEM.COMPETENCIA, 1, 4)
            and DOCUMENTACAO.T9_CODBEM = VIAGEM.COD_CM
        
        left join
        (
            select
                SN1.N1_GRUPO as GRUPO,
                trim(isnull(SN1.N1_CBASE, '-')) as ATIVO,
                trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,
                convert(date, SN3.N3_DINDEPR, 103) as INI_DEPREC,
                SN3.N3_TXDEPR1 /12 as DEPREC_MENSAL,
                substring(SN4.N4_DATA, 1, 6) as PERIODO,
                SN4.N4_VLROC1 as VALOR_MOV,
                case when SN1.N1_CODBEM like 'CM%' then 'CM' when SN1.N1_CODBEM like 'SR%' then 'SR' else 'OUTROS' end as TIPO_VEICULO

            from SN4010 SN4
                inner join SN3010 SN3
                    on SN3.D_E_L_E_T_ = ''
                    and SN3.N3_CBASE = SN4.N4_CBASE
                    and SN3.N3_ITEM = SN4.N4_ITEM

                    left join SN1010 SN1
                        on SN1.D_E_L_E_T_ = ''
                        and SN1.N1_CBASE = SN3.N3_CBASE
                        and SN1.N1_ITEM = SN3.N3_ITEM

                        left join ST9010 ST9
                            on ST9.D_E_L_E_T_ = ''
                            and ST9.T9_CODBEM = SN1.N1_CODBEM
            where
                    SN4.D_E_L_E_T_ = ''
                and SN4.N4_OCORR = 6

        ) DEPRECIACAO
            on DEPRECIACAO.PERIODO = VIAGEM.COMPETENCIA
            and DEPRECIACAO.T9_CODBEM = VIAGEM.COD_CM
    where VIAGEM.CHE_VIAGEM BETWEEN <<START_DATE>> AND <<FINAL_DATE>>

union 

    select
        'P |01|01' AS BK_EMPRESA,
        VIAGEM.ID_VIAGEM,
        
        VIAGEM.CHE_CLIDEV,
        VIAGEM.SAI_CLIDEV,
        VIAGEM.CHE_VIAGEM,
        VIAGEM.SAI_VIAGEM,
        VIAGEM.km_fim,
        VIAGEM.km_ini,

        DT6.DT6_DOC,
        DT6.DT6_DATEMI,

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

        VIAGEM.ID_VEICULO_CM,
        VIAGEM.ID_VEICULO_RB1,
        VIAGEM.ID_VEICULO_RB2,
        VIAGEM.ID_VEICULO_RB3,
        VIAGEM.ID_MOTORISTA,

        case MANUTENCAO.TIPO_VEICULO when 'SR' then MANUTENCAO.TJ_ORDEM else null end as MNT_TJ_ORDEM,
        case MANUTENCAO.TIPO_VEICULO when 'SR' then MANUTENCAO.TIPO_CUSTO else null end as MNT_TIPO_CUSTO,
        case MANUTENCAO.TIPO_VEICULO when 'SR' then MANUTENCAO.TL_TIPOREG else null end as MNT_TL_TIPOREG,
        case MANUTENCAO.TIPO_VEICULO when 'SR' then MANUTENCAO.TL_CUSTO else null end as MNT_TL_CUSTO,
        
        null as COMB_km,
        null as COMB_NOME,
        null as COMB_CUSTO,

        case DOCUMENTACAO.TIPO_VEICULO when 'SR' then DOCUMENTACAO.TS0_DOCTO else null end as TAX_TS0_DOCTO,
        case DOCUMENTACAO.TIPO_VEICULO when 'SR' then DOCUMENTACAO.VALOR_TAXA else null end as TAX_CUSTO,

        case DEPRECIACAO.TIPO_VEICULO when 'SR' then DEPRECIACAO.VALOR_MOV else null end as DEPRECIACAO,

        0.0 as AUTOTRAC,
        0.0 as SEGURO_VEICULO,
        0.0 as OUTROS_CUSTOS_VEICULO

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
                trim(DA4010.DA4_COD) as ID_MOTORISTA,
                DA4010.DA4_COD,
                DA4010.DA4_MAT,
                
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODVEI) as ID_VEICULO_CM,
                DTR.DTR_CODVEI as COD_CM,
                
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB1) as ID_VEICULO_RB1,
                DTR.DTR_CODRB1 as COD_RB1,
                
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB2) as ID_VEICULO_RB2,
                DTR.DTR_CODRB2 as COD_RB2,
                
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB3) as ID_VEICULO_RB3,
                DTR.DTR_CODRB3 as COD_RB3,

                (
                    select
                            top 1 concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))
                    from DTW010
                    where
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                        and DTW010.DTW_HORREA != ''
                        and DTW010.DTW_DATREA != ''
                        and DTW010.DTW_ATIVID = 57 /*58 PONTO DE APOIO*/
                        and DTW010.DTW_CODCLI != 761
                    order by DTW010.DTW_SEQUEN
                ) as CHE_CLIDEV,
                (
                    select
                            top 1 concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))
                    from DTW010
                    where
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                        and DTW010.DTW_HORREA != ''
                        and DTW010.DTW_DATREA != ''
                        and DTW010.DTW_ATIVID = 56 /*58 PONTO DE APOIO*/
                        and DTW010.DTW_CODCLI != 761
                    order by DTW010.DTW_SEQUEN
                ) as SAI_CLIDEV,

                (
                    select
                            concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))
                    from DTW010
                    where
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                        and DTW010.DTW_HORREA != ''
                        and DTW010.DTW_DATREA != ''
                        and DTW010.DTW_ATIVID = 49
                ) as SAI_VIAGEM,
                (
                    select
                            concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))
                    from DTW010
                    where
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                        and DTW010.DTW_HORREA != ''
                        and DTW010.DTW_DATREA != ''
                        and DTW010.DTW_ATIVID = 50
                ) as CHE_VIAGEM,
                (
                    select substring(DTW010.DTW_DATREA, 1, 6)
                    from DTW010
                    where 
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                        and DTW010.DTW_ATIVID = 50
                ) as COMPETENCIA

            from DTQ010 DTQ
                left join DTR010 DTR
                    on DTR.D_E_L_E_T_ = ''
                    and DTR.DTR_FILORI = DTQ.DTQ_FILORI
                    and DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM
                    
                    left join DUP010
                        on DUP010.D_E_L_E_T_ = ''
                        and DUP010.DUP_FILORI = DTR.DTR_FILORI
                        and DUP010.DUP_VIAGEM = DTR.DTR_VIAGEM
                        and DUP010.DUP_ITEDTR = DTR.DTR_ITEM
                        and DUP010.DUP_CODVEI = DTR.DTR_CODVEI

                        left join DA4010
                            on DA4010.D_E_L_E_T_ = ''
                            and DA4010.DA4_COD = DUP010.DUP_CODMOT

            where
                    DTQ.D_E_L_E_T_ = ''
                and year(DTQ.DTQ_DATENC) > 2021
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
                STL.TL_TIPOREG,
                STL.PERIODO_MNT,
                STL.TIPO_CUSTO,
                STJ.TJ_CCUSTO,
                STL.TL_UNIDADE,
                sum(STL.TL_QUANTID) as TL_QUANTID,
                sum(STL.TL_CUSTO) as TL_CUSTO,
                case when STJ.TJ_CODBEM like 'CM%' then 'CM' when STJ.TJ_CODBEM like 'SR%' then 'SR' else 'OUTROS' end as TIPO_VEICULO

            from STJ010 STJ
                inner join ST9010 ST9
                    on ST9.D_E_L_E_T_ = ''
                    and ST9.T9_CODBEM = STJ.TJ_CODBEM

                inner join
                (
                    select
                        STL010.TL_ORDEM,
                        STL010.TL_PLANO,
                        STL010.TL_FILIAL,
                        substring(STL010.TL_DTINICI, 1, 6) as PERIODO_MNT,
                        STL010.TL_CODIGO,
                        STL010.TL_UNIDADE,
                        STL010.TL_QUANTID,

                        case STL010.TL_TIPOREG
                            when 'M' then 'MAO-DE-OBRA'
                            when 'E' then 'MAO-DE-OBRA'
                            when 'P' then 'PECAS'
                            when 'T' then 'TERCEIROS'
                            else 'OUTROS'
                        end as TL_TIPOREG,

                        case when STL010.TL_LOCAL in ('20', '21', '22', '23', '24', '26') then 'PNEU' else 'MANUTENCAO' end as TIPO_CUSTO,
                        case when STL010.TL_LOCAL in ('20', '21', '22', '23', '24', '26') then PNEU_CUSTO.B9_CM * STL010.TL_QUANTID else STL010.TL_CUSTO end as TL_CUSTO

                    from STL010
                        left join
                        (
                            select
                                SB9010.B9_COD,
                                min(SB9010.B9_VINI1/SB9010.B9_QINI) as B9_CM,
                                min(SB9010.B9_DATA) as B9_DATA
                            from SB9010
                            where
                                    SB9010.D_E_L_E_T_ = ''
                                and SB9010.B9_LOCAL = '20'
                                and SB9010.B9_COD like '1130%'
                                and SB9010.B9_QINI != 0
                            group by
                                SB9010.B9_COD
                        ) PNEU_CUSTO /* custo médio de pneu novo do período */
                            on PNEU_CUSTO.B9_COD = STL010.TL_CODIGO
                    where
                            STL010.D_E_L_E_T_ = ''
                        and STL010.TL_TIPOREG in ('P', 'T')
                        and STL010.TL_SEQRELA > 0
                ) STL
                    on STL.TL_FILIAL = STJ.TJ_FILIAL
                    and STL.TL_ORDEM = STJ.TJ_ORDEM
                    and STL.TL_PLANO = STJ.TJ_PLANO
            where
                    STJ.D_E_L_E_T_ = ''
                and ST9.T9_CODFAMI in ('VP', 'VM')
            group by
                STJ.TJ_CODBEM,
                STJ.TJ_ORDEM,
                STL.TL_TIPOREG,
                STL.PERIODO_MNT,
                STL.TIPO_CUSTO,
                STJ.TJ_CCUSTO,
                STL.TL_UNIDADE

        ) MANUTENCAO
            on MANUTENCAO.PERIODO_MNT = VIAGEM.COMPETENCIA
            and MANUTENCAO.TJ_CODBEM = VIAGEM.COD_RB1
        
        left join
        (
            select
                sum(TS1.TS1_VALOR) as VALOR_TAXA,
                trim(isnull(TS0010.TS0_NOMDOC, '-')) as TS0_DOCTO,
                trim(isnull(ST9010.T9_CODBEM, '-')) as T9_CODBEM,
                TS1.ANO_DOCTO,
                case when ST9010.T9_CODBEM like 'CM%' then 'CM' when ST9010.T9_CODBEM like 'SR%' then 'SR' else 'OUTROS' end as TIPO_VEICULO
            from
                (
                    select
                        TS1010.TS1_DOCTO,
                        TS1010.TS1_CODBEM,
                        TS1010.TS1_VALOR,
                        year(TS1010.TS1_DTEMIS) as ANO_DOCTO
                    from TS1010
                    where TS1010.D_E_L_E_T_ = ''
                ) TS1
                left join TS0010
                    on TS0010.D_E_L_E_T_ = ''
                    and TS0010.TS0_DOCTO = TS1.TS1_DOCTO
                left join ST9010
                    on ST9010.D_E_L_E_T_ = ''
                    and ST9010.T9_CODBEM = TS1.TS1_CODBEM
            group by
                TS0010.TS0_NOMDOC,
                ST9010.T9_CODBEM,
                TS1.ANO_DOCTO

        ) DOCUMENTACAO
            on DOCUMENTACAO.ANO_DOCTO = substring(VIAGEM.COMPETENCIA, 1, 4)
            and DOCUMENTACAO.T9_CODBEM = VIAGEM.COD_RB1
        
        left join
        (
            select
                SN1.N1_GRUPO as GRUPO,
                trim(isnull(SN1.N1_CBASE, '-')) as ATIVO,
                trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,
                convert(date, SN3.N3_DINDEPR, 103) as INI_DEPREC,
                SN3.N3_TXDEPR1 /12 as DEPREC_MENSAL,
                substring(SN4.N4_DATA, 1, 6) as PERIODO,
                SN4.N4_VLROC1 as VALOR_MOV,
                case when SN1.N1_CODBEM like 'CM%' then 'CM' when SN1.N1_CODBEM like 'SR%' then 'SR' else 'OUTROS' end as TIPO_VEICULO

            from SN4010 SN4
                inner join SN3010 SN3
                    on SN3.D_E_L_E_T_ = ''
                    and SN3.N3_CBASE = SN4.N4_CBASE
                    and SN3.N3_ITEM = SN4.N4_ITEM

                    left join SN1010 SN1
                        on SN1.D_E_L_E_T_ = ''
                        and SN1.N1_CBASE = SN3.N3_CBASE
                        and SN1.N1_ITEM = SN3.N3_ITEM

                        left join ST9010 ST9
                            on ST9.D_E_L_E_T_ = ''
                            and ST9.T9_CODBEM = SN1.N1_CODBEM
            where
                    SN4.D_E_L_E_T_ = ''
                and SN4.N4_OCORR = 6

        ) DEPRECIACAO
            on DEPRECIACAO.PERIODO = VIAGEM.COMPETENCIA
            and DEPRECIACAO.T9_CODBEM = VIAGEM.COD_RB1
    where VIAGEM.CHE_VIAGEM BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
