select
    ZC2.ZC2_FILIAL as FILIAL,
    ZC2.ZC2_NUM as NUM,
    ZC1.ZC1_CC as CC,
    ZC1.ZC1_ATIVD as ITEM,
    sum(cast(coalesce(ZC2.ZC2_TOTAL, 0) as decimal (14, 2))) as TOTAL
from ZC2010 ZC2
    inner join ZC1010 ZC1
        on ZC1.D_E_L_E_T_ = ''
        and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
        and ZC1.ZC1_NUM = ZC2.ZC2_NUM
where
        ZC2.D_E_L_E_T_ = ''
    and ZC2.ZC2_TIPO = 11 and ZC2.ZC2_YFORNE = '000052'
    and left(ZC2.ZC2_COMPET, 6) = '"+cCompt+"' and ZC2.ZC2_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
group by ZC2.ZC2_FILIAL, ZC2.ZC2_NUM, ZC1.ZC1_CC, ZC1.ZC1_ATIVD
