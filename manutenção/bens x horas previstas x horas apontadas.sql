SELECT T9_CODBEM,
       T9_NOME,
       CTT_CUSTO,
       CTT_DESC01,
       COMPET,
       T6_YHRPADR RH_PADRAO,
       QTD_DIAS,
       HORAS_PREV,
       HrApont HORAS_APO
FROM
  (SELECT *,
          T6_YHRPADR*QTD_DIAS HORAS_PREV
   FROM
     (SELECT COMPET,
             T9_CODBEM,
             T9_NOME,
             CTT_CUSTO,
             CTT_DESC01,
             T6_YHRPADR,
             COUNT(*) QTD_DIAS,
             SUM(HrApont) HrApont
      FROM
        (SELECT T9_CODBEM,
                T9_NOME,
                SUBSTRING(CAST(D.ID AS VARCHAR), 1, 6) COMPET,
                D.ID AS DDATA,
                CTT_CUSTO,
                CTT_DESC01,
                T6_YHRPADR,
                datediff(MINUTE, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 AS HrApont
         FROM ST9010 T9
         INNER JOIN YDATA D ON ID BETWEEN '20240401' AND '20240430'
         INNER JOIN CTT010 CTT ON CTT_FILIAL = '0101'
         AND CTT_CUSTO IN ('305',
                           '304')
         INNER JOIN TPN010 TPN2 ON TPN2.TPN_CCUSTO = CTT_CUSTO
         AND TPN2.R_E_C_N_O_ =
           (SELECT TOP (1) TPN3.R_E_C_N_O_
            FROM TPN010 AS TPN3
            WHERE (TPN3.TPN_FILIAL = T9.T9_FILIAL)
              AND (TPN3.TPN_CODBEM = T9.T9_CODBEM)
              AND (TPN3.TPN_DTINIC <= D.ID)
              AND (TPN3.D_E_L_E_T_ = ' ')
            ORDER BY TPN3.TPN_DTINIC DESC)
         INNER JOIN ST6010 ST6 ON T6_CODFAMI=T9_CODFAMI
         AND ST6.D_E_L_E_T_<>'*'
         LEFT JOIN ZC2010 ZC2 ON ZC2_DATA = D.ID
         AND ZC2_TIPO='3'
         AND ZC2.D_E_L_E_T_=' '
         AND (ZC2_DTINI <> ' '
              AND ZC2_DTFIM <> ' '
              AND ZC2_HRINI <> ' '
              AND ZC2_HRFIM <> ' ')
         AND ZC2_COD = T9.T9_CODBEM
         WHERE T9_CATBEM NOT IN ('3')
           AND T9.D_E_L_E_T_ = ' '
           AND T9_DTCOMPR <= '20240430'
           AND (T9_DTBAIXA >= '20240401'
                OR T9_DTBAIXA = ' ') ) B
      GROUP BY COMPET,
               T9_CODBEM,
               T9_NOME,
               CTT_CUSTO,
               CTT_DESC01,
               T6_YHRPADR) C) D