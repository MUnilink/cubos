SELECT *,

  (SELECT TOP 1 TQN_HODOM
   FROM TQN010
   WHERE TQN_FROTA = COD_PAI
     AND TQN_YTIPO = 'C'
     AND TQN_DTABAS <= DATA_INI
     AND D_E_L_E_T_ = ' '
     AND TQN_CODCOM = '001'
   ORDER BY TQN_DTABAS DESC) HODOM_INI,

  (SELECT TOP 1 TQN_HODOM
   FROM TQN010
   WHERE TQN_FROTA = COD_PAI
     AND TQN_YTIPO = 'C'
     AND TQN_DTABAS >= DATA_FIM
     AND D_E_L_E_T_ = ' '
     AND TQN_CODCOM = '001'
   ORDER BY TQN_DTABAS DESC) HODOM_FIM
FROM
  (SELECT T9.T9_CODBEM COD_PNEU,
          T9.T9_NOME NOME_PNEU,
          TZ_BEMPAI COD_PAI,
          T92.T9_NOME NOME_PAI,
          T92.T9_TEMCONT,
          TZ_LOCALIZ,
          TZ_DATAMOV,
          TZ_DATASAI,
          CASE
              WHEN SUBSTRING(TZ_DATAMOV, 1, 6) < '202403' THEN '20240301'
              ELSE TZ_DATAMOV
          END AS DATA_INI,
          CASE
              WHEN SUBSTRING(TZ_DATASAI, 1, 6) > '202403'
                   OR TZ_DATASAI = ' ' THEN '20240331'
              ELSE TZ_DATASAI
          END AS DATA_FIM
   FROM ST9010 T9
   INNER JOIN STZ010 TZ ON TZ_FILIAL = ' '
   AND TZ_CODBEM = T9.T9_CODBEM
   AND TZ.D_E_L_E_T_ = ' '
   AND ('202403' BETWEEN TZ_DATAMOV AND TZ_DATASAI
        OR (SUBSTRING(TZ_DATAMOV, 1, 6) <= '202403'
            AND TZ_DATASAI = ' '))
   INNER JOIN ST9010 T92 ON T92.T9_FILIAL = ' '
   AND T92.T9_CODBEM = TZ_BEMPAI
   AND T92.D_E_L_E_T_ =' '
   AND T92.T9_TEMCONT = 'S'
   WHERE T9.T9_FILIAL = ' '
     AND T9.T9_CATBEM = '3'
     AND T9.D_E_L_E_T_ = ' ' ) A
UNION ALL
SELECT *
FROM
  (SELECT COD_PNEU,
          NOME_PNEU,
          COD_PAI2 COD_PAI,
          NOME_PAI2 NOME_PAI,
          T9_TEMCONT,
          TZ_LOCALIZ,
          TZ_DATAMOV,
          TZ_DATASAI,
          DATA_INI2 DATA_INI,
          DATA_FIM2 DATA_FIM,

     (SELECT TOP 1 TQN_HODOM
      FROM TQN010
      WHERE TQN_FROTA = COD_PAI2
        AND TQN_YTIPO = 'C'
        AND TQN_DTABAS <= DATA_INI2
        AND D_E_L_E_T_ = ' '
        AND TQN_CODCOM = '001'
      ORDER BY TQN_DTABAS DESC) HODOM_INI,

     (SELECT TOP 1 TQN_HODOM
      FROM TQN010
      WHERE TQN_FROTA = COD_PAI2
        AND TQN_YTIPO = 'C'
        AND TQN_DTABAS >= DATA_FIM2
        AND D_E_L_E_T_ = ' '
        AND TQN_CODCOM = '001'
      ORDER BY TQN_DTABAS DESC) HODOM_FIM
   FROM
     (SELECT TZ2.TZ_DATAMOV DATA2,
             TZ2.TZ_BEMPAI COD_PAI2,
             T93.T9_NOME NOME_PAI2,
             CASE
                 WHEN SUBSTRING(TZ2.TZ_DATAMOV, 1, 6) < '202403' THEN '20240301'
                 ELSE TZ2.TZ_DATAMOV
             END AS DATA_INI2,
             CASE
                 WHEN SUBSTRING(TZ2.TZ_DATASAI, 1, 6) > '202403'
                      OR TZ2.TZ_DATASAI = ' ' THEN '20240331'
                 ELSE TZ2.TZ_DATASAI
             END AS DATA_FIM2,
             COD_PNEU,
             NOME_PNEU,
             COD_PAI,
             NOME_PAI,
             B.T9_TEMCONT,
             B.TZ_LOCALIZ,
             B.TZ_DATAMOV,
             B.TZ_DATASAI,
             DATA_INI,
             DATA_FIM
      FROM
        (SELECT T9.T9_CODBEM COD_PNEU,
                T9.T9_NOME NOME_PNEU,
                TZ.TZ_BEMPAI COD_PAI,
                T92.T9_NOME NOME_PAI,
                T92.T9_TEMCONT,
                TZ.TZ_LOCALIZ,
                TZ.TZ_DATAMOV,
                TZ.TZ_DATASAI,
                CASE
                    WHEN SUBSTRING(TZ.TZ_DATAMOV, 1, 6) < '202403' THEN '20240301'
                    ELSE TZ_DATAMOV
                END AS DATA_INI,
                CASE
                    WHEN SUBSTRING(TZ.TZ_DATASAI, 1, 6) > '202403'
                         OR TZ.TZ_DATASAI = ' ' THEN '20240331'
                    ELSE TZ.TZ_DATASAI
                END AS DATA_FIM
         FROM ST9010 T9
         INNER JOIN STZ010 TZ ON TZ.TZ_FILIAL = ' '
         AND TZ.TZ_CODBEM = T9.T9_CODBEM
         AND TZ.D_E_L_E_T_ = ' '
         AND ('202403' BETWEEN TZ.TZ_DATAMOV AND TZ.TZ_DATASAI
              OR (SUBSTRING(TZ.TZ_DATAMOV, 1, 6) <= '202403'
                  AND TZ.TZ_DATASAI = ' '))
         INNER JOIN ST9010 T92 ON T92.T9_FILIAL = ' '
         AND T92.T9_CODBEM = TZ.TZ_BEMPAI
         AND T92.D_E_L_E_T_ =' '
         AND T92.T9_TEMCONT = 'P'
         WHERE T9.T9_FILIAL = ' '
           AND T9.T9_CATBEM = '3'
           AND T9.D_E_L_E_T_ = ' ' ) B
      INNER JOIN STZ010 TZ2 ON TZ2.TZ_FILIAL = ' '
      AND TZ2.TZ_CODBEM = COD_PAI
      AND TZ2.D_E_L_E_T_ = ' '
      AND (TZ2.TZ_DATAMOV <= DATA_FIM
           AND (TZ2.TZ_DATASAI = ' '
                OR TZ2.TZ_DATASAI >= DATA_FIM))
      INNER JOIN ST9010 T93 ON T93.T9_FILIAL = ' '
      AND T93.T9_CODBEM = TZ2.TZ_BEMPAI
      AND T93.D_E_L_E_T_ =' '
      AND T93.T9_TEMCONT = 'S') G) U
ORDER BY COD_PNEU,
         TZ_DATAMOV