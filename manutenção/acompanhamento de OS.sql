select
	trim(STJ.TJ_CODBEM) as EQUIPAMENTO,
	trim(ST9.T9_CODFAMI) as FAMILIA,
	trim(TQR.TQR_DESMOD) as MODELO,
	trim(ST7.T7_NOME) as FABRICANTE,
	trim(STJ.TJ_SERVICO) as SERVICO,
	ST9.T9_POSCONT as CONTADOR_ATUAL,
	trim(upper(STJ.TJ_USUAFIM)) as USR_FIM,
    trim(upper(STJ.TJ_USUARIO)) as USR_INI,
	convert(datetime, concat(STJ.TJ_DTORIGI, ' ', STJ.TJ_HORACO1), 113) as DATA_OS,
	STJ.TJ_POSCONT as CONTADOR_OS,
	ST9.T9_NOME as DESC_EQUIPAMENTO,
	trim(STJ.TJ_CCUSTO) as CC,
	coalesce(nullif(trim(STJ.TJ_YITMCT), ''), nullif((select top 1 first_value(TPN010.TPN_XITEMC) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_CODBEM, TPN010.TPN_DTINIC, TPN010.TPN_HRINIC) from TPN010 where TPN010.D_E_L_E_T_ = '' and TPN010.TPN_CODBEM = STJ.TJ_CODBEM and TPN010.TPN_DTINIC >= STJ.TJ_DTORIGI), ''), nullif(ST9.T9_ITEMCTA, '')) as ATIVIDADE,
	
	(select trim(ST4010.T4_NOME) from ST4010 (nolock) where ST4010.D_E_L_E_T_ = '' and ST4010.T4_SERVICO = STJ.TJ_SERVICO) as SERVICO_NOME,
	case when STJ.TJ_SERVICO in ('PNEMOV', 'CONSEP', 'REFORP', 'PNEROD') then 'PNEUS' else 'MNT' end as PNEUS_MNT,
	case STJ.TJ_TERMINO when 'S' then 'SIM' when 'N' then 'NÃO' end as TERMINO,
    case STJ.TJ_TERCEIR when '2' then 'SIM' when '1' then 'NÃO' when 'N' then 'NÃO' end as EXTERNA,
    case STJ.TJ_SITUACA
        when 'C' then upper('Cancelado')
        when 'L' then upper('Liberado')
        when 'P' then upper('Pendente')
        else 'OUTROS'
    end as SITUACAO_OS,

	case STE.TE_CARACTE
        when 'P' then 'PREVENTIVA'
        when 'C' then 'CORRETIVA'
        else 'OUTROS'
    end as TIPO_MNT,

	left(STJ.TJ_DTORIGI, 6) as PERIODO_OS,
	case when isdate(concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI)) = 1 then convert(datetime, concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI), 113) else null end as DTH_INIMNT,
	case when isdate(concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI)) = 1 then convert(datetime, concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI), 113) else null end as DTH_INIPAR,
	case when isdate(concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM)) = 1 then convert(datetime, concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM), 113) else null end as DTH_FIMMNT,
	case when isdate(concat(STJ.TJ_DTPRFIM, ' ', STJ.TJ_HOPRFIM)) = 1 then convert(datetime, concat(STJ.TJ_DTPRFIM, ' ', STJ.TJ_HOPRFIM), 113) else null end as DTH_FIMPAR,

	TQB.TQB_SOLICI as SS,
    convert(datetime, concat(TQB.TQB_DTABER, ' ', TQB.TQB_HOABER), 113) as DT_INISS,
    convert(datetime, concat(TQB.TQB_DTFECH, ' ', TQB.TQB_HOFECH), 113) as DT_ENCSS,
    
    case TQB.TQB_SOLUCA
        when 'A' then upper('Aguardando Analise')
        when 'D' then upper('Distribuida')
        when 'E' then upper('Encerrada')
        when 'C' then upper('Cancelada')
        else 'OUTROS'
    end as SITUACAO_SS,

	concat(trim(TQB.TQB_CDSERV), ' - ', (select upper(trim(TQ3010.TQ3_NMSERV)) from TQ3010 where TQ3010.D_E_L_E_T_ = '' and TQ3010.TQ3_CDSERV = TQB.TQB_CDSERV)) as SERVICO_SS,
    concat(trim(TQB.TQB_CDEXEC), ' - ', (select upper(trim(TQ4010.TQ4_NMEXEC)) from TQ4010 where TQ4010.D_E_L_E_T_ = '' and TQ4010.TQ4_CDEXEC = TQB.TQB_CDEXEC)) as EXECUTA_SS,
    upper(TQB.TQB_USUARI) as USR_SS,
	
	case when isdate(concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI)) = 1 and isdate(concat(STJ.TJ_DTPRFIM, ' ', STJ.TJ_HOPRFIM)) = 1 then cast(datediff(minute, concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI), concat(STJ.TJ_DTPRFIM, ' ', STJ.TJ_HOPRFIM))/60.0 as numeric(15, 2)) else 0.0 end as TEMPO_PAR,
    case when isdate(concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI)) = 1 and isdate(concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM)) = 1 then cast(datediff(minute, concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI), concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM))/60.0 as numeric(15, 2)) else 0.0 end as TEMPO_MNT,
	case when isdate(concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI)) = 1 then datediff(minute, concat(TQB.TQB_DTABER, ' ', TQB.TQB_HOABER), concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI))/(60.0 *24) else null end as DIAS_SS_OS,
	
	case when
		isnull
		(
			(
				select max(cast(STL010.TL_SEQRELA as int))
				from STL010
				where 
						STL010.D_E_L_E_T_ = ''
					and STL010.TL_ORDEM = STJ.TJ_ORDEM
					and STL010.TL_PLANO = STJ.TJ_PLANO
					and STL010.TL_FILIAL = STJ.TJ_FILIAL
			),
			0) = 0
		then 'PREVISTOS' else 'REALIZADOS' end as CONTEM_ITENS,
	1 as qtd
from STJ010 STJ (nolock)
	inner join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = STJ.TJ_CODBEM

		inner join TQR010 TQR (nolock)
			on TQR.D_E_L_E_T_ = ''
			and TQR.TQR_TIPMOD = ST9.T9_TIPMOD
			
			inner join ST7010 ST7 (nolock)
				on ST7.D_E_L_E_T_ = ''
				and ST7.T7_FABRICA = TQR.TQR_FABRIC

	inner join ST4010 ST4 (nolock)
		on ST4.D_E_L_E_T_ = ''
		and ST4.T4_SERVICO = STJ.TJ_SERVICO
	left join STI010 STI (nolock)
		on STI.D_E_L_E_T_ = ''
		and STI.TI_FILIAL = STJ.TJ_FILIAL
		and STI.TI_PLANO = STJ.TJ_PLANO
	left join TQB010 TQB (nolock)
		on TQB.D_E_L_E_T_ = ''
		and TQB.TQB_FILIAL = STJ.TJ_FILIAL
		and TQB.TQB_ORDEM = STJ.TJ_ORDEM
	left join STE010 STE (nolock)
		on STE.D_E_L_E_T_ = ''
		and STE.TE_TIPOMAN = STJ.TJ_TIPO

where STJ.D_E_L_E_T_ = ''
