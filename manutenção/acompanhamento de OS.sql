select
	STJ.TJ_FILIAL as FILIAL,
	trim(STJ.TJ_CODBEM) as EQUIPAMENTO,
	trim(ST9.T9_CODFAMI) as FAMILIA,
	trim(TQR.TQR_DESMOD) as MODELO,
	trim(ST7.T7_NOME) as FABRICANTE,
	trim(STJ.TJ_SERVICO) as SERVICO,
	ST9.T9_POSCONT as CONTADOR_ATUAL,
	trim(upper(STJ.TJ_USUAFIM)) as USR_FIM,
    trim(upper(STJ.TJ_USUARIO)) as USR_INI,
	STJ.TJ_POSCONT as CONTADOR_OS,
	upper(trim(ST9.T9_NOME)) as DESC_EQUIPAMENTO,
	trim(STJ.TJ_CCUSTO) as CC,
	coalesce(nullif(trim(STJ.TJ_YITMCT), ''), nullif((select top 1 first_value(TPN010.TPN_XITEMC) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_CODBEM, TPN010.TPN_DTINIC, TPN010.TPN_HRINIC) from TPN010 where TPN010.D_E_L_E_T_ = '' and TPN010.TPN_CODBEM = STJ.TJ_CODBEM and TPN010.TPN_DTINIC >= STJ.TJ_DTORIGI), ''), nullif(ST9.T9_ITEMCTA, '')) as ATIVIDADE,

	cast(STJ.TJ_CUSTMDO as numeric(15, 2)) as 'custo Total Mao de Obra',
	cast(STJ.TJ_CUSTMAT as numeric(15, 2)) as 'custo Materiais de Troca',
	cast(STJ.TJ_CUSTMAA as numeric(15, 2)) as 'custo de Materias Apoio',
	cast(STJ.TJ_CUSTMAS as numeric(15, 2)) as 'custo Mater. Substituicao',
	cast(STJ.TJ_CUSTTER as numeric(15, 2)) as 'custo de Terceiros',

	cast(STJ.TJ_CUSTMDO + STJ.TJ_CUSTMAT + STJ.TJ_CUSTMAA + STJ.TJ_CUSTMAS + STJ.TJ_CUSTTER as numeric(15, 2)) as CUSTO_OS,
	
	STJ.TJ_ORDEM as OS,
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
	left(STJ.TJ_DTMRINI, 6) as PERIODO_MNTINI,
	left(STJ.TJ_DTPRINI, 6) as PERIODO_PARINI,
	left(STJ.TJ_DTMRFIM, 6) as PERIODO_MNTFIM,
	left(STJ.TJ_DTPRFIM, 6) as PERIODO_PARFIM,
	case when isdate(convert(datetime, concat(STJ.TJ_DTORIGI, ' ', nullif(trim(STJ.TJ_HORACO1), ':')), 113)) = 1 then convert(datetime, concat(STJ.TJ_DTORIGI, ' ', nullif(trim(STJ.TJ_HORACO1), ':')), 113) else null end as DATA_OS,
	case when isdate(concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI)) = 1 then convert(datetime, concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI), 113) else null end as DTH_INIMNT,
	case when isdate(concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI)) = 1 then convert(datetime, concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI), 113) else null end as DTH_INIPAR,
	case when isdate(concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM)) = 1 then convert(datetime, concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM), 113) else null end as DTH_FIMMNT,
	case when isdate(concat(STJ.TJ_DTPRFIM, ' ', STJ.TJ_HOPRFIM)) = 1 then convert(datetime, concat(STJ.TJ_DTPRFIM, ' ', STJ.TJ_HOPRFIM), 113) else null end as DTH_FIMPAR,

	TQB.TQB_SOLICI as SS,
    convert(datetime, concat(TQB.TQB_DTABER, ' ', TQB.TQB_HOABER), 113) as DT_INICISS,
    convert(datetime, concat(TQB.TQB_DTFECH, ' ', TQB.TQB_HOFECH), 113) as DT_ENCERSS,
	convert(datetime, concat(TQB.TQB_DTCANC, ' ', TQB.TQB_HRCANC), 113) as DT_CANCESS,
    
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
	
	case when isdate(concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI)) = 1 and isdate(concat(STJ.TJ_DTPRFIM, ' ', STJ.TJ_HOPRFIM)) = 1 then cast(datediff(minute, STJ.TJ_DTPRINI, STJ.TJ_DTPRFIM) as numeric(15, 2))/60.0 else 0.0 end as TEMPO_PAR,
	case when isdate(concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI)) = 1 and isdate(concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM)) = 1 then cast(datediff(minute, STJ.TJ_DTMRINI, STJ.TJ_DTMRFIM) as numeric(15, 2))/60.0 else 0.0 end as TEMPO_MNT,
	case when isdate(concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI)) = 1 then datediff(minute, concat(TQB.TQB_DTABER, ' ', TQB.TQB_HOABER), concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI))/60.0 else null end as TEMPO_SS_OS,
	(
		select
			case when exists(SC7.C7_NUM) then
				case
					when trim(SC7.C7_RESIDUO) = 'S' then 'ELIMINADO' /* CINZA */
					when trim(SC7.C7_CONAPRO) = 'B' and (cast(SC7.C7_QUJE as numeric(15, 2)) < cast(SC7.C7_QUANT as numeric(15, 2))) then 'BLOQUEADO' /* AZUL */
					when cast(SC7.C7_QUJE as numeric(15, 2)) >= cast(SC7.C7_QUANT as numeric(15, 2)) then 'RECEBIDO' /* VERMELHO */
					when cast(SC7.C7_QUJE as numeric(15, 2)) != 0.00 and (cast(SC7.C7_QUJE as numeric(15, 2)) < cast(SC7.C7_QUANT as numeric(15, 2))) then 'REC. PARCIAL' /* AMARELO */
					when cast(SC7.C7_QTDACLA as numeric(15, 2)) > 0.00 then 'PRÉ-NOTA' /* LARANJA */
					when cast(SC7.C7_TIPO as int) = 1 and SC7.C7_RESIDUO = '' then 'APROVADO' /* VERDE */
				else 'OUTROS' end
			else 'SEM PEDIDO DE COMPRA'
			end
		from STL010 (nolock)
			left join SD1010 (nolock)
				on SD1010.D_E_L_E_T_ = ''
				and SD1010.D1_FILIAL = STL010.TL_FILIAL
				and left(SD1010.D1_OP, 6) = STL010.TL_ORDEM
				and SD1010.D1_DOC = STL010.TL_NOTFIS
				and SD1010.D1_SERIE = STL010.TL_SERIE
				and SD1010.D1_ITEM = STL010.TL_ITEM
				and SD1010.D1_FORNECE = STL010.TL_FORNEC
				and SD1010.D1_LOJA = STL010.TL_LOJA

				left join SC7010 SC7 (nolock)
					on SC7.D_E_L_E_T_ = ''
					and SC7.C7_FILIAL = SD1.D1_FILIAL
					and SC7.C7_NUM = SD1.D1_PEDIDO
					and SC7.C7_ITEM = SD1.D1_ITEMPC
		where
			on STL010.TL_ORIGNFE = 'SD1'
			on STJ.D_E_L_E_T_ = ''
			and STJ.TJ_ORDEM = STL.TL_ORDEM
			and STJ.TJ_PLANO = STL.TL_PLANO
			and STJ.TJ_FILIAL = STL.TL_FILIAL

	) as STATUS_COMPRA,

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
