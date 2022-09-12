select
    VIAGEM.DTQ_FILORI,
    VIAGEM.DTQ_VIAGEM,
    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    convert(date, DT6.DT6_DATEMI, 103) as DT6_DATEMI,
    VIAGEM.DTQ_KMVGE,
    VIAGEM.DTR_CODVEI,
    DT6.DT6_CDRORI,
    DT6.DT6_CDRDES,
    DT6.DT6_CDRCAL,

    (
        select substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT))
        from DTW010 (nolock)
            inner join ZB1010 (nolock)
                on ZB1010.D_E_L_E_T_ = ''
                and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                and
                    dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                    =
                    datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = VIAGEM.DTQ_FILORI
            and DTW010.DTW_VIAGEM = VIAGEM.DTQ_VIAGEM
            and ZB1010.ZB1_CODDA3 = VIAGEM.DTR_CODVEI
            and DTW010.DTW_ATIVID in ('050')
    ) as km_fim,
    (
        select substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT))
        from DTW010 (nolock)
            inner join ZB1010 (nolock)
                on ZB1010.D_E_L_E_T_ = ''
                and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                and
                    dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                    =
                    datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
        where
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = VIAGEM.DTQ_FILORI
            and DTW010.DTW_VIAGEM = VIAGEM.DTQ_VIAGEM
            and ZB1010.ZB1_CODDA3 = VIAGEM.DTR_CODVEI
            and DTW010.DTW_ATIVID in ('049')
    ) as km_ini,

    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,

    DTC.DTC_NUMNFC,
    DTC.DTC_SERNFC,
    DTC.DTC_VALOR,

    DTC.DTC_VALOR *
    (
        select case DU5010.DU5_INTERV when 1000 then (DU5010.DU5_VALOR/10)/100 else (DU5010.DU5_VALOR)/100 end
        from DU5010 (nolock)
            inner join DTC010 (nolock)
                on DTC010.D_E_L_E_T_ = ''
                and DU5010.DU5_CDRORI = DTC010.DTC_CDRORI
                and DU5010.DU5_CDRDES = DTC010.DTC_CDRCAL
        where
                DU5010.D_E_L_E_T_ = ''
            and DTC010.DTC_FILORI = DTC.DTC_FILORI
            and DTC010.DTC_NUMNFC = DTC.DTC_NUMNFC
            and DTC010.DTC_SERNFC = DTC.DTC_SERNFC
            and DTC010.DTC_FILDOC = DT6.DT6_FILDOC
            and DTC010.DTC_DOC = DT6.DT6_DOC
            and DTC010.DTC_SERIE = DT6.DT6_SERIE
    ) as SEGURO,

    case when DT5.DT5_STATUS = '4' then 'INTERNA' else case when DT5.DT5_STATUS like '[0-9]' then 'COLETA' else 'ENTREGA' end end as STATUS,

    DT5.DT5_NUMSOL,
    DT5.DT5_DOC,
    DT5.DT5_SERIE,
    DT5.DT5_STATUS,
    DT5.DT5_TIPCOL,
    DT5.DT5_CODSOL,
    DT5.DT5_CODOBC,

    DUA.DUA_FILOCO,
    DUA.DUA_NUMOCO,
    DUA.DUA_FILORI,
    DUA.DUA_VIAGEM,
    DUA.DUA_SEQOCO,
    DUA.DUA_DATOCO,
    DUA.DUA_HOROCO,
    DT2.DT2_CODOCO,
    DT2.DT2_DESCRI,

    VIAGEM.DATAINI,
    VIAGEM.HORAINI,
    VIAGEM.DATAFIM,
    VIAGEM.HORAFIM,
    VIAGEM.COMPETENCIA,
    VIAGEM.DTQ_STATUS,

    DIARIAS.DYV_IDCDIA,
    DIARIAS.DYX_DATDIA,
    DIARIAS.DYX_VLRUNI,

    MANUTENCAO.TJ_CODBEM,
    MANUTENCAO.TJ_ORDEM,
    MANUTENCAO.TL_DTINICI,
    MANUTENCAO.INSUMO,
    MANUTENCAO.DESC_INSUMO,
    MANUTENCAO.TL_CUSTO,
    COMBUSTIVEL.ZD3_TOTAL,
    COMBUSTIVEL.ZD3_LITROS,
    COMBUSTIVEL.ZD3_VLUNI,
    COMBUSTIVEL.ZD3_DATA,

    DOCUMENTACAO.TS0_DOCTO,
    DOCUMENTACAO.VALPARC,

    datediff(month, DEPRECIACAO.N3_DINDEPR, VIAGEM.DTQ_DATENC) TEMPO_ATIVO,
	DEPRECIACAO.TEMPO_DEPREC,
	DEPRECIACAO.DEPRECMENSAL,
    DEPRECIACAO.TXDEPRECMENSAL,
    case when DEPRECIACAO.TEMPO_DEPREC >= datediff(month, DEPRECIACAO.N3_DINDEPR, VIAGEM.DTQ_DATENC) then DEPRECIACAO.DEPRECMENSAL else 0.0 end as DEPRECATUAL,

    1 as SEGURO_CARGA,
    1 as SEGURO_VEI,
    1 as EXTRAS

from DUD010 DUD (nolock)
    left join /* ver modelo para adição de dimensão motorista */
    (
        select
            DTQ.DTQ_FILIAL,
            DTQ.DTQ_FILORI,
            DTQ.DTQ_VIAGEM,
            DTQ.DTQ_DATGER,
            DTQ.DTQ_DATFEC,
            DTQ.DTQ_DATENC,
            DTQ.DTQ_KMVGE,
            
            DTR010.DTR_CODVEI,
            DUP010.DUP_CODMOT,
            DA4010.DA4_MAT,
            DTR010.DTR_CODRB1,
            DTR010.DTR_CODRB2,
            DTR010.DTR_CODRB3,

            (
                select cast(DTW010.DTW_DATREA as date)
                from DTW010 (nolock)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = '049'
            ) as DATAINI,
            (
                select DTW010.DTW_HORREA
                from DTW010 (nolock)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = '049'
            ) as HORAINI,
            (
                select cast(DTW010.DTW_DATREA as date)
                from DTW010 (nolock)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = '050'
            ) as DATAFIM,
            (
                select DTW010.DTW_HORREA
                from DTW010 (nolock)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = '050'
            ) as HORAFIM,

            (
                select substring(DTW010.DTW_DATREA, 1, 6)
                from DTW010 (nolock)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = '050'
            ) as COMPETENCIA,

            case DTQ.DTQ_STATUS
                when '1' then 'EXCLUÍDA'
                when '2' then 'EM TRANSITO'
                when '3' then 'ENCERRADA'
                when '4' then 'CHEGADA EM FILIAL'
                when '5' then 'FECHADA'
                when '9' then 'CANCELADA'
                else 'OUTROS'
            end as DTQ_STATUS

        from DTQ010 DTQ (nolock)
            inner join DTR010 (nolock)
                on DTR010.D_E_L_E_T_ = ''
                and DTR010.DTR_FILORI = DTQ.DTQ_FILORI
                and DTR010.DTR_VIAGEM = DTQ.DTQ_VIAGEM
                
                inner join DUP010 (nolock)
                    on DUP010.D_E_L_E_T_ = ''
                    and DUP010.DUP_FILORI = DTR010.DTR_FILORI
                    and DUP010.DUP_VIAGEM = DTR010.DTR_VIAGEM
                    and DUP010.DUP_ITEDTR = DTR010.DTR_ITEM
                    and DUP010.DUP_CODVEI = DTR010.DTR_CODVEI

                    inner join DA4010 (nolock)
                        on DA4010.D_E_L_E_T_ = ''
                        and DA4010.DA4_COD = DUP010.DUP_CODMOT
        where DTQ.D_E_L_E_T_ = ''
    ) VIAGEM
        on year(VIAGEM.DTQ_DATGER) = 2022
        and VIAGEM.DTQ_FILIAL = DUD.DUD_FILIAL
        and VIAGEM.DTQ_FILORI = DUD.DUD_FILORI
        and VIAGEM.DTQ_VIAGEM = DUD.DUD_VIAGEM
    left join DT5010 DT5 (nolock)
        on DT5.D_E_L_E_T_ = ''
        and DT5.DT5_FILDOC = DUD.DUD_FILDOC
        and DT5.DT5_NUMSOL = DUD.DUD_DOC
        and DT5.DT5_SERIE = DUD.DUD_SERIE
    
    left join DUA010 DUA (nolock)
        on DUA.D_E_L_E_T_ = ''
        and DUA.DUA_FILIAL = VIAGEM.DTQ_FILIAL
        and DUA.DUA_FILORI = VIAGEM.DTQ_FILORI
        and DUA.DUA_VIAGEM = VIAGEM.DTQ_VIAGEM

        left join DT2010 DT2 (nolock)
            on DT2.D_E_L_E_T_ = ' '
            and DT2.DT2_FILIAL = DUA.DUA_FILIAL
            and DT2.DT2_CODOCO = DUA.DUA_CODOCO

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
        left join DTC010 DTC (nolock)
            on DTC.D_E_L_E_T_ = ''
            and DTC.DTC_FILORI = DT6.DT6_FILDOC
            and DTC.DTC_DOC = DT6.DT6_DOC
            and DTC.DTC_SERIE = DT6.DT6_SERIE

    left join
    (
        select
            DYV010.DYV_VIAGEM,
            DYV010.DYV_CODMOT,
            DYV010.DYV_IDCDIA,
            DYX010.DYX_ITEM,
            DYX010.DYX_DATDIA,
            DYX010.DYX_QTDE,
            DYX010.DYX_VLRUNI
        from DYV010 (nolock)
            inner join DYX010 (nolock)
                on DYX010.D_E_L_E_T_ = ''
                and DYX010.DYX_IDCDIA = DYV010.DYV_IDCDIA
                and year(DYX010.DYX_DATDIA) = 2022
        where DYV010.D_E_L_E_T_ = ''
    ) DIARIAS
        on DIARIAS.DYV_VIAGEM = VIAGEM.DTQ_VIAGEM
    left join
    (
        select distinct
            STJ.TJ_CODBEM,
            STJ.TJ_ORDEM,
            STL.TL_DTINICI,
            STL.TL_QUANTID,
            STL.TL_SEQRELA,

            case when STL.TL_CODIGO = ST0.T0_ESPECIA or STL.TL_CODIGO = ST1.T1_CODFUNC then 'MÃO-DE-OBRA'
            else
                case when STL.TL_CODIGO = SB1.B1_COD and SB1.B1_COD like '1%' then 'PEÇAS'
                else
                    case when SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA then 'TERCEIROS'
                    else
                        case when STL.TL_CODIGO = SH4.H4_CODIGO then 'FERRAMENTA'
                        else 'OUTROS'
                        end
                    end
                end
            end as NATUREZA_CUSTO,

            case when STL.TL_CODIGO = ST1.T1_CODFUNC then trim(isnull(ST1.T1_CODFUNC, isnull(ST0.T0_ESPECIA, '-')))
            else
                case when STL.TL_CODIGO = SB1.B1_COD and SB1.B1_COD like '1%' then trim(SB1.B1_COD)
                else
                    case when SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA then isnull(trim(SA2.A2_COD) + '-' + trim(SA2.A2_LOJA), '-')
                    else
                        case when STL.TL_CODIGO = SH4.H4_CODIGO then trim(SH4.H4_CODIGO)
                        else 'OUTROS'
                        end
                    end
                end
            end as INSUMO,

            case when STL.TL_CODIGO = ST1.T1_CODFUNC then trim(isnull(ST1.T1_NOME, isnull(ST0.T0_NOME, '-')))
            else
                case when STL.TL_CODIGO = SB1.B1_COD and SB1.B1_COD like '1%' then trim(SB1.B1_DESC)
                else
                    case when SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA then trim(SA2.A2_NOME)
                    else
                        case when STL.TL_CODIGO = SH4.H4_CODIGO then trim(SH4.H4_DESCRI)
                        else 'OUTROS'
                        end
                    end
                end
            end as DESC_INSUMO,

            year(STL.TL_DTINICI) as ano_APP,
            month(STL.TL_DTINICI) as mes_APP,

            case when STJ.TJ_SERVICO = 'PNEMOV' then 'PNEU' else 'MANUTENÇÃO' end as TIPO_CUSTO,

            case when trim(STL.TL_CODIGO) in ('11380003', '11380004', '11380005') and STL.TL_LOCAL = '80' then ADESIVO_CUSTO.B9_CM * STL.TL_QUANTID
            else
                case when trim(STL.TL_CODIGO) like ('1130%') then PNEU_CUSTO.B9_CM * STL.TL_QUANTID
                else
                    STL.TL_CUSTO
                end
            end as TL_CUSTO
        from STJ010 STJ (nolock)
            inner join ST9010 ST9 (nolock)
                on ST9.D_E_L_E_T_ = ''
                and ST9.T9_CODBEM = STJ.TJ_CODBEM

                left join TQR010 TQR (nolock)
                    on TQR.D_E_L_E_T_ = ''
                    and TQR.TQR_TIPMOD = ST9.T9_TIPMOD

            inner join STL010 STL (nolock)
                on STL.D_E_L_E_T_ = ''
                and STL.TL_ORDEM = STJ.TJ_ORDEM
                and STL.TL_PLANO = STJ.TJ_PLANO
                and STL.TL_FILIAL = STJ.TJ_FILIAL

                left join SA2010 SA2 (nolock)
                    on SA2.D_E_L_E_T_ = ''
                    and SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA
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
            and STL.TL_SEQRELA > 0
            and STL.TL_DTINICI > 20211231
            and STJ.TJ_CCUSTO = 304 /* ver veículo portuário do BRANDAO */
            and ST9.T9_CODFAMI != 'PN'

    ) MANUTENCAO
        on MANUTENCAO.NATUREZA_CUSTO != 'MÃO-DE-OBRA'
        and substring(MANUTENCAO.TL_DTINICI, 1, 6) = substring(VIAGEM.DTQ_DATENC, 1, 6)
        and
        (
            MANUTENCAO.TJ_CODBEM = VIAGEM.DTR_CODVEI or
            MANUTENCAO.TJ_CODBEM = VIAGEM.DTR_CODRB1 or
            MANUTENCAO.TJ_CODBEM = VIAGEM.DTR_CODRB2 or
            MANUTENCAO.TJ_CODBEM = VIAGEM.DTR_CODRB3
        )
    
    left join
    (
        select
            ZD3.ZD3_LITROS,
            ZD3.ZD3_VLUNI,
            ZD3.ZD3_HODOM,
            ZD3.ZD3_KMRD,
            ZD3.ZD3_KML,
            ZD3.ZD3_TOTAL,
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
                    
                    ZD3010.ZD3_TANQUE,
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
                    TQI010.TQI_TANQUE,
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
        on COMBUSTIVEL.T9_CODBEM = VIAGEM.DTR_CODVEI
        and substring(COMBUSTIVEL.ZD3_DATA, 1, 6) = substring(VIAGEM.DTQ_DATENC, 1, 6)
    left join
    (
        select
            SN1010.N1_GRUPO,
            trim(isnull(SN1010.N1_CBASE, '-')) as N1_CBASE,
            trim(isnull(SN1010.N1_CODBEM, '-')) as N1_CODBEM,
            convert(date, SN3010.N3_DINDEPR, 103) as N3_DINDEPR,
            SNG010.NG_TXDEPR1 /12 as TXDEPRECMENSAL,

            SN1010.N1_QUANTD,
            SN3010.N3_VORIG1,
            SN3010.N3_VORIG2,
            SN3010.N3_VORIG3,
            SN3010.N3_VORIG4,
            SN3010.N3_VORIG5,
            SN3010.N3_TXDEPR1,
            SN3010.N3_TXDEPR2,
            SN3010.N3_TXDEPR3,
            SN3010.N3_TXDEPR4,
            SN3010.N3_TXDEPR5,

            100 / (SNG010.NG_TXDEPR1 /12) as TEMPO_DEPREC,
            SN3010.N3_VORIG1 * (SNG010.NG_TXDEPR1 / 1200) as DEPRECMENSAL

        from SN1010 (nolock)
            inner join SNG010 (nolock)
                on SNG010.D_E_L_E_T_ = ''
                and SNG010.NG_GRUPO = SN1010.N1_GRUPO
            left join SN3010 (nolock)
                on SN3010.D_E_L_E_T_ = ''
                and cast(SN3010.N3_TIPO as int) = 1
                and SN3010.N3_FILIAL = SN1010.N1_FILIAL
                and SN3010.N3_CBASE = SN1010.N1_CBASE
        where
                SN1010.D_E_L_E_T_ = ''
            and cast(SNG010.NG_TXDEPR1 as decimal) > 0
    ) DEPRECIACAO
        on (12 * (100 / DEPRECIACAO.TXDEPRECMENSAL)) > datediff(month, DEPRECIACAO.N3_DINDEPR, VIAGEM.DTQ_DATENC)
        and
        (
            DEPRECIACAO.N1_CODBEM = VIAGEM.DTR_CODVEI or
            DEPRECIACAO.N1_CODBEM = VIAGEM.DTR_CODRB1 or
            DEPRECIACAO.N1_CODBEM = VIAGEM.DTR_CODRB2 or
            DEPRECIACAO.N1_CODBEM = VIAGEM.DTR_CODRB3
        )
    
    left join /* ver amortização das taxas dos veículos */
    (
        select
            trim(isnull(TS1010.TS1_DTEMIS, '-')) as TS1_DTEMIS,
            trim(isnull(SE2010.E2_VENCREA, '-')) as TS1_DTVENC,
            TS1010.TS1_QTDPAR,
            SE2010.E2_PARCELA,
            TS1010.TS1_VALOR/TS1010.TS1_QTDPAR as VALPARC,
            TS1010.TS1_VALOR,

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
        on substring(DOCUMENTACAO.TS1_DTVENC, 1, 6) = substring(VIAGEM.DTQ_DATENC, 1, 6)
        and
        (
            DOCUMENTACAO.T9_CODBEM = VIAGEM.DTR_CODVEI or
            DOCUMENTACAO.T9_CODBEM = VIAGEM.DTR_CODRB1 or
            DOCUMENTACAO.T9_CODBEM = VIAGEM.DTR_CODRB2 or
            DOCUMENTACAO.T9_CODBEM = VIAGEM.DTR_CODRB3
        )
where DUD.DUD_VIAGEM in (7263, 7268, 7269, 7277, 7283, 7284, 7286, 7287, 7291, 7292, 7296, 7298, 7299, 7300, 7301, 7302, 7307, 7308, 7309, 7310, 7311, 7312, 7313, 7314, 7316, 7318, 7320, 7325, 7329, 7330, 7333, 7334, 7336, 7337, 7338, 7339, 7340, 7341, 7349, 7351, 7353, 7354, 7355, 7356, 7357, 7358, 7359, 7362, 7363, 7371, 7372, 7373, 7375, 7376, 7376, 7376, 7376, 7377, 7379, 7380, 7385, 7389, 7390, 7392, 7395, 7398, 7399, 7403, 7404, 7407, 7408, 7409, 7410, 7411, 7413, 7414, 7415, 7416, 7418, 7419, 7420, 7422, 7423, 7424, 7427, 7428, 7429, 7431, 7433, 7438, 7439, 7440, 7441, 7442, 7443, 7444, 7445, 7448, 7449, 7450, 7454, 7455, 7456, 7458, 7459, 7460, 7462, 7463, 7464, 7465, 7468, 7469, 7470, 7471, 7473, 7474, 7476, 7477, 7478, 7479, 7481, 7482, 7483, 7484, 7487, 7488, 7490, 7491, 7492, 7493, 7494, 7495, 7496, 7503, 7504, 7506, 7507, 7509, 7510, 7512, 7516, 7517, 7518, 7519, 7520, 7521, 7523, 7524, 7528, 7533, 7534, 7535, 7536, 7537, 7538, 7539, 7540, 7541, 7542, 7543, 7544, 7545, 7546, 7548, 7552, 7553, 7554, 7555, 7556, 7557, 7558, 7559, 7560, 7561, 7562, 7566, 7567, 7568, 7569, 7570, 7571, 7575, 7576, 7577, 7579, 7580, 7581, 7583, 7584, 7585, 7588, 7589, 7590, 7591, 7592, 7594, 7595, 7596, 7597, 7598, 7599, 7600, 7601, 7602, 7603, 7604, 7605, 7606, 7607, 7609, 7610, 7611, 7612, 7613, 7614, 7616, 7617, 7618, 7619, 7620, 7621, 7622, 7623, 7623, 7623, 7623, 7625, 7626, 7627, 7630, 7633, 7634, 7635, 7636, 7637, 7638, 7639, 7640, 7641, 7644, 7648, 7649, 7650, 7651, 7652, 7653, 7654, 7657, 7659, 7661, 7662, 7663, 7664, 7665, 7666, 7667, 7668, 7669, 7671, 7673, 7674, 7676, 7677, 7678, 7679, 7680, 7681, 7682, 7683, 7684, 7685, 7686, 7687, 7688, 7689, 7690, 7691, 7694, 7695, 7696, 7697, 7698, 7699, 7700, 7707, 7710, 7711, 7712, 7713, 7714, 7715, 7716, 7717, 7718, 7728, 7729, 7732, 7733, 7736, 7740, 7741, 7742, 7743, 7751, 7752, 7753, 7755, 7756, 7757, 7758, 7759, 7760, 7761, 7762, 7763, 7764, 7765, 7766, 7767, 7777, 7778, 7779, 7780, 7781, 7782, 7787, 7790, 7791, 7792, 7793, 7794, 7795, 7796, 7797, 7798, 7799, 7801, 7802, 7805, 7806, 7807, 7808, 7809, 7810, 7811, 7812, 7813, 7814, 7815, 7816, 7823, 7824, 7825, 7826, 7827, 7828, 7829, 7835, 7839, 7841, 7842, 7844, 7846, 7847, 7857, 7861, 7862, 7866, 7867, 7876, 7877, 7878, 7879, 7880, 7882, 7883, 7884, 7885, 7886, 7887, 7888, 7889, 7890, 7892, 7893, 7899, 7900, 7901, 7902, 7903, 7904, 7905, 7906, 7908, 7911, 7912, 7913, 7914, 7916, 7917, 7918, 7921, 7922, 7923, 7925, 7927, 7928, 7929, 7930, 7934, 7935, 7937, 7938, 7939, 7943, 7947, 7948, 7326, 7672, 7321)
    and DUD.D_E_L_E_T_ = ''
