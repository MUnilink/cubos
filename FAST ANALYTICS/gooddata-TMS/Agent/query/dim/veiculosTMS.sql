select
    trim(ST9.T9_CODBEM) as ID_VEI,
    trim(ST9.T9_CODBEM) as DA3_COD,
    trim(ST9.T9_NOME) as DA3_DESC,
    trim(ST9.T9_PLACA) as DA3_PLACA,
    <<CODE_INSTANCE>> AS INSTANCIA
from ST9010 ST9
    left join DA3010 DA3
        on DA3.D_E_L_E_T_ = ''
        and DA3.DA3_COD = ST9.T9_CODBEM
where
        ST9.D_E_L_E_T_ = ''
    and ST9.T9_CATBEM in (2, 4)
    and ST9.T9_CCUSTO in (304, 305)
