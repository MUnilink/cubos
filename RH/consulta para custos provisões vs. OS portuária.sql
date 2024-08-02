SELECT *
FROM
  (SELECT ZC7_CODIGO,
          ZC7_ORIGEM,
          ZC7_CC,
          ZC7_COMPET,
          ZC7_HRPAD,
          ZC7_HRPROD,
          ZC7_HRIMPR,
          SUM(VALOR_AVO) VALOR_PROV
   FROM
     (SELECT RJ_CARGO,
             ZC7_CODIGO,
             ZC7_ORIGEM,
             ZC7_CC,
             ZC7_COMPET,
             ZC7_HRPAD,
             ZC7_HRPROD,
             ZC7_HRIMPR,
             RT_TIPPROV,
             RT_DFERVEN,
             RT_DFERPRO,
             RT_AVOS13S,
             VALOR,
             CASE
                 WHEN RT_TIPPROV = '1' THEN ROUND(VALOR/(RT_DFERVEN/2.5), 2)
                 WHEN RT_TIPPROV = '2' THEN ROUND(VALOR/(RT_DFERPRO/2.5), 2)
                 WHEN RT_TIPPROV = '3' THEN ROUND(VALOR/RT_AVOS13S, 2)
             END AS VALOR_AVO
      FROM
        (SELECT RJ_CARGO,
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
                SUM(SRT.RT_VALOR) AS VALOR
         FROM SRT010 SRT
         INNER JOIN SRA010 SRA ON RA_FILIAL='010102'
         AND RA_MAT=SRT.RT_MAT
         AND SRA.D_E_L_E_T_=' '
         INNER JOIN SRJ010 RJ ON RJ_FILIAL = SUBSTRING(RA_FILIAL, 1, 4)
         AND RJ_FUNCAO = RA_CODFUNC
         AND RJ_CARGO <> ' '
         AND RJ.D_E_L_E_T_ = ' '
         INNER JOIN ZC7010 ZC7 ON ZC7_ORIGEM = 'SQ3'
         AND ZC7_COMPET = '202402'
         AND ZC7.D_E_L_E_T_ = ' '
         AND ZC7_CC = '305'
         AND ZC7_CODIGO = RJ_CARGO
         INNER JOIN SRT010 RT2 ON RT2.RT_FILIAL = RA_FILIAL
         AND RT2.RT_MAT = RA_MAT
         AND RT2.RT_TIPPROV = '1'
         AND RT2.RT_VERBA = '830'
         AND RT2.RT_DATABAS <> ' '
         AND RT2.D_E_L_E_T_ = ' '
         AND RT2.RT_DATACAL = SRT.RT_DATACAL
         WHERE SRT.RT_FILIAL='010102'
           AND SUBSTRING(SRT.RT_DATACAL, 1, 6) = '202402'
           AND exists (select * from SX6010 where SX6010.X6_VAR in ('UN_OSVERBA', 'UN_OSVERB1') and SX6010.X6_CONTEUD like '%' || SRT.RT_VERBA || '%')
           AND SRT.D_E_L_E_T_=' '
           AND SRT.RT_CC = '305'
           AND SRA.D_E_L_E_T_=' '
         GROUP BY RJ_CARGO,
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
                  RT2.RT_AVOS13S) B) C
   GROUP BY ZC7_CODIGO,
            ZC7_ORIGEM,
            ZC7_CC,
            ZC7_COMPET,
            ZC7_HRPAD,
            ZC7_HRPROD,
            ZC7_HRIMPR) D