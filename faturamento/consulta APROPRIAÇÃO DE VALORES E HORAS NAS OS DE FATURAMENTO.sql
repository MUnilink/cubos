select COMPET,
       CCUSTO,
       CTT_DESC01,
       CITEM,
       CTD_DESC01,
       Q3_CARGO,
       Q3_DESCSUM,
       CONT_FUNC,
       HORAS_TOT,
       VLR_TOT,
       HORAS_AFAST,
       HORAS_FERIAS,
       HORAS_PONTO,
       SUM((datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0)*ZC2_QTDREC) as HrApont
from
    (
        select RFQ_PERIOD COMPET,
                CCUSTO,
                CTT_DESC01,
                CITEM,
                CTD_DESC01,
                Q3_CARGO,
                Q3_DESCSUM,
                COUNT(DISTINCT(RA_MAT)) CONT_FUNC,
                SUM(HORAS_VINC) HORAS_TOT,
                SUM(AFASTADO) HORAS_AFAST,
                SUM(FERIAS) HORAS_FERIAS,
                SUM(AUS_PON) HORAS_PONTO,
                SUM(VLR_FOLHA) VLR_TOT
        from
            (select RA_FILIAL,
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
                    ROUND((RA_HRSMES/DIAS_PER)*AFASTADO, 2) AFASTADO,
                    ROUND((RA_HRSMES/DIAS_PER)*FERIAS, 2) FERIAS,
                    AUS_PON,
                    CCUSTO,
                    CTT_DESC01,
                    CITEM,
                    CTD_DESC01,
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
                            when SUBSTRING(RA_ADMISSA, 1, 6) = RFQ_PERIOD then datediff(day, RA_ADMISSA, RFQ_DTFIM)+1
                            when SUBSTRING(RA_DEMISSA, 1, 6) = RFQ_PERIOD then datediff(day, RFQ_DTINI, RA_DEMISSA)+1
                            else datediff(day, RFQ_DTINI, RFQ_DTFIM)+1
                        end as DIAS_PER,
                        
                        COUNT(distinct ID) DIAS_VINC,
                        SUM(AFASTADO) AFASTADO,
                        SUM(FERIAS) FERIAS,
                        SUM(AUS_PON) AUS_PON,
                        RA_HRSMES,
                        CCUSTO,
                        CTT_DESC01,
                        CITEM,
                        CTD_DESC01,
                        FUNCAO,
                        RJ_DESC,
                        Q3_CARGO,
                        Q3_DESCSUM,
                        (
                            (select ISNULL(SUM(RD_VALOR), 0)
                                from SRD010 RD
                                inner join SRV010 RV on RV_FILIAL = '0101  '
                                and RV_COD = RD_PD
                                and RV_TIPOCOD in ('1', '3', '4')
                                and RV.D_E_L_E_T_ = ' '
                                and RV_YCPOR = 'S'
                                where RD_FILIAL = RA_FILIAL
                                    and RD_MAT = RA_MAT
                                    and RD_PERIODO = RFQ_PERIOD
                                    and RD.D_E_L_E_T_ = ' ') -
                            (select ISNULL(SUM(RD_VALOR), 0)
                                from SRD010 RD
                                inner join SRV010 RV on RV_FILIAL = '0101  '
                                and RV_COD = RD_PD
                                and RV_TIPOCOD in ('2')
                                and RV.D_E_L_E_T_ = ' '
                                and RV_YCPOR = 'S'
                                where RD_FILIAL = RA_FILIAL
                                    and RD_MAT = RA_MAT
                                    and RD_PERIODO = RFQ_PERIOD
                                    and RD.D_E_L_E_T_ = ' ')
                        ) VLR_FOLHA
                from
                    (
                        select
                            RA_FILIAL,
                            RA_MAT,
                            RA_NOME,
                            RA_ADMISSA,
                            RA_DEMISSA,
                            RFQ_PERIOD,
                            RFQ_DTINI,
                            RFQ_DTFIM,
                            ID,
                            RA_HRSMES,
                            ISNULL(SRE.RE_CCP, ISNULL(RE2.RE_CCD, RA_CC)) as CCUSTO,
                            ISNULL(SRE.RE_ITEMP, ISNULL(RE2.RE_ITEMD, RA_ITEM)) as CITEM,
                            ISNULL(R7_FUNCAO, RA_CODFUNC) as FUNCAO,
                            
                            COALESCE
                            (
                                    (
                                        select COUNT(*)
                                        from SR8010 R8
                                        inner join RCM010 RCM on RCM_FILIAL = '0101'
                                        and RCM_TIPO = R8_TIPOAFA
                                        and RCM.D_E_L_E_T_ = ' '
                                        where R8_FILIAL = RA_FILIAL
                                            and R8_MAT = RA_MAT
                                            and R8_TIPOAFA <> '001'
                                            and R8_DATAINI <= ID
                                            and CONVERT(VARCHAR(8), DATEADD(day, RCM_DIASEM, (CONVERT(DATE, R8_DATAINI, 112))), 112) >= ID
                                            and (R8_DATAFIM = ' ' or R8_DATAFIM >= ID)
                                            and R8.D_E_L_E_T_ = ' ')
                                        ,0
                                    ) AFASTADO,
                            COALESCE
                            (
                                    (
                                        select COUNT(*)
                                        from SR8010 R8
                                        where R8_FILIAL = RA_FILIAL
                                            and R8_MAT = RA_MAT
                                            and R8_TIPOAFA = '001'
                                            and R8_DATAINI <= ID
                                            and (R8_DATAFIM = ' '
                                                or R8_DATAFIM >= ID)
                                            and R8.D_E_L_E_T_ = ' ')
                                        ,0
                                    ) FERIAS,

                            (
                                select SUM(PH_QUANTC)
                                from SPH010 PH
                                    inner join SP9010 P9 on P9_FILIAL = '0101'
                                    and P9_CODIGO = PH_PD
                                    and P9.D_E_L_E_T_ = ' '
                                    and P9_TIPOCOD = '2'
                                    and P9_CLASEV in ('02', '03', '04', '05')
                                    inner join SRA010 RA2 on RA.RA_MAT = RA2.RA_MAT
                                    and RA.RA_FILIAL = RA2.RA_FILIAL
                                    and RA2.RA_REGRA <> '00'
                                where PH.D_E_L_E_T_ = ' '
                                    and PH_FILIAL = RA.RA_FILIAL
                                    and PH_MAT = RA.RA_MAT
                                    and PH_DATA = ID
                                    and PH_ABONO not in ('02', '04', '11', '19', '23')
                            ) AUS_PON
                        from SRA010 RA
                            inner join RFQ010 RFQ on RFQ_FILIAL = SUBSTRING(RA_FILIAL, 1, 4)
                                and RFQ_PROCES = '00001'
                                and RFQ_PERIOD = '202509'
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
                            and (RA_DEMISSA = ' ' or RA_DEMISSA >= ID)
                            and RA_PROCES = RFQ_PROCES
                    ) A
                    inner join SRJ010 RJ on RJ_FILIAL = SUBSTRING(RA_FILIAL, 1, 4)
                        and RJ_FUNCAO = FUNCAO
                        and RJ_CARGO <> ' '
                        and RJ.D_E_L_E_T_ = ' '
                    inner join CTT010 CTT on CTT_FILIAL = SUBSTRING(RA_FILIAL, 1, 4)
                        and CTT_CUSTO = CCUSTO
                        and RJ_CARGO <> ' '
                        and CTT.D_E_L_E_T_ = ' '
                    inner join CTD010 CTD on CTD_FILIAL = '      '
                        and CTD_ITEM = CITEM
                        and CTD.D_E_L_E_T_ = ' '
                    inner join SQ3010 Q3 on Q3_FILIAL = RJ_FILIAL
                        and Q3_CARGO = RJ_CARGO
                        and Q3.D_E_L_E_T_ = ' '
                where CCUSTO in ('305', '304') and CITEM <> '11'
                group by
                    RA_FILIAL,
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
                    CITEM,
                    CTD_DESC01,
                    FUNCAO,
                    RJ_DESC,
                    Q3_CARGO,
                    Q3_DESCSUM
            ) B
        ) C
        group by RFQ_PERIOD,
                CCUSTO,
                CTT_DESC01,
                CITEM,
                CTD_DESC01,
                Q3_CARGO,
                Q3_DESCSUM
    ) D
    left join ZC2010 ZC2 on SUBSTRING(ZC2_DATA, 1, 6) = COMPET
        and ZC2_TIPO='2'
        and ZC2.D_E_L_E_T_=' '
        and ZC2_QTDREA > 0
        and (ZC2_DTINI <> ' ' and ZC2_DTFIM <> ' ' and ZC2_HRINI <> ' ' and ZC2_HRFIM <> ' ')
        and ZC2_COD = Q3_CARGO
        and ZC2_FILIAL + ZC2_NUM in
            (
                select ZC1_FILIAL + ZC1_NUM
                from ZC1010 ZC1
                where
                        ZC1.D_E_L_E_T_ = ' '
                    and (SUBSTRING(ZC1_DTFIM, 1, 6) >= COMPET or ZC1_DTFIM = ' ')
                    and SUBSTRING(ZC1_DTINI, 1, 6) <= COMPET
                    and ZC1_CC = CCUSTO
                    and ZC1_ATIVD = CITEM
            )
group by COMPET,
         CCUSTO,
         CTT_DESC01,
         CITEM,
         CTD_DESC01,
         Q3_CARGO,
         Q3_DESCSUM,
         CONT_FUNC,
         HORAS_TOT,
         VLR_TOT,
         HORAS_AFAST,
         HORAS_FERIAS,
         HORAS_PONTO
