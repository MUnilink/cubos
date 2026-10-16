select
    VIAGEM.CHE_CLIDEV_REAL,
    VIAGEM.SAI_CLIDEV_REAL,
    VIAGEM.SAI_VIAGEM_REAL,
    VIAGEM.CHE_VIAGEM_REAL,

    DF1.ID_AGENDAMENTO,
    VIAGEM.ID_VIAGEM,
    VIAGEM.ID_VEICULO_CM,
    VIAGEM.ID_VEICULO_RB1,
    VIAGEM.ID_VEICULO_RB2,
    VIAGEM.ID_VEICULO_RB3,
    VIAGEM.ID_MOTORISTA,
    VIAGEM.ID_ROTA,

    concat(DYV.DYV_FILIAL, DYV.DYV_IDCDIA) as ID_DIARIA,
    DYV.DYV_IDCDIA as DIARIA,
    DYX.DYX_DATDIA as DATA_DIARIA,
    DYX.DYX_DATAPR as DATA_APROVA,
    DYX.DYX_ITEM as ITEM,
    
    cast(DYX.DYX_QTDE as int) as QTD,
    cast(DYX.DYX_VLRUNI as numeric(15, 2)) as VALOR_UNI,
    trim(upper(TP_DIA.X5_DESCRI)) as TIPO_DIARIA,
    case DYX.DYX_STATUS
        when 1 then upper('Pendente sem Restricao')
        when 2 then upper('Pendente com Restricao')
        when 3 then upper('Aprovada')
        when 4 then upper('Reprovada')
        when 5 then upper('Cancelada')
    else 'OUTROS' end as STATUS_DIARIA,
    upper(trim(SYS_USR.USR_CODIGO)) as LIBERADA_POR,

    trim(SE2.E2_NUM) as TITULO,
    cast(SE2.E2_VALOR as numeric(15, 2)) as VL_TITULO,
    cast(SE2.E2_VALLIQ as numeric(15, 2)) as VL_LIQUIDO,
    trim(SE2.E2_ORIGEM) as ORIGEM,
    SE2.E2_EMISSAO as DT_TITULO,
	SE2.E2_VENCTO as DT_VENCIMENTO,
	SE2.E2_VENCREA as DT_VENCREAL,
	SE2.E2_BAIXA as DT_BAIXA,
    upper(trim(SE2.E2_HIST)) as HISTORICO

from DYX010 DYX
    left join SE2010 SE2
        on SE2.D_E_L_E_T_ = ''
        and SE2.E2_PREFIXO = DYX.DYX_PRETIT
        and SE2.E2_NUM = DYX.DYX_NUMTIT
    left join SX5010 TP_DIA
        on TP_DIA.D_E_L_E_T_ = ''
        and TP_DIA.X5_TABELA = 'MS'
        and TP_DIA.X5_CHAVE = DYX.DYX_TIPVAL
    left join SYS_USR
        on SYS_USR.D_E_L_E_T_ = ''
        and SYS_USR.USR_ID = DYX.DYX_USRAPR

    inner join DYV010 DYV
        on DYV.D_E_L_E_T_ = ''
        and DYV.DYV_IDCDIA = DYX.DYX_IDCDIA

        inner join DA4010 DA4
            on DA4.D_E_L_E_T_ = ''
            and DA4.DA4_COD = DYV.DYV_CODMOT
        
        left join
        (
            select
                concat(trim(DA8010.DA8_FILIAL), trim(DA8010.DA8_COD)) as ID_ROTA,
                DA4010.DA4_COD,
                DTR.DTR_CODVEI,
                DTR.DTR_CODRB1,
                DTR.DTR_CODRB2,
                DTR.DTR_CODRB3,

                concat(trim(DUD.DUD_FILDOC), trim(DUD.DUD_VIAGEM)) as ID_VIAGEM,
                trim(DA4010.DA4_COD) as ID_MOTORISTA,
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODVEI) as ID_VEICULO_CM,
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB1) as ID_VEICULO_RB1,
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB2) as ID_VEICULO_RB2,
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB3) as ID_VEICULO_RB3,

                (
                    select top 1 first_value(concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))) over (partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
                    from DTW010
                    where
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DUD.DUD_FILORI
                        and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                        and DTW010.DTW_HORREA != ''
                        and DTW010.DTW_DATREA != ''
                        and DTW010.DTW_ATIVID = '057' /*58 PONTO DE APOIO*/
                        and DTW010.DTW_CODCLI != '000761'
                ) as CHE_CLIDEV_REAL,
                (
                    select top 1 first_value(concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))) over (partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
                    from DTW010
                    where
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DUD.DUD_FILORI
                        and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                        and DTW010.DTW_HORREA != ''
                        and DTW010.DTW_DATREA != ''
                        and DTW010.DTW_ATIVID = '056' /*58 PONTO DE APOIO*/
                        and DTW010.DTW_CODCLI != '000761'
                ) as SAI_CLIDEV_REAL,

                (
                    select concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))
                    from DTW010
                    where
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DUD.DUD_FILORI
                        and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                        and DTW010.DTW_HORREA != ''
                        and DTW010.DTW_DATREA != ''
                        and DTW010.DTW_ATIVID = '049'
                ) as SAI_VIAGEM_REAL,
                (
                    select concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))
                    from DTW010
                    where
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DUD.DUD_FILORI
                        and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                        and DTW010.DTW_HORREA != ''
                        and DTW010.DTW_DATREA != ''
                        and DTW010.DTW_ATIVID = '050'
                ) as CHE_VIAGEM_REAL,
                
                DUD.DUD_FILIAL,
                DUD.DUD_FILORI,
                DUD.DUD_FILDOC,
                DUD.DUD_DOC,
                DUD.DUD_SERIE,
                DUD.DUD_VIAGEM

            from DUD010 DUD
                left join DTR010 DTR
                    on DTR.D_E_L_E_T_ = ''
                    and DTR.DTR_FILIAL = DUD.DUD_FILIAL
                    and DTR.DTR_FILORI = DUD.DUD_FILORI
                    and DTR.DTR_VIAGEM = DUD.DUD_VIAGEM
                    
                    left join DUP010
                        on DUP010.D_E_L_E_T_ = ''
                        and DUP010.DUP_FILORI = DTR.DTR_FILORI
                        and DUP010.DUP_VIAGEM = DTR.DTR_VIAGEM
                        and DUP010.DUP_ITEDTR = DTR.DTR_ITEM
                        and DUP010.DUP_CODVEI = DTR.DTR_CODVEI

                        left join DA4010
                            on DA4010.D_E_L_E_T_ = ''
                            and DA4010.DA4_COD = DUP010.DUP_CODMOT
                
                left join DTQ010
                    on DTQ010.D_E_L_E_T_ = ''
                    and DTQ010.DTQ_FILIAL = DUD.DUD_FILIAL
                    and DTQ010.DTQ_FILORI = DUD.DUD_FILORI
                    and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM
                    
                    left join DA8010
                        on DA8010.D_E_L_E_T_ = ''
                        and DA8010.DA8_COD = DTQ010.DTQ_ROTA
            where DUD.D_E_L_E_T_ = ''
        ) VIAGEM
            on VIAGEM.DUD_FILIAL = DYV.DYV_FILIAL
            and VIAGEM.DUD_FILORI = DYV.DYV_FILORI
            and VIAGEM.DUD_VIAGEM = DYV.DYV_VIAGEM
            
            left join
            (
                select
                    concat(trim(DF1010.DF1_FILIAL), trim(DF1010.DF1_NUMAGE), trim(DF1010.DF1_ITEAGE), trim(DF1010.DF1_FILDOC), trim(DF1010.DF1_DOC), trim(DF1010.DF1_SERIE)) as ID_AGENDAMENTO,
                    DF1010.DF1_NUMAGE,
                    DF1010.DF1_ITEAGE,
                    DF1010.DF1_YOSCLI,
                    DF1010.DF1_FILDOC,
                    DF1010.DF1_DOC,
                    DF1010.DF1_SERIE,
                    DTC010.DTC_FILDOC,
                    DTC010.DTC_DOC,
                    DTC010.DTC_SERIE,
                    concat(DF1010.DF1_DATPRC, DF1010.DF1_HORPRC) as PREV_COL,
                    concat(DF1010.DF1_DATPRE, DF1010.DF1_HORPRE) as PREV_ENT,
                    coalesce
                    (
                        concat(DF1010.DF1_DATPRC, ' ', nullif(trim(concat(substring(DF1010.DF1_HORPRC, 1, 2), ':', substring(DF1010.DF1_HORPRC, 3, 2), ':', substring(DF1010.DF1_HORPRC, 5, 2), '00')), ':  :00')),
                        concat(DF1010.DF1_DATPRE, ' ', nullif(trim(concat(substring(DF1010.DF1_HORPRE, 1, 2), ':', substring(DF1010.DF1_HORPRE, 3, 2), ':', substring(DF1010.DF1_HORPRE, 5, 2), '00')), ':  :00'))
                    ) as CHE_CLIDEV_PREV,

                    /* RM */
                    DTC010.DTC_NUMNFC,
                    DTC010.DTC_SERNFC

                from DF1010
                    inner join DTC010
                        on DTC010.D_E_L_E_T_ = ''
                        and DTC010.DTC_FILDOC = DF1010.DF1_FILDOC
                        and DTC010.DTC_NUMSOL = DF1010.DF1_DOC
                where DF1010.D_E_L_E_T_ = ''
            ) DF1
                on DF1.DTC_FILDOC = VIAGEM.DUD_FILDOC
                and DF1.DTC_DOC = VIAGEM.DUD_DOC
                and DF1.DTC_SERIE = VIAGEM.DUD_SERIE

where DYX.D_E_L_E_T_ = ''
