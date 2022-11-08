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
    sum(VERBAS.VALOR) as VALOR,

    VIAGEM.DTQ_VIAGEM,
    VIAGEM.BK_REMETENTE,
    VIAGEM.BK_DESTINATARIO,
    VIAGEM.BK_DEVEDOR,
    VIAGEM.BK_CDRORI,
    VIAGEM.BK_CDRDES,
    VIAGEM.BK_CDRCAL,
    VIAGEM.BK_NEGOCIACAO,
    VIAGEM.BK_SERVICO,
    VIAGEM.BK_TIPTRA,
    VIAGEM.BK_FILIAL,
    VIAGEM.BK_FILIAL_ORIGEM,
    VIAGEM.BK_FILIAL_DESTINO,
    VIAGEM.BK_REGIAO_REM,
    VIAGEM.BK_REGIAO_DES,
    VIAGEM.BK_REGIAO_DEV,
    VIAGEM.BK_FILIAL_DOCTO,
    VIAGEM.DT6_FILDOC,
    VIAGEM.DT6_DOC,
    VIAGEM.DT6_SERIE

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
            SRV010.RV_COD, /* VER ELIMINAÇÃO DE VERBAS INDIVIDUAIS, OQ PERMITIRIA USAR DISTINCT NESTA TABELA E VINCULAR AO EMPREGADO SEM DUPLICATAS */
            isnull(SRD010.RD_PD, SRT010.RT_VERBA) as EVENTO,
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

        inner join
        (
            select
                DTQ.DTQ_FILORI,
                DTQ.DTQ_VIAGEM,
                'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIREM, ' '))+RTRIM(COALESCE(DT6.DT6_LOJREM, ' ')), ' '), '|') AS BK_REMETENTE,
                'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIDES, ' '))+RTRIM(COALESCE(DT6.DT6_LOJDES, ' ')), ' '), '|') AS BK_DESTINATARIO,
                'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIDEV, ' '))+RTRIM(COALESCE(DT6.DT6_LOJDEV, ' ')), ' '), '|') AS BK_DEVEDOR,
                'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRORI, ' ')), ' '), '|') AS BK_CDRORI,
                'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDES.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRDES, ' ')), ' '), '|') AS BK_CDRDES,
                'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRCAL, ' ')), ' '), '|') AS BK_CDRCAL,
                'P |01|DDB010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DDB.DDB_FILIAL, ' '))+'|'+RTRIM(COALESCE(DDB.DDB_CODNEG, ' ')), ' '), '|') AS BK_NEGOCIACAO,
                'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SX5.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_SERVIC, ' ')), ' '), '|') AS BK_SERVICO,
                'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(DT6.DT6_TIPTRA, ' ')), ' '), '|') AS BK_TIPTRA,
                CASE WHEN DT6.DT6_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILIAL AS CHAR (8)) END AS BK_FILIAL,
                CASE WHEN DT6.DT6_FILORI IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILORI AS CHAR (8)) END AS BK_FILIAL_ORIGEM,
                CASE WHEN DT6.DT6_FILDES IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILDES AS CHAR (8)) END AS BK_FILIAL_DESTINO,
                CASE WHEN REM.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' '))+RTRIM(COALESCE(REM.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_REM,
                CASE WHEN DES.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' '))+RTRIM(COALESCE(DES.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DES,
                CASE WHEN DEV.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' '))+RTRIM(COALESCE(DEV.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DEV,
                CASE WHEN DT6.DT6_FILDOC IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILDOC AS CHAR (8)) END AS BK_FILIAL_DOCTO,
                DT6.DT6_FILDOC,
                DT6.DT6_DOC,
                DT6.DT6_SERIE,
                
                (
                    select substring(DTW010.DTW_DATREA, 1, 6)
                    from DTW010 (nolock)
                    where 
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                        and DTW010.DTW_ATIVID = '050'
                        and DTW010.DTW_DATREA > '20211231'
                ) as PERIODO

            from DTQ010 DTQ (nolock)
                inner join DUD010 DUD (nolock)
                    on DUD.D_E_L_E_T_ = ''
                    and DUD.DUD_FILIAL = DTQ.DTQ_FILIAL
                    and DUD.DUD_FILORI = DTQ.DTQ_FILORI
                    and DUD.DUD_VIAGEM = DTQ.DTQ_VIAGEM

                    left join DT6010 DT6 (nolock)
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
            where
                    DTQ.D_E_L_E_T_ = ''
                and cast(DTQ.DTQ_STATUS as int) = 3
        ) VIAGEM
            on VIAGEM.DTQ_FILORI = VERBAS.FILIAL
            and VIAGEM.PERIODO = VERBAS.PERIODO
where
        SRA.D_E_L_E_T_ = ''
    and (SRA.RA_CC = 302 or SRA.RA_CC = 206)
group by
    SRA.RA_FILIAL,
    VERBAS.PERIODO,
    VERBAS.MATRICULA,
    VERBAS.CONTA,
    CTD.CTD_DESC01,
    CTT.CTT_DESC01,
    SRA.RA_NOME,
	SRJ.RJ_DESC,
    VIAGEM.DTQ_VIAGEM,
    VIAGEM.BK_REMETENTE,
    VIAGEM.BK_DESTINATARIO,
    VIAGEM.BK_DEVEDOR,
    VIAGEM.BK_CDRORI,
    VIAGEM.BK_CDRDES,
    VIAGEM.BK_CDRCAL,
    VIAGEM.BK_NEGOCIACAO,
    VIAGEM.BK_SERVICO,
    VIAGEM.BK_TIPTRA,
    VIAGEM.BK_FILIAL,
    VIAGEM.BK_FILIAL_ORIGEM,
    VIAGEM.BK_FILIAL_DESTINO,
    VIAGEM.BK_REGIAO_REM,
    VIAGEM.BK_REGIAO_DES,
    VIAGEM.BK_REGIAO_DEV,
    VIAGEM.BK_FILIAL_DOCTO,
    VIAGEM.DT6_FILDOC,
    VIAGEM.DT6_DOC,
    VIAGEM.DT6_SERIE
