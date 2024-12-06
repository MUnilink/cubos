select
    SC7.C7_FILIAL as FILIAL,
    ZC2.ZC2_NUM as NUM,
    SD3.D3_CC as CC,
	sum(cast(coalesce(SD1.D1_TOTAL, 0) as decimal (14, 2))) as TOTAL
from SC7010 SC7
	left join SD1010 SD1
		on SD1.D_E_L_E_T_ = ''
		and SD1.D1_FILIAL = SC7.C7_FILIAL
		and SD1.D1_PEDIDO = SC7.C7_NUM
		and SD1.D1_ITEMPC = SC7.C7_ITEM
    inner join ZC2010 ZC2
        on case when trim(SC7.C7_YOS) = '2024/0' then right(left(replace(replace(SC7.C7_OBS, char(10), ''), char(13), ''), 63), 11) else SC7.C7_YOS end = ZC2.ZC2_NUM
        and SC7.C7_YOSIT = ZC2.ZC2_ITEM
        and SC7.D_E_L_E_T_ = ''
where
        cast(SC7.C7_FORNECE as int) not in (52, 4997)
    and SC7.D_E_L_E_T_ = ''
    and left(SC7.C7_EMISSAO, 6) = '"+cCompt+"' and SC7.C7_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
group by
    SC7.C7_FILIAL,
    ZC2.ZC2_NUM
