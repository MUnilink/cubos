select
    concat(trim(DA3.DA3_FILIAL), trim(DA3.DA3_COD)) as ID_VEICULOTMS,
	trim(DA3.DA3_COD) as COD_VEICULO,
	trim(DA3.DA3_DESC) as DESC_VEICULO,
	trim(DA3.DA3_PLACA) as PLACA_VEICULO,
	(select trim(ST9010.T9_YPORTAL) from ST9010 where ST9010.D_E_L_E_T_ = '' and ST9010.T9_CODBEM = DA3.DA3_COD) as APP_PORT
from DA3010 DA3	
where DA3.D_E_L_E_T_ = ''
