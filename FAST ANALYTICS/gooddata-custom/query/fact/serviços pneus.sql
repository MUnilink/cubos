select
	trim(STJ.TJ_FILIAL) as FILIAL,
	trim(STJ.TJ_ORDEM) as OS,
	trim(TQS.TQS_CODBEM) as TQS_CODBEM,
	trim(ST9.T9_CODBEM) as T9_CODBEM,
	trim(TR8.TR8_LOTE) as LOTE,
	trim(TR8.TR8_MOTIVO) as TR8_MOTIVO
	trim(STJ.TJ_SERVICO) as SERVICO,
	trim(ST9.T9_STATUS) as STATUS,
	trim(TQS.TQS_MEDIDA) as MEDIDA,
	trim(STJ.TJ_CCUSTO) as CCUSTO,
	case when STJ.TJ_YITMCT is not null and STJ.TJ_YITMCT != '' then STJ.TJ_YITMCT
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

	trim(ST9.T9_VALCPA) as CUSTO_COMPRA,
	trim(STJ.TJ_CUSTTER) as CUSTO_SERVICOS,
	trim(ST9.T9_CONTACU) as CONT_ACUMULADO,

	case ST9.T9_SITBEM when 'A' then 'ATIVO' when 'I' then 'INATIVO' else 'OUTROS' end as SITUACAO,
	trim(ST9.T9_LOCPAD) as ARMAZEM,
	
	trim(TQS.TQS_KMR1) as TQS_KMR1,
	trim(TQS.TQS_KMR2) as TQS_KMR2,
	trim(TQS.TQS_KMR3) as TQS_KMR3,
	trim(TQS.TQS_KMR4) as TQS_KMR4,
	trim(TQS.TQS_KMR5) as TQS_KMR5,
	trim(TQS.TQS_KMR6) as TQS_KMR6,
	trim(TQS.TQS_KMR7) as TQS_KMR7,
	trim(TQS.TQS_KMOR) as TQS_KMOR,
	trim(TQS.TQS_KMOR) + trim(TQS.TQS_KMR1) + trim(TQS.TQS_KMR2) + trim(TQS.TQS_KMR3) + trim(TQS.TQS_KMR4) + trim(TQS.TQS_KMR5) + trim(TQS.TQS_KMR6) + trim(TQS.TQS_KMR7) as kmTOT,

	trim(TR7.TR7_DTRECI) as DATA

from STJ010 STJ
	left join TR8010 TR8
		on TR8.D_E_L_E_T_ = ''
		and TR8.TR8_FILIAL = STJ.TJ_FILIAL
		and TR8.TR8_ORDEM = STJ.TJ_ORDEM
		and TR8.TR8_PLANO = STJ.TJ_PLANO
	inner join TQS010 TQS
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = STJ.TJ_CODBEM

		inner join ST9010 ST9
			on ST9.D_E_L_E_T_ = ''
			and ST9.T9_CODBEM = TQS.TQS_CODBEM
where
		STJ.D_E_L_E_T_ = ''
