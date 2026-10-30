select
       BK_EMPRESA,
       BK_FILIAL,
       BK_CONTA,
       normal,
       CTARES,
       TIPOCONTA,
       GRUPO,
       NATCTA,
       CT1DTEXSF,
       DESCCTA,
       data,
       CAST(COALESCE(SALDOANTDB, 0) as DECIMAL(16, 2)) as SALDOANTDB,
       CAST(COALESCE(SALDOANTCR, 0) as DECIMAL(16, 2)) as SALDOANTCR,
       CAST(COALESCE(SALDODEB, 0) as DECIMAL(16, 2)) as SALDODEB,
       CAST(COALESCE(SALDOCRD, 0) as DECIMAL(16, 2)) as SALDOCRD
from
    (
       select
              distinct 'P |01|01' as BK_EMPRESA,
              case when CQ1_FILIAL is null then 'P |01||' else 'P |01|01'+ CAST(CQ1_FILIAL as CHAR (6)) end as BK_FILIAL,
              'P |01|CT1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CT1_FILIAL, ' '))+'|'+RTRIM(COALESCE(CQ1_CONTA, ' ')), ' '), '|') as BK_CONTA,
              CT1_NORMAL as normal,
              CT1_RES as CTARES,
              CT1_CLASSE as TIPOCONTA,
              CT1_GRUPO as GRUPO,
              CT1_NATCTA as NATCTA,
              CT1_DTEXSF as CT1DTEXSF,
              CT1_DESC01 as DESCCTA,
              <<FINAL_DATE>> as data,

              (
                     select case when SUM(CQ1_DEBITO) is null then 0 else SUM(CQ1_DEBITO) end as SALDOANTDB
                     from CQ1010 CQ11
                     where
                            CQ11.CQ1_CONTA = CQ1.CQ1_CONTA
                            and CQ11.CQ1_TPSALD = '1'
                            and CQ11.CQ1_DATA < <<START_DATE>>
                            and CQ11.D_E_L_E_T_ = ' '
                            and CQ11.CQ1_FILIAL = CQ1.CQ1_FILIAL
                            and CQ11.CQ1_MOEDA = '01'
              ) as SALDOANTDB,

              (
                     select case when SUM(CQ1_CREDIT) is null then 0 else SUM(CQ1_CREDIT) end as SALDOANTCR
                     from CQ1010 CQ12
                     where
                            CQ12.CQ1_CONTA = CQ1.CQ1_CONTA
                            and CQ12.CQ1_TPSALD = '1'
                            and CQ12.CQ1_DATA < <<START_DATE>>
                            and CQ12.D_E_L_E_T_ = ' '
                            and CQ12.CQ1_FILIAL = CQ1.CQ1_FILIAL
                            and CQ12.CQ1_MOEDA = '01'
              ) as SALDOANTCR,

              (
                     select case when SUM(CQ1_DEBITO) is null then 0 else SUM(CQ1_DEBITO) end as SALDODEB
                     from CQ1010 CQ13
                     where
                            CQ13.CQ1_CONTA = CQ1.CQ1_CONTA
                            and CQ13.CQ1_TPSALD = '1'
                            and CQ13.CQ1_DATA >= <<START_DATE>>
                            and CQ13.CQ1_DATA <= <<FINAL_DATE>>
                            and CQ13.D_E_L_E_T_ = ' '
                            and CQ13.CQ1_FILIAL = CQ1.CQ1_FILIAL
                            and CQ13.CQ1_MOEDA = '01'
              ) as SALDODEB,

              (
                     select case when SUM(CQ1_CREDIT) is null then 0 else SUM(CQ1_CREDIT) end as SALDOCRD
                     from CQ1010 CQ14
                     where
                            CQ14.CQ1_CONTA = CQ1.CQ1_CONTA
                            and CQ14.CQ1_TPSALD = '1'
                            and CQ14.CQ1_DATA >= <<START_DATE>>
                            and CQ14.CQ1_DATA <= <<FINAL_DATE>>
                            and CQ14.D_E_L_E_T_ = ' '
                            and CQ14.CQ1_FILIAL = CQ1.CQ1_FILIAL
                            and CQ14.CQ1_MOEDA = '01'
              ) as SALDOCRD
       from CQ1010 CQ1
       inner join CT1010 CT1
              on CT1_FILIAL = CQ1_FILIAL
              and CT1_CONTA = CQ1_CONTA
              and CT1.D_E_L_E_T_ = ' '
       where CQ1.D_E_L_E_T_ = ' ' and CQ1.CQ1_MOEDA = '01'
) SALDOARQ
where (SALDOANTDB - SALDOANTCR <> 0 or SALDODEB <> 0 or SALDOCRD <> 0)
