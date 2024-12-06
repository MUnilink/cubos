select
    SD3.D3_FILIAL as FILIAL,
    ZC2.ZC2_NUM as NUM,
    SD3.D3_CC as CC,
    sum(cast(coalesce(SD3.D3_CUSTO1, 0) as decimal (14, 2))) as TOTAL
from SD3010 SD3
    inner join ZC2010 ZC2
        on ZC2.ZC2_NUM = SD3.D3_YOS
        and ZC2.ZC2_COD = SD3.D3_COD
        and ZC2.ZC2_FILIAL = SD3.D3_FILIAL
        and left(ZC2.ZC2_COMPET, 6) = left(SD3.D3_EMISSAO, 6)
        and ZC2.D_E_L_E_T_ = ''
    inner join SB1010 SB1
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SD3.D3_COD
where
        SB1.B1_YCTCUST = '320601003'
    and SD3.D3_ESTORNO = ''
    and SD3.D_E_L_E_T_ = ''
    and left(SD3.D3_EMISSAO, 6) = '"+cCompt+"' and SD3.D3_FILIAL between '"+cFilIni+"' and '"+cFilFim+"'
group by
    SD3.D3_FILIAL,
    ZC2.ZC2_NUM
