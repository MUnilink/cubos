select
    VIAGEM.DTQ_VIAGEM,
    VIAGEM.DTR_CODVEI,
    VIAGEM.DTR_CODRB1,
    VIAGEM.DTR_CODRB3,
    VIAGEM.DTR_CODRB2,
    isnull(VIAGEM.DA4_MAT, VIAGEM.DUP_CODMOT) as ID_MOT,
    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    convert(date, DT6.DT6_DATEMI, 103) as DT6_DATEMI,
    DT6.DT6_CDRORI,
    DT6.DT6_CDRDES,
    DT6.DT6_CDRCAL,

    (
        select top 1 substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT))
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
        select top 1 substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT))
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
    VIAGEM.DTQ_KMVGE,

    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,

    DTC.DTC_NUMNFC,
    DTC.DTC_SERNFC,
    DTC.DTC_VALOR,

    case when DT5.DT5_STATUS = '4' then 'INTERNA' else case when DT5.DT5_STATUS like '[0-9]' then 'COLETA' else 'ENTREGA' end end as STATUS,

    DT5.DT5_NUMSOL,
    DT5.DT5_DOC,
    DT5.DT5_SERIE,
    DT5.DT5_STATUS,
    DT5.DT5_TIPCOL,
    DT5.DT5_CODSOL,
    DT5.DT5_CODOBC,
    
    VIAGEM.DTQ_FILORI,

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
    MANUTENCAO.TIPO_CUSTO,
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

    null as OUTROS_CUSTOS,
    null as SEGURO_CARGA /* PLANILHA DE SEGURO */,
    null as SEGURO_VEICULOS,
    null as COMISSOES

from DUD010 DUD (nolock)
    left join /* ver modelo para adição de dimensão motorista */
    (
        select
            DTQ_1.DTQ_FILIAL,
            DTQ_1.DTQ_FILORI,
            DTQ_1.DTQ_VIAGEM,
            DTQ_1.DTQ_DATGER,
            DTQ_1.DTQ_DATFEC,
            DTQ_1.DTQ_DATENC,
            DTQ_1.DTQ_KMVGE,
            
            DTR010.DTR_CODVEI,
            DUP010.DUP_CODMOT,
            DA4010.DA4_MAT,
            DTR010.DTR_CODRB1,
            DTR010.DTR_CODRB2,
            DTR010.DTR_CODRB3,

            (
                select DTW010.DTW_DATREA
                from DTW010 (nolock)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ_1.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ_1.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = '049'
            ) as DATAINI,
            (
                select DTW010.DTW_HORREA
                from DTW010 (nolock)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ_1.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ_1.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = '049'
            ) as HORAINI,
            (
                select DTW010.DTW_DATREA
                from DTW010 (nolock)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ_1.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ_1.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = '050'
            ) as DATAFIM,
            (
                select DTW010.DTW_HORREA
                from DTW010 (nolock)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ_1.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ_1.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = '050'
            ) as HORAFIM,

            (
                select substring(DTW010.DTW_DATREA, 1, 6)
                from DTW010 (nolock)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ_1.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ_1.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = '050'
            ) as COMPETENCIA,

            case DTQ_1.DTQ_STATUS
                when '1' then 'EXCLUÍDA'
                when '2' then 'EM TRANSITO'
                when '3' then 'ENCERRADA'
                when '4' then 'CHEGADA EM FILIAL'
                when '5' then 'FECHADA'
                when '9' then 'CANCELADA'
                else 'OUTROS'
            end as DTQ_STATUS

        from DTQ010 DTQ_1 (nolock)
            inner join DTR010 (nolock)
                on DTR010.D_E_L_E_T_ = ''
                and DTR010.DTR_FILORI = DTQ_1.DTQ_FILORI
                and DTR010.DTR_VIAGEM = DTQ_1.DTQ_VIAGEM
                
                inner join DUP010 (nolock)
                    on DUP010.D_E_L_E_T_ = ''
                    and DUP010.DUP_FILORI = DTR010.DTR_FILORI
                    and DUP010.DUP_VIAGEM = DTR010.DTR_VIAGEM
                    and DUP010.DUP_ITEDTR = DTR010.DTR_ITEM
                    and DUP010.DUP_CODVEI = DTR010.DTR_CODVEI

                    inner join DA4010 (nolock)
                        on DA4010.D_E_L_E_T_ = ''
                        and DA4010.DA4_COD = DUP010.DUP_CODMOT
        where DTQ_1.D_E_L_E_T_ = ''
    ) VIAGEM
        on year(VIAGEM.DTQ_DATGER) = 2022
        and substring(VIAGEM.DTQ_FILIAL, 1, 4) = DUD.DUD_FILIAL
        and VIAGEM.DTQ_FILORI = DUD.DUD_FILORI
        and VIAGEM.DTQ_VIAGEM = DUD.DUD_VIAGEM
    left join DT5010 DT5 (nolock)
        on DT5.D_E_L_E_T_ = ''
        and DT5.DT5_FILDOC = DUD.DUD_FILDOC
        and DT5.DT5_NUMSOL = DUD.DUD_DOC
        and DT5.DT5_SERIE = DUD.DUD_SERIE
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
            DYV010.DYV_FILORI,
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
        on DIARIAS.DYV_FILORI = VIAGEM.DTQ_FILORI
        and DIARIAS.DYV_VIAGEM = VIAGEM.DTQ_VIAGEM
where DUD.DUD_VIAGEM in (7263, 7268, 7269, 7277, 7283, 7284, 7286, 7287, 7291, 7292, 7296, 7298, 7299, 7300, 7301, 7302, 7307, 7308, 7309, 7310, 7311, 7312, 7313, 7314, 7316, 7318, 7320, 7325, 7329, 7330, 7333, 7334, 7336, 7337, 7338, 7339, 7340, 7341, 7349, 7351, 7353, 7354, 7355, 7356, 7357, 7358, 7359, 7362, 7363, 7371, 7372, 7373, 7375, 7376, 7376, 7376, 7376, 7377, 7379, 7380, 7385, 7389, 7390, 7392, 7395, 7398, 7399, 7403, 7404, 7407, 7408, 7409, 7410, 7411, 7413, 7414, 7415, 7416, 7418, 7419, 7420, 7422, 7423, 7424, 7427, 7428, 7429, 7431, 7433, 7438, 7439, 7440, 7441, 7442, 7443, 7444, 7445, 7448, 7449, 7450, 7454, 7455, 7456, 7458, 7459, 7460, 7462, 7463, 7464, 7465, 7468, 7469, 7470, 7471, 7473, 7474, 7476, 7477, 7478, 7479, 7481, 7482, 7483, 7484, 7487, 7488, 7490, 7491, 7492, 7493, 7494, 7495, 7496, 7503, 7504, 7506, 7507, 7509, 7510, 7512, 7516, 7517, 7518, 7519, 7520, 7521, 7523, 7524, 7528, 7533, 7534, 7535, 7536, 7537, 7538, 7539, 7540, 7541, 7542, 7543, 7544, 7545, 7546, 7548, 7552, 7553, 7554, 7555, 7556, 7557, 7558, 7559, 7560, 7561, 7562, 7566, 7567, 7568, 7569, 7570, 7571, 7575, 7576, 7577, 7579, 7580, 7581, 7583, 7584, 7585, 7588, 7589, 7590, 7591, 7592, 7594, 7595, 7596, 7597, 7598, 7599, 7600, 7601, 7602, 7603, 7604, 7605, 7606, 7607, 7609, 7610, 7611, 7612, 7613, 7614, 7616, 7617, 7618, 7619, 7620, 7621, 7622, 7623, 7623, 7623, 7623, 7625, 7626, 7627, 7630, 7633, 7634, 7635, 7636, 7637, 7638, 7639, 7640, 7641, 7644, 7648, 7649, 7650, 7651, 7652, 7653, 7654, 7657, 7659, 7661, 7662, 7663, 7664, 7665, 7666, 7667, 7668, 7669, 7671, 7673, 7674, 7676, 7677, 7678, 7679, 7680, 7681, 7682, 7683, 7684, 7685, 7686, 7687, 7688, 7689, 7690, 7691, 7694, 7695, 7696, 7697, 7698, 7699, 7700, 7707, 7710, 7711, 7712, 7713, 7714, 7715, 7716, 7717, 7718, 7728, 7729, 7732, 7733, 7736, 7740, 7741, 7742, 7743, 7751, 7752, 7753, 7755, 7756, 7757, 7758, 7759, 7760, 7761, 7762, 7763, 7764, 7765, 7766, 7767, 7777, 7778, 7779, 7780, 7781, 7782, 7787, 7790, 7791, 7792, 7793, 7794, 7795, 7796, 7797, 7798, 7799, 7801, 7802, 7805, 7806, 7807, 7808, 7809, 7810, 7811, 7812, 7813, 7814, 7815, 7816, 7823, 7824, 7825, 7826, 7827, 7828, 7829, 7835, 7839, 7841, 7842, 7844, 7846, 7847, 7857, 7861, 7862, 7866, 7867, 7876, 7877, 7878, 7879, 7880, 7882, 7883, 7884, 7885, 7886, 7887, 7888, 7889, 7890, 7892, 7893, 7899, 7900, 7901, 7902, 7903, 7904, 7905, 7906, 7908, 7911, 7912, 7913, 7914, 7916, 7917, 7918, 7921, 7922, 7923, 7925, 7927, 7928, 7929, 7930, 7934, 7935, 7937, 7938, 7939, 7943, 7947, 7948, 7326, 7672, 7321)
    and DUD.D_E_L_E_T_ = ''
