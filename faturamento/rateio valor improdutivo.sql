select
    concat(trim(ZC2.ZC2_FILIAL), trim(ZC2.ZC2_NUM)) as ID_OSPORTUARIA,
    substring(ZC2.ZC2_NUM, 6, 10) as OS,
    cast(ZC2.ZC2_TIPO as int) as ID_TIPO_ITEM,
    case when cast(ZC2.ZC2_TIPO as int) = 3 then (select concat(trim(ST9010.T9_FILIAL), trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13)) else null end as COD_DA3,
    case when cast(ZC2.ZC2_TIPO as int) = 2 then (select concat(trim(SQ3010.Q3_FILIAL), trim(SQ3010.Q3_CARGO)) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and trim(SQ3010.Q3_CARGO) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (2, 14)) else null end as COD_SRJ,

    trim(ZC2.ZC2_COD) as INSUMO,
    trim(ZC2.ZC2_ITEM) as ITEM,
    cast(coalesce(ZC2.ZC2_DTFIM, ZC2.ZC2_DTINI) as date) as DATA_APP,
    trim(ZC2.ZC2_COMPET) as COMPETENCIA,
    
    case when ZC2.ZC2_VLUREA > 99999999 then 99999999 else cast(ZC2.ZC2_VLUREA as numeric(15, 2)) end as VAL_REAL,
    case when ZC2.ZC2_TOTAL > 99999999 then 99999999 else cast(ZC2.ZC2_TOTAL as numeric(15, 2)) end as VALOR_TOTAL,
    ZC2.ZC2_QTDREC as QTD_RECURSO,
    upper(trim(ZC2.ZC2_NMUSU)) as USUARIO,
                
    cast(
        case
            when cast(ZC2.ZC2_TIPO as int) = 2 then
            (
                select
                    ZG1.ZG1_VLIMPR/
                    (
                        select sum(ZG1010.ZG1_VLIMPR)
                        from ZG1010
                        where
                            ZG1010.ZG1_VLIMPR != 0
                        and ZG1010.ZG1_FILORI = ZG1.ZG1_FILORI
                        and ZG1010.ZG1_COMPET = ZG1.ZG1_COMPET
                        and ZG1010.ZG1_CODIGO = ZG1.ZG1_CODIGO
                        and ZG1010.D_E_L_E_T_ = ''
                    )
                from ZG1010 ZG1 (nolock)
                where
                        ZG1.ZG1_TIPO = cast(ZC2.ZC2_TIPO as int)
                    and left(ZC2.ZC2_COMPET, 6) = ZG1.ZG1_COMPET
                    and ZC2.ZC2_COD = trim(ZG1.ZG1_CODIGO)
                    and ZG1.D_E_L_E_T_ = ''
            )
            when cast(ZC2.ZC2_TIPO as int) = 14 then
            (
                select
                    ZG1.ZG1_VLIMPR/
                    (
                        select sum(ZG1010.ZG1_VLIMPR)
                        from ZG1010
                        where
                            ZG1010.ZG1_VLIMPR != 0
                        and ZG1010.ZG1_FILORI = ZG1.ZG1_FILORI
                        and ZG1010.ZG1_COMPET = ZG1.ZG1_COMPET
                        and ZG1010.ZG1_CODIGO = ZG1.ZG1_CODIGO
                        and ZG1010.D_E_L_E_T_ = ''
                    )
                from ZG1010 ZG1 (nolock)
                where
                        ZG1.ZG1_TIPO = cast(ZC2.ZC2_TIPO as int)
                    and left(ZC2.ZC2_COMPET, 6) = ZG1.ZG1_COMPET
                    and ZC2.ZC2_COD = trim(ZG1.ZG1_CODIGO)
                    and ZG1.D_E_L_E_T_ = ''
            )
            when cast(ZC2.ZC2_TIPO as int) = 3 then
            (
                select
                    ZG1.ZG1_VLIMPR/
                    (
                        select sum(ZG1010.ZG1_VLIMPR)
                        from ZG1010
                        where
                            ZG1010.ZG1_VLIMPR != 0
                        and ZG1010.ZG1_FILORI = ZG1.ZG1_FILORI
                        and ZG1010.ZG1_COMPET = ZG1.ZG1_COMPET
                        and ZG1010.ZG1_CODIGO = ZG1.ZG1_CODIGO
                        and ZG1010.D_E_L_E_T_ = ''
                    )
                from ZG1010 ZG1 (nolock)
                where
                        ZG1.ZG1_TIPO = cast(ZC2.ZC2_TIPO as int)
                    and left(ZC2.ZC2_COMPET, 6) = ZG1.ZG1_COMPET
                    and ZC2.ZC2_COD = trim(ZG1.ZG1_CODIGO)
                    and ZG1.D_E_L_E_T_ = ''
            )
            when cast(ZC2.ZC2_TIPO as int) = 6 then
            (
                select
                    ZG1.ZG1_VLIMPR/
                    (
                        select sum(ZG1010.ZG1_VLIMPR)
                        from ZG1010
                        where
                            ZG1010.ZG1_VLIMPR != 0
                        and ZG1010.ZG1_FILORI = ZG1.ZG1_FILORI
                        and ZG1010.ZG1_COMPET = ZG1.ZG1_COMPET
                        and ZG1010.ZG1_CODIGO = ZG1.ZG1_CODIGO
                        and ZG1010.D_E_L_E_T_ = ''
                    )
                from ZG1010 ZG1 (nolock)
                where
                        ZG1.ZG1_TIPO = cast(ZC2.ZC2_TIPO as int)
                    and left(ZC2.ZC2_COMPET, 6) = ZG1.ZG1_COMPET
                    and ZC2.ZC2_COD = trim(ZG1.ZG1_CODIGO)
                    and ZG1.D_E_L_E_T_ = ''
            )
            when cast(ZC2.ZC2_TIPO as int) = 9 then
            (
                select
                    ZG1.ZG1_VLIMPR/
                    (
                        select sum(ZG1010.ZG1_VLIMPR)
                        from ZG1010
                        where
                            ZG1010.ZG1_VLIMPR != 0
                        and ZG1010.ZG1_FILORI = ZG1.ZG1_FILORI
                        and ZG1010.ZG1_COMPET = ZG1.ZG1_COMPET
                        and ZG1010.ZG1_CODIGO = ZG1.ZG1_CODIGO
                        and ZG1010.D_E_L_E_T_ = ''
                    )
                from ZG1010 ZG1 (nolock)
                where
                        ZG1.ZG1_TIPO = cast(ZC2.ZC2_TIPO as int)
                    and left(ZC2.ZC2_COMPET, 6) = ZG1.ZG1_COMPET
                    and ZC2.ZC2_COD = trim(ZG1.ZG1_CODIGO)
                    and ZG1.D_E_L_E_T_ = ''
            )
            when cast(ZC2.ZC2_TIPO as int) = 12 then
            (
                select
                    ZG1.ZG1_VLIMPR/
                    (
                        select sum(ZG1010.ZG1_VLIMPR)
                        from ZG1010
                        where
                            ZG1010.ZG1_VLIMPR != 0
                        and ZG1010.ZG1_FILORI = ZG1.ZG1_FILORI
                        and ZG1010.ZG1_COMPET = ZG1.ZG1_COMPET
                        and ZG1010.ZG1_CODIGO = ZG1.ZG1_CODIGO
                        and ZG1010.D_E_L_E_T_ = ''
                    )
                from ZG1010 ZG1 (nolock)
                where
                        ZG1.ZG1_TIPO = cast(ZC2.ZC2_TIPO as int)
                    and left(ZC2.ZC2_COMPET, 6) = ZG1.ZG1_COMPET
                    and ZC2.ZC2_COD = trim(ZG1.ZG1_CODIGO)
                    and ZG1.D_E_L_E_T_ = ''
            )
        else 0.0 end as numeric(15, 2)
    ) as RATEIO_IMP

from ZC2010 ZC2 (nolock)
where ZC2.D_E_L_E_T_ = ''
