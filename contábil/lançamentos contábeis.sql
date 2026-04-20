select
    cast(CT2.CT2_DATA as date) as DATA,
    left(CT2.CT2_DATA, 6) as PERIODO,
    trim(CT2.CT2_DEBITO) as CONTA_DEBITO,
    (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = CT2.CT2_DEBITO) as DESCONTA_DEB,
    trim(CT2.CT2_CREDIT) as CONTA_CREDITO,
    (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = CT2.CT2_CREDIT) as DESCONTA_CRE,
    cast(CT2.CT2_VALOR as numeric(15, 2)) as VALOR,
    
    trim(CT2.CT2_ITEMD) as AT_DEB,
    trim(CT2.CT2_ITEMC) as AT_CRE,
    trim(CT2.CT2_CCD) as CC_DEB,
    trim(CT2.CT2_CCC) as CC_CRE,
    
    trim(CT2.CT2_HIST) as HISTORICO, /* CF.1551 -12060311-VR NF.000325986-PEDREI */
    trim(CT2.CT2_HIST) as NF
from CT2010 CT2 (nolock)
where
        left(CT2.CT2_DATA, 6)=:PERIODO
    and CT2.D_E_L_E_T_ = ''
