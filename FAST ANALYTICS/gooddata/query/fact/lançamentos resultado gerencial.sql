select
	ZE3.ZE3_NUM as ,
    ZE3.ZE3_COMPET as ,
    ZE3.ZE3_ITEMPL as ,
    ZE3.ZE3_VALOR as ,
from ZE3010 ZE3
    inner join ZE2010 ZE2
        on ZE2.D_E_L_E_T_ = ''
        and ZE2.ZE2_COD = ZE3.ZE3_ITEMPL
    inner join ZC1010 ZC1
        on ZC1.D_E_L_E_T_ = ''
        and concat(ZC1.ZC1_FILIAL, ZC1.ZC1_NUM) = ZE3.ZE3_NUM
where
        ZE3.D_E_L_E_T_ = ''
    and ZE3.ZE3_ORIGEM = 'POR'
