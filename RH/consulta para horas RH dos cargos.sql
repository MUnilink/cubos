SELECT *,
       ISNULL(FERIAS, 0)+ISNULL(ATESTADO, 0)+ISNULL(AUSEN_PON, 0) TOT_AUS
FROM
    (SELECT RA_FILIAL,
            RA_MAT,
            RA_NOME,
            RA_ADMISSA,
            RA_DEMISSA,
            RFQ_PERIOD,
            RFQ_DTINI,
            RFQ_DTFIM,
            DIAS_PER,
            DIAS_VINC,
            ROUND((RA_HRSMES/DIAS_PER)*AFASTADO, 2) ATESTADO,
            ROUND((RA_HRSMES/DIAS_PER)*FERIAS, 2) FERIAS,
            AUS_PON AS AUSEN_PON,
            RA_HRSMES,
            (RA_HRSMES/DIAS_PER)*DIAS_VINC AS HORAS_VINC,
            CCUSTO,
            CTT_DESC01,
            FUNCAO,
            RJ_DESC,
            Q3_CARGO,
            Q3_DESCSUM,
            ROUND((VLR_FOLHA/DIAS_PER)*DIAS_VINC, 2) AS VLR_FOLHA
     FROM
         (SELECT RA_FILIAL,
                 RA_MAT,
                 RA_NOME,
                 RA_ADMISSA,
                 RA_DEMISSA,
                 RFQ_PERIOD,
                 RFQ_DTINI,
                 RFQ_DTFIM,
                 CASE
                     WHEN SUBSTRING(RA_ADMISSA, 1, 6) = RFQ_PERIOD THEN DATEDIFF(DAY, RA_ADMISSA, RFQ_DTFIM)+1
                     WHEN SUBSTRING(RA_DEMISSA, 1, 6) = RFQ_PERIOD THEN DATEDIFF(DAY, RFQ_DTINI, RA_DEMISSA)+1
                     ELSE DATEDIFF(DAY, RFQ_DTINI, RFQ_DTFIM)+1
                 END AS DIAS_PER,
                 COUNT(DISTINCT ID) DIAS_VINC,
                 SUM(AFASTADO) AFASTADO,
                 SUM(FERIAS) FERIAS,
                 SUM(AUS_PON) AUS_PON,
                 RA_HRSMES,
                 CCUSTO,
                 CTT_DESC01,
                 FUNCAO,
                 RJ_DESC,
                 Q3_CARGO,
                 Q3_DESCSUM,
                 (
                      (SELECT COALESCE(SUM(RD_VALOR), 0)
                       FROM SRD010 RD
                       INNER JOIN SRV010 RV ON RV_FILIAL = '0101'
                       AND RV_COD = RD_PD
                       AND RV_TIPOCOD IN ('1',
                                          '3',
                                          '4')
                       AND RV.D_E_L_E_T_ = ' '
                       AND RV_YCPOR = 'S'
                       WHERE RD_FILIAL = RA_FILIAL
                           AND RD_MAT = RA_MAT
                           AND RD_PERIODO = RFQ_PERIOD
                           AND RD.D_E_L_E_T_ = ' ') -
                      (SELECT COALESCE(SUM(RD_VALOR), 0)
                       FROM SRD010 RD
                       INNER JOIN SRV010 RV ON RV_FILIAL = '0101'
                       AND RV_COD = RD_PD
                       AND RV_TIPOCOD IN ('2')
                       AND RV.D_E_L_E_T_ = ' '
                       AND RV_YCPOR = 'S'
                       WHERE RD_FILIAL = RA_FILIAL
                           AND RD_MAT = RA_MAT
                           AND RD_PERIODO = RFQ_PERIOD
                           AND RD.D_E_L_E_T_ = ' ')) VLR_FOLHA
          FROM
              (SELECT RA_FILIAL,
                      RA_MAT,
                      RA_NOME,
                      RA_ADMISSA,
                      RA_DEMISSA,
                      RFQ_PERIOD,
                      RFQ_DTINI,
                      RFQ_DTFIM,
                      ID,
                      RA_HRSMES,
                      COALESCE(SRE.RE_CCP, COALESCE(RE2.RE_CCD, RA_CC)) AS CCUSTO,
                      COALESCE(R7_FUNCAO, RA_CODFUNC) AS FUNCAO,
                      COALESCE(
                                   (SELECT COUNT(*)
                                    FROM SR8010 R8
                                    INNER JOIN RCM010 RCM ON RCM_FILIAL = '0101'
                                    AND RCM_TIPO = R8_TIPOAFA
                                    AND RCM.D_E_L_E_T_ = ' '
                                    WHERE R8_FILIAL = RA_FILIAL
                                        AND R8_MAT = RA_MAT
                                        AND R8_TIPOAFA <> '001'
                                        AND R8_DATAINI <= ID
                                        AND CONVERT(VARCHAR(8), DATEADD(day, RCM_DIASEM, (CONVERT(DATE, R8_DATAINI, 112))), 112) >= ID
                                        AND (R8_DATAFIM = ' '
                                             OR R8_DATAFIM >= ID)
                                        AND R8.D_E_L_E_T_ = ' '),0) AFASTADO,
                      COALESCE(
                                   (SELECT COUNT(*)
                                    FROM SR8010 R8
                                    WHERE R8_FILIAL = RA_FILIAL
                                        AND R8_MAT = RA_MAT
                                        AND R8_TIPOAFA = '001'
                                        AND R8_DATAINI <= ID
                                        AND (R8_DATAFIM = ' '
                                             OR R8_DATAFIM >= ID)
                                        AND R8.D_E_L_E_T_ = ' '),0) FERIAS,

                   (SELECT SUM(PH_QUANTC)
                    FROM SPH010 PH
                    INNER JOIN SP9010 P9 ON P9_FILIAL = '0101'
                    AND P9_CODIGO = PH_PD
                    AND P9.D_E_L_E_T_ = ' '
                    AND P9_TIPOCOD = '2'
                    AND P9_CLASEV IN ('02',
                                      '03',
                                      '04',
                                      '05')
                    INNER JOIN SRA010 RA2 ON RA.RA_MAT = RA2.RA_MAT
                    AND RA.RA_FILIAL = RA2.RA_FILIAL
                    AND RA2.RA_REGRA <> '00'
                    WHERE PH.D_E_L_E_T_ = ' '
                        AND PH_FILIAL = RA.RA_FILIAL
                        AND PH_MAT = RA.RA_MAT
                        AND PH_DATA = ID
                        AND PH_ABONO NOT IN ('02',
                                             '04',
                                             '11',
                                             '19',
                                             '23')) AUS_PON
               FROM SRA010 RA
               INNER JOIN RFQ010 RFQ ON RFQ_FILIAL = SUBSTRING(RA_FILIAL, 1, 4)
               AND RFQ_PROCES = '00001'
               AND RFQ_PERIOD = '202502'
               AND RFQ.D_E_L_E_T_ = ' '
               INNER JOIN YDATA ON ID BETWEEN RFQ_DTINI AND RFQ_DTFIM
               LEFT JOIN SRE010 SRE ON SRE.R_E_C_N_O_ =
                   (SELECT TOP (1) RE.R_E_C_N_O_
                    FROM SRE010 AS RE
                    WHERE (RE_FILIALP = RA_FILIAL)
                        AND (RE_MATP = RA_MAT)
                        AND (RE_DATA <= ID)
                        AND (RE.D_E_L_E_T_ = ' ')
                    ORDER BY RE_DATA DESC)
               LEFT JOIN SRE010 RE2 ON RE2.R_E_C_N_O_ =
                   (SELECT TOP (1) RE.R_E_C_N_O_
                    FROM SRE010 AS RE
                    WHERE (RE_FILIALP = RA_FILIAL)
                        AND (RE_MATP = RA_MAT)
                        AND (RE_DATA > ID)
                        AND (RE.D_E_L_E_T_ = ' ')
                    ORDER BY RE_DATA)
               LEFT JOIN SR7010 SR7 ON SR7.R_E_C_N_O_ =
                   (SELECT TOP (1) R7.R_E_C_N_O_
                    FROM SR7010 AS R7
                    WHERE (R7_FILIAL = RA_FILIAL)
                        AND (R7_MAT = RA_MAT)
                        AND (R7_DATA <= ID)
                        AND (R7.D_E_L_E_T_ = ' ')
                    ORDER BY R7_DATA DESC)
               WHERE RA.D_E_L_E_T_ = ' '
                   AND RA_ADMISSA <= ID
                   AND (RA_DEMISSA = ' '
                        OR RA_DEMISSA >= ID)
                   AND RA_PROCES = RFQ_PROCES) A
          INNER JOIN SRJ010 RJ ON RJ_FILIAL = SUBSTRING(RA_FILIAL, 1, 4)
          AND RJ_FUNCAO = FUNCAO
          AND RJ_CARGO <> ' '
          AND RJ.D_E_L_E_T_ = ' '
          INNER JOIN CTT010 CTT ON CTT_FILIAL = SUBSTRING(RA_FILIAL, 1, 4)
          AND CTT_CUSTO = CCUSTO
          AND RJ_CARGO <> ' '
          AND CTT.D_E_L_E_T_ = ' '
          INNER JOIN SQ3010 Q3 ON Q3_FILIAL = RJ_FILIAL
          AND Q3_CARGO = RJ_CARGO
          AND Q3.D_E_L_E_T_ = ' '
          WHERE CCUSTO IN ('305',
                           '304')
          GROUP BY RA_FILIAL,
                   RA_MAT,
                   RA_NOME,
                   RA_ADMISSA,
                   RA_DEMISSA,
                   RFQ_PERIOD,
                   RFQ_DTINI,
                   RFQ_DTFIM,
                   RA_HRSMES,
                   CCUSTO,
                   CTT_DESC01,
                   FUNCAO,
                   RJ_DESC,
                   Q3_CARGO,
                   Q3_DESCSUM) B) C