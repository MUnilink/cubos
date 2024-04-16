select
    trim(ZA7010.ZA7_COD) as COD_DESPESA,
    trim(ZA7010.ZA7_DESC) as DESPESA,
    convert(date, CT2010.CT2_DATA, 103) as DATA,
    substring(CT2010.CT2_DATA, 1, 6) as PERIODO,
    case when CT2010.CT2_DEBITO between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM then cast(CT2010.CT2_VALOR as numeric(15, 2)) else case when CT2010.CT2_CREDIT between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM then cast(CT2010.CT2_VALOR as numeric(15, 2))*-1 else 0.0 end end as VALOR,
    trim(CT2010.CT2_DEBITO) as CONTA_DEBITO,
    trim(CT2010.CT2_CREDIT) as CONTA_CREDITO,
    trim(CT2010.CT2_ITEMD) as ATIVIDADE_DEB,
    trim(CT2010.CT2_ITEMC) as ATIVIDADE_CRE,
    trim(CT2010.CT2_CCD) as CC_DEB,
    trim(CT2010.CT2_CCC) as CC_CRE
from CT2010 (nolock)
    inner join ZA8010 (nolock)
        on ZA8010.D_E_L_E_T_ = ''
        and (CT2010.CT2_DEBITO between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM or CT2010.CT2_CREDIT between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM)
        and (CT2010.CT2_ITEMD between ZA8010.ZA8_CTDINI and ZA8010.ZA8_CTDFIM or CT2010.CT2_ITEMC between ZA8010.ZA8_CTDINI and ZA8010.ZA8_CTDFIM)
        and (CT2010.CT2_CCD between ZA8010.ZA8_CTTINI and ZA8010.ZA8_CTTFIM or CT2010.CT2_CCC between ZA8010.ZA8_CTTINI and ZA8010.ZA8_CTTFIM)

        inner join ZA7010 (nolock)
            on ZA7010.D_E_L_E_T_ = ''
            and ZA7010.ZA7_COD = ZA8010.ZA8_COD
where
        CT2010.D_E_L_E_T_ = ''
