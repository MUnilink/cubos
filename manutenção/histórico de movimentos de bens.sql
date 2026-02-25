select
	trim(STZ.TZ_FILIAL) as TJ_FILIAL,
	trim(STZ.TZ_ORDEM) as TZ_ORDEM,
	trim(SR.T9_CODBEM) as SR,
	trim(CM.T9_CODBEM) as CM,
	STZ.TZ_POSCONT,
	STZ.TZ_CONTSAI,
	convert(datetime, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), 103) as DATAMOV,
	convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 103) as DATASAI,

	STZ.TZ_TEMCONT as CONT_COMPONENTE,
	STZ.TZ_TEMCPAI as CONT_ESTRUTURA,

	case CM.T9_PROPRIE when 1 then 'SIM' when '2' then 'NAO' else 'OUTROS' end as CM_PROPRIO,
	case SR.T9_PROPRIE when 1 then 'SIM' when '2' then 'NAO' else 'OUTROS' end as SR_PROPRIO, 
	case when CM.T9_DTBAIXA < coalesce(nullif(STZ.TZ_DATASAI, ''), STZ.TZ_DATAMOV) then 'ATIVO' else 'INATIVO' end as CM_ATIVO,
	case when SR.T9_DTBAIXA < coalesce(nullif(STZ.TZ_DATASAI, ''), STZ.TZ_DATAMOV) then 'ATIVO' else 'INATIVO' end as SR_ATIVO,

	trim(isnull(STZ.TZ_TIPOMOV, '-')) as TZ_TIPOMOV,
	(select top 1 last_value(TPN010.TPN_CCUSTO) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_CODBEM) from TPN010 where TPN010.D_E_L_E_T_ = '' and TPN010.TPN_CODBEM = STZ.TZ_BEMPAI and concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC) < (concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT))) as CC_ANT_CM,
	(select top 1 last_value(TPN010.TPN_CCUSTO) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_CODBEM) from TPN010 where TPN010.D_E_L_E_T_ = '' and TPN010.TPN_CODBEM = STZ.TZ_CODBEM and concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC) < (concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT))) as CC_ANT_SR,
	(select top 1 last_value(TPN010.TPN_XITEMC) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_CODBEM) from TPN010 where TPN010.D_E_L_E_T_ = '' and TPN010.TPN_CODBEM = STZ.TZ_BEMPAI and concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC) < (concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT))) as AT_ANT_CM,
	(select top 1 last_value(TPN010.TPN_XITEMC) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_CODBEM) from TPN010 where TPN010.D_E_L_E_T_ = '' and TPN010.TPN_CODBEM = STZ.TZ_CODBEM and concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC) < (concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT))) as AT_ANT_SR,
    (select top 1 last_value(convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC), 103)) over (partition by TPN010.TPN_CODBEM order by TPN010.TPN_CODBEM) from TPN010 where TPN010.D_E_L_E_T_ = '' and TPN010.TPN_CODBEM = STZ.TZ_BEMPAI and concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC) < (concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT))) as DT_TRANSF,

	substring(STZ.TZ_DATAMOV, 1, 6) as PERIODO_MOV,
	substring(STZ.TZ_DATASAI, 1, 6) as PERIODO_SAI,
    
    STZ.TZ_CONTSAI - STZ.TZ_POSCONT as km,
	case STZ.TZ_TIPOMOV when 'S' then datediff(minute, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI))/(60*24) else 0.0 end as DIAS

from STZ010 STZ (nolock)
	inner join ST9010 SR (nolock)
		on SR.D_E_L_E_T_ = ''
		and SR.T9_CODBEM = STZ.TZ_CODBEM
		and SR.T9_CATBEM != 3
	inner join ST9010 CM (nolock)
		on CM.D_E_L_E_T_ = ''
		and CM.T9_CODBEM = STZ.TZ_BEMPAI
		and CM.T9_CATBEM != 3
where
		STZ.D_E_L_E_T_ = ''
