select
	ZD3.ZD3_LITROS,
	ZD3.ZD3_VLUNI,
	ZD3.ZD3_HODOM,
	ZD3.ZD3_KMRD,
	ZD3.ZD3_KML,
	ZD3.ZD3_TOTAL,
	trim(isnull(ZD3.ZD3_DATA, '-')) as ZD3_DATA,

	trim(isnull(TQI.TQI_TANQUE, '-')) as TQI_TANQUE,
	trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,
	trim(isnull(TQM.TQM_CODCOM, '-')) as TQM_CODCOM,
	trim(isnull(ZD3.TQN_CCUSTO, '-')) as TQN_CCUSTO,
	trim(isnull(ZD3.TQN_YITMCT, '-')) as TQN_YITMCT,
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
			
			ZD3010.ZD3_TANQUE,
			ZD3010.ZD3_COMB,
			substring(ZD3010.ZD3_DATA, 1, 8) as ZD3_DATA,
			ZD3010.ZD3_KML,
			ZD3010.ZD3_KMRD,
			TQN010.TQN_CCUSTO,
			TQN010.TQN_YITMCT
		from ZD3010 (nolock)
			inner join TQN010 (nolock)
				on TQN010.D_E_L_E_T_ = ''
				and TQN010.TQN_FROTA = ZD3010.ZD3_VEICUL
				and TQN010.TQN_DTABAS + TQN010.TQN_HRABAS = substring(ZD3010.ZD3_DATA, 1, 8) + substring(ZD3010.ZD3_DATA, 10, 14)
		where ZD3010.D_E_L_E_T_ = ''
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
where ZD3.ZD3_DATA between <<START_DATE>> AND <<FINAL_DATE>>