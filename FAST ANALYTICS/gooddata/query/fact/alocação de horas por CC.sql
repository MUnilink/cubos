select
    case when ZC7.ZC7_ORIGEM = 'ST9' then (select concat(trim(ST9010.T9_FILIAL), trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC7.ZC7_CODIGO)) else null end as COD_DA3,
    case when ZC7.ZC7_ORIGEM = 'SQ3' then (select concat(trim(SQ3010.Q3_FILIAL), trim(SQ3010.Q3_CARGO)) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and trim(SQ3010.Q3_CARGO) = trim(ZC7.ZC7_CODIGO)) else null end as COD_SRJ,
    'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(ZC7.ZC7_CC, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
    concat(ZC7.ZC7_COMPET, '01') as COMPETENCIA,
    
    ZC2.ID_RECURSO,
    ZC2.TIPO,
    
    isnull(ZC7.ZC7_HRPAD, 0.0) as ZC7_HRPAD,
    isnull(ZC7.ZC7_HRPROD, 0.0) as ZC7_HRPROD,
    isnull(ZC7.ZC7_HRIMPR, 0.0) as ZC7_HRIMPR,
    isnull(ZC2.QTD_REAL_ITEM, 0.0) as QTD_REAL_ITEM,
    isnull(ZC2.VAL_REAL_ITEM, 0.0) as VAL_REAL_ITEM,
    isnull(ZC2.QTD_RECURSO, 0.0) as QTD_RECURSO,
    isnull(ZC2.VALOR_TOTAL, 0.0) as VALOR_TOTAL,
    
    ZC2.BK_FILIAL,
    ZC2.BK_CLIENTE,
    ZC2.BK_FORNECEDOR,
    ZC2.ID_OSPORTUARIA,
    PV.ID_PEDIDODEVENDA,
    PV.ID_NFS,
    ZC2.BK_NAT_FINANCEIRA,
    ZC2.BK_CONDICAO_DE_PAGAMENTO,
    PV.BK_ITEM_CONTABIL,
    
    isnull
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
            when ZC2.TIPO = 10 then
            (
                select cast(sum(TQN010.TQN_VALTOT) as numeric(15, 2))
                from TQN010
                where
                        TQN010.D_E_L_E_T_ = ''
                    and TQN010.TQN_FROTA = ZC7.ZC7_CODIGO
                    and left(TQN010.TQN_DTABAS, 6) = ZC7.ZC7_COMPET
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
            when ZC2.TIPO = 13 then
            (
                select sum(ZC6010.ZC6_CUSTO)
                from ZC6010
                where
                        ZC6010.D_E_L_E_T_ = ''
                    and ZC6010.ZC6_ANOMES = left(ZC7.ZC7_COMPET, 6)
                    and (ZC6010.ZC6_BEMPAI = ZC7.ZC7_CODIGO or ZC6010.ZC6_BEMPA2 = ZC7.ZC7_CODIGO)
            )
        else 0.0 end, 0.0
    ) as CUSTO

from ZC7010 ZC7
    left join
    (
        select
            ZC1010.ZC1_FILIAL as FILIAL,
            ZC1010.ZC1_NUM as OS,
            sum(cast(ZC2010.ZC2_QTDREA as numeric(15, 2))) as QTD_REAL_ITEM,
            sum(cast(ZC2010.ZC2_VLUREA as numeric(15, 2))) as VAL_REAL_ITEM,
            sum(cast(ZC2010.ZC2_QTDREC as numeric(15, 2))) as QTD_RECURSO,
            sum(cast(ZC2010.ZC2_TOTAL as numeric(15, 2))) as VALOR_TOTAL,
            
            concat(left(ZC2010.ZC2_COMPET, 6), '01') as PERIODO,
            trim(ZC2010.ZC2_COD) as ENTIDADE,
            concat(trim(ZC2.ZC2_TIPO), ' ', trim(ZC2.ZC2_COD)) as ID_RECURSO,
            cast(ZC2010.ZC2_TIPO as int) as TIPO,

            CASE WHEN ZC1010.ZC1_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(ZC1010.ZC1_FILIAL AS CHAR (6)) END AS BK_FILIAL,
            'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1010.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA1010.A1_COD, ' '))+RTRIM(COALESCE(SA1010.A1_LOJA, ' ')), ' '), '|') as BK_CLIENTE,
            'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2010.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA2010.A2_COD, ' '))+RTRIM(COALESCE(SA2010.A2_LOJA, ' ')), ' '), '|') as BK_FORNECEDOR,
            concat(trim(ZC1010.ZC1_FILIAL), trim(ZC1010.ZC1_NUM)) as ID_OSPORTUARIA,
            'P |01|SED010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SED010.ED_FILIAL, ' '))+'|'+RTRIM(COALESCE(SED010.ED_CODIGO, ' ')), ' '), '|') AS BK_NAT_FINANCEIRA,
            'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4010.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SE4010.E4_CODIGO, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO
        from ZC2010
            inner join ZC1010
                on ZC1010.D_E_L_E_T_ = ''
                and ZC1010.ZC1_FILIAL = ZC2010.ZC2_FILIAL
                and ZC1010.ZC1_NUM = ZC2010.ZC2_NUM

                left join SA1010
                    on SA1010.D_E_L_E_T_ = ''
                    and SA1010.A1_COD = ZC1010.ZC1_CODSA1
                    and SA1010.A1_LOJA = ZC1010.ZC1_LOJSA1
                left join SA2010
                    on SA2010.D_E_L_E_T_ = ''
                    and SA2010.A2_COD = ZC1010.ZC1_DESPA
                    and SA2010.A2_LOJA = ZC1010.ZC1_LJDESP
                left join SED010
                    on SED010.D_E_L_E_T_ = ''
                    and SED010.ED_CODIGO = ZC1010.ZC1_NATURE
                left join SE4010
                    on SE4010.D_E_L_E_T_ = ''
                    and SE4010.E4_CODIGO = ZC1010.ZC1_COND
        where
                concat(left(ZC2010.ZC2_COMPET, 6), '01') > '20231231'
            and cast(ZC2010.ZC2_TIPO as int) in (2, 14, 3, 6, 9, 10, 12, 13)
            and ZC2010.D_E_L_E_T_ = ''
        group by
            ZC1010.ZC1_NUM,
            ZC2010.ZC2_COD,
            ZC2010.ZC2_TIPO,
            ZC1010.ZC1_FILIAL,
            ZC2010.ZC2_COMPET,
            SA1010.A1_FILIAL,
            SA1010.A1_COD,
            SA1010.A1_LOJA,
            SA2010.A2_FILIAL,
            SA2010.A2_COD,
            SA2010.A2_LOJA,
            SED010.ED_FILIAL,
            SED010.ED_CODIGO,
            SE4010.E4_FILIAL,
            SE4010.E4_CODIGO
    ) ZC2
        on ZC2.PERIODO = concat(ZC7.ZC7_COMPET, '01')
        and ZC2.ENTIDADE = trim(ZC7.ZC7_CODIGO)
        and ZC7.ZC7_CC = 305

        left join
        (
            select distinct
                SC6010.C6_FILIAL as FILIAL,
                SC6010.C6_YOS as OS,
                concat(trim(SC6010.C6_FILIAL), trim(SC6010.C6_NUM)) as ID_PEDIDODEVENDA,
                concat('SF2', trim(SF2010.F2_FILIAL), trim(SF2010.F2_CLIENTE), trim(SF2010.F2_LOJA), trim(SF2010.F2_DOC), trim(SF2010.F2_SERIE)) as ID_NFS,
                'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD010.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC6010.C6_ITEMCTA, ' ')), ' '), '|') as BK_ITEM_CONTABIL,
                'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT010.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC6010.C6_CC, ' ')), ' '), '|') as BK_CENTRO_DE_CUSTO
            from SC6010
                left join SD2010
                    on SD2010.D_E_L_E_T_= ''
                    and SD2010.D2_FILIAL = SC6010.C6_FILIAL
                    and SD2010.D2_PEDIDO = SC6010.C6_NUM
                    and SD2010.D2_ITEMPV = SC6010.C6_ITEM
                        
                    left join SF2010
                        on SF2010.D_E_L_E_T_= ' '
                        and SF2010.F2_FILIAL = SD2010.D2_FILIAL
                        and SF2010.F2_CLIENTE = SD2010.D2_CLIENTE
                        and SF2010.F2_LOJA = SD2010.D2_LOJA
                        and SF2010.F2_DOC = SD2010.D2_DOC
                        and SF2010.F2_SERIE = SD2010.D2_SERIE
                
                left join CTD010
                    on CTD010.CTD_FILIAL = ''
                    and CTD010.CTD_ITEM = SC6010.C6_ITEMCTA
                    and CTD010.D_E_L_E_T_ = ''
                left join CTT010
                    on CTT010.D_E_L_E_T_ = ''
                    and CTT010.CTT_FILIAL = substring(SC6010.C6_FILIAL, 1, 4)
                    and CTT010.CTT_CUSTO = SC6010.C6_CC
            where
                    SC6010.D_E_L_E_T_ = ''
        ) PV
            on PV.FILIAL = ZC2.FILIAL
            and PV.OS = ZC2.OS

    left join CTT010 CTT
        on CTT.D_E_L_E_T_ = ''
        and CTT.CTT_CUSTO = ZC7.ZC7_CC
where
        concat(ZC7.ZC7_COMPET, '01') BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
    and ZC7.D_E_L_E_T_ = ''
