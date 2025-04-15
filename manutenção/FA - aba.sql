select
	ZD3.ZD3_LITROS,
	(select sum(SD1010.D1_TOTAL) from SD1010 where SD1010.D_E_L_E_T_ = '' and SD1010.D1_COD = '11100008' and left(SD1010.D1_DTDIGIT, 6) = left(ZD3.ZD3_DATA, 6))/
	(select sum(SD1010.D1_QUANT) from SD1010 where SD1010.D_E_L_E_T_ = '' and SD1010.D1_COD = '11100008' and left(SD1010.D1_DTDIGIT, 6) = left(ZD3.ZD3_DATA, 6)) as ZD3_VLUNI,
	
	ZD3.ZD3_HODOM,
	ZD3.ZD3_KMRD,
	ZD3.ZD3_KML,
	ZD3.ZD3_TOTAL,
	trim(ZD3.ZD3_DATA) as ZD3_DATA,

	trim(TQI.TQI_TANQUE) as TQI_TANQUE,
	trim(ST9.T9_CODBEM) as T9_CODBEM,
	trim(TQM.TQM_CODCOM) as TQM_CODCOM,
	trim(ZD3.TQN_CCUSTO) as TQN_CCUSTO,
	ZD3.TQN_YITMCT as TQN_YITMCT,

	/* RM */
	trim(ST9.T9_CODFAMI) as FAMILIA,
	convert(datetime, ZD3.DATA_ABA, 113) as DATA_ABA,
	ZD3.TIPO_ABA,
	case
		when ST9.T9_CODFAMI = 'VP' then ZD3.ZD3_HODOM
		when ZD3.ZD3_HODOM < lag(ZD3.ZD3_HODOM, 1, 0) over (partition by ZD3.ZD3_VEICUL, ZD3.ZD3_COMB order by ZD3.ZD3_VEICUL, ZD3.ZD3_DATA, ZD3.ZD3_HORA) then ZD3.ZD3_HODOM /* quando quebra */
		else
		(
			select max(STP010.TP_POSCONT)
			from STP010
			where
					STP010.D_E_L_E_T_ = ''
				and STP010.TP_CODBEM = ZD3.ZD3_VEICUL
				and convert(datetime, concat(STP010.TP_DTLEITU, ' ', STP010.TP_HORA), 113) < convert(datetime, ZD3.DATA_ABA, 113)
				and STP010.TP_TIPOLAN = 'A'
		)
	end as cont_TQN,

	left(ZD3.ZD3_DATA, 6) as PERIODO
from
	(
		select
			case cast(ZD30.ZD3_TANQUE as int)
				when 12 then '010102'
				else trim(isnull(ZD30.ZD3_FILIAL, '-'))
			end as ZD3_FILIAL,
			ZD30.ZD3_KM as ZD3_HODOM,
			ZD30.ZD3_VEICUL,
			ZD30.ZD3_LITROS,
			ZD30.ZD3_TOTAL,
			ZD30.ZD3_TANQUE,
			ZD30.ZD3_COMB,
			left(ZD30.ZD3_DATA, 14) as DATA_ABA,
			case when right(trim(ZD30.ZD3_DATA), 1) = '*' then 'P' else 'C' end as TIPO_ABA,
			left(ZD30.ZD3_DATA, 8) as ZD3_DATA,
			left(right(trim(ZD30.ZD3_DATA), 7), 5) as ZD3_HORA,
			ZD30.ZD3_KML,
			ZD30.ZD3_KMRD,

			(
				select TQN010.TQN_CCUSTO
				from TQN010
				where
						TQN010.D_E_L_E_T_ = ''
					and TQN010.TQN_FROTA = ZD30.ZD3_VEICUL
					and TQN010.TQN_DTABAS = substring(ZD30.ZD3_DATA, 1, 8)
					and TQN010.TQN_HRABAS = substring(ZD30.ZD3_DATA, 10, 5)
			) as TQN_CCUSTO,
			(
				select
					case when TQN010.TQN_YITMCT is not null and TQN010.TQN_YITMCT != '' then TQN010.TQN_YITMCT
					else
						case TQN010.TQN_CCUSTO
							when 302 then 11
							when 304 then 11
							when 303 then 21
							when 305 then 21
							when 306 then 21
							else 90
						end
					end
				from TQN010
				where
						TQN010.D_E_L_E_T_ = ''
					and TQN010.TQN_FROTA = ZD30.ZD3_VEICUL
					and TQN010.TQN_DTABAS = substring(ZD30.ZD3_DATA, 1, 8)
					and TQN010.TQN_HRABAS = substring(ZD30.ZD3_DATA, 10, 5)
			) as TQN_YITMCT
		from ZD3010 ZD30
		where ZD30.D_E_L_E_T_ = ''
	) as ZD3

	left join
	(
		select
			TQI010.TQI_FILIAL,
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
				TQF010.TQF_CODFIL as TQF_FILIAL,
				TQF010.TQF_CODIGO,
				TQF010.TQF_LOJA
			from TQF010
			where TQF010.D_E_L_E_T_ = ''
		) as TQF
			on TQF.TQF_FILIAL = TQI.TQI_FILIAL
			and TQF.TQF_CODIGO + TQF.TQF_LOJA = TQI.TQI_CODPOS + TQI.TQI_LOJA

	left join ST9010 ST9
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = ZD3.ZD3_VEICUL
	left join TQM010 TQM
		on TQM.D_E_L_E_T_ = ''
		and TQM.TQM_CODCOM = ZD3.ZD3_COMB
