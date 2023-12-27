select
    DT6.DT6_FILIAL as FILIAL,
    DT6.DT6_DOC as DOCUMENTO,
    DT6.DT6_SERIE as SERIE,
    convert(date, DT6.DT6_DATEMI, 103) as EMISSAO,
    DT6.DT6_VALFRE as VALOR_FRETE,
    DT6.DT6_VALIMP as VALOR_ICMS,
    DT6.DT6_VALTOT as VALOR_TOTAL,
    DT6.DT6_CHVCTE as CHAVE,

    substring(DT6.DT6_DATEMI, 1, 6) as COMPETENCIA,

    DT6.DT6_VALFRE / isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DTQ.DTQ_VIAGEM), 1) as CTE_CM,
    DT6.DT6_VALFRE as CTE_TOTAL,
    DT6.DT6_VALIMP / isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DTQ.DTQ_VIAGEM), 1) as IMPOSTO_CM,
    DT6.DT6_VALIMP as IMPOSTO_TOTAL,
    DT6.DT6_VALTOT,

    DT6C.D2_DOC as COMP_DOC,
    DT6C.D2_SERIE as COMP_SERIE,
    DT6C.D2_TOTAL as COMP_TOTAL,
    DT6C.D2_VALIPI as COMP_VALIPI,
    DT6C.D2_VALICM as COMP_VALICM,
    convert(date, DT6C.D2_EMISSAO, 103) as COMP_EMISSAO,

    trim(DEV.A1_COD) as A1_COD,
    trim(DEV.A1_LOJA) as A1_LOJA,
    trim(DEV.A1_NOME) as CLIENTE,
    
    DTQ.DTQ_FILORI,
    DTQ.DTQ_VIAGEM,
    DTQ.DTQ_DATGER,
    DTQ.DTQ_DATFEC,
    DTQ.DTQ_DATENC,

    DTR.DTR_ITEM,
    DUP.DUP_CODMOT,
    DA4.DA4_MAT,
    DA4.DA4_NOME,
    DA4.DA4_FORNEC,
    DA4.DA4_LOJA,

    DTR.DTR_CODVEI,
    (select DA3010.DA3_PLACA from DA3010 where DA3010.DA3_COD = DTR.DTR_CODVEI) as PLACA_VEI,
    DTR.DTR_CODRB1,
    (select DA3010.DA3_PLACA from DA3010 where DA3010.DA3_COD = DTR.DTR_CODRB1) as PLACA_RB1,
    DTR.DTR_CODRB2,
    DTR.DTR_CODRB3,

    case DTQ.DTQ_STATUS
        when '1' then 'EXCLUÍDA'
        when '2' then 'EM TRANSITO'
        when '3' then 'ENCERRADA'
        when '4' then 'CHEGADA EM FILIAL'
        when '5' then 'FECHADA'
        when '9' then 'CANCELADA'
        when '' then 'SEM VIAGEM'
        else 'OUTROS'
    end as DTQ_STATUS

from DT6010 DT6 (nolock)
    left join SD2010 DT6C (nolock)
        on DT6C.D_E_L_E_T_ = ''
        and DT6C.D2_NFORI = DT6.DT6_DOC
        and DT6C.D2_SERIORI = DT6.DT6_SERIE
        and DT6C.D2_CLIENTE = DT6.DT6_CLIDEV
        and DT6C.D2_LOJA = DT6.DT6_LOJDEV
    
    left join SA1010 DEV (nolock)
        on DEV.A1_FILIAL = '      '
        and DEV.A1_COD = DT6.DT6_CLIDEV
        and DEV.A1_LOJA = DT6.DT6_LOJDEV
        and DEV.D_E_L_E_T_ = ' '

    left join DUD010 DUD (nolock)
        on DUD.D_E_L_E_T_ = ''
        and DUD.DUD_FILDOC = DT6.DT6_FILDOC
        and DUD.DUD_DOC = DT6.DT6_DOC
        and DUD.DUD_SERIE = DT6.DT6_SERIE
    
        left join DTQ010 DTQ (nolock)
            on DTQ.D_E_L_E_T_ = ''
            and DTQ.DTQ_FILORI = DUD.DUD_FILORI
            and DTQ.DTQ_VIAGEM = DUD.DUD_VIAGEM

            left join DA8010 DA8 (nolock)
                on DA8.D_E_L_E_T_ = ''
                and DA8.DA8_COD = DTQ.DTQ_ROTA
            left join DTR010 DTR (nolock)
                on DTR.D_E_L_E_T_ = ''
                and DTR.DTR_FILORI = DTQ.DTQ_FILORI
                and DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM

                left join DUP010 DUP (nolock)
                    on DUP.D_E_L_E_T_ = ''
                    and DUP.DUP_FILORI = DTR.DTR_FILORI
                    and DUP.DUP_VIAGEM = DTR.DTR_VIAGEM
                    and DUP.DUP_ITEDTR = DTR.DTR_ITEM
                    and DUP.DUP_CODVEI = DTR.DTR_CODVEI

                    left join DA4010 DA4 (nolock)
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

where DT6.D_E_L_E_T_ = ''
