select
    ZG1.ZG1_FILORI as FILIAL,
    ZG1.ZG1_COMPET as PERIODO,
    ZG1.ZG1_TABELA as TABELA,
    trim(ZG1.ZG1_CODIGO) as RECURSO,
    
    case ZG1.ZG1_TABELA
        when 'ST9' then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = ZG1.ZG1_CODIGO and ZG1.ZG1_TIPO in (3, 6, 9, 12))
        when 'SQ3' then (select trim(SQ3010.Q3_DESCSUM) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and SQ3010.Q3_CARGO = ZG1.ZG1_CODIGO and ZG1.ZG1_TIPO in (2, 14))
    else null end as DESC_RECURSO,

    case cast(ZG1.ZG1_TIPO as int)
        when 1 then 'RECEITA'
        when 2 then 'FOLHA'
        when 3 then 'MANUTENÇÃO'
        when 4 then 'MATERIAIS'
        when 5 then 'COMPRAS'
        when 6 then 'DEPRECIAÇÃO'
        when 7 then 'CONTABILIDADE'
        when 8 then 'DESPESAS FINANCEIRAS'
        when 9 then 'OUTROS CUSTOS - TAXAS'
        when 10 then 'COMBUSTIVEL'
        when 11 then 'SERVIÇOS TOMADOS'
        when 12 then 'SEGURO'
        when 13 then 'PNEUS'
        when 14 then 'PROVISÕES'
        when 15 then 'TIPO RH IMPROD'
        when 16 then 'TIPO MNT IMPROD'
        else 'OUTROS'
    end as TIPO_INSUMO,
    
    ZG1.ZG1_TIPO as TIPO,
    ZG1.ZG1_HRPAD as HORA_PAD,
    ZG1.ZG1_HRPRO as HORA_PRO,
    ZG1.ZG1_HRIMPR as HORA_IMP,
    ZG1.ZG1_VLTOTL as VL_TOTAL,
    ZG1.ZG1_VLHORA as VL_HORA,
    ZG1.ZG1_VLIMPR as VL_IMP,
    ZG1.ZG1_VLPROD as VL_PRO,
    ZG1.ZG1_VLIMPR/
    (
        select sum(ZG1010.ZG1_VLIMPR)
        from ZG1010
        where
            ZG1010.D_E_L_E_T_ = ''
        and ZG1010.ZG1_VLIMPR != 0
        and ZG1010.ZG1_FILORI = ZG1.ZG1_FILORI
        and ZG1010.ZG1_COMPET = ZG1.ZG1_COMPET
        and ZG1010.ZG1_CODIGO = ZG1.ZG1_CODIGO
    ) as VL_RIMP,
    
    case
        when ZG1.ZG1_TIPO = 3 then
        (
            select sum(STL010.TL_CUSTO)
            from STJ010 (nolock)
                left join STL010 (nolock)
                    on STL010.D_E_L_E_T_ = ''
                    and STL010.TL_FILIAL = STJ010.TJ_FILIAL
                    and STL010.TL_PLANO = STJ010.TJ_PLANO
                    and STL010.TL_ORDEM = STJ010.TJ_ORDEM
            where
                    STJ010.D_E_L_E_T_ = ''
                and STJ010.TJ_CODBEM = ZG1.ZG1_CODIGO
                and left(STL010.TL_DTFIM, 6) = ZG1.ZG1_COMPET
                and STL010.TL_SEQRELA > 0
                and STJ010.TJ_SERVICO not in ('PNEMOV', 'PNEROD')
        )
        when ZG1.ZG1_TIPO = 6 then
        (
            select cast(sum(SN4010.N4_VLROC1) as numeric(15, 2))
            from SN4010 (nolock)
                inner join SN3010 (nolock)
                    on SN3010.D_E_L_E_T_ = ''
                    and SN3010.N3_CBASE = SN4010.N4_CBASE
                    and SN3010.N3_ITEM = SN4010.N4_ITEM

                    inner join SN1010 (nolock)
                        on SN1010.D_E_L_E_T_ = ''
                        and SN1010.N1_CBASE = SN3010.N3_CBASE
                        and SN1010.N1_ITEM = SN3010.N3_ITEM
            where
                    SN4010.D_E_L_E_T_ = ''
                and SN1010.N1_CODBEM = ZG1.ZG1_CODIGO
                and left(SN4010.N4_DATA, 6) = ZG1.ZG1_COMPET
                and SN4010.N4_OCORR = 6
                and SN4010.N4_TIPOCNT = 3
        )
        when ZG1.ZG1_TIPO = 7 then
        (
            select cast(sum(case when CT2010.CT2_DEBITO between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM then cast(CT2010.CT2_VALOR as numeric(15, 2)) else case when CT2010.CT2_CREDIT between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM then cast(CT2010.CT2_VALOR as numeric(15, 2))*-1 else 0.0 end end) as numeric(15, 2))
            from CT2010 (nolock)
                inner join ZA8010 (nolock)
                    on ZA8010.D_E_L_E_T_ = ''
                    and (CT2010.CT2_DEBITO between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM or CT2010.CT2_CREDIT between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM)
                    and (CT2010.CT2_ITEMD between ZA8010.ZA8_CTDINI and ZA8010.ZA8_CTDFIM or CT2010.CT2_ITEMC between ZA8010.ZA8_CTDINI and ZA8010.ZA8_CTDFIM)
                    and (CT2010.CT2_CCD between ZA8010.ZA8_CTTINI and ZA8010.ZA8_CTTFIM or CT2010.CT2_CCC between ZA8010.ZA8_CTTINI and ZA8010.ZA8_CTTFIM)

                    inner join ZA7010 (nolock)
                        on ZA7010.D_E_L_E_T_ = ''
                        and ZA7010.ZA7_COD = ZA8010.ZA8_COD
            where
                    CT2010.D_E_L_E_T_ = ''
                and ZA7010.ZA7_COD = ZG1.ZG1_CODIGO
                and left(CT2010.CT2_DATA, 6) = ZG1.ZG1_COMPET
                and ZG1.ZG1_TIPO = 7
        )
        when ZG1.ZG1_TIPO = 9 then
        (
            select cast(sum(TS1010.TS1_VALOR)/12 as numeric(15, 2))
            from TS1010 (nolock)
                inner join
                (
                    select
                        TS1010.TS1_CODBEM,
                        TS1010.TS1_DOCTO,
                        max(TS1010.TS1_DTVENC) as TS1_DTVENC
                    from TS1010 (nolock)
                    where
                            TS1010.D_E_L_E_T_ = ''
                        and TS1010.TS1_DOCTO in (1, 2, 3, 7)
                    group by
                        TS1010.TS1_CODBEM,
                        TS1010.TS1_DOCTO
                ) TS1
                on TS1010.D_E_L_E_T_ = ''
                and TS1.TS1_DOCTO = TS1010.TS1_DOCTO
                and TS1.TS1_CODBEM = TS1010.TS1_CODBEM
                and TS1.TS1_DTVENC = TS1010.TS1_DTVENC
            where TS1010.TS1_CODBEM = ZG1.ZG1_CODIGO
        )
        when ZG1.ZG1_TIPO = 12 then
        (
            select cast(sum(ZC4010.ZC4_VLSEG)/sum(ZC4.VALOR_ANUAL)/12.0 as numeric(15, 2))
            from ZC4010 (nolock)
                inner join
                    (
                        select
                            cast(datediff(day, ZC4010.ZC4_DTVGIN, ZC4010.ZC4_DTVGFI)/365.0 as numeric(15, 5)) as VALOR_ANUAL,
                            cast(ZC4010.ZC4_DTVGIN as date) as INI_VIG,
                            cast(ZC4010.ZC4_DTVGFI as date) as FIM_VIG,
                            ZC4010.ZC4_CODBEM
                        from ZC4010 (nolock)
                        where
                                ZC4010.D_E_L_E_T_ = ''
                    ) ZC4
                        on ZC4010.ZC4_CODBEM = ZC4.ZC4_CODBEM
                        and ZC4010.ZC4_DTVGIN = ZC4.INI_VIG
                        and ZC4010.ZC4_DTVGFI = ZC4.FIM_VIG
            where
                    ZC4010.D_E_L_E_T_ = ''
                and ZG1.ZG1_CODIGO = ZC4010.ZC4_CODBEM
                and eomonth(concat(ZG1.ZG1_COMPET, '01')) between ZC4.INI_VIG and ZC4.FIM_VIG
        )
        when ZG1.ZG1_TIPO = 2 then
        (
            select sum(FOLHA.VALOR)
            from
            (
                select
                    SRD.RD_VALOR,
                    SRD.RD_VALOR *
                    (
                        datediff
                        (
                            day,
                            concat(SRD.RD_DATARQ, '01'),
                            case when
                            (
                                select max(SR7010.R7_DATA)
                                from SR7010
                                where
                                        SR7010.D_E_L_E_T_ = ''
                                    and SR7010.R7_FILIAL = SRD.RD_FILIAL
                                    and SR7010.R7_MAT = SRD.RD_MAT
                                    and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
                            ) >= concat(SRD.RD_DATARQ, '01') then
                            (
                                select max(SR7010.R7_DATA)
                                from SR7010
                                where
                                        SR7010.D_E_L_E_T_ = ''
                                    and SR7010.R7_FILIAL = SRD.RD_FILIAL
                                    and SR7010.R7_MAT = SRD.RD_MAT
                                    and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
                            )
                            else concat(SRD.RD_DATARQ, '01') end
                        )
                    ) / (1 + datediff(day, concat(SRD.RD_DATARQ, '01'), eomonth(concat(SRD.RD_DATARQ, '01')))) /* VALOR_ANT */
                    +
                    SRD.RD_VALOR *
                    (
                        datediff
                        (
                            day,
                            case when
                            (
                                select max(SR7010.R7_DATA)
                                from SR7010
                                where
                                        SR7010.D_E_L_E_T_ = ''
                                    and SR7010.R7_FILIAL = SRD.RD_FILIAL
                                    and SR7010.R7_MAT = SRD.RD_MAT
                                    and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
                            ) >= concat(SRD.RD_DATARQ, '01') then
                            (
                                select max(SR7010.R7_DATA)
                                from SR7010
                                where
                                        SR7010.D_E_L_E_T_ = ''
                                    and SR7010.R7_FILIAL = SRD.RD_FILIAL
                                    and SR7010.R7_MAT = SRD.RD_MAT
                                    and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
                            )
                            else concat(SRD.RD_DATARQ, '01') end,
                            dateadd(day, 1, eomonth(concat(SRD.RD_DATARQ, '01')))
                        )
                    ) / (1 + datediff(day, concat(SRD.RD_DATARQ, '01'), eomonth(concat(SRD.RD_DATARQ, '01')))) as VALOR, /* VALOR_ANT */
                    (
                        select top 1 last_value(trim(SR7010.R7_CARGO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
                        from SR7010
                        where
                                SR7010.D_E_L_E_T_ = ''
                            and SR7010.R7_FILIAL = SRD.RD_FILIAL
                            and SR7010.R7_MAT = SRD.RD_MAT
                            and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')
                    ) as CARGO_FOLHA,
                    SRD.RD_FILIAL,
                    SRD.RD_MAT,
                    SRD.RD_DATARQ
                from SRD010 SRD
                where
                        exists
                        (
                            select *
                            from SR7010
                            where
                                    SR7010.D_E_L_E_T_ = ''
                                and SR7010.R7_FILIAL = SRD.RD_FILIAL
                                and SR7010.R7_MAT = SRD.RD_MAT
                                and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')
                        )
                    and exists (select * from SRV010 (nolock) where SRV010.D_E_L_E_T_ = '' and nullif(SRV010.RV_YCPOR, '') is not null and SRV010.RV_COD = SRD.RD_PD /* nullif(SRV.RV_YCTMS, '') */)
                    and SRD.D_E_L_E_T_ = ''
            ) FOLHA
            where concat(FOLHA.RD_FILIAL, FOLHA.RD_DATARQ, FOLHA.CARGO_FOLHA) = concat(ZG1.ZG1_FILORI, ZG1.ZG1_COMPET, ZG1.ZG1_CODIGO)
        )
        when ZG1.ZG1_TIPO = 14 then 0.0
    else 0.0 end as CUSTO

from ZG1010 ZG1 (nolock)
where
        ZG1.ZG1_COMPET=:PERIODO_CUSTO
    and ZG1.D_E_L_E_T_ = ''
