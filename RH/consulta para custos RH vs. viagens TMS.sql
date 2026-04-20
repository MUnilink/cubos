select RA_FILIAL,
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
       (RA_HRSMES/DIAS_PER)*DIAS_VINC as HORAS_VINC,
       CCUSTO,
       CTT_DESC01,
       FUNCAO,
       RJ_DESC,
       Q3_CARGO,
       Q3_DESCSUM,
       ROUND((VLR_FOLHA/DIAS_PER)*DIAS_VINC, 2) as VLR_FOLHA
from
    (select RA_FILIAL,
            RA_MAT,
            RA_NOME,
            RA_ADMISSA,
            RA_DEMISSA,
            RFQ_PERIOD,
            RFQ_DTINI,
            RFQ_DTFIM,
            case
                when SUBSTRING(RA_ADMISSA, 1, 6) = RFQ_PERIOD then DATEDIFF(day, RA_ADMISSA, RFQ_DTFIM)+1
                when SUBSTRING(RA_DEMISSA, 1, 6) = RFQ_PERIOD then DATEDIFF(day, RFQ_DTINI, RA_DEMISSA)+1
                else DATEDIFF(day, RFQ_DTINI, RFQ_DTFIM)+1
            end as DIAS_PER,
            COUNT(distinct ID) DIAS_VINC,
            RA_HRSMES,
            CCUSTO,
            CTT_DESC01,
            FUNCAO,
            RJ_DESC,
            Q3_CARGO,
            Q3_DESCSUM,
            (
                 (select COALESCE(SUM(RD_VALOR), 0)
                  from SRD010 RD
                  inner join SRV010 RV on RV_FILIAL = '0101'
                  and RV_COD = RD_PD
                  and RV_TIPOCOD in ('1', '3', '4')
                  and RV.D_E_L_E_T_ = ' '
                  and RV_YCTMS = 'S'
                  where RD_FILIAL = RA_FILIAL
                      and RD_MAT = RA_MAT
                      and RD_PERIODO = RFQ_PERIOD
                      and RD.D_E_L_E_T_ = ' ') -
                 (select COALESCE(SUM(RD_VALOR), 0)
                  from SRD010 RD
                  inner join SRV010 RV on RV_FILIAL = '0101'
                  and RV_COD = RD_PD
                  and RV_TIPOCOD in ('2')
                  and RV.D_E_L_E_T_ = ' '
                  and RV_YCTMS = 'S'
                  where RD_FILIAL = RA_FILIAL
                      and RD_MAT = RA_MAT
                      and RD_PERIODO = RFQ_PERIOD
                      and RD.D_E_L_E_T_ = ' ')) VLR_FOLHA
     from
         (select RA_FILIAL,
                 RA_MAT,
                 RA_NOME,
                 RA_ADMISSA,
                 RA_DEMISSA,
                 RFQ_PERIOD,
                 RFQ_DTINI,
                 RFQ_DTFIM,
                 ID,
                 RA_HRSMES,
                 COALESCE(SRE.RE_CCP, COALESCE(RE2.RE_CCD, RA_CC)) as CCUSTO,
                 COALESCE(R7_FUNCAO, RA_CODFUNC) as FUNCAO
          from SRA010 RA
          inner join RFQ010 RFQ on RFQ_FILIAL = SUBSTRING(RA_FILIAL, 1, 4)
          and RFQ_PROCES = '00001'
          and RFQ_PERIOD =:PERIODO
          and RFQ.D_E_L_E_T_ = ' '
          inner join YDATA on ID between RFQ_DTINI and RFQ_DTFIM
          left join SRE010 SRE on SRE.R_E_C_N_O_ =
              (select TOP (1) RE.R_E_C_N_O_
               from SRE010 as RE
               where (RE_FILIALP = RA_FILIAL)
                   and (RE_MATP = RA_MAT)
                   and (RE_DATA <= ID)
                   and (RE.D_E_L_E_T_ = ' ')
               order by RE_DATA desc)
          left join SRE010 RE2 on RE2.R_E_C_N_O_ =
              (select TOP (1) RE.R_E_C_N_O_
               from SRE010 as RE
               where (RE_FILIALP = RA_FILIAL)
                   and (RE_MATP = RA_MAT)
                   and (RE_DATA > ID)
                   and (RE.D_E_L_E_T_ = ' ')
               order by RE_DATA)
          left join SR7010 SR7 on SR7.R_E_C_N_O_ =
              (select TOP (1) R7.R_E_C_N_O_
               from SR7010 as R7
               where (R7_FILIAL = RA_FILIAL)
                   and (R7_MAT = RA_MAT)
                   and (R7_DATA <= ID)
                   and (R7.D_E_L_E_T_ = ' ')
               order by R7_DATA desc)
          where RA.D_E_L_E_T_ = ' '
              and RA_ADMISSA <= ID
              and (RA_DEMISSA = ' '
                   or RA_DEMISSA >= ID)
              and RA_PROCES = RFQ_PROCES) A
     inner join SRJ010 RJ on RJ_FILIAL = SUBSTRING(RA_FILIAL, 1, 4)
     and RJ_FUNCAO = FUNCAO
     and RJ_CARGO <> ' '
     and RJ.D_E_L_E_T_ = ' '
     inner join CTT010 CTT on CTT_FILIAL = SUBSTRING(RA_FILIAL, 1, 4)
     and CTT_CUSTO = CCUSTO
     and RJ_CARGO <> ' '
     and CTT.D_E_L_E_T_ = ' '
     inner join SQ3010 Q3 on Q3_FILIAL = RJ_FILIAL
     and Q3_CARGO = RJ_CARGO
     and Q3.D_E_L_E_T_ = ' '
     where CCUSTO in ('305', '304')
     group by RA_FILIAL,
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