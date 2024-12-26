select
    ZG1.ZG1_FILORI as FILIAL,
    ZC2.ZC2_NUM as NUM,
    ZC2.ZC2_ITEM as ITEM,
    ZG1.ZG1_FILORI,
    ZG1.ZG1_COMPET,
    ZG1.ZG1_CODIGO,
    ZG1.ZG1_TIPO,
    cast(ZG1.ZG1_VLIMPR as numeric(15, 2)) as VAL_IMPR,
    cast(ZG1.VL_ITOTAL as numeric(15, 2)) as VAL_TOTAL,
    cast(ZC2.ZC2_TOTAL as numeric(15, 2)) as VAL_ITEM,
    cast(ZG1.VL_RIMP as numeric(15, 2)) as RATEIO,
    cast(ZC2.ZC2_TOTAL * ZG1.VL_RIMP as numeric(15, 2)) as VIMP_ITEM
from ZC2010 ZC2 (nolock)
    inner join
    (
        select
            G1.ZG1_FILORI,
            G1.ZG1_COMPET,
            G1.ZG1_CODIGO,
            G1.ZG1_TIPO,
            G1.ZG1_VLIMPR,
            G1.ZG1_VLIMPR/
            (
                select sum(ZG1010.ZG1_VLIMPR)
                from ZG1010
                where
                    ZG1010.D_E_L_E_T_ = ''
                and ZG1010.ZG1_VLIMPR != 0
                and ZG1010.ZG1_FILORI = G1.ZG1_FILORI
                and ZG1010.ZG1_COMPET = G1.ZG1_COMPET
                and ZG1010.ZG1_CODIGO = G1.ZG1_CODIGO
            ) as VL_RIMP,
            (
                select sum(ZG1010.ZG1_VLIMPR)
                from ZG1010
                where
                    ZG1010.D_E_L_E_T_ = ''
                and ZG1010.ZG1_VLIMPR != 0
                and ZG1010.ZG1_FILORI = G1.ZG1_FILORI
                and ZG1010.ZG1_COMPET = G1.ZG1_COMPET
                and ZG1010.ZG1_CODIGO = G1.ZG1_CODIGO
            ) as VL_ITOTAL
        from ZG1010 G1 (nolock)
        where G1.D_E_L_E_T_ = '' and G1.ZG1_TIPO = '2'
    ) ZG1
        on left(ZC2.ZC2_COMPET, 6) = ZG1.ZG1_COMPET
        and ZC2.ZC2_FILIAL = ZG1.ZG1_FILORI
        and ZC2.ZC2_COD = trim(ZG1.ZG1_CODIGO)
where
        ZC2.D_E_L_E_T_ = ''
    and ZC2.ZC2_TIPO = '15'
