select
    trim(ST9.T9_CODBEM) as ID_EQUIPAMENTO,
    trim(ST9.T9_CODBEM) as CODBEM,
    trim(upper(ST9.T9_NOME)) as NOME,
    (select trim(upper(ST6010.T6_NOME)) from ST6010 where ST6010.D_E_L_E_T_ = '' and ST6010.T6_CODFAMI = ST9.T9_CODFAMI) as FAMILIA,
    (select trim(upper(TQR010.TQR_DESMOD)) from TQR010 where TQR010.D_E_L_E_T_ = '' and TQR010.TQR_TIPMOD = ST9.T9_TIPMOD) as MODELO,
    <<CODE_INSTANCE>> AS INSTANCIA
from ST9010 ST9
where
        ST9.D_E_L_E_T_ = ''
    and ST9.T9_CATBEM in (2, 4)
    and ST9.T9_CCUSTO in (304, 305)
