SELECT B.*,
       CASE
         WHEN B.RT_DFERVEN != 0
              AND B.RT_TIPPROV = '1' THEN B.VALOR / ( B.RT_DFERVEN / 2.5 )
         WHEN B.RT_DFERPRO != 0
              AND B.RT_TIPPROV = '2' THEN B.VALOR / ( B.RT_DFERPRO / 2.5 )
         WHEN B.RT_AVOS13S != 0
              AND B.RT_TIPPROV = '3' THEN B.VALOR / B.RT_AVOS13S
         ELSE 0.0
       END AS VALOR_AVO
FROM   (SELECT RJ_CARGO,
               ZC7_CODIGO,
               ZC7_ORIGEM,
               ZC7_CC,
               ZC7_COMPET,
               ZC7_HRPAD,
               ZC7_HRPROD,
               ZC7_HRIMPR,
               SRA.RA_MAT,
               SRT.RT_VERBA,
               SRT.RT_TIPPROV,
               RT2.RT_DFERVEN,
               RT2.RT_DFERPRO,
               RT2.RT_AVOS13S,
               Sum(SRT.RT_VALOR) AS VALOR
        FROM   SRT010 SRT
               INNER JOIN SRA010 SRA
                       ON RA_FILIAL = '010102'
                          AND RA_MAT = SRT.RT_MAT
                          AND SRA.D_E_L_E_T_ = ' '
               INNER JOIN SRJ010 RJ
                       ON RJ_FILIAL = Substring(RA_FILIAL, 1, 4)
                          AND RJ_FUNCAO = RA_CODFUNC
                          AND RJ_CARGO <> ' '
                          AND RJ.D_E_L_E_T_ = ' '
               INNER JOIN ZC7010 ZC7
                       ON ZC7_ORIGEM = 'SQ3'
                          AND ZC7_COMPET = '202401'
                          AND ZC7.D_E_L_E_T_ = ' '
                          AND ZC7_CC = '305'
                          AND ZC7_CODIGO = RJ_CARGO
               INNER JOIN SRT010 RT2
                       ON RT2.RT_FILIAL = RA_FILIAL
                          AND RT2.RT_MAT = RA_MAT
                          AND RT2.RT_TIPPROV IN ( '1', '2' )
                          AND RT2.RT_VERBA = '830'
                          AND RT2.RT_DATABAS <> ' '
                          AND RT2.D_E_L_E_T_ = ' '
                          AND RT2.RT_DATACAL = SRT.RT_DATACAL
        WHERE  SRT.RT_FILIAL = '010102'
               AND SRT.RT_TIPPROV IN ( '2', '3' )
               AND Substring(SRT.RT_DATACAL, 1, 6) = '202401'
               AND SRT.RT_VERBA IN ( '224', '255', '336', '371',
                                     '020', '113', '344', '039',
                                     '030', '029', '749', '719',
                                     '796', '738', '800', '962',
                                     '950', '955', '960', '961',
                                     '817', '830', '845', '442',
                                     '440', '441', '444', '446',
                                     '591', '038', '025', '051',
                                     '134', '170', '171', '172',
                                     '173', '371', '445', '739',
                                     '831', '832', '833', '834',
                                     '846', '847', '848' )
               AND SRT.D_E_L_E_T_ = ' '
               AND SRT.RT_CC = '305'
               AND SRA.D_E_L_E_T_ = ' '
        GROUP  BY RJ_CARGO,
                  ZC7_CODIGO,
                  ZC7_ORIGEM,
                  ZC7_CC,
                  ZC7_COMPET,
                  ZC7_HRPAD,
                  ZC7_HRPROD,
                  ZC7_HRIMPR,
                  SRT.RT_TIPPROV,
                  RT2.RT_DFERVEN,
                  RT2.RT_DFERPRO,
                  RT2.RT_AVOS13S,
                  SRA.RA_MAT,
                  SRT.RT_VERBA) B 
