select
    ZC7.ZC7_CODIGO as ENTIDADE,
    ZC7.ZC7_CC as CC,
    ZC7.ZC7_COMPET as COMPETENCIA,
    ZC7.ZC7_ORIGEM as TABELA,
    case when ZC7.ZC7_ORIGEM = 'SQ3' then (select concat(trim(ST9010.T9_FILIAL), trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC7.ZC7_CODIGO) and ZC7.ZC7_ORIGEM = 'SQ3') else null end as COD_DA3,
    case when ZC7.ZC7_ORIGEM = 'ST9' then (select concat(trim(SQ3010.Q3_FILIAL), trim(SQ3010.Q3_CARGO)) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and trim(SQ3010.Q3_CARGO) = trim(ZC7.ZC7_CODIGO) and ZC7.ZC7_ORIGEM = 'ST9') else null end as COD_SRJ,
    cast(ZC7.ZC7_HRPAD as numeric(15, 2)) as HORA_PAD,
    cast(ZC7.ZC7_HRPROD as numeric(15, 2)) as HORA_PROD,
    cast(ZC7.ZC7_HRIMPR as numeric(15, 2)) as HORA_IMPR,
    
    ZC2.ID_RECURSO,
    ZC2.TIPO,
    ZC2.QTD_REAL_ITEM,
    ZC2.VAL_REAL_ITEM,
    ZC2.QTD_RECURSO,
    ZC2.VALOR_TOTAL,

    case ZC2.TIPO
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
        else 'OUTROS'
    end as TIPO_INSUMO,

    cast
    (
        case
            when ZC2.TIPO = 3 then
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
                    and STJ010.TJ_CODBEM = ZC7.ZC7_CODIGO
                    and left(STL010.TL_DTFIM, 6) = ZC7.ZC7_COMPET
                    and STL010.TL_SEQRELA > 0
                    and STJ010.TJ_SERVICO not in ('PNEMOV', 'PNEROD')
            )
            when ZC2.TIPO = 6 then
            (
                select sum(SN4010.N4_VLROC1)
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
                    and SN1010.N1_CODBEM = ZC7.ZC7_CODIGO
                    and left(SN4010.N4_DATA, 6) = ZC7.ZC7_COMPET
                    and SN4010.N4_OCORR = 6
                    and SN4010.N4_TIPOCNT = 3
            )
            when ZC2.TIPO = 9 then
            (
                select sum(TS1010.TS1_VALOR)/12.0
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
                where TS1010.TS1_CODBEM = ZC7.ZC7_CODIGO
            )
            when ZC2.TIPO = 12 then
            (
                select sum(ZC4010.ZC4_VLSEG)/sum(ZC4.VALOR_ANUAL)/12.0
                from ZC4010 (nolock)
                    inner join
                        (
                            select
                                cast(datediff(day, ZC4010.ZC4_DTVGIN, ZC4010.ZC4_DTVGFI)/365.0 as numeric(15, 5)) as VALOR_ANUAL,
                                ZC4010.ZC4_CODBEM,
                                ZC4010.ZC4_DTVGIN,
                                ZC4010.ZC4_DTVGFI
                            from ZC4010 (nolock)
                            where
                                    ZC4010.D_E_L_E_T_ = ''
                        ) ZC4
                            on ZC4010.ZC4_CODBEM = ZC4.ZC4_CODBEM
                            and ZC4010.ZC4_DTVGIN = ZC4.ZC4_DTVGIN
                            and ZC4010.ZC4_DTVGFI = ZC4.ZC4_DTVGFI
                where
                        ZC4010.D_E_L_E_T_ = ''
                    and ZC7.ZC7_CODIGO = ZC4010.ZC4_CODBEM
                    and eomonth(concat(ZC7.ZC7_COMPET, '01')) between ZC4.ZC4_DTVGIN and ZC4.ZC4_DTVGFI
            )
        else 0.0 end as numeric(15, 2)
    ) as CUSTO

from ZC7010 ZC7
    left join
    (
        select
            cast(sum(ZC2010.ZC2_QTDREA) as numeric(15, 2)) as QTD_REAL_ITEM,
            cast(sum(ZC2010.ZC2_VLUREA) as numeric(15, 2)) as VAL_REAL_ITEM,
            cast(sum(ZC2010.ZC2_QTDREC) as numeric(15, 2)) as QTD_RECURSO,
            cast(sum(ZC2010.ZC2_TOTAL) as numeric(15, 2)) as VALOR_TOTAL,
            left(ZC2010.ZC2_COMPET, 6) as PERIODO,
            ZC2010.ZC2_COD as ENTIDADE,
            cast(ZC2010.ZC2_TIPO as int) as TIPO,
            trim(ZC2.ZC2_TIPO) as ID_RECURSO
        from ZC2010
        where 
                ZC2010.ZC2_COMPET > '20231231'
            and cast(ZC2010.ZC2_TIPO as int) > 1
            and ZC2010.D_E_L_E_T_ = ''
        group by ZC2010.ZC2_COD, ZC2010.ZC2_TIPO, ZC2010.ZC2_COMPET
    ) ZC2
    on ZC2.PERIODO = ZC7.ZC7_COMPET
    and ZC2.ENTIDADE = ZC7.ZC7_CODIGO
    and ZC7.ZC7_CC = 305
where
        eomonth(concat(ZC7.ZC7_COMPET, '01')) BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
    and ZC7.D_E_L_E_T_ = ''
