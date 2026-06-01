select
	convert(datetime, getdate(), 113) as ULTIMA_CARGA,
	cast(trim(STL.TL_SEQRELA) as int) as ITEM_OS,
	cast(STL.TL_QUANTID as numeric(15, 2)) as TL_QUANTID,

	cast
	(
		case
			when trim(STL.TL_CODIGO) in ('11380003', '11380004', '11380005') and STL.TL_LOCAL = '80' then ADESIVO_CUSTO.B9_CM * STL.TL_QUANTID
			when STL.TL_TIPOREG = 'M' and trim(STL.TL_CODIGO) like 'T%' then ST1.T1_SALARIO * STL.TL_QUANTID
			when STL.TL_TIPOREG = 'M' and left(STL.TL_DTINICI, 6) > (select trim(SX6010.X6_CONTEUD) from SX6010 where SX6010.X6_VAR = 'MV_GPMESCT') then
			(
				select avg(STL010.TL_CUSTO)
				from STL010
				where
						STL010.D_E_L_E_T_ = ''
					and STL010.TL_CODIGO = STL.TL_CODIGO
					and left(STL010.TL_DTINICI, 6) = (select trim(SX6010.X6_CONTEUD) from SX6010 where SX6010.X6_VAR = 'MV_GPMESCT')
			)
			else STL.TL_CUSTO
		end
		as numeric(15, 2)
	) as TL_CUSTO,

	case
		when isdate(concat(STL.TL_DTINICI, ' ', STL.TL_HOINICI)) = 1 then convert(datetime, concat(STL.TL_DTINICI, ' ', STL.TL_HOINICI), 120)
		when isdate(STL.TL_DTINICI) = 1 then convert(datetime, concat(STL.TL_DTINICI, ' ', '00:00:00'), 120)
	else convert(datetime, concat(STJ.TJ_DTORIGI , ' ', '00:00:00'), 120) end as DTINI_APP,
	
	case
		when isdate(concat(STL.TL_DTFIM, ' ', STL.TL_HOFIM)) = 1 then convert(datetime, concat(STL.TL_DTFIM, ' ', STL.TL_HOFIM), 120)
		when isdate(STL.TL_DTFIM) = 1 then convert(datetime, concat(STL.TL_DTFIM, ' ', '00:00:00'), 120)
	else convert(datetime, concat(STJ.TJ_DTPRFIM , ' ', '00:00:00'), 120) end as DTFIM_APP,
	
	STJ.TJ_DTORIGI as DATA_INIOS,
	STJ.TJ_DTPRFIM as DATA_FIMOS,
	STJ.TJ_TERMINO as OS_ENCERRADA,
	STJ.TJ_SITUACA as SITUACAO,
	STJ.TJ_POSCONT,
	(select max(ST6010.T6_YHRPADR) from ST6010 where ST6010.D_E_L_E_T_ = '' and ST6010.T6_CODFAMI = ST9.T9_CODFAMI) as HORA_PADRAO,
	trim(STL.TL_CODIGO) as INSUMO,
	trim(STL.TL_LOCAL) as ARMAZEM,

	case STL.TL_TIPOREG
		when 'M' then 'MÃO-DE-OBRA'
		when 'E' then 'ESPECIALIDADE'
		when 'P' then case when SB1.B1_GRUPO = '2201' then 'TERCEIROS' when STL.TL_ORIGNFE = 'SD1' then 'PEÇAS DIRETAS' else 'PEÇAS' end
		when 'T' then 'TERCEIROS'
		else 'OUTROS'
	end as TIPO_CUSTO,

	case STL.TL_TIPOREG
		when 'M' then trim(ST1.T1_NOME)
		when 'E' then trim(ST0.T0_NOME)
		when 'P' then trim(SB1.B1_DESC)
		when 'T' then trim(SA2.A2_NOME)
		else 'OUTROS'
	end as DESC_INSUMO,

	trim(STJ.TJ_TIPO) as CARAC_TIPO,
	trim(STJ.TJ_ORDEM) as TJ_ORDEM,
	trim(STL.TL_TAREFA) as T5_TAREFA,
	trim(STJ.TJ_CODBEM) as TJ_CODBEM,
	trim(SH4.H4_CODIGO) as H4_CODIGO,
	trim(ST0.T0_ESPECIA) as T0_ESPECIA,
	trim(ST1.T1_CODFUNC) as T1_CODFUNC,
	trim(SB1.B1_GRUPO) as B1_GRUPO,
	trim(SB1.B1_COD) as B1_COD,
	trim(SA2.A2_COD) + trim(SA2.A2_LOJA) as ID_FORNECEDOR,
	trim(STL.TL_PLANO) as TI_PLANO,
	trim(STL.TL_FILIAL) as COD_FILIAL,
	trim(STJ.TJ_SERVICO) as T4_SERVICO,
	trim(STJ.TJ_CCUSTO) as CC,
	coalesce(nullif(trim(STJ.TJ_YITMCT), ''), nullif((select top 1 last_value(TPN010.TPN_XITEMC) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_CODBEM, TPN010.TPN_DTINIC, TPN010.TPN_HRINIC) from TPN010 where TPN010.D_E_L_E_T_ = '' and TPN010.TPN_CODBEM = STJ.TJ_CODBEM and TPN010.TPN_DTINIC <= STL.TL_DTINICI), '')) as ATIVIDADE,
	trim(SD1.D1_PEDIDO) as PEDCOMPRA,
	
	case
        when STL.TL_TIPOREG = 'M' and ST1.T1_CCUSTO = '302' and ST1.T1_DTFIMDI <= STL.TL_DTFIM and SH7.H7_CODIGO = '001' then 220.0
        when STL.TL_TIPOREG = 'M' and ST1.T1_CCUSTO = '303' and ST1.T1_DTFIMDI <= STL.TL_DTFIM and SH7.H7_CODIGO = '015' then 220.0
        when STL.TL_TIPOREG = 'M' and ST1.T1_CCUSTO = '303' and ST1.T1_DTFIMDI <= STL.TL_DTFIM and SH7.H7_CODIGO = '016' then 180.0
        when STL.TL_TIPOREG = 'M' and ST1.T1_CCUSTO = '303' and ST1.T1_DTFIMDI <= STL.TL_DTFIM and SH7.H7_CODIGO = '017' then 180.0
    else 0.0 end as HORAS_FUNC,

	/*
		**** ABAIXO DADOS DE CONTROLE PELO RM ****
	*/

	ST9.T9_NOME,
	case
		when trim(STL.TL_CODIGO) in ('11380003', '11380004', '11380005') and STL.TL_LOCAL = '80' then ADESIVO_CUSTO.B9_CM
		when STL.TL_TIPOREG = 'M' and trim(STL.TL_CODIGO) like 'T%' then ST1.T1_SALARIO * STL.TL_QUANTID
		when STL.TL_TIPOREG = 'M' and left(STL.TL_DTINICI, 6) > (select trim(SX6010.X6_CONTEUD) from SX6010 where SX6010.X6_VAR = 'MV_GPMESCT') then
		(
			select avg(STL010.TL_CUSTO)
			from STL010
			where
					STL010.D_E_L_E_T_ = ''
				and STL010.TL_CODIGO = STL.TL_CODIGO
				and left(STL010.TL_DTINICI, 6) = (select trim(SX6010.X6_CONTEUD) from SX6010 where SX6010.X6_VAR = 'MV_GPMESCT')
		) / STL.TL_QUANTID
		when STL.TL_QUANTID != 0.0 then STL.TL_CUSTO / STL.TL_QUANTID
	else 0.0
	end as TL_UNI,
	
	STL.TL_CUSTO as CUSTO_MNT,
	case when isdate(concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI)) = 1 then convert(datetime, concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI), 113) else null end as DATAHORA_IOS,
	case when isdate(concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM)) = 1 then convert(datetime, concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM), 113) else null end as DATAHORA_FOS,

	cast(STL.TL_DTINICI as date) as DATAINI_APP,
	STL.TL_HOINICI as HORA_INIAPP,
	case when isdate(concat(STL.TL_DTINICI, ' ', STL.TL_HOINICI)) = 1 then convert(datetime, concat(STL.TL_DTINICI, ' ', STL.TL_HOINICI), 113) else null end as DATAHORA_IRET,
	cast(STL.TL_DTFIM as date) as DATAFIM_APP,
	STL.TL_HOFIM as HORA_FIMAPP,
	case when isdate(concat(STL.TL_DTFIM, ' ', STL.TL_HOFIM)) = 1 then convert(datetime, concat(STL.TL_DTFIM, ' ', STL.TL_HOFIM), 113) else null end as DATAHORA_FRET,

	case STL.TL_SEQRELA when 0 then 'PREVISTO' else 'REALIZADO' end as APP_INSUMO,
	STL.TL_SEQRELA as ITEM,
	ST9.T9_CODFAMI as FAMILIA,
	trim(STJ.TJ_USUARIO) as TJ_USUAINI,
	trim(STJ.TJ_USUAFIM) as TJ_USUAFIM,
	case STJ.TJ_SERVICO when 'PNEMOV' then 'PNEUS' when 'CONSEP' then 'PNEUS' when 'REFORP' then 'PNEUS' when 'PNEROD' then 'PNEUS' else 'MNT' end as TIPO_SERV,
	STJ.TJ_POSCONT as CONTADOR_ATUAL,
	STJ.TJ_HORACO1 as HORA_CONT,
	lag(STJ.TJ_POSCONT) over(partition by STJ.TJ_CODBEM order by STJ.TJ_DTORIGI, STJ.TJ_HORACO1) as CONTADOR_ANTERIOR,

	substring(STL.TL_DTFIM, 1, 6) as PERIODO,
	substring(STJ.TJ_DTORIGI, 1, 6) as PERIODO_OS,
	STJ.TJ_TERMINO as TERMINO,
	STJ.TJ_SITUACA as SITUACAO,

	concat(trim(SH7.H7_CODIGO), ' - ', trim(SH7.H7_DESCRI)) as TURNO_MDO,
    cast(ST1.T1_DTFIMDI as date) as FIM_DISP,
    trim(ST1.T1_CCUSTO) as CC_FUNC,
	
	trim(ST4.T4_NOME) as DESC_SERVICO,
	trim(TT9.TT9_DESCRI) as DESC_TAREFA,
	SCP.CP_NUM as SA,
	SCP.CP_QUANT as SA_QTD_SOLICTADA,
    SCP.CP_QUJE as SA_QTD_ATENDIDA,
	trim(SCP.CP_SOLICIT) as SOLICITANTE_SA,
	trim(SB1.B1_GRUPO) as B1_GRUPO,
	trim(SB1.B1_COD) as B1_COD,
	trim(SB1.B1_DESC) as B1_DESC,

    case when SCP.CP_QUANT = SCP.CP_QUJE then 'TOT. ATENDIDA'
    else
        case when SCP.CP_QUJE = 0.0 then 'PENDENTE'
        else
            case when SCP.CP_QUANT > SCP.CP_QUJE then 'PAR. ATENDIDA'
            else 'OUTROS'
            end
        end
    end as SA_ATENDIDA,

	STL.TL_DOC as DOC,
	STL.TL_SDOC as SERIE,
	STL.TL_ORIGNFE as TIPO_DOC

from STJ010 STJ (nolock)
	inner join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = STJ.TJ_CODBEM

		left join TQR010 TQR (nolock)
			on 	TQR.D_E_L_E_T_ = ''
			and TQR.TQR_TIPMOD = ST9.T9_TIPMOD

	inner join ST4010 ST4 (nolock)
		on ST4.D_E_L_E_T_ = ''
		and ST4.T4_SERVICO = STJ.TJ_SERVICO
	inner join STL010 STL (nolock)
		on STL.D_E_L_E_T_ = ''
		and STL.TL_ORDEM = STJ.TJ_ORDEM
		and STL.TL_PLANO = STJ.TJ_PLANO
		and STL.TL_FILIAL = STJ.TJ_FILIAL

		left join SCP010 SCP (nolock)
			on SCP.D_E_L_E_T_ = ''
			and SCP.CP_FILIAL = STL.TL_FILIAL
			and SCP.CP_NUM = STL.TL_NUMSA
			and SCP.CP_ITEM = STL.TL_ITEMSA

		left join TT9010 TT9 (nolock)
			on TT9.D_E_L_E_T_ = ''
			and TT9.TT9_TAREFA = STL.TL_TAREFA

		left join
		(
			select
				SB9010.B9_FILIAL,
				SB9010.B9_DATA,
				SB9010.B9_COD,
				(SB9010.B9_VINI1/isnull(nullif(SB9010.B9_QINI, 0), 1)) as B9_CM
			from SB9010 (nolock)
			where
					SB9010.B9_QINI != 0
				and SB9010.B9_COD in ('11380003', '11380004', '11380005')
				and SB9010.B9_LOCAL = '01'
				and SB9010.D_E_L_E_T_ = ''
		) ADESIVO_CUSTO
			on ADESIVO_CUSTO.B9_FILIAL = STL.TL_FILIAL
			and left(ADESIVO_CUSTO.B9_DATA, 6) = left(STL.TL_DTFIM, 6)
			and ADESIVO_CUSTO.B9_COD = STL.TL_CODIGO
		
		left join SB1010 SB1 (nolock)
			on SB1.D_E_L_E_T_ = ''
			and SB1.B1_COD = STL.TL_CODIGO
		left join SH4010 SH4 (nolock)
			on SH4.D_E_L_E_T_ = ''
			and SH4.H4_CODIGO = STL.TL_CODIGO
		left join ST0010 ST0 (nolock)
			on ST0.D_E_L_E_T_ = ''
			and ST0.T0_ESPECIA = STL.TL_CODIGO
		left join ST1010 ST1 (nolock)
			on ST1.D_E_L_E_T_ = ''
			and ST1.T1_FILIAL = STL.TL_FILIAL
			and ST1.T1_CODFUNC = STL.TL_CODIGO

			left join SH7010 SH7 (nolock)
				on SH7.D_E_L_E_T_ = ''
				and SH7.H7_CODIGO = ST1.T1_TURNO
		
		left join STI010 STI (nolock)
			on STI.D_E_L_E_T_ = ''
			and STI.TI_FILIAL = STL.TL_FILIAL
			and STI.TI_PLANO = STL.TL_PLANO
		
		left join SD1010 SD1 (nolock)
			on STL.TL_ORIGNFE = 'SD1'
			and SD1.D_E_L_E_T_ = ''
			and SD1.D1_FILIAL = STL.TL_FILIAL
			and left(SD1.D1_OP, 6) = STL.TL_ORDEM
			and SD1.D1_DOC = STL.TL_NOTFIS
			and SD1.D1_SERIE = STL.TL_SERIE
			and SD1.D1_ITEM = STL.TL_ITEM
			and SD1.D1_FORNECE = STL.TL_FORNEC
			and SD1.D1_LOJA = STL.TL_LOJA

			left join SA2010 SA2 (nolock)
				on SA2.D_E_L_E_T_ = ''
				and SA2.A2_COD = SD1.D1_FORNECE
				and SA2.A2_LOJA = SD1.D1_LOJA
where
		STJ.TJ_DTORIGI between '20201231' and '20281231'
	and STL.D_E_L_E_T_ = ''
