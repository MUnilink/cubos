select
/*
	ZD3.ZD3_LITROS,
	ZD3.ZD3_VLUNI,
	ZD3.ZD3_HODOM,
	ZD3.ZD3_KMRD,
	ZD3.ZD3_KML,
	ZD3.ZD3_TOTAL,	
    convert(date, ZD3.ZD3_DATA, 103) as ZD3_DATA,
	substring(ZD3.ZD3_DATA, 1, 6) as PERIODO_ZD3,
*/
	trim(TQI.TQI_TANQUE) as TANQUE,
	trim(ST9.T9_CODBEM) as EQUIPAMENTO,
	trim(TQN.TQN_CCUSTO) as CC,
	trim(TQN.TQN_YITMCT) as ATIVIDADE,
	trim(TQM.TQM_NOMCOM) as COMBUSTIVEL,
	(
		select avg(SD1010.D1_VUNIT)
		from SD1010
		where
				SD1010.D_E_L_E_T_ = ''
			and SD1010.D1_COD = '11100008'
			and SD1010.D1_TES = 42
			and substring(SD1010.D1_DTDIGIT, 1, 6) = substring(TQN.TQN_DTABAS, 1, 6)
	) as VALOR_COMPRA,
	
	substring(TQN.TQN_DTABAS, 1, 6) as PERIODO_TQN,
	convert(datetime, concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS), 113) as DATA_ABA,
	TQN.TQN_QUANT as LITROS,
	TQN.TQN_VALUNI as VALOR_UNI,
	TQN.TQN_VALTOT as VALOR_TOTAL,
	SD3.D3_NUMSEQ,
	SD3.D3_LOCAL,
	SD3.D3_DOC,
	SD3.D3_TM,
	SD3.D3_CF,
	SD3.D3_QUANT,
	SD3.D3_CUSTO1
from TQN010 TQN (nolock)
	left join SD3010 SD3 (nolock)
		on SD3.D_E_L_E_T_ = ''
		and SD3.D3_FILIAL = TQN.TQN_FILIAL
		and SD3.D3_LOCAL = TQN.TQN_TANQUE
		and SD3.D3_NUMSEQ = TQN.TQN_NUMSEQ
	left join TQI010 TQI (nolock)
		on TQI.D_E_L_E_T_ = ''
		and TQI.TQI_FILIAL = TQN.TQN_FILIAL
		and TQI.TQI_TANQUE = TQN.TQN_TANQUE

		left join TQF010 TQF (nolock)
			on TQF.D_E_L_E_T_ = ''
			and TQF.TQF_FILIAL = TQI.TQI_FILIAL
			and TQF.TQF_CODIGO = TQI.TQI_CODPOS 
			and TQF.TQF_LOJA = TQI.TQI_LOJA

	left join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = TQN.TQN_FROTA
	left join TQM010 TQM (nolock)
		on TQM.D_E_L_E_T_ = ''
		and TQM.TQM_CODCOM = TQN.TQN_CODCOM
where
		TQN.D_E_L_E_T_ = ''
	and year(TQN.TQN_DTABAS) > 2022
