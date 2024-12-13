select
    ZG1.ZG1_FILORI as FILIAL,
    ZC2.ZC2_NUM as NUM,
    '305' as CC,
    ZG1.ZG1_VLIMPR/
    (
        select sum(ZG1010.ZG1_VLIMPR)
        from ZG1010
        where
                ZG1010.ZG1_TIPO = '14'
            and ZG1010.ZG1_VLIMPR != 0
            and ZG1010.D_E_L_E_T_ = ''
            and ZG1010.ZG1_COMPET = ZG1.ZG1_COMPET
            and ZG1010.ZG1_CODIGO = ZG1.ZG1_CODIGO
    ) as VALOR
from ZC2010 ZC2 (nolock)
    inner join ZG1010 ZG1 (nolock)
        on ZG1.D_E_L_E_T_ = ''
        and left(isnull(nullif(ZC2.ZC2_COMPET, ''), '20231231'), 6) = ZG1.ZG1_COMPET
        and ZC2.ZC2_COD = trim(ZG1.ZG1_CODIGO)
where
        ZC2.D_E_L_E_T_ = ''
