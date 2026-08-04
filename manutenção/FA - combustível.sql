select
	trim(TQN.TQN_FILIAL) as FILIAL,
	trim(TQI.TQI_TANQUE) as TANQUE,
	trim(TQF.TQF_FILIAL) as FILIAL_POSTO,
	trim(TQF.TQF_CODIGO) as COD_POSTO,
	trim(TQF.TQF_LOJA) as LOJA,
	trim(TQF.TQF_CNPJ) as CNPJ,
	trim(TQF.TQF_NREDUZ) as DESC_POSTO,
	trim(TQF.TQF_CIDADE) as CIDADE_POSTO,
	trim(ST9.T9_CODBEM) as EQUIPAMENTO,
	trim(TQN.TQN_CCUSTO) as CC,
	trim(TQN.TQN_YITMCT) as ATIVIDADE,
	trim(TQM.TQM_NOMCOM) as COMBUSTIVEL,
	(select sum(SD1010.D1_TOTAL) from SD1010 where SD1010.D_E_L_E_T_ = '' and SD1010.D1_COD = '11100008' and SD1010.D1_TES in (42, 44) and left(SD1010.D1_DTDIGIT, 6) = left(TQN.TQN_DTABAS, 6))/
	(select sum(SD1010.D1_QUANT) from SD1010 where SD1010.D_E_L_E_T_ = '' and SD1010.D1_COD = '11100008' and SD1010.D1_TES in (42, 44) and left(SD1010.D1_DTDIGIT, 6) = left(TQN.TQN_DTABAS, 6)) as VALOR_COMPRA,
	
	substring(TQN.TQN_DTABAS, 1, 6) as PERIODO_TQN,
	convert(datetime, concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS), 113) as DATA_ABA,
	convert(datetime, lag(concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS), 1, null) over (partition by TQN.TQN_FROTA, TQN.TQN_CODCOM order by TQN.TQN_FROTA, TQN.TQN_DTABAS, TQN.TQN_HRABAS), 113) as DATA_ANT,
	TQN.TQN_YTIPO as TIPO_ABA,
	TQN.TQN_QUANT as LITROS,
	TQN.TQN_VALUNI as VALOR_UNI,
	TQN.TQN_VALTOT as VALOR_TOTAL,

	trim(ST9.T9_CODFAMI) as FAMILIA,
	TQN.TQN_HODOM as CONT_ATU,
	
	case
		when ST9.T9_CODFAMI in ('VP', 'VM') and (TQN.TQN_YTIPO = 'P' or TQN.TQN_CODCOM = 2) then TQN.TQN_HODOM
		when ST9.T9_CODFAMI in ('VP', 'VM') and TQN.TQN_YTIPO != 'P' then (select max(STP010.TP_POSCONT) from STP010 where STP010.D_E_L_E_T_ = '' and TQN.TQN_YTIPO = 'C' and STP010.TP_TIPOLAN = 'A' and STP010.TP_CODBEM = TQN.TQN_FROTA and concat(STP010.TP_DTLEITU, ' ', STP010.TP_HORA) < concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS)) /* não calcula para ARLA e parcial*/
		when TQN.TQN_HODOM < lag(TQN.TQN_HODOM, 1, 0) over (partition by TQN.TQN_FROTA, TQN.TQN_CODCOM order by TQN.TQN_FROTA, TQN.TQN_DTABAS, TQN.TQN_HRABAS) then (select max(TQN010.TQN_HODOM) from TQN010 where TQN010.D_E_L_E_T_ = '' and TQN010.TQN_FROTA = TQN.TQN_FROTA and concat(TQN010.TQN_DTABAS, ' ', TQN010.TQN_HRABAS) < concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS) and TQN010.TQN_HODOM < TQN.TQN_HODOM) /* quando quebra */
		else (select max(STP010.TP_POSCONT) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = TQN.TQN_FROTA and concat(STP010.TP_DTLEITU, ' ', STP010.TP_HORA) < concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS))
	end as CONT_ANT,
	(select ZD3010.ZD3_KMRD from ZD3010 where ZD3010.D_E_L_E_T_ = '' and TQN.TQN_FROTA = ZD3010.ZD3_VEICUL and TQN.TQN_DTABAS = substring(ZD3010.ZD3_DATA, 1, 8) and TQN.TQN_HRABAS = substring(ZD3010.ZD3_DATA, 10, 14)) as km_ZD3,
	
	case
		when ST9.T9_CODFAMI in ('VP', 'VM') and (TQN.TQN_YTIPO = 'P' or TQN.TQN_CODCOM != '001') then 0.0 /* não calcula para ARLA e parcial*/
		when ST9.T9_CODFAMI in ('VP', 'VM') and TQN.TQN_YTIPO != 'P' then TQN.TQN_HODOM - (select max(STP010.TP_POSCONT) from STP010 where STP010.D_E_L_E_T_ = '' and TQN.TQN_YTIPO = 'C' and STP010.TP_TIPOLAN = 'A' and TQN.TQN_YTIPO = 'C' and STP010.TP_CODBEM = TQN.TQN_FROTA and concat(STP010.TP_DTLEITU, ' ', STP010.TP_HORA) < concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS))
		when TQN.TQN_HODOM < lag(TQN.TQN_HODOM, 1, 0) over (partition by TQN.TQN_FROTA, TQN.TQN_CODCOM order by TQN.TQN_FROTA, TQN.TQN_DTABAS, TQN.TQN_HRABAS) then TQN.TQN_HODOM /* quando quebra */
		else TQN.TQN_HODOM - (select max(STP010.TP_POSCONT) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = TQN.TQN_FROTA and concat(STP010.TP_DTLEITU, ' ', STP010.TP_HORA) < concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS))
	end as km_TQN

from TQN010 TQN (nolock)
	left join TQI010 TQI (nolock)
		on TQI.D_E_L_E_T_ = ''
		and TQI.TQI_FILIAL = TQN.TQN_FILIAL
		and TQI.TQI_CODPOS = TQN.TQN_POSTO
		and TQI.TQI_LOJA = TQN.TQN_LOJA
		and TQI.TQI_TANQUE = TQN.TQN_TANQUE
	left join TQF010 TQF (nolock)
		on TQF.D_E_L_E_T_ = ''
		and TQF.TQF_FILIAL = TQN.TQN_FILIAL
		and TQF.TQF_CODIGO = TQN.TQN_POSTO
		and TQF.TQF_LOJA = TQN.TQN_LOJA
	left join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = TQN.TQN_FROTA
	left join TQM010 TQM (nolock)
		on TQM.D_E_L_E_T_ = ''
		and TQM.TQM_CODCOM = TQN.TQN_CODCOM
where
		TQN.D_E_L_E_T_ = ''
