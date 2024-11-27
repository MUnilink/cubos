select
    SD2.D2_FILIAL as FILIAL,
    SC6.C6_YOS as NUM,
    sum(cast(coalesce(SD2.D2_VALIMP5, 0) as decimal(14, 2))) as TOTAL
from SD2010 SD2
    left join SC6010 SC6
        on SC6.D_E_L_E_T_ = ''
        and SC6.C6_FILIAL = SD2.D2_FILIAL
        and SC6.C6_NUM = SD2.D2_PEDIDO
        and SC6.C6_ITEM = SD2.D2_ITEMPV
where SD2.D_E_L_E_T_ = ''
group by
    SD2.D2_FILIAL,
    SC6.C6_YOS
