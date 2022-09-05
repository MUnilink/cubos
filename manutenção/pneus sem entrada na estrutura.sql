select
    STC.TC_CODBEM,
    STC.TC_COMPONE
from STC010 STC (nolock)
where
        STC.D_E_L_E_T_ = ''
    and not exists
    (
        select * from STZ010 where STZ010.D_E_L_E_T_ = '' and STZ010.TZ_CODBEM = STC.TC_COMPONE
    )
