	select
		concat(trim(ST9.T9_FILIAL), trim(ST9.T9_CODBEM)) as ID_VEICULOTMS,
		trim(ST9010.T9_CODBEM) as COD_VEICULO,
		trim(ST9.T9_NOME) as DESC_VEICULO,
		trim(ST9.T9_PLACA) as PLACA_VEICULO,
		trim(ST9010.T9_YPORTAL) as APP_PORT
	from ST9010 ST9	
	where ST9.D_E_L_E_T_ = ''
union
		select null, null, null, null, null