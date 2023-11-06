select
	STJ.TJ_FILIAL as FILIAL,
	STJ.TJ_ORDEM as OS,
	trim(TQS.TQS_CODBEM) as TQS_CODBEM,
	trim(ST9.T9_CODBEM) as T9_CODBEM,
	TR8.TR8_LOTE as LOTE,
	trim(TR8.TR8_MOTIVO) as MOTIVO,
	STJ.TJ_SERVICO as SERVICO,
	trim(ST9.T9_STATUS) as STATUS,
	trim(TQS.TQS_MEDIDA) as TQS_MEDIDA,
	ST9.T9_TIPMOD as MODELO,
	trim(TR4.TR4_PAREC) as TR4_PAREC,
	
	trim(STJ.TJ_CCUSTO) as CCUSTO,
	case when STJ.TJ_YITMCT is not null and STJ.TJ_YITMCT != '' then trim(STJ.TJ_YITMCT)
	else
		case STJ.TJ_CCUSTO
			when 302 then 11
			when 304 then 11
			when 303 then 21
			when 305 then 21
			when 306 then 21
			else 90
		end
	end as ATIVIDADE,

	ST9.T9_VALCPA as CUSTO_COMPRA,
	STJ.TJ_CUSTTER as CUSTO_SERVICOS,
	concat(TR7.TR7_DTRECI, ' ', TR7.TR7_HRRECI) as DATA

from STJ010 STJ (nolock)
	left join TR8010 TR8 (nolock)
		on TR8.D_E_L_E_T_ = ''
		and TR8.TR8_FILIAL = STJ.TJ_FILIAL
		and TR8.TR8_ORDEM = STJ.TJ_ORDEM
		and TR8.TR8_PLANO = STJ.TJ_PLANO
		
		inner join TR7010 TR7 (nolock)
            on TR7.D_E_L_E_T_ = ''
            and TR7.TR7_FILIAL = TR8.TR8_FILIAL
            and TR7.TR7_LOTE = TR8.TR8_LOTE
		left join TR4010 TR4 (nolock)
			on TR4.D_E_L_E_T_ = ''
			and TR4.TR4_ORDEM = TR8.TR8_ORDEM

	inner join TQS010 TQS (nolock)
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = STJ.TJ_CODBEM

		inner join ST9010 ST9 (nolock)
			on ST9.D_E_L_E_T_ = ''
			and ST9.T9_CODBEM = TQS.TQS_CODBEM
where
		STJ.D_E_L_E_T_ = ''
