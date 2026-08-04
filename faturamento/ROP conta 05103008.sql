select
    ZE1.ZE1_FILIAL as FILIAL,
    ZE1.ZE1_NUM as NUM,
    '304      ' as CC,
    '11       ' as ITEM,
    sum(cast(coalesce(ZE1.ZE1_TOTAL, 0) as decimal (14, 2))) as TOTAL
from ZE1010 ZE1
where
        ZE1.D_E_L_E_T_ = ''
    and ZE1.ZE1_TIPO = 19
    and left(ZE1.ZE1_COMPET, 6) = '"+cCompt+"' and ZE1.ZE1_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
group by ZE1.ZE1_FILIAL, ZE1.ZE1_NUM
