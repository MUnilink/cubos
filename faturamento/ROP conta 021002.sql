select
    SD2.D2_FILIAL as FILIAL,
    SC6.C6_YOS as NUM,
    SC6.C6_CC as CC,
    sum(cast(coalesce(SD2.D2_VALISS, 0) as decimal(14, 2))) as TOTAL
from SD2010 SD2
    inner join SC6010 SC6
        on SC6.D_E_L_E_T_ = ''
        and SC6.C6_FILIAL = SD2.D2_FILIAL
        and SC6.C6_NUM = SD2.D2_PEDIDO
        and SC6.C6_ITEM = SD2.D2_ITEMPV
        
        inner join ZC2010 ZC2 (nolock)
            on ZC2.D_E_L_E_T_ = ''
            and ZC2.ZC2_FILIAL = SC6.C6_FILIAL
            and ZC2.ZC2_NUM = SC6.C6_YOS
            and ZC2.ZC2_ITEM = SC6.C6_YITOS
where
        SD2.D_E_L_E_T_ = ''
    and left(SD2.D2_EMISSAO, 6) = '"+cCompt+"' and SD2.D2_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
group by SD2.D2_FILIAL, SC6.C6_YOS, SC6.C6_CC
