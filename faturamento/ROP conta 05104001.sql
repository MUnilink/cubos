select
    ZC2.ZC2_FILIAL as FILIAL,
    ZC2.ZC2_NUM as NUM,
    (
        select isnull(avg(cast(nullif(SC6010.C6_CC, '') as int)), '305') /* pois cortesia */
        from SC6010
        where
                SC6010.D_E_L_E_T_ = ''
            and SC6010.C6_FILIAL = ZC2.ZC2_FILIAL
            and SC6010.C6_YOS = ZC2.ZC2_NUM
    ) as CC,
    sum(cast(coalesce(ZC2.ZC2_TOTAL, 0) as decimal (14, 2))) as TOTAL
from ZC2010 ZC2
where
        ZC2.D_E_L_E_T_ = ''
    and ZC2.ZC2_TIPO = 11 and ZC2.ZC2_YFORNE = '000052'
    and left(ZC2.ZC2_COMPET, 6) = '"+cCompt+"' and ZC2.ZC2_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
group by ZC2.ZC2_FILIAL, ZC2.ZC2_NUM
