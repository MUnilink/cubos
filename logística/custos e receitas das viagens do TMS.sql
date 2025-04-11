select
    VIAGEM.*,    
    trim(DUYDEV.DUY_DESCRI) as DEVEDOR,
    trim(DEV.A1_COD) as DEV_COD,
    trim(DEV.A1_LOJA) as DEV_LOJA,
    trim(DEV.A1_NOME) as CLI_DEVEDOR,
    
    trim(DUYORI.DUY_DESCRI) as ORIGEM,
    trim(REM.A1_COD) as REM_COD,
    trim(REM.A1_LOJA) as REM_LOJA,
    trim(REM.A1_NOME) as CLI_ORIGEM,
    
    trim(DUYDES.DUY_DESCRI) as DESTINO,
    trim(DES.A1_COD) as DES_COD,
    trim(DES.A1_LOJA) as DES_LOJA,
    trim(DES.A1_NOME) as CLI_DESTINO,

    DT6.DT6_DOC CTE_DOC,
    DT6.DT6_SERIE CTE_SERIE,
    left(DT6.DT6_DATEMI, 6) as PERIODO_CTE,
    cast(DT6.DT6_DATEMI as date) as DATA_CTE,

    DT6.DT6_VALFRE/
    (
        isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DUD.DUD_VIAGEM), 1)
        *
        isnull
        (
            (
                select nullif(count(DTC010.DTC_NUMNFC), '')
                from DTC010 (nolock)
                where
                        DTC010.D_E_L_E_T_ = ''
                    and DTC010.DTC_FILDOC = DT6.DT6_FILDOC
                    and DTC010.DTC_DOC = DT6.DT6_DOC
                    and DTC010.DTC_SERIE = DT6.DT6_SERIE
            ), 1
        )
    ) as CTE_RAT,

    COMP.D2_TOTAL/
    (
        isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DUD.DUD_VIAGEM), 1)
        *
        isnull
        (
            (
                select nullif(count(DTC010.DTC_NUMNFC), '')
                from DTC010 (nolock)
                where
                        DTC010.D_E_L_E_T_ = ''
                    and DTC010.DTC_FILDOC = DT6.DT6_FILDOC
                    and DTC010.DTC_DOC = DT6.DT6_DOC
                    and DTC010.DTC_SERIE = DT6.DT6_SERIE
            ), 1
        )
    ) as COMP_RAT,

    RPS.D2_TOTAL/
    (
        isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DUD.DUD_VIAGEM), 1)
        *
        isnull
        (
            (
                select nullif(count(DTC010.DTC_NUMNFC), '')
                from DTC010 (nolock)
                where
                        DTC010.D_E_L_E_T_ = ''
                    and DTC010.DTC_FILDOC = DT6.DT6_FILDOC
                    and DTC010.DTC_DOC = DT6.DT6_DOC
                    and DTC010.DTC_SERIE = DT6.DT6_SERIE
            ), 1
        )
    ) as RPS_RAT,

    SE1.E1_VALOR/
    (
        isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DUD.DUD_VIAGEM), 1)
        *
        isnull
        (
            (
                select nullif(count(DTC010.DTC_NUMNFC), '')
                from DTC010 (nolock)
                where
                        DTC010.D_E_L_E_T_ = ''
                    and DTC010.DTC_FILDOC = DT6.DT6_FILDOC
                    and DTC010.DTC_DOC = DT6.DT6_DOC
                    and DTC010.DTC_SERIE = DT6.DT6_SERIE
            ), 1
        )
    ) as ND_RAT,

    DT6.DT6_VALFRE as CTE_TOTAL,
    DT6.DT6_VALIMP / isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DUD.DUD_VIAGEM), 1) as IMPOSTO_CM,
    DT6.DT6_VALIMP as IMPOSTO_TOTAL,
    DT6.DT6_VALTOT,
    DT6.DT6_VALMER,

    case when DT5.DT5_STATUS = '4' then 'INTERNA' else case when DT5.DT5_STATUS like '[0-9]' then 'COLETA' else 'ENTREGA' end end as STATUS,

    DT5.DT5_NUMSOL,
    DT5.DT5_DOC,
    DT5.DT5_SERIE,
    DT5.DT5_STATUS,
    DT5.DT5_TIPCOL,
    DT5.DT5_CODSOL,
    DT5.DT5_CODOBC,
    
    cast(DF1.DF1_DATCON as date) as DT_AGE,
    substring(DF1.DF1_DATCON, 1, 6) as PERIODO_AGE,
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
    datetimefromparts(year(DF1.DF1_YDTCON), month(DF1.DF1_YDTCON), day(DF1.DF1_YDTCON), substring(DF1.DF1_YHRCON, 1, 2), substring(DF1.DF1_YHRCON, 4, 5), 0, 0) as DATA_CONTEINER,
    DF1.DF1_YARMAD as ARMADORA,
    DF1.DF1_YLJARM as LOJA_ARMADORA,
    DF1.DF1_CODOBC,
    DF1.DF1_YDSARM as NOME_ARMADORA,

    COMP.D2_DOC as DOCOMP_DOC,
    COMP.D2_SERIE as DOCOMP_SERIE,
    COMP.D2_TOTAL as DOCOMP_TOTAL,
    COMP.D2_VALIPI as DOCOMP_VALIPI,
    COMP.D2_VALICM as DOCOMP_VALICM,
    cast(COMP.D2_EMISSAO as date) as DOCOMP_EMISSAO,

    SC5.C5_NUM as RPS_PEDIDO,
    RPS.D2_DOC as RPS_DOC,
    RPS.D2_SERIE as RPS_SERIE,
    RPS.D2_TOTAL as RPS_TOTAL,
    RPS.D2_VALIPI as RPS_VALIPI,
    RPS.D2_VALICM as RPS_VALICM,
    cast(RPS.D2_EMISSAO as date) as RPS_EMISSAO,

    SE1.E1_NUM as ND_TITULO,
    SE1.E1_VALOR as ND_VALOR,
    cast(SE1.E1_EMISSAO as date) as ND_EMISSAO,

    cast(VIAGEM.DTQ_DATGER as date) as DT_GERVGA,
    cast(VIAGEM.DTQ_DATFEC as date) as DT_FECVGA,
    cast(VIAGEM.DTQ_DATENC as date) as DT_ENCVGA,
    left(VIAGEM.DTQ_DATGER, 6) as PERIODO_GERVGA,
    left(VIAGEM.DTQ_DATFEC, 6) as PERIODO_FECVGA,
    left(VIAGEM.DTQ_DATENC, 6) as PERIODO_ENCVGA,

    (
        select datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
        from DTW010 (nolock)
        where
                DTW010.D_E_L_E_T_ = ''
            and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and DTW010.DTW_ATIVID = 49
    ) as DATAINI,
    (
        select datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
        from DTW010 (nolock)
        where
                DTW010.D_E_L_E_T_ = ''
            and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as DATAFIM,
    (
        select left(DTW010.DTW_DATREA, 6)
        from DTW010 (nolock)
        where
                DTW010.D_E_L_E_T_ = ''
            and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as COMPETENCIA,

    ZE4.ZE4_TOTHR as VGA_HORAS,
    ZE4.ZE4_STATUS as STATUS_TMS,
    ZE4.ZE4_KMINI as km_ini,
    ZE4.ZE4_KMFIM as km_fim,
    ZE4.ZE4_KMFIM - ZE4.ZE4_KMINI as km_VIAGEM,
    ZE5.ZE5_ITENS as ITEM_CAB,
    
    trim(ZE1.ZE1_COD) as VGA_CODIGO,
    cast(ZE1.ZE1_TOTAL as numeric(15, 2)) as VGA_VALOR,
    cast(ZE1.ZE1_DATA as date) as VGA_DATA,
    left(ZE1.ZE1_COMPET, 6) as VGA_PERIODO,

    ZE1.ZE1_ITEM as VGA_ITEM,
    ZE1.ZE1_TIPO as VGA_TIPO,
    case ZE1.ZE1_TIPO
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
        when 17 then 'DIÁRIA'
        else 'OUTROS'
    end as TIPO_ITEM,

    case
        when ZE1.ZE1_TIPO in (1, 4, 5, 11) then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO in (1, 4, 5, 11))
        when ZE1.ZE1_TIPO in (2, 14, 15) then (select trim(SQ3010.Q3_DESCSUM) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and SQ3010.Q3_CARGO = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO in (2, 14))
        when ZE1.ZE1_TIPO in (3, 6, 9, 10, 12, 13, 16) then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO in (3, 6, 9, 10, 12, 13, 16))
        when ZE1.ZE1_TIPO = 7 then (select trim(ZA7010.ZA7_DESC) from ZA7010 (nolock) where ZA7010.D_E_L_E_T_ = '' and trim(ZA7010.ZA7_COD) = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO = 7)
    else null end as DESC_RECURSO

from ZE1010 ZE1 (nolock)
    inner join ZE4010 ZE4 (nolock)
        on ZE4.D_E_L_E_T_ = ''
        and ZE4.ZE4_FILIAL = ZE1.ZE1_FILIAL
        and ZE4.ZE4_VIAGEM = ZE1.ZE1_NUM

    left join DUD010 DUD (nolock)
        on DUD.D_E_L_E_T_ = ''
        and DUD.DUD_FILORI = ZE1.ZE1_FILIAL
        and DUD.DUD_VIAGEM = ZE1.ZE1_NUM
        
        left join
        (
            select
                DTQ.DTQ_FILIAL as FILIAL,
                DTQ.DTQ_FILORI as FILORI,
                DTQ.DTQ_VIAGEM as VIAGEM,
                DTQ.DTQ_DATGER,
                DTQ.DTQ_DATFEC,
                DTQ.DTQ_DATENC,
                trim(DA8010.DA8_DESC) as ROTA,

                case DTQ.DTQ_STATUS
                    when '1' then 'EXCLUÍDA'
                    when '2' then 'EM TRANSITO'
                    when '3' then 'ENCERRADA'
                    when '4' then 'CHEGADA EM FILIAL'
                    when '5' then 'FECHADA'
                    when '9' then 'CANCELADA'
                    else 'OUTROS'
                end as STATUS_VGA,
                
                concat(trim(DTQ.DTQ_FILORI), trim(DTQ.DTQ_VIAGEM)) as ID_VIAGEM,
                trim(DA4010.DA4_COD) as ID_MOTORISTA,
                trim(DA4010.DA4_NOME) as MOTORISTA,
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODVEI) as ID_VEICULO_CM,
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB1) as ID_VEICULO_RB1,
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB2) as ID_VEICULO_RB2,
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB3) as ID_VEICULO_RB3,
                DTR.DTR_ITEM as ITEM
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
                
                left join DA8010 (nolock)
                    on DA8010.D_E_L_E_T_ = ''
                    and DA8010.DA8_COD = DTQ.DTQ_ROTA
            where DTQ.D_E_L_E_T_ = ''
        ) VIAGEM
            on DUD.DUD_FILIAL = VIAGEM.FILIAL
            and DUD.DUD_FILORI = VIAGEM.FILORI
            and DUD.DUD_VIAGEM = VIAGEM.VIAGEM

            inner join ZE5010 ZE5 (nolock)
                on ZE5.D_E_L_E_T_ = ''
                and concat(ZE5.ZE5_FILIAL, ZE5.ZE5_VIAGEM) = VIAGEM.ID_VIAGEM
                and ZE5.ZE5_MOTORI = VIAGEM.ID_MOTORISTA
                and ZE5.ZE5_BEMCAV = VIAGEM.ID_VEICULO_CM
                and ZE5.ZE5_ITENS = VIAGEM.ITEM

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

            left join SD2010 COMP (nolock)
                on COMP.D_E_L_E_T_ = ''
                and COMP.D2_NFORI = DT6.DT6_DOC
                and COMP.D2_SERIORI = DT6.DT6_SERIE
                and COMP.D2_CLIENTE = DT6.DT6_CLIDEV
                and COMP.D2_LOJA = DT6.DT6_LOJDEV
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

        LEFT JOIN DUY010 DUYORI
            ON DUYORI.DUY_FILIAL = DT6.DT6_FILIAL
            AND DUYORI.DUY_GRPVEN = DT6.DT6_CDRORI
            AND DUYORI.D_E_L_E_T_ = ' '
        LEFT JOIN DUY010 DUYDES
            ON DUYDES.DUY_FILIAL = DT6.DT6_FILIAL
            AND DUYDES.DUY_GRPVEN = DT6.DT6_CDRDES
            AND DUYDES.D_E_L_E_T_ = ' '
        LEFT JOIN DUY010 DUYDEV
            ON DUYDEV.DUY_FILIAL = DT6.DT6_FILIAL
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
        
        left join SC5010 SC5 (nolock)
            on SC5.D_E_L_E_T_ = ''
            and trim(SC5.C5_YVIAGEM) = DUD.DUD_VIAGEM

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
where
        ZE1.D_E_L_E_T_ = ''
