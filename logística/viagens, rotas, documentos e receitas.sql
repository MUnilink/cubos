select
    DUD.DUD_FILORI as FILIAL,
    DUD.DUD_FILORI as FILORI,
    DUD.DUD_VIAGEM as VIAGEM,
    DA8.DA8_DESC as ROTA,

    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    left(DT6.DT6_DATEMI, 6) as PERIODO_CTE,
    cast(DT6.DT6_DATEMI as date) as DT6_DATEMI,

    trim(REG_COL.DUY_EST) as UF_COLETA,
	trim(REG_COL.DUY_DESCRI) as MUN_COLETA,
	trim(REG_ENT.DUY_EST) as UF_ENTREGA,
	trim(REG_ENT.DUY_DESCRI) as MUN_ENTREGA,

    trim(DUYORI.DUY_DESCRI) as ORIGEM,
    trim(DUYDES.DUY_DESCRI) as DESTINO,
    trim(DUYDEV.DUY_DESCRI) as DEVEDOR,
    trim(REM.A1_NOME) as CLI_ORIGEM,
    trim(DES.A1_NOME) as CLI_DESTINO,
    trim(DEV.A1_NOME) as CLI_DEVEDOR,
    trim(REM.A1_CEP) as CEP_ORIGEM,
    trim(DES.A1_CEP) as CEP_DESTINO,
    trim(DEV.A1_CEP) as CEP_DEVEDOR,
    
    cast(DTQ.DTQ_DATGER as date) as DT_GERVGA,
    cast(DTQ.DTQ_DATFEC as date) as DT_FECVGA,
    cast(DTQ.DTQ_DATENC as date) as DT_ENCVGA,

    left(DTQ.DTQ_DATGER, 1, 6) as PERIODO_GERVGA,
    left(DTQ.DTQ_DATFEC, 1, 6) as PERIODO_FECVGA,
    left(DTQ.DTQ_DATENC, 1, 6) as PERIODO_ENCVGA,

    case DTQ.DTQ_TIPVIA
        when '1' then upper('Normal')
        when '2' then upper('Vazia')
        when '3' then upper('Planejada')
        when '4' then upper('Socorro')
        when '5' then upper('Redespacho')
        else 'Outros'
    end as TIPO_VIAGEM,

    case DTQ.DTQ_STATUS
        when '1' then upper('Em Aberto')
        when '2' then upper('Em Transito')
        when '3' then upper('Encerrada')
        when '4' then upper('Chegada em Filial')
        when '5' then upper('Fechada')
        when '9' then upper('Cancelada')
        else 'Outros'
    end as STATUS_VGA,

    case DUD.DUD_STATUS
        when '1' then upper('Em Aberto')
        when '2' then upper('Em Transito')
        when '3' then upper('Carregado')
        when '4' then upper('Encerrado')
        when '9' then upper('Cancelado')
        else 'Outros'
    end as VINCULO_DOCVGA,

    case DT5.DT5_STATUS
        when '1' then upper('Em Aberto')
        when '2' then upper('Indicada para Coleta')
        when '3' then upper('Em Transito')
        when '4' then upper('Encerrada')
        when '5' then upper('Documento Informado')
        when '6' then upper('Bloqueada')
        when '7' then upper('Em Conferencia')
        when '9' then upper('Cancelada')
        else 'Outros'
    end as STATUS_COL,

    case when DT5.DT5_STATUS = '4' then 'INTERNA' else case when DT5.DT5_STATUS like '[0-9]' then 'COLETA' else 'ENTREGA' end end as TIPO_VGA,
    /* concat((DUA.DUA_FILVTR), (DUA.DUA_NUMVTR)) as VGATRA_OCOR, */

    trim(DTR.DTR_ITEM) as ITEM_COMPLEMENTO,
    trim(DUP.DUP_CODMOT) as COD_MOTORISTA,
    trim(DA4.DA4_MAT) as MAT_MOTORISTA,
    trim(DA4.DA4_NOME) as MOTORISTA,

    trim(DTR.DTR_CODVEI) as FROTA_CM,
    trim(DTR.DTR_CODRB1) as FROTA_RB1,
    trim(DTR.DTR_CODRB2) as FROTA_RB2,
    trim(DTR.DTR_CODRB3) as FROTA_RB3,
    (select trim(DA3010.DA3_PLACA) from DA3010 where DA3010.DA3_COD = DTR.DTR_CODVEI) as PLACA_CM,
    (select trim(DA3010.DA3_PLACA) from DA3010 where DA3010.DA3_COD = DTR.DTR_CODRB1) as PLACA_RB1,
    (select trim(DA3010.DA3_PLACA) from DA3010 where DA3010.DA3_COD = DTR.DTR_CODRB2) as PLACA_RB2,
    (select trim(DA3010.DA3_PLACA) from DA3010 where DA3010.DA3_COD = DTR.DTR_CODRB3) as PLACA_RB3,

    trim(DTR.DTR_CIOT) as CIOT,
    case DTR.DTR_TPCIOT when 1 then 'LOTACAO' when 2 then 'FRACIONADA' else 'outros' end as CIOT_TIPO,
    cast(DTR.DTR_DTFMCI as date) as CIOT_DATAENC,

    trim(DT3.DT3_CODPAS) as TIPO_COMPONENTE,
    trim(DT3.DT3_DESCRI) as DESC_COMPONENTE,
    cast(DT8.DT8_VALPAS as decimal(14, 2)) as VALOR_COMPONENTE,
    cast(DT8.DT8_VALIMP as decimal(14, 2)) as VALOR_IMPOSTO,
    cast(DT8.DT8_VALTOT as decimal(14, 2)) as VALOR_TOTAL,

    cast(DT6.DT6_VALFRE as decimal(14, 2)) as CTE_TOTAL,
    cast(DT6.DT6_VALIMP as decimal(14, 2)) as CTE_IMPOSTO,
    cast(DT6.DT6_VALMER as decimal(14, 2)) as VALOR_MERCADORIA,

    DTC.DTC_CTRDPC as CTE_CLIENTE,
    DTC.DTC_FILORI,
    DTC.DTC_DOC,
    DTC.DTC_SERIE,
    DTC.DTC_NUMNFC,
    DTC.DTC_SERNFC,
    DTC.DTC_CODPRO,
    DTC.DTC_VALOR,
    DTC.DTC_PESO,
    DTC.DTC_PESLIQ,
    trim(SB1.B1_DESC) as NFCLI_PRODUTO,

    DT5.DT5_NUMSOL,
    DT5.DT5_DOC,
    DT5.DT5_SERIE,
    DT5.DT5_STATUS,
    DT5.DT5_TIPCOL,
    DT5.DT5_CODSOL,
    DT5.DT5_CODOBC,
    
    cast(DF1.DF1_DATCON as date) as DT_AGE,
    left(DF1.DF1_DATCON, 6) as PERIODO_AGE,
    datetimefromparts(year(DF1.DF1_YDTCON), month(DF1.DF1_YDTCON), day(DF1.DF1_YDTCON), substring(DF1.DF1_YHRCON, 1, 2), substring(DF1.DF1_YHRCON, 4, 5), 0, 0) as DATA_CONTEINER,
    DF1.DF1_NUMAGE as AGENDAMENTO,
    DF1.DF1_ITEAGE as ITEM_AGENDA,
    DF1.DF1_YDSPOR as PORTO,
    DF1.DF1_YDIBOO as BOOKING,
    DF1.DF1_YOSCLI as OS_CLIENTE,
    DF1.DF1_YNAVIO as NAVIO,
    DF1.DF1_YDSNAV as NOME_NAVIO,
    DF1.DF1_YVIAGE as VIAGEM_PORT,
    DF1.DF1_YCONT as CONTEINER,
    DF1.DF1_YLACRE as LACRE,
    DF1.DF1_YARMAD as ARMADORA,
    DF1.DF1_YLJARM as LOJA_ARMADORA,
    DF1.DF1_CODOBC,
    DF1.DF1_YDSARM as NOME_ARMADORA,

    COMP.D2_DOC as COMP_DOC,
    COMP.D2_SERIE as COMP_SERIE,
    COMP.D2_TOTAL as COMP_TOTAL,
    COMP.D2_VALIPI as COMP_VALIPI,
    COMP.D2_VALICM as COMP_VALICM,
    cast(COMP.D2_EMISSAO as date) as COMP_EMISSAO,

    SC5.C5_NUM as RPS_PEDIDO,
    RPS.D2_DOC as RPS_DOC,
    RPS.D2_SERIE as RPS_SERIE,
    RPS.D2_TOTAL as RPS_TOTAL,
    RPS.D2_VALIPI as RPS_VALIPI,
    RPS.D2_VALICM as RPS_VALICM,
    cast(RPS.D2_EMISSAO as date) as RPS_EMISSAO,

    SE1.E1_NUM as ND_TITULO,
    SE1.E1_VALOR as ND_VALOR,
    SE1.E1_EMISSAO as ND_EMISSAO,

    (
        select substring(DTW010.DTW_DATREA, 1, 6)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILIAL = DUD.DUD_FILIAL
            and DTW010.DTW_FILORI = DUD.DUD_FILORI
            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
            and DTW010.DTW_ATIVID = '050'
    ) as COMPETENCIA_INIVGA,
    (
        select substring(DTW010.DTW_DATREA, 1, 6)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILIAL = DUD.DUD_FILIAL
            and DTW010.DTW_FILORI = DUD.DUD_FILORI
            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
            and DTW010.DTW_ATIVID = '050'
    ) as COMPETENCIA_FIMVGA,
    (
        select convert(datetime, concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00')), 113)
        from DTW010
        where
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DUD.DUD_FILORI
            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
            and DTW010.DTW_HORREA != ''
            and DTW010.DTW_DATREA != ''
            and DTW010.DTW_ATIVID = '049'
    ) as DATAINI,
    (
        select convert(datetime, concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00')), 113)
        from DTW010
        where
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DUD.DUD_FILORI
            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
            and DTW010.DTW_HORREA != ''
            and DTW010.DTW_DATREA != ''
            and DTW010.DTW_ATIVID = '050'
    ) as DATAFIM,
    (
        select top 1 convert(datetime, first_value(concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))) over (partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN), 113)
        from DTW010
        where
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DUD.DUD_FILORI
            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
            and DTW010.DTW_HORREA != ''
            and DTW010.DTW_DATREA != ''
            and DTW010.DTW_ATIVID = '057' /*58 PONTO DE APOIO*/
            and DTW010.DTW_CODCLI != '000761'
    ) as DATA_CHECLI,
    (
        select top 1 convert(datetime, first_value(concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))) over (partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN), 113)
        from DTW010
        where
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DUD.DUD_FILORI
            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
            and DTW010.DTW_HORREA != ''
            and DTW010.DTW_DATREA != ''
            and DTW010.DTW_ATIVID = '056' /*58 PONTO DE APOIO*/
            and DTW010.DTW_CODCLI != '000761'
    ) as DATA_SAICLI,

/*
    OPERAÇÕES
    01 – INICIO DE VIAGEM
    05 – CHEGADA NO CLIENTE
    06 - SAIDA DO CLIENTE
    09 – CHEGADA NO PORTO - no TMS essa macro é apontada como chegada de cliente {porto}
    10 – SAIDA DO PORTO - no TMS essa macro é apontada como saída de cliente {porto}
    07 – FIM DE VIAGEM

    OCORRÊNCIA
    17 – ENTREGA EFETUADA
*/

    cast
    (
        (
            select
                coalesce
                (
                    (
                        select top 1 nullif(substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT)), '')
                        from ZB1010 (nolock)
                        where
                                ZB1010.D_E_L_E_T_ = ''
                            and ZB1010.ZB1_STATUS = 'OK'
                            and
                                dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                                =
                                datetimefromparts(year(APT.DTW_DATREA), month(APT.DTW_DATREA), day(APT.DTW_DATREA), substring(APT.DTW_HORREA, 1, 2), substring(APT.DTW_HORREA, 3, 4), 0, 0)
                            and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                            and ZB1010.ZB1_MACRON = 7
                            and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
                    ),
                    nullif(APT.DTW_YHODFI, ''),
                    0
                )
            from DTW010 APT (nolock)
            where
                    APT.D_E_L_E_T_ = ''
                and APT.DTW_FILORI = DTR.DTR_FILORI
                and APT.DTW_VIAGEM = DTR.DTR_VIAGEM
                and APT.DTW_ATIVID = 50
        ) as numeric(15, 2)
    ) as km_fim,
    cast
    (
        (
            select
                coalesce
                (
                    (
                        select top 1 nullif(substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT)), '')
                        from ZB1010 (nolock)
                        where
                                ZB1010.D_E_L_E_T_ = ''
                            and ZB1010.ZB1_STATUS = 'OK'
                            and
                                dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                                =
                                datetimefromparts(year(APT.DTW_DATREA), month(APT.DTW_DATREA), day(APT.DTW_DATREA), substring(APT.DTW_HORREA, 1, 2), substring(APT.DTW_HORREA, 3, 4), 0, 0)
                            and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                            and ZB1010.ZB1_MACRON = 1
                            and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
                    ),
                    nullif(APT.DTW_YHODIN, ''),
                    0
                )
            from DTW010 APT (nolock)
            where
                    APT.D_E_L_E_T_ = ''
                and APT.DTW_FILORI = DTR.DTR_FILORI
                and APT.DTW_VIAGEM = DTR.DTR_VIAGEM
                and APT.DTW_ATIVID = 49
        ) as numeric(15, 2)
    ) as km_ini,
    DTQ.DTQ_KMVGE as km_ROTA

from DUD010 DUD (nolock)
    left join DTQ010 DTQ (nolock)
        on DTQ.D_E_L_E_T_ = ''
        and DTQ.DTQ_FILORI = DUD.DUD_FILORI
        and DTQ.DTQ_VIAGEM = DUD.DUD_VIAGEM
        
        inner join DA8010 DA8 (nolock)
            on DA8.D_E_L_E_T_ = ''
            and DA8.DA8_COD = DTQ.DTQ_ROTA
    
        inner join DTR010 DTR (nolock)
            on DTR.D_E_L_E_T_ = ''
            and DTR.DTR_FILORI = DTQ.DTQ_FILORI
            and DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM

            inner join DUP010 DUP (nolock)
                on DUP.D_E_L_E_T_ = ''
                and DUP.DUP_FILORI = DTR.DTR_FILORI
                and DUP.DUP_VIAGEM = DTR.DTR_VIAGEM
                and DUP.DUP_ITEDTR = DTR.DTR_ITEM
                and DUP.DUP_CODVEI = DTR.DTR_CODVEI

                inner join DA4010 DA4 (nolock)
                    on DA4.DA4_COD = DUP.DUP_CODMOT

    left join DT5010 DT5 (nolock)
        on DT5.D_E_L_E_T_ = ''
        and DT5.DT5_FILDOC = DUD.DUD_FILDOC
        and DT5.DT5_NUMSOL = DUD.DUD_DOC
        and DUD.DUD_SERIE = 'COL'

        left join DF1010 DF1 (nolock)
            on DF1.D_E_L_E_T_ = ''
            and DF1.DF1_FILDOC = DT5.DT5_FILORI
            and DF1.DF1_DOC = DT5.DT5_DOC
            and DF1.DF1_SERIE = DT5.DT5_SERIE

    left join DT6010 DT6 (nolock)
        on DT6.D_E_L_E_T_ = ''
        and DT6.DT6_FILDOC = DUD.DUD_FILDOC
        and DT6.DT6_DOC = DUD.DUD_DOC
        and DT6.DT6_SERIE = DUD.DUD_SERIE
        
        left join DT8010 DT8
            on DT8.D_E_L_E_T_ = ' '
            and DT8.DT8_FILIAL = DT6.DT6_FILIAL
            and DT8.DT8_FILDOC = DT6.DT6_FILDOC
            and DT8.DT8_DOC = DT6.DT6_DOC
            and DT8.DT8_SERIE = DT6.DT6_SERIE
            and DT6.DT6_SERIE <> 'COL'
            and DT6.DT6_SERIE <> 'PED'

            left join DT3010 DT3
                on DT3.DT3_FILIAL = DT8.DT8_FILIAL
                and DT3.DT3_CODPAS = DT8.DT8_CODPAS
                and DT3.D_E_L_E_T_ = ' '

        left join SA1010 DEV (nolock)
            on DEV.A1_FILIAL = '      '
            and DEV.A1_COD = DT6.DT6_CLIDEV
            and DEV.A1_LOJA = DT6.DT6_LOJDEV
            and DEV.D_E_L_E_T_ = ' '
        left join SA1010 REM
            ON REM.A1_FILIAL = '      '
            AND REM.A1_COD = DT6.DT6_CLIREM
            AND REM.A1_LOJA = DT6.DT6_LOJREM
            AND REM.D_E_L_E_T_ = ' '
        left join SA1010 DES
            ON DES.A1_FILIAL = '      '
            AND DES.A1_COD = DT6.DT6_CLIDES
            AND DES.A1_LOJA = DT6.DT6_LOJDES
            AND DES.D_E_L_E_T_ = ' '
        left join SD2010 COMP (nolock)
            on COMP.D_E_L_E_T_ = ''
            and COMP.D2_NFORI = DT6.DT6_DOC
            and COMP.D2_SERIORI = DT6.DT6_SERIE
            and COMP.D2_CLIENTE = DT6.DT6_CLIDEV
            and COMP.D2_LOJA = DT6.DT6_LOJDEV

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
    
    left join DUY010 REG_COL (nolock)
        ON REG_COL.D_E_L_E_T_ = ' '
        and REG_COL.DUY_FILIAL = DT6.DT6_FILIAL
        and REG_COL.DUY_GRPVEN = DT6.DT6_CDRORI
    left join DUY010 REG_ENT (nolock)
        ON REG_ENT.D_E_L_E_T_ = ' '
        and REG_ENT.DUY_FILIAL = DT6.DT6_FILIAL
        and REG_ENT.DUY_GRPVEN = DT6.DT6_CDRCAL
    left join DTC010 DTC (nolock)
        on DTC.D_E_L_E_T_ = ''
        and DTC.DTC_FILDOC = DT6.DT6_FILDOC
        and DTC.DTC_DOC = DT6.DT6_DOC
        and DTC.DTC_SERIE = DT6.DT6_SERIE

        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = DTC.DTC_CODPRO
    
    left join SC5010 SC5 (nolock)
        on SC5.D_E_L_E_T_ = ''
        and SC5.C5_YVIAGEM = DUD.DUD_VIAGEM

        left join SD2010 RPS (nolock)
            on RPS.D_E_L_E_T_ = ''
            and RPS.D2_FILIAL = SC5.C5_FILIAL
            and RPS.D2_DOC = SC5.C5_NOTA
            and RPS.D2_SERIE = SC5.C5_SERIE
            and RPS.D2_CLIENTE = SC5.C5_CLIENTE
            and RPS.D2_LOJA = SC5.C5_LOJACLI
    
    left join SE1010 SE1 (nolock)
        on SE1.D_E_L_E_T_ = ''
        and (SE1.E1_YVIATMS = DUD.DUD_VIAGEM or SE1.E1_YVIAGEM = DUD.DUD_VIAGEM)
where DUD.D_E_L_E_T_ = ''
