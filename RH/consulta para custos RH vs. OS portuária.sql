SELECT RA_FILIAL,
       RA_MAT,
       RA_NOME,
       RA_ADMISSA,
       RA_DEMISSA,
       RFQ_PERIOD,
       RFQ_DTINI,
       RFQ_DTFIM,
       DIAS_PER,
       DIAS_VINC,
       RA_HRSMES,
       ( RA_HRSMES / DIAS_PER ) * DIAS_VINC                           AS HORAS_VINC,
       CCUSTO,
       CTT_DESC01,
       FUNCAO,
       RJ_DESC,
       Q3_CARGO,
       Q3_DESCSUM,
       Round(( VLR_FOLHA * ( DIAS_VINC * 100 / DIAS_PER ) ) / 100, 2) AS VLR_FOLHA
FROM   (SELECT RA_FILIAL,
               RA_MAT,
               RA_NOME,
               RA_ADMISSA,
               RA_DEMISSA,
               RFQ_PERIOD,
               RFQ_DTINI,
               RFQ_DTFIM,
               Datediff(DAY, RFQ_DTINI, RFQ_DTFIM) + 1                                 DIAS_PER,
               Count(DISTINCT ID)                                                      DIAS_VINC,
               RA_HRSMES,
               CCUSTO,
               CTT_DESC01,
               FUNCAO,
               RJ_DESC,
               Q3_CARGO,
               Q3_DESCSUM,
               ( (SELECT COALESCE(Sum(RD_VALOR), 0)
                  FROM   SRD010 RD
                         INNER JOIN SRV010 RV
                                 ON RV_FILIAL = '0101'
                                    AND RV_COD = RD_PD
                                    AND RV_TIPOCOD IN ( '1', '3', '4' )
                                    AND RV.D_E_L_E_T_ = ' '
                  WHERE  RV_YCPOR = 'S'
                         AND RD_FILIAL = RA_FILIAL
                         AND RD_MAT = RA_MAT
                         AND RD_PERIODO = RFQ_PERIOD
                         AND RD.D_E_L_E_T_ = ' ') - (SELECT COALESCE(Sum(RD_VALOR), 0)
                                                     FROM   SRD010 RD
                                                            INNER JOIN SRV010 RV
                                                                    ON RV_FILIAL = '0101'
                                                                       AND RV_COD = RD_PD
                                                                       AND RV_TIPOCOD IN ( '2' )
                                                                       AND RV.D_E_L_E_T_ = ' '
                                                     WHERE  RV_YCPOR = 'S'
                                                            AND RD_FILIAL = RA_FILIAL
                                                            AND RD_MAT = RA_MAT
                                                            AND RD_PERIODO = RFQ_PERIOD
                                                            AND RD.D_E_L_E_T_ = ' ') ) VLR_FOLHA
        FROM   (SELECT RA_FILIAL,
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
                       COALESCE(R7_FUNCAO, RA_CODFUNC)                   AS FUNCAO
                FROM   SRA010 RA
                       INNER JOIN RFQ010 RFQ
                               ON RFQ_FILIAL = Substring(RA_FILIAL, 1, 4)
                                  AND RFQ_PROCES = '00001'
                                  AND RFQ_PERIOD = '202409'
                                  AND RFQ.D_E_L_E_T_ = ' '
                       INNER JOIN YDATA
                               ON ID BETWEEN RFQ_DTINI AND RFQ_DTFIM
                       LEFT JOIN SRE010 SRE
                              ON SRE.R_E_C_N_O_ = (SELECT TOP (1) RE.R_E_C_N_O_
                                                   FROM   SRE010 AS RE
                                                   WHERE  ( RE_FILIALP = RA_FILIAL )
                                                          AND ( RE_MATP = RA_MAT )
                                                          AND ( RE_DATA <= ID )
                                                          AND ( RE.D_E_L_E_T_ = ' ' )
                                                   ORDER  BY RE_DATA DESC)
                       LEFT JOIN SRE010 RE2
                              ON RE2.R_E_C_N_O_ = (SELECT TOP (1) RE.R_E_C_N_O_
                                                   FROM   SRE010 AS RE
                                                   WHERE  ( RE_FILIALP = RA_FILIAL )
                                                          AND ( RE_MATP = RA_MAT )
                                                          AND ( RE_DATA > ID )
                                                          AND ( RE.D_E_L_E_T_ = ' ' )
                                                   ORDER  BY RE_DATA)
                       LEFT JOIN SR7010 SR7
                              ON SR7.R_E_C_N_O_ = (SELECT TOP (1) R7.R_E_C_N_O_
                                                   FROM   SR7010 AS R7
                                                   WHERE  ( R7_FILIAL = RA_FILIAL )
                                                          AND ( R7_MAT = RA_MAT )
                                                          AND ( R7_DATA <= ID )
                                                          AND ( R7.D_E_L_E_T_ = ' ' )
                                                   ORDER  BY R7_DATA DESC)
                WHERE  RA.D_E_L_E_T_ = ' '
                       AND RA_ADMISSA <= ID
                       AND ( RA_DEMISSA = ' '
                              OR RA_DEMISSA >= ID )
                       AND RA_PROCES = RFQ_PROCES) A
               INNER JOIN SRJ010 RJ
                       ON RJ_FILIAL = Substring(RA_FILIAL, 1, 4)
                          AND RJ_FUNCAO = FUNCAO
                          AND RJ_CARGO <> ' '
                          AND RJ.D_E_L_E_T_ = ' '
               INNER JOIN CTT010 CTT
                       ON CTT_FILIAL = Substring(RA_FILIAL, 1, 4)
                          AND CTT_CUSTO = CCUSTO
                          AND RJ_CARGO <> ' '
                          AND CTT.D_E_L_E_T_ = ' '
               INNER JOIN SQ3010 Q3
                       ON Q3_FILIAL = RJ_FILIAL
                          AND Q3_CARGO = RJ_CARGO
                          AND Q3.D_E_L_E_T_ = ' '
        WHERE  CCUSTO IN ( '305', '304' )
        GROUP  BY RA_FILIAL,
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
                  Q3_DESCSUM) B 
