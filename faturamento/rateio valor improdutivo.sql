select
    ZG1.ZG1_FILORI as FILIAL,
    ZC2.ZC2_NUM as NUM,
    ZC2.ZC2_ITEM as ITEM,
    ZG1.ZG1_FILORI,
    ZG1.ZG1_COMPET,
    case when cast(ZC2.ZC2_TIPO as int) in (15, 16) then ZG1.ZG1_TIPO else cast(ZC2.ZC2_TIPO as int) end as ZC2_TIPO,
    trim(ZG1.ZG1_CODIGO) as INSUMO,
    cast(ZG1.ZG1_VLIMPR as numeric(15, 2)) as VAL_IMPR,
    cast(ZG1.perc as numeric(15, 2)) as SOMA_IMPR,
    cast(ZC2.ZC2_TOTAL as numeric(15, 2)) as VAL_ITEM,
    cast(ZG1.RATEIO as numeric(15, 2)) as RATEIO,
    cast(ZC2.ZC2_TOTAL * ZG1.RATEIO as numeric(15, 2)) as VIMP_ITEM
from ZC2010 ZC2 (nolock)
    inner join
    (
        select
            G1.ZG1_FILORI,
            G1.ZG1_COMPET,
            G1.ZG1_CODIGO,
            G1.ZG1_TIPO,
            G1.ZG1_VLIMPR,
            case when G1.ZG1_HRIMPR != 0 then G1.ZG1_VLIMPR/
            (
                select case when coalesce(nullif(floor(sum(ZG1010.ZG1_VLIMPR)), 0), 0) = 0 then 1 else sum(ZG1010.ZG1_VLIMPR) end
                from ZG1010
                where
                    ZG1010.ZG1_VLIMPR != 0
                and ZG1010.ZG1_FILORI = G1.ZG1_FILORI
                and ZG1010.ZG1_COMPET = G1.ZG1_COMPET
                and ZG1010.ZG1_CODIGO = G1.ZG1_CODIGO
                and ZG1010.D_E_L_E_T_ = ''
            ) else 0.0 end as RATEIO,
            (
                select case when coalesce(nullif(floor(sum(ZG1010.ZG1_VLIMPR)), 0), 0) = 0 then 1 else sum(ZG1010.ZG1_VLIMPR) end
                from ZG1010
                where
                    ZG1010.ZG1_VLIMPR != 0
                and ZG1010.ZG1_FILORI = G1.ZG1_FILORI
                and ZG1010.ZG1_COMPET = G1.ZG1_COMPET
                and ZG1010.ZG1_CODIGO = G1.ZG1_CODIGO
                and ZG1010.D_E_L_E_T_ = ''
            ) as perc
        from ZG1010 G1 (nolock)
        where G1.D_E_L_E_T_ = ''
    ) ZG1
        on left(ZC2.ZC2_COMPET, 6) = ZG1.ZG1_COMPET
        and ZC2.ZC2_FILIAL = ZG1.ZG1_FILORI
        and ZC2.ZC2_COD = trim(ZG1.ZG1_CODIGO)
        and cast(ZC2.ZC2_TIPO as int) = case when ZG1.ZG1_TIPO in (2, 14) then 15 when ZG1.ZG1_TIPO in (3, 6, 9, 12) then 16 else 0 end
where
        ZC2.D_E_L_E_T_ = ''
