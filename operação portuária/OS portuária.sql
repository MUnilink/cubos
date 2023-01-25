select
    ZC1.ZC1_FILIAL,
    ZC1.ZC1_NUM,
    ZC2.ZC2_ITEM,
    ZC2.ZC2_COD,
    
    ZC2.ZC2_QTDPRV,
    ZC2.ZC2_QTDREA,
    ZC2.ZC2_VLUPRV,
    ZC2.ZC2_VLUREA,
    
    convert(datetime, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), 103) as ZC2_DTINI,
    convert(datetime, concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM), 103) as ZC2_DTFIM,
    ZC2.ZC2_NMUSU
from ZC2010 ZC2 (nolock)
    inner join ZC1010 ZC1 (nolock)
        on ZC1.D_E_L_E_T_ = ''
        and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
        and ZC1.ZC1_NUM = ZC2.ZC2_NUM
where ZC2.D_E_L_E_T_ = ''
