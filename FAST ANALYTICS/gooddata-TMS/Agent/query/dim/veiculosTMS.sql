select
    trim(DA3.DA3_COD) as ID_VEI,
    trim(DA3.DA3_COD) as DA3_COD,
    trim(DA3.DA3_DESC) as DA3_DESC,
    trim(DA3.DA3_PLACA) as DA3_PLACA,
    <<CODE_INSTANCE>> AS INSTANCIA
from DA3010 DA3
where DA3.D_E_L_E_T_ = ''
