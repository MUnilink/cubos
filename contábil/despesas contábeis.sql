select
    trim(ZA7.ZA7_COD) as COD_DESPESA,
    trim(ZA7.ZA7_DESC) as DESPESA,
    trim(ZA8.ZA8_CT1INI) as CONTA_INI,
    (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = trim(ZA8.ZA8_CT1INI)) as DCONTA_INI,
    trim(ZA8.ZA8_CT1FIM) as CONTA_FIM,
    (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = trim(ZA8.ZA8_CT1FIM)) as DCONTA_FIM,
    trim(ZA8.ZA8_CTTINI) as CC_INI,
    trim(ZA8.ZA8_CTTFIM) as CC_FIM,
    trim(ZA8.ZA8_CTDINI) as ITEM_INI,
    trim(ZA8.ZA8_CTDFIM) as ITEM_FIM,
    cast(CT2.CT2_DATA as date) as DATA,
    left(CT2.CT2_DATA, 6) as PERIODO,
    case when CT2.CT2_DEBITO between ZA8.ZA8_CT1INI and ZA8.ZA8_CT1FIM then cast(CT2.CT2_VALOR as numeric(15, 2)) else case when CT2.CT2_CREDIT between ZA8.ZA8_CT1INI and ZA8.ZA8_CT1FIM then cast(CT2.CT2_VALOR as numeric(15, 2))*-1 else 0.0 end end as VALOR,
    trim(CT2.CT2_DEBITO) as CONTA_DEBITO,
    trim(CT2.CT2_CREDIT) as CONTA_CREDITO,
    trim(CT2.CT2_ITEMD) as ATIVIDADE_DEB,
    trim(CT2.CT2_ITEMC) as ATIVIDADE_CRE,
    trim(CT2.CT2_CCD) as CC_DEB,
    trim(CT2.CT2_CCC) as CC_CRE
from CT2010 CT2 (nolock)
    inner join ZA8010 ZA8 (nolock)
        on ZA8.D_E_L_E_T_ = ''
        and (CT2.CT2_DEBITO between ZA8.ZA8_CT1INI and ZA8.ZA8_CT1FIM or CT2.CT2_CREDIT between ZA8.ZA8_CT1INI and ZA8.ZA8_CT1FIM)
        and (CT2.CT2_ITEMD between ZA8.ZA8_CTDINI and ZA8.ZA8_CTDFIM or CT2.CT2_ITEMC between ZA8.ZA8_CTDINI and ZA8.ZA8_CTDFIM)
        and (CT2.CT2_CCD between ZA8.ZA8_CTTINI and ZA8.ZA8_CTTFIM or CT2.CT2_CCC between ZA8.ZA8_CTTINI and ZA8.ZA8_CTTFIM)

        inner join ZA7010 ZA7 (nolock)
            on ZA7.D_E_L_E_T_ = ''
            and ZA7.ZA7_COD = ZA8.ZA8_COD
where
        CT2.D_E_L_E_T_ = ''
