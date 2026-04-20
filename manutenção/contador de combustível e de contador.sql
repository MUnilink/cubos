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
	
	substring(TQN.TQN_DTABAS, 1, 6) as PERIODO_TQN,
	convert(datetime, lag(concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS), 1, null) over (partition by TQN.TQN_FROTA, TQN.TQN_CODCOM order by TQN.TQN_FROTA, TQN.TQN_DTABAS, TQN.TQN_HRABAS), 113) as DATA_ANT,
	datediff(minute, concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS), lag(concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS), 1, null) over (partition by TQN.TQN_FROTA, TQN.TQN_CODCOM order by TQN.TQN_FROTA, TQN.TQN_DTABAS, TQN.TQN_HRABAS))/(60 * 24 *-1.0) as DIAS,
	TQN.TQN_YTIPO as TIPO_ABA,
	TQN.TQN_QUANT as LITROS,
	TQN.TQN_VALUNI as VALOR_UNI,
	TQN.TQN_VALTOT as VALOR_TOTAL,

	trim(ST9.T9_CODFAMI) as FAMILIA,

	isnull(TQN.TQN_HODOM, STP.TP_POSCONT) as CONT_ATU,
	convert(datetime, isnull(nullif(concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS), ' '), STP.DATACONT), 113) as DATA_ABA,

	(select max(TQN010.TQN_HODOM) from TQN010 where TQN010.D_E_L_E_T_ = '' and TQN010.TQN_FROTA = TQN.TQN_FROTA and concat(TQN010.TQN_DTABAS, ' ', TQN010.TQN_HRABAS) < concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS) and TQN010.TQN_HODOM < TQN.TQN_HODOM and TQN010.TQN_YTIPO = 'C') as CONT_ANT,
	(select ZD3010.ZD3_KMRD from ZD3010 where ZD3010.D_E_L_E_T_ = '' and TQN.TQN_FROTA = ZD3010.ZD3_VEICUL and TQN.TQN_DTABAS = substring(ZD3010.ZD3_DATA, 1, 8) and TQN.TQN_HRABAS = substring(ZD3010.ZD3_DATA, 10, 14)) as km_ZD3,

	isnull(	
		case
			when TQN.TQN_YTIPO = 'P' or TQN.TQN_CODCOM = 2 then 0.0 /* não calcula para ARLA e parcial*/
			when TQN.TQN_HODOM < lag(TQN.TQN_HODOM, 1, 0) over (partition by TQN.TQN_FROTA, TQN.TQN_CODCOM, TQN.TQN_YTIPO order by TQN.TQN_FROTA, TQN.TQN_DTABAS, TQN.TQN_HRABAS) then TQN.TQN_HODOM /* quando quebra */
			else TQN.TQN_HODOM - lag(TQN.TQN_HODOM, 1, TQN.TQN_HODOM) over (partition by TQN.TQN_FROTA, TQN.TQN_CODCOM, TQN.TQN_YTIPO order by TQN.TQN_FROTA, TQN.TQN_DTABAS, TQN.TQN_HRABAS)
		end,
		
		case when STP.TP_POSCONT < lag(STP.TP_POSCONT, 1, 0) over (partition by STP.TP_CODBEM order by STP.TP_CODBEM, STP.DATACONT) then STP.TP_POSCONT /* quando quebra */
			else STP.TP_POSCONT - lag(STP.TP_POSCONT, 1, STP.TP_POSCONT) over (partition by STP.TP_CODBEM order by STP.TP_CODBEM, STP.DATACONT)
		end
	) as km_TQN

from ST9010 ST9 (nolock)
	left join TQN010 TQN (nolock)
		on TQN.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = TQN.TQN_FROTA
		
		left join TQI010 TQI (nolock)
			on TQI.D_E_L_E_T_ = ''
			and TQI.TQI_FILIAL = TQN.TQN_FILIAL
			and TQI.TQI_TANQUE = TQN.TQN_TANQUE

			left join TQF010 TQF (nolock)
				on TQF.D_E_L_E_T_ = ''
				and TQF.TQF_FILIAL = TQI.TQI_FILIAL
				and TQF.TQF_CODIGO = TQI.TQI_CODPOS
				and TQF.TQF_LOJA = TQI.TQI_LOJA

		left join TQM010 TQM (nolock)
			on TQM.D_E_L_E_T_ = ''
			and TQM.TQM_CODCOM = TQN.TQN_CODCOM
	
	left join
	(
		select
			STP010.TP_POSCONT,
			STP010.TP_ORDEM,
			STP010.TP_PLANO,
			STP010.TP_CODBEM,
			concat(STP010.TP_DTLEITU, ' ', STP010.TP_HORA) as DATACONT,
			STP010.TP_DTLEITU,
			STP010.TP_CCUSTO,
			STP010.TP_ACUMCON,
			STP010.TP_HORA,
			STP010.TP_ORIGEM
		from STP010
		where
				STP010.D_E_L_E_T_ = ''
			and STP010.TP_TIPOLAN != 'A'
	) STP
	on STP.TP_CODBEM = ST9.T9_CODBEM
where
        ST9.T9_TEMCONT = 'S'
	and STP.TP_CODBEM not in (select STP010.TP_CODBEM from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STP.TP_CODBEM and substring(STP010.TP_DTLEITU, 1, 6) = substring(STP.DATACONT, 1, 6))
	and ST9.D_E_L_E_T_ = ''
