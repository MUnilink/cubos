select
    'P |01|01' AS BK_EMPRESA,
    VIAGEM.DTQ_VIAGEM as VIAGEM,
    
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

    VIAGEM.ID_VEICULO_CM,
    VIAGEM.ID_VEICULO_RB1,
    VIAGEM.ID_VEICULO_RB2,
    VIAGEM.ID_VEICULO_RB3,
    VIAGEM.ID_MOTORISTA,
    VIAGEM.MOTORISTA,

    SF2.F2_ESPECIE as ESPECIE_NF,
    DT6.DT6_DOC CTE_DOC,
    DT6.DT6_SERIE CTE_SERIE,
    left(DT6.DT6_DATEMI, 6) as PERIODO_CTE,
    cast(DT6.DT6_DATEMI as date) as DATA_CTE,
    DT6.DT6_VALFRE / isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DUD.DUD_VIAGEM), 1) as CTE_CM,
    DT6.DT6_VALFRE as CTE_TOTAL,
    DT6.DT6_VALIMP / isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DUD.DUD_VIAGEM), 1) as IMPOSTO_CM,
    DT6.DT6_VALIMP as IMPOSTO_TOTAL,
    concat(trim(SD2.D2_TES), ' - ', trim(SF4.F4_TEXTO)) as TES,
    concat(trim(SD2.D2_CF), ' - ', trim(CFOP.X5_DESCRI)) as CFOP,

    COMP.D2_DOC as DOCOMP_DOC,
    COMP.D2_SERIE as DOCOMP_SERIE,
    COMP.D2_TOTAL as DOCOMP_TOTAL,
    COMP.D2_VALIPI as DOCOMP_VALIPI,
    COMP.D2_VALICM as DOCOMP_VALICM,
    cast(COMP.D2_EMISSAO as date) as DOCOMP_EMISSAO,

    SC5.C5_NUM as NFS_PEDIDO,
    NFS.D2_DOC as NFS_DOC,
    NFS.D2_SERIE as NFS_SERIE,
    NFS.D2_TOTAL as NFS_TOTAL,
    NFS.D2_VALIPI as NFS_VALIPI,
    NFS.D2_VALICM as NFS_VALICM,
    cast(NFS.D2_EMISSAO as date) as NFS_EMISSAO,

    SE1.E1_NUM as ND_TITULO,
    SE1.E1_VALOR as ND_VALOR,
    cast(SE1.E1_EMISSAO as date) as ND_EMISSAO,

    cast(VIAGEM.DTQ_DATGER as date) as DT_GERVGA,
    cast(VIAGEM.DTQ_DATFEC as date) as DT_FECVGA,
    cast(VIAGEM.DTQ_DATENC as date) as DT_ENCVGA,
    left(VIAGEM.DTQ_DATGER, 6) as PERIODO_GERVGA,
    left(VIAGEM.DTQ_DATFEC, 6) as PERIODO_FECVGA,
    left(VIAGEM.DTQ_DATENC, 6) as PERIODO_ENCVGA,

    trim(DTC.DTC_CTRDPC) as CTE_CLIENTE,
    trim(DTC.DTC_NUMNFC) as NFCLI_DOC,
    trim(DTC.DTC_SERNFC) as NFCLI_SERIE,
    trim(DTC.DTC_CODPRO) as NFCLI_CODPROD,
    (select trim(SB1010.B1_DESC) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and SB1010.B1_COD = DTC.DTC_CODPRO) as NFCLI_PRODUTO,
    cast(DTC.DTC_VALOR as numeric(15, 2)) as NFCLI_VALOR,
    cast(DTC.DTC_PESO as numeric(15, 2)) as NFCLI_PESO,
    cast(DTC.DTC_PESLIQ as numeric(15, 2)) as NFCLI_PESOLIQ,

    case
        /* LP 610-001 */
        when trim(CFOP.X5_CHAVE) like '[5-6]933' and SF4.F4_CSTCOF = '08' then concat(trim(SB1.B1_YCTREC4), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC4))
        when trim(CFOP.X5_CHAVE) like '[5-6]933' and SF4.F4_CSTCOF != '08' and SD2.D2_TES = '511' then concat(trim(SB1.B1_YCTREC5), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC5))
        when trim(CFOP.X5_CHAVE) like '[5-6]933' and SF4.F4_CSTCOF != '08' and SD2.D2_TES != '511' then concat(trim(SB1.B1_YCTREC3), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC3))
        /* LP 610-040 */
        when trim(CFOP.X5_CHAVE) = 5359 then concat(trim(SB1.B1_YCTREC1), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC1))
        /* LP 610-600 */
        when trim(CFOP.X5_CHAVE) like '[5-6]932' and SD2.D2_TES = '509' then concat(trim(SB1.B1_YCTREC2), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC2))
        when trim(CFOP.X5_CHAVE) like '[5-6]932' and SD2.D2_TES != '509' then concat(trim(SB1.B1_YCTREC1), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC1))
        /* LP 610-010 */
        when trim(CFOP.X5_CHAVE) = 5360 and SD2.D2_TES = '520' then concat(trim(SB1.B1_YCTREC1), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC1))
        when trim(CFOP.X5_CHAVE) = 5360 and SD2.D2_TES != '520' then concat(trim(SB1.B1_YCTREC2), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC2))
        /* LP 610-020 */
        when trim(CFOP.X5_CHAVE) like '[5-6]35[2-3]' and (SD2.D2_TES = '507' or SD2.D2_TES = '539') then concat(trim(SB1.B1_YCTREC1), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC1))
        when trim(CFOP.X5_CHAVE) like '[5-6]35[2-3]' and (SD2.D2_TES != '507' and SD2.D2_TES != '539') then concat(trim(SB1.B1_YCTREC2), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC2))
        /* LP 610-030 */
        when trim(CFOP.X5_CHAVE) like '[5-6]35[1-2]' and SD2.D2_TES in ('506', '534', '535', '536', '537') then concat(trim(SB1.B1_YCTREC1), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC1))
        when trim(CFOP.X5_CHAVE) like '[5-6]35[1-2]' and SD2.D2_TES not in ('506', '534', '535', '536', '537') then concat(trim(SB1.B1_YCTREC2), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC2))
        /*LP 610-050 */
        when trim(CFOP.X5_CHAVE) = 7949 and SD2.D2_TES = '522' then concat(trim(SB1.B1_YCTREC5), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC5))
        when trim(CFOP.X5_CHAVE) = 7949 and SD2.D2_TES != '522' then concat(trim(SB1.B1_YCTREC4), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC4))
        /* LP 610-015 */
        when trim(CFOP.X5_CHAVE) like '[5-6]355' and SD2.D2_TES = '520' then concat(trim(SB1.B1_YCTREC1), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC1))
        when trim(CFOP.X5_CHAVE) like '[5-6]355' and SD2.D2_TES != '520' then concat(trim(SB1.B1_YCTREC2), ' ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SB1.B1_YCTREC2))
    else null end as LP_CRE

from DUD010 DUD (nolock)
    left join SC5010 SC5 (nolock)
        on SC5.D_E_L_E_T_ = ''
        and SC5.C5_FILIAL = DUD.DUD_FILDOC
        and SC5.C5_YVIAGEM = DUD.DUD_VIAGEM

        left join SD2010 NFS (nolock)
            on NFS.D_E_L_E_T_ = ''
            and NFS.D2_FILIAL = SC5.C5_FILIAL
            and NFS.D2_DOC = SC5.C5_NOTA
            and NFS.D2_SERIE = SC5.C5_SERIE
            and NFS.D2_CLIENTE = SC5.C5_CLIENTE
            and NFS.D2_LOJA = SC5.C5_LOJACLI

            left join SF4010 NFS_TES (nolock)
                on NFS_TES.D_E_L_E_T_ = ''
                and NFS_TES.F4_CODIGO = NFS.D2_TES
            left join SX5010 NFS_CFOP (nolock)
                on NFS_CFOP.D_E_L_E_T_ = ''
                and NFS_CFOP.X5_TABELA = '13'
                and NFS_CFOP.X5_CHAVE = NFS.D2_CF
    
    left join SE1010 SE1 (nolock)
        on SE1.D_E_L_E_T_ = ''
        and SE1.E1_FILIAL = DUD.DUD_FILDOC
        and SE1.E1_YVIATMS = DUD.DUD_VIAGEM
    
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

            left join SF4010 NFC_TES (nolock)
                on NFC_TES.D_E_L_E_T_ = ''
                and NFC_TES.F4_CODIGO = COMP.D2_TES
            left join SX5010 NFC_CFOP (nolock)
                on NFC_CFOP.D_E_L_E_T_ = ''
                and NFC_CFOP.X5_TABELA = '13'
                and NFC_CFOP.X5_CHAVE = COMP.D2_CF
        
        left join SD2010 SD2 (nolock)
            on SD2.D_E_L_E_T_ = ''
            and SD2.D2_DOC = DT6.DT6_DOC
            and SD2.D2_SERIE = DT6.DT6_SERIE
            and SD2.D2_CLIENTE = DT6.DT6_CLIDEV
            and SD2.D2_LOJA = DT6.DT6_LOJDEV

            left join SF2010 SF2 (nolock)
                on SF2.F2_FILIAL = SD2.D2_FILIAL
                and SF2.F2_CLIENTE = SD2.D2_CLIENTE
                and SF2.F2_LOJA = SD2.D2_LOJA
                and SF2.F2_DOC = SD2.D2_DOC
                and SF2.F2_SERIE = SD2.D2_SERIE
                and SF2.D_E_L_E_T_= ' '
            left join SF4010 SF4 (nolock)
                on SF4.D_E_L_E_T_ = ''
                and SF4.F4_CODIGO = SD2.D2_TES
            left join SX5010 CFOP (nolock)
                on CFOP.D_E_L_E_T_ = ''
                and CFOP.X5_TABELA = '13'
                and CFOP.X5_CHAVE = SD2.D2_CF
            left join SB1010 SB1 (nolock)
                on SB1.D_E_L_E_T_= ''
                and SB1.B1_COD = SD2.D2_COD

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
            concat(trim(DTQ.DTQ_FILORI), trim(DTQ.DTQ_VIAGEM)) as ID_VIAGEM,
            trim(DA4010.DA4_COD) as ID_MOTORISTA,
            trim(DA4010.DA4_NOME) as MOTORISTA,
            (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODVEI) as ID_VEICULO_CM,
            (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB1) as ID_VEICULO_RB1,
            (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB2) as ID_VEICULO_RB2,
            (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB3) as ID_VEICULO_RB3
        from DTQ010 DTQ (nolock)
            left join DTR010 DTR (nolock)
                on DTR.D_E_L_E_T_ = ''
                and DTR.DTR_FILORI = DTQ.DTQ_FILORI
                and DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM
                
                left join DUP010 (nolock)
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
