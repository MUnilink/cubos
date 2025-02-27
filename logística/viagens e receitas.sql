select
    'P |01|01' AS BK_EMPRESA,
    VIAGEM.DTQ_VIAGEM as VIAGEM,
    cast(VIAGEM.DATAFIM as date) as DATA_FIMVGA,
    left(VIAGEM.DATAFIM, 6) as PERIODO_FIMVGA,
    
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

    DTC.DTC_CODPRO as PRODUTO,
    VIAGEM.ID_VEICULO_CM,
    VIAGEM.ID_VEICULO_RB1,
    VIAGEM.ID_VEICULO_RB2,
    VIAGEM.ID_VEICULO_RB3,
    VIAGEM.ID_MOTORISTA,
    VIAGEM.MOTORISTA,

    DT6.DT6_DOC CTE_DOC,
    DT6.DT6_SERIE CTE_SERIE,
    left(DT6.DT6_DATEMI, 6) as PERIODO_CTE,
    cast(DT6.DT6_DATEMI as date) as DATA_CTE,
    DT6.DT6_VALFRE / isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DUD.DUD_VIAGEM), 1) as CTE_CM,
    DT6.DT6_VALFRE as CTE_TOTAL,
    DT6.DT6_VALIMP / isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DUD.DUD_VIAGEM), 1) as IMPOSTO_CM,
    DT6.DT6_VALIMP as IMPOSTO_TOTAL,

    DT6C.D2_DOC as DOCOMP_DOC,
    DT6C.D2_SERIE as DOCOMP_SERIE,
    DT6C.D2_TOTAL as DOCOMP_TOTAL,
    DT6C.D2_VALIPI as DOCOMP_VALIPI,
    DT6C.D2_VALICM as DOCOMP_VALICM,
    cast(DT6C.D2_EMISSAO as date) as DOCOMP_EMISSAO,

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
    left(VIAGEM.DTQ_DATENC, 6) as PERIODO_ENCVGA

from DUD010 DUD (nolock)
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
        and trim(SE1.E1_YVIATMS) = DUD.DUD_VIAGEM
    
    left join DT6010 DT6
        on DT6.D_E_L_E_T_ = ''
        and DT6.DT6_FILDOC = DUD.DUD_FILDOC
        and DT6.DT6_DOC = DUD.DUD_DOC
        and DT6.DT6_SERIE = DUD.DUD_SERIE
            
        left join SD2010 DT6C (nolock)
            on DT6C.D_E_L_E_T_ = ''
            and DT6C.D2_NFORI = DT6.DT6_DOC
            and DT6C.D2_SERIORI = DT6.DT6_SERIE
            and DT6C.D2_CLIENTE = DT6.DT6_CLIDEV
            and DT6C.D2_LOJA = DT6.DT6_LOJDEV
        left join DTC010 DTC
            on DTC.D_E_L_E_T_ = ''
            and DTC.DTC_FILDOC = DT6.DT6_FILDOC
            and DTC.DTC_DOC = DT6.DT6_DOC
            and DTC.DTC_SERIE = DT6.DT6_SERIE
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
            on SX5.X5_FILIAL = '      '
            and SX5.X5_TABELA = 'L4'
            and SX5.X5_CHAVE = DT6.DT6_SERVIC
            and SX5.D_E_L_E_T_ = ' '
    
    inner join
    (
        select
            DTQ.DTQ_FILIAL,
            DTQ.DTQ_FILORI,
            DTQ.DTQ_VIAGEM,
            DTQ.DTQ_DATGER,
            DTQ.DTQ_DATFEC,
            DTQ.DTQ_DATENC,

            (
                select DTW010.DTW_DATREA
                from DTW010 
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = 50
            ) as DATAFIM,
            
            concat(trim(DTQ.DTQ_FILORI), trim(DTQ.DTQ_VIAGEM)) as ID_VIAGEM,
            trim(DA4010.DA4_COD) as ID_MOTORISTA,
            trim(DA4010.DA4_NOME) as MOTORISTA,
            (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODVEI) as ID_VEICULO_CM,
            (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB1) as ID_VEICULO_RB1,
            (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB2) as ID_VEICULO_RB2,
            (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB3) as ID_VEICULO_RB3
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
        where DTQ.D_E_L_E_T_ = ''
    ) VIAGEM
        on DUD.DUD_FILIAL = VIAGEM.DTQ_FILIAL
        and DUD.DUD_FILORI = VIAGEM.DTQ_FILORI
        and DUD.DUD_VIAGEM = VIAGEM.DTQ_VIAGEM

where DUD.D_E_L_E_T_ = ''
