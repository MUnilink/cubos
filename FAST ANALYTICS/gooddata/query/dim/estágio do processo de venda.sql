select
    substring(AC2.AC2_PROVEN, 1, 9) as AC2_PROVEN,
    substring(AC2.AC2_STAGE, 1, 9) as AC2_STAGE,
    substring(AC2.AC2_DESCRI, 1, 9) as AC2_DESCRI
from AC2010 AC2
where AC2.D_E_L_E_T_ = ''
