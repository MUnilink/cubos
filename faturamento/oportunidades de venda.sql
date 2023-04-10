select
    AD2.AD2_DESCRI as ESTAGIO_PROCESSO,
from AD1010 AD1 (nolock)
    inner join SA3010 SA3 (nolock)
        on SA3.D_E_L_E_T_ = ''
        and SA3.A3_COD = AD1.AD1_VEND
    inner join AD2010 AD2 (nolock)
        on AD2.D_E_L_E_T_ = ''
        and AD2.AD2_PROVEN = AD1.AD1_PROVEN
        and AD2.AD2_STAGE = AD1.AD1_STAGE
where AD1.D_E_L_E_T_ = ''
