select
	trim(isnull(ST9.T9_CODBEM, '-')) as EQUIPAMENTO,
	trim(isnull(ST9.T9_PLACA, '-')) as PLACA,
	trim(isnull(ST9.T9_CODFAMI, '-')) as FAMILIA,
	convert(date, ST9.T9_DTCOMPR, 103) as DTCOMPR,
	trim(isnull(ST7.T7_NOME, '-')) as FABRICANTE,
	trim(isnull(ST9.T9_CHASSI, '-')) as CHASSI,
	trim(isnull(ST9.T9_ANOMOD, '-')) as ANOMODELO,
	trim(isnull(ST9.T9_ANOFAB, '-')) as ANOFABRIC,
	trim(isnull(ST9.T9_RENAVAM, '-')) as RENAVAM,
	case ST9.T9_SITBEM when 'A' then 'ATIVO' when 'I' then 'INATIVO' else 'OUTROS' end as SITUACAO,
	ST9.T9_STATUS,
	substring(TPN.TPN_DTINIC, 1, 6) as PERIODO_MOV,
	
	convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113) as DT_MOV,
	lag(convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC, TPN.TPN_HRINIC) as DT_ANT,
	lead(convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC, TPN.TPN_HRINIC) as DT_PRO,
	cast(datediff(minute, lag(concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC, TPN.TPN_HRINIC), concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC))/(60*24.0) as numeric(15, 2)) as diff,
	
	eomonth(cast(TPN.TPN_DTINIC as date)) as DTMOV_FIMMES,
	dateadd(day, 1, eomonth(dateadd(month, -1, TPN.TPN_DTINIC))) as DTMOV_INIMES,

	/* ver se o fim do mês ocorre antes da próxima movimentação; se sim, fim do mês */
	case when eomonth(cast(TPN.TPN_DTINIC as date)) < lead(convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC, TPN.TPN_HRINIC)
		then eomonth(cast(TPN.TPN_DTINIC as date))
		else lead(convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC, TPN.TPN_HRINIC)
	end as DT_FIMMOV,

	/* ver se última movimentação ocorre antes do princípio do mês; se sim, princípio do mês */
	case when dateadd(day, 1, eomonth(dateadd(month, -1, TPN.TPN_DTINIC))) > lag(convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC, TPN.TPN_HRINIC)
		then dateadd(day, 1, eomonth(dateadd(month, -1, TPN.TPN_DTINIC)))
		else lag(convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC, TPN.TPN_HRINIC)
	end as DT_INIMOV,

	lag(trim(TPN.TPN_CCUSTO), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC, TPN.TPN_HRINIC) as CC_ANT,
	trim(TPN.TPN_CCUSTO) as CC

from TPN010 TPN (nolock)
	inner join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = TPN.TPN_CODBEM
		and ST9.T9_CATBEM != 3
where
		TPN.D_E_L_E_T_ = ''
