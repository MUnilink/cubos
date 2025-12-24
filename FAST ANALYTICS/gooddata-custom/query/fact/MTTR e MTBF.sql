select
	convert(datetime, getdate(), 113) as ULTIMA_CARGA,
	cast(STJ.TJ_DTORIGI as date) as DATA_OS,
	STJ.TJ_TERMINO as TERMINO,
	STJ.TJ_SITUACA as SITUACAO,
	STJ.TJ_POSCONT as CONTADOR,
	trim(STJ.TJ_CODBEM) as EQUIPAMENTO,
	trim(STJ.TJ_SERVICO) as SERVICO,
	trim(STJ.TJ_CCUSTO) as CC,
	coalesce(nullif(trim(STJ.TJ_YITMCT), ''), nullif((select top 1 first_value(TPN010.TPN_XITEMC) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_CODBEM, TPN010.TPN_DTINIC, TPN010.TPN_HRINIC) from TPN010 where TPN010.D_E_L_E_T_ = '' and TPN010.TPN_CODBEM = STJ.TJ_CODBEM and TPN010.TPN_DTINIC >= STJ.TJ_DTORIGI), ''), nullif(ST9.T9_ITEMCTA, '')) as ATIVIDADE,

    concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI) as DTH_INIMNT,
    concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM) as DTH_FIMMNT,
    concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI) as DTH_INIPAR,
    concat(STJ.TJ_DTPRFIM, ' ', STJ.TJ_HOPRFIM) as DTH_FIMPAR,

	/*
		**** ABAIXO DADOS DE CONTROLE PELO RM ****
	*/

	ST9.T9_NOME,
	case when isdate(concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI)) = 1 then convert(datetime, concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI), 113) else null end as DATAHORA_INIOS,
	case when isdate(concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM)) = 1 then convert(datetime, concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM), 113) else null end as DATAHORA_FIMOS,

	trim(ST9.T9_CODFAMI) as FAMILIA,
	case STJ.TJ_SERVICO when 'PNEMOV' then 'PNEUS' when 'CONSEP' then 'PNEUS' when 'REFORP' then 'PNEUS' when 'PNEROD' then 'PNEUS' else 'MNT' end as TIPO_SERV,
	STJ.TJ_POSCONT as CONTADOR_ATUAL,
	STJ.TJ_HORACO1 as HORA_CONT,
	left(STJ.TJ_DTORIGI, 6) as PERIODO_OS,
	STJ.TJ_TERMINO as TERMINO,
	STJ.TJ_SITUACA as SITUACAO

from STJ010 STJ (nolock)
	inner join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = STJ.TJ_CODBEM

		left join TQR010 TQR (nolock)
			on TQR.D_E_L_E_T_ = ''
			and TQR.TQR_TIPMOD = ST9.T9_TIPMOD

	inner join ST4010 ST4 (nolock)
		on ST4.D_E_L_E_T_ = ''
		and ST4.T4_SERVICO = STJ.TJ_SERVICO
		
	left join STI010 STI (nolock)
		on STI.D_E_L_E_T_ = ''
		and STI.TI_FILIAL = STJ.TJ_FILIAL
		and STI.TI_PLANO = STJ.TJ_PLANO
where
		STJ.TJ_DTORIGI between <<START_DATE>> AND <<FINAL_DATE>>
	and STJ.D_E_L_E_T_ = ''
