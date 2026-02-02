select
	cast(STJ.TJ_DTORIGI as date) as DATA_OS,
	STJ.TJ_POSCONT as CONTADOR,
	trim(STJ.TJ_CODBEM) as EQUIPAMENTO,
	trim(STJ.TJ_SERVICO) as SERVICO,
	(select trim(ST4010.T4_NOME) from ST4010 (nolock) where ST4010.D_E_L_E_T_ = '' and ST4010.T4_SERVICO = STJ.TJ_SERVICO) as SERVICONOME,
	trim(STJ.TJ_CCUSTO) as CC,
	coalesce(nullif(trim(STJ.TJ_YITMCT), ''), nullif((select top 1 first_value(TPN010.TPN_XITEMC) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_CODBEM, TPN010.TPN_DTINIC, TPN010.TPN_HRINIC) from TPN010 where TPN010.D_E_L_E_T_ = '' and TPN010.TPN_CODBEM = STJ.TJ_CODBEM and TPN010.TPN_DTINIC >= STJ.TJ_DTORIGI), ''), nullif(ST9.T9_ITEMCTA, '')) as ATIVIDADE,

	case STJ.TJ_TERMINO when 'S' then 'SIM' when 'N' then 'NÃO' end as TERMINO,
    case STJ.TJ_TERCEIR when '2' then 'SIM' when '1' then 'NÃO' when 'N' then 'NÃO' end as EXTERNA,
    case STJ.TJ_SITUACA 
        when 'C' then upper('Cancelado')
        when 'L' then upper('Liberado')
        when 'P' then upper('Pendente')
        else 'OUTROS'
    end as SITUACAO_OS,

	ST9.T9_NOME,
	case when isdate(concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI)) = 1 then convert(datetime, concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI), 113) else null end as DTH_INIMNT,
	case when isdate(concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI)) = 1 then convert(datetime, concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI), 113) else null end as DTH_INIPAR,
	case when isdate(concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM)) = 1 then convert(datetime, concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM), 113) else null end as DTH_FIMMNT,
	case when isdate(concat(STJ.TJ_DTPRFIM, ' ', STJ.TJ_HOPRFIM)) = 1 then convert(datetime, concat(STJ.TJ_DTPRFIM, ' ', STJ.TJ_HOPRFIM), 113) else null end as DTH_FIMPAR,

	trim(ST9.T9_CODFAMI) as FAMILIA,
	case STJ.TJ_SERVICO when 'PNEMOV' then 'PNEUS' when 'CONSEP' then 'PNEUS' when 'REFORP' then 'PNEUS' when 'PNEROD' then 'PNEUS' else 'MNT' end as TIPO_SERV,
	STJ.TJ_POSCONT as CONTADOR_ATUAL,
	STJ.TJ_HORACO1 as HORA_CONT,
	left(STJ.TJ_DTORIGI, 6) as PERIODO_OS,
	
	(
		select coalesce(nullif('SD1' + trim(SD1010.D1_DOC), 'SD1'), null)
		from SD1010
			left join STL010 (nolock)
				on STL010.TL_ORIGNFE = 'SD1'
				and SD1.D1_FILIAL = STL010.TL_FILIAL
				and left(SD1.D1_OP, 6) = STL010.TL_ORDEM
				and SD1.D1_DOC = STL010.TL_NOTFIS
				and SD1.D1_SERIE = STL010.TL_SERIE
				and SD1.D1_ITEM = STL010.TL_ITEM
				and SD1.D1_FORNECE = STL010.TL_FORNEC
				and SD1.D1_LOJA = STL010.TL_LOJA
			left join SC7010 SC7 (nolock)
				on SC7.D_E_L_E_T_ = ''
				and SC7.C7_FILIAL = SD1.D1_FILIAL
				and SC7.C7_NUM = SD1.D1_PEDIDO
				and SC7.C7_ITEM = SD1.D1_ITEMPC
		where 
				SD1.D_E_L_E_T_ = ''
			and STL010.TL_ORDEM = STJ.TJ_ORDEM
			and STL010.TL_PLANO = STJ.TJ_PLANO
			and STL010.TL_FILIAL = STJ.TJ_FILIAL
	) as NF

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
		STJ.D_E_L_E_T_ = ''
