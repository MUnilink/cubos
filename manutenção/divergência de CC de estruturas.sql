select
	trim(ST9.T9_CODBEM) as ST9,
	trim(ST9.T9_CCUSTO) as CC_CAD,
	(select top 1 last_value(trim(TPN010.TPN_CCUSTO)) over (partition by TPN010.TPN_CODBEM order by TPN010.TPN_CODBEM) from TPN010 where TPN010.D_E_L_E_T_ = '' and TPN010.TPN_CODBEM = ST9.T9_CODBEM) as CC_MOV,
    case when ST9.T9_CCUSTO != (select top 1 last_value(TPN010.TPN_CCUSTO) over (partition by TPN010.TPN_CODBEM order by TPN010.TPN_CODBEM) from TPN010 where TPN010.D_E_L_E_T_ = '' and TPN010.TPN_CODBEM = ST9.T9_CODBEM) then 'diff' else trim(ST9.T9_CCUSTO) end as ULT_CC

from ST9010 ST9 (nolock)
where
		ST9.D_E_L_E_T_ = ''
