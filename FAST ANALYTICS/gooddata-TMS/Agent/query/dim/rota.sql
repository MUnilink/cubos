select
    concat(trim(DA8010.DA8_FILIAL), trim(DA8010.DA8_COD)) as ID_ROTA,
    trim(DA8010.DA8_COD) as DA8_COD,
    trim(DA8010.DA8_DESC) as DA8_DESC,
    <<CODE_INSTANCE>> AS INSTANCIA
FROM DA8010
WHERE DA8010.D_E_L_E_T_ = ' '
union select null, null, null
