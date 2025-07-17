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
        and ZC2.ZC2_TIPO = 9
        and left(ZC2.ZC2_COMPET, 6) = '"+cCompt+"' and ZC2.ZC2_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
    group by ZC2.ZC2_FILIAL, ZC2.ZC2_NUM
union
    select
        ZE1.ZE1_FILIAL as FILIAL,
        ZE1.ZE1_NUM as NUM,
        '304' as CC,
        sum(cast(coalesce(ZE1.ZE1_TOTAL, 0) as decimal (14, 2))) as TOTAL
    from ZE1010 ZE1
    where
            ZE1.D_E_L_E_T_ = ''
        and ZE1.ZE1_TIPO = 9
        and left(ZE1.ZE1_COMPET, 6) = '"+cCompt+"' and ZE1.ZE1_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
    group by ZE1.ZE1_FILIAL, ZE1.ZE1_NUM
