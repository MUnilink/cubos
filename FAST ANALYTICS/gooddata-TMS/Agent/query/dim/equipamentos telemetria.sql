select
    trim(ST9.T9_CODBEM) as ID_EQUIPAMENTO,
    trim(ST9.T9_CODBEM) as CODBEM,
    trim(ST9.T9_NOME) as NOME,
    trim(ST9.T9_CODFAMI) as FAMILIA,
    <<CODE_INSTANCE>> AS INSTANCIA
from ST9010 ST9
where
        ST9.D_E_L_E_T_ = ''
    and ST9.T9_CATBEM in (2, 4)
    and ST9.T9_CCUSTO in (304, 305)
