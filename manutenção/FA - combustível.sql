select
	ZD3.ZD3_LITROS,
	ZD3.ZD3_VLUNI,

	(
		select avg(SD1010.D1_VUNIT)
		from SD1010
		where
				SD1010.D_E_L_E_T_ = ''
			and SD1010.D1_COD = '11100008'
			and SD1010.D1_TES = 42
			and substring(SD1010.D1_DTDIGIT, 1, 6) = substring(ZD3.ZD3_DATA, 1, 6)
	) as VALOR_COMPRA,
	
	ZD3.ZD3_HODOM,
	ZD3.ZD3_KMRD,
	ZD3.ZD3_KML,
	ZD3.ZD3_TOTAL,
	
    convert(date, ZD3.ZD3_DATA, 103) as ZD3_DATA,
	ZD3.ZD3_HORA as ZD3_HORA,
	ZD3.ZD3_DTPROC,

	trim(isnull(TQI.TQI_TANQUE, '-')) as TQI_TANQUE,
	trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,
	trim(isnull(TQM.TQM_CODCOM, '-')) as TQM_CODCOM,
	trim(isnull(ZD3.TQN_CCUSTO, '-')) as TQN_CCUSTO,
	trim(isnull(ZD3.TQN_YITMCT, '-')) as TQN_YITMCT,

	substring(ZD3.ZD3_DATA, 1, 6) as PERIODO,
	trim(TQM.TQM_NOMCOM) as TQM_NOMCOM

from
	(
		select
			case cast(ZD3010.ZD3_TANQUE as int)
				when 12 then '010102'
				else trim(isnull(ZD3010.ZD3_FILIAL, '-'))
			end as ZD3_FILIAL,
			ZD3010.ZD3_KM as ZD3_HODOM,

			ZD3010.ZD3_VEICUL,
			ZD3010.ZD3_LITROS,
			ZD3010.ZD3_VLUNI,
			ZD3010.ZD3_TOTAL,
			ZD3010.ZD3_DTPROC,
			ZD3010.ZD3_TANQUE,
			ZD3010.ZD3_COMB,
			/*datetimefromparts(substring(ZD3010.ZD3_DATA, 1, 8), substring(ZD3010.ZD3_DATA, 1, 8), substring(ZD3010.ZD3_DATA, 1, 8), substring(ZD3010.ZD3_DATA, 10, 14), substring(ZD3010.ZD3_DATA, 10, 14), 0, 0) as ZD3_DATA,*/
			substring(ZD3010.ZD3_DATA, 1, 8) as ZD3_DATA,
			substring(ZD3010.ZD3_DATA, 10, 14) as ZD3_HORA,
			ZD3010.ZD3_KML,
			ZD3010.ZD3_KMRD,
			TQN.TQN_CCUSTO,
			TQN.TQN_YITMCT,
			
			TQN.TQN_NUMSEQ
		from ZD3010 (nolock)
			inner join TQN010 TQN (nolock)
				on TQN.D_E_L_E_T_ = ''
				and TQN.TQN_FROTA = ZD3010.ZD3_VEICUL
				and TQN.TQN_DTABAS = substring(ZD3010.ZD3_DATA, 1, 8)
				and TQN.TQN_HRABAS = substring(ZD3010.ZD3_DATA, 10, 14)
		where
				ZD3010.D_E_L_E_T_ = ''
			and substring(ZD3010.ZD3_DATA, 1, 4) > 2021
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
