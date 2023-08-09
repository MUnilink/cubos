select
	STJ.TJ_FILIAL as FILIAL,
	STJ.TJ_ORDEM as OS,
	cast(ST9.T9_CODBEM as int) as T9_CODBEM,
	TR8.TR8_LOTE as LOTE,
	STJ.TJ_CCUSTO as CCUSTO,
	STJ.TJ_SERVICO as SERVICO,

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

	STJ.TJ_CUSTTER,
	TQS.TQS_KMR1,
	TQS.TQS_KMR2,
	TQS.TQS_KMR3,
	TQS.TQS_KMR4,
	TQS.TQS_KMR5,
	TQS.TQS_KMR6,
	TQS.TQS_KMR7,
	TQS.TQS_KMOR,
	ST9.T9_VALCPA,
	TQS.TQS_KMOR + TQS.TQS_KMR1 + TQS.TQS_KMR2 + TQS.TQS_KMR3 + TQS.TQS_KMR4 + TQS.TQS_KMR5 + TQS.TQS_KMR6 + TQS.TQS_KMR7 as kmTOT,

	(
        select top 1 first_value(STZ010.TZ_DATAMOV) over (partition by STZ010.TZ_CODBEM order by STZ010.TZ_CODBEM)
        from STZ010 (nolock)
        where
                STZ010.D_E_L_E_T_ = ''
            and STZ010.TZ_CODBEM = ST9.T9_CODBEM
    ) as DATA

from STJ010 STJ (nolock)
	left join TR8010 TR8 (nolock)
		on TR8.D_E_L_E_T_ = ''
		and TR8.TR8_FILIAL = STJ.TJ_FILIAL
		and TR8.TR8_ORDEM = STJ.TJ_ORDEM
		and TR8.TR8_PLANO = STJ.TJ_PLANO
	inner join TQS010 TQS (nolock)
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = STJ.TJ_CODBEM

		inner join ST9010 ST9 (nolock)
			on ST9.D_E_L_E_T_ = ''
			and ST9.T9_CODBEM = TQS.TQS_CODBEM

where
		STJ.D_E_L_E_T_ = ''
