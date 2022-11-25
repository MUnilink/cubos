select
    concat(trim(DA4.DA4_FILATU), trim(DA4.DA4_COD)) as ID_MOT,
    trim(DA4.DA4_COD) as DA4_COD,
    trim(DA4.DA4_MAT) as DA4_MAT,
    trim(DA4.DA4_NOME) as DA4_NOME,
    <<CODE_INSTANCE>> AS INSTANCIA
from DA4010 DA4
where DA4.D_E_L_E_T_ = ''
