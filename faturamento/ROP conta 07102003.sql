select
    ZG1.ZG1_FILORI as FILIAL,
    ZC2.ZC2_NUM as NUM,
    '305' as CC,
    sum(ZC2.ZC2_TOTAL * ZG1.VL_RIMP) as VALOR
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
            ) as VL_RIMP
        from ZG1010 G1 (nolock)
        where G1.D_E_L_E_T_ = '' and G1.ZG1_TIPO = '12'
    ) ZG1
        on left(isnull(nullif(ZC2.ZC2_COMPET, ''), '20231231'), 6) = ZG1.ZG1_COMPET
        and ZC2.ZC2_COD = trim(ZG1.ZG1_CODIGO)
where
        ZC2.D_E_L_E_T_ = ''
    and ZC2.ZC2_TIPO = '16'
group by ZG1.ZG1_FILORI, ZC2.ZC2_NUM
