select
	ZD3.ZD3_LITROS as LITROS,
	ZD3.ZD3_KMRD as RODADO,
    ST9.T9_CODFAMI as FAMILIA,
	trim(isnull(ST9.T9_CODBEM, '-')) as EQUIPAMENTO,
	trim(isnull(TQM.TQM_NOMCOM, '-')) as COMBUSTIVEL,
	ZD3.TQN_DTABAS as PERIODO
from
	(
		select
			case cast(isnull(ZD3010.ZD3_TANQUE, TQN.TQN_TANQUE) as int)
				when 12 then '010102'
				else trim(isnull(ZD3010.ZD3_FILIAL, TQN.TQN_FILIAL))
			end as ZD3_FILIAL,
			ZD3010.ZD3_KM as ZD3_HODOM,

			isnull(ZD3010.ZD3_VEICUL, TQN.TQN_FROTA) as ZD3_VEICUL,
			isnull(ZD3010.ZD3_LITROS, TQN.TQN_QUANT) as ZD3_LITROS,
			isnull(ZD3010.ZD3_VLUNI, TQN.TQN_VALUNI) as ZD3_VLUNI,
			isnull(ZD3010.ZD3_TOTAL, TQN.TQN_VALTOT) as ZD3_TOTAL,
			ZD3010.ZD3_DTPROC,
			isnull(ZD3010.ZD3_TANQUE, TQN.TQN_TANQUE) as ZD3_TANQUE,
			ZD3010.ZD3_COMB,
			substring(ZD3010.ZD3_DATA, 1, 8) as ZD3_DATA,
			substring(ZD3010.ZD3_DATA, 10, 14) as ZD3_HORA,
			ZD3010.ZD3_KML,
			ZD3010.ZD3_KMRD,
			TQN.TQN_CCUSTO,
			TQN.TQN_YITMCT,
			
			convert(datetime, concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS), 113) as DATA_ABA,
			substring(TQN.TQN_DTABAS, 1, 6) as TQN_DTABAS,
			TQN.TQN_QUANT,
			TQN.TQN_VALUNI,
			TQN.TQN_VALTOT,

			SD3.D3_NUMSEQ,
			SD3.D3_LOCAL,
			SD3.D3_DOC,
			SD3.D3_TM,
			SD3.D3_CF,
			SD3.D3_COD,
			SD3.D3_QUANT,
			SD3.D3_CUSTO1
		from TQN010 TQN (nolock)
			left join ZD3010 (nolock)
				on ZD3010.D_E_L_E_T_ = ''
				and TQN.TQN_FROTA = ZD3010.ZD3_VEICUL
				and TQN.TQN_DTABAS = substring(ZD3010.ZD3_DATA, 1, 8)
				and TQN.TQN_HRABAS = substring(ZD3010.ZD3_DATA, 10, 14)
			left join SD3010 SD3 (nolock)
				on SD3.D_E_L_E_T_ = ''
				and SD3.D3_FILIAL = TQN.TQN_FILIAL
				and SD3.D3_LOCAL = TQN.TQN_TANQUE
				and SD3.D3_NUMSEQ = TQN.TQN_NUMSEQ
		where
				TQN.D_E_L_E_T_ = ''
			and year(TQN.TQN_DTABAS) > 2021
	) as ZD3

	left join
	(
		select
			case cast(TQI010.TQI_CODPOS as int)
				when 59 then '010102'
				else trim(isnull(TQI010.TQI_FILIAL, '-'))
			end as TQI_FILIAL,

			TQI010.TQI_CODPOS,
			TQI010.TQI_LOJA,
			TQI010.TQI_TANQUE,
			TQI010.TQI_YDETAN,
			TQI010.TQI_CODCOM,
			TQI010.TQI_PRODUT,
			TQI010.TQI_FABRIC
		from TQI010
		where TQI010.D_E_L_E_T_ = ''
	) as TQI
		on TQI.TQI_FILIAL = ZD3.ZD3_FILIAL
		and TQI.TQI_TANQUE = ZD3.ZD3_TANQUE

		left join
		(
			select
				case cast(TQF010.TQF_CODIGO as int)
					when 59 then '010102'
					else trim(isnull(TQF010.TQF_CODFIL, '-'))
				end as TQF_FILIAL,
				TQF010.TQF_CODIGO,
				TQF010.TQF_LOJA
			from TQF010
			where TQF010.D_E_L_E_T_ = ''
		) as TQF
			on TQF.TQF_FILIAL = TQI.TQI_FILIAL
			and TQF.TQF_CODIGO + TQF.TQF_LOJA = TQI.TQI_CODPOS + TQI.TQI_LOJA

	left join ST9010 as ST9
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = ZD3.ZD3_VEICUL	
    left join TQM010 as TQM
		on TQM.D_E_L_E_T_ = ''
		and TQM.TQM_CODCOM = ZD3.ZD3_COMB