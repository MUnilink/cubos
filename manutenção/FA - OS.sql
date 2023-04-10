select
	STL.TL_SEQRELA,
	STL.TL_QUANTID,

	case when trim(STL.TL_CODIGO) in ('11380003', '11380004', '11380005') and STL.TL_LOCAL = '80' then ADESIVO_CUSTO.B9_CM * STL.TL_QUANTID
	else
		case when trim(STL.TL_CODIGO) in ('T05', 'T12', 'T15', 'T16', 'T17') then ST1.T1_SALARIO * STL.TL_QUANTID
		else
			case when STL.TL_TIPOREG = 'M' and substring(STL.TL_DTINICI, 1, 6) > (select trim(SX6010.X6_CONTEUD) from SX6010 where SX6010.X6_VAR = 'MV_GPMESCT')
				then
				(
					select avg(STL010.TL_CUSTO)
					from STL010
					where
							STL010.D_E_L_E_T_ = ''
						and STL010.TL_CODIGO = STL.TL_CODIGO
						and substring(STL010.TL_DTINICI, 1, 6) = (select trim(SX6010.X6_CONTEUD) from SX6010 where SX6010.X6_VAR = 'MV_GPMESCT')
				)
			else STL.TL_CUSTO
			end
		end
	end as TL_CUSTO,

	convert(datetime, datetimefromparts(year(STL.TL_DTINICI), month(STL.TL_DTINICI), day(STL.TL_DTINICI), substring(STL.TL_HOINICI, 1, 2), substring(STL.TL_HOINICI, 4, 5), 0, 0), 113) as TL_DTINICI,
	convert(datetime, datetimefromparts(year(STL.TL_DTFIM), month(STL.TL_DTFIM), day(STL.TL_DTFIM), substring(STL.TL_HOFIM, 1, 2), substring(STL.TL_HOFIM, 4, 5), 0, 0), 113) as TL_DTINFIM,
	convert(date, STJ.TJ_DTORIGI, 103) as TJ_DTORIGI,
	
	STJ.TJ_POSCONT,
	case when substring(ST9.T9_DTCOMPR, 1, 6) = substring(STL.TL_DTINICI, 1, 6) then ST9.T9_VALCPA else 0.0 end as T9_VALCPA,
	STJ.TJ_CUSTMDO,
	STJ.TJ_CUSTMAT,
	STJ.TJ_CUSTMAA,
	STJ.TJ_CUSTMAS,
	STJ.TJ_CUSTTER,

	trim(isnull(STL.TL_CODIGO, '-')) as INSUMO,
	trim(isnull(STL.TL_LOCAL, '-')) as ARMAZEM,
	
	case STL.TL_TIPOREG
		when 'M' then 'MÃO-DE-OBRA'
		when 'E' then 'MÃO-DE-OBRA'
		when 'P' then 'PEÇAS'
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

	trim(isnull(STJ.TJ_ORDEM, '-')) as TJ_ORDEM,
	trim(isnull(STL.TL_TAREFA, '-')) as TL_TAREFA,
	trim(isnull(STJ.TJ_CODBEM, '-')) as TJ_CODBEM,
	trim(isnull(SH4.H4_CODIGO, '-')) as H4_CODIGO,
	trim(isnull(ST0.T0_ESPECIA, '-')) as T0_ESPECIA,
	trim(isnull(ST1.T1_CODFUNC, '-')) as T1_CODFUNC,

	trim(isnull(SB1.B1_GRUPO, '-')) as B1_GRUPO,
	trim(isnull(SB1.B1_COD, '-')) as B1_COD,
	trim(isnull(SA2.A2_COD + SA2.A2_LOJA, '-')) as ID_FORNECEDOR,
	trim(isnull(STI.TI_PLANO, '-')) as TI_PLANO,
	trim(isnull(STJ.TJ_FILIAL, '-')) as COD_FILIAL,
	trim(isnull(ST4.T4_SERVICO, '-')) as T4_SERVICO,
	trim(isnull(STJ.TJ_CCUSTO, '-')) as CC,
	trim(isnull(STJ.TJ_YITMCT, '-')) as ATIVIDADE,
	ST1.T1_SALARIO,
	SB1.B1_UPRC,

	/* ABAIXO DADOS DE CONTROLE PELO RM*/

	case when trim(STL.TL_CODIGO) in ('11380003', '11380004', '11380005') and STL.TL_LOCAL = '80' then ADESIVO_CUSTO.B9_CM
	else
		case when trim(STL.TL_CODIGO) in ('T05', 'T12', 'T15', 'T16', 'T17', 'T18') then ST1.T1_SALARIO
		else
			case when STL.TL_QUANTID != 0.0 and STL.TL_TIPOREG = 'M' and substring(STL.TL_DTINICI, 1, 6) > (select trim(SX6010.X6_CONTEUD) from SX6010 where SX6010.X6_VAR = 'MV_GPMESCT')
				then
				(
					select avg(STL010.TL_CUSTO)
					from STL010
					where
							STL010.D_E_L_E_T_ = ''
						and STL010.TL_CODIGO = STL.TL_CODIGO
						and substring(STL010.TL_DTINICI, 1, 6) = (select trim(SX6010.X6_CONTEUD) from SX6010 where SX6010.X6_VAR = 'MV_GPMESCT')
				) / STL.TL_QUANTID
			else
				case when STL.TL_QUANTID != 0.0 then STL.TL_CUSTO / STL.TL_QUANTID
				else
					0.0
				end
			end
		end
	end as TL_UNI,

	case STL.TL_SEQRELA when 0 then 'PREVISTO' else 'REALIZADO' end as APP_INSUMO,
	trim(isnull(TT9.TT9_DESCRI, '-')) as T5_TAREFA,
	trim(isnull(STJ.TJ_USUAFIM, '-')) as TJ_USUAFIM,
	STJ.TJ_SERVICO,
	STJ.TJ_POSCONT as CONTADOR_ATUAL,
	STJ.TJ_HORACO1 as HORA_CONT,
	lag(STJ.TJ_POSCONT) over(partition by STJ.TJ_CODBEM order by STJ.TJ_DTORIGI, STJ.TJ_HORACO1) as CONTADOR_ANTERIOR,

	trim(isnull(SB1.B1_GRUPO, '-')) as B1_GRUPO,
	trim(isnull(SB1.B1_COD, '-')) as B1_COD,
	trim(isnull(SB1.B1_DESC, '-')) as B1_DESC,
	substring(STL.TL_DTINICI, 1, 6) as PERIODO,
	SCP.CP_NUM as SA,
	SCP.CP_QUANT as SA_QTD_SOLICTADA,
    SCP.CP_QUJE as SA_QTD_ATENDIDA,

    case when SCP.CP_QUANT = SCP.CP_QUJE then 'TOT. ATENDIDA'
    else
        case when SCP.CP_QUJE = 0.0 then 'PENDENTE'
        else
            case when SCP.CP_QUANT > SCP.CP_QUJE then 'PAR. ATENDIDA'
            else 'OUTROS'
            end
        end
    end as SA_ATENDIDA

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
			and STL.TL_FILIAL = SCP.CP_FILIAL
			and STL.TL_ORDEM = substring(SCP.CP_OP, 1, 6)
			and STL.TL_CODIGO = SCP.CP_PRODUTO

		left join TT9010 TT9 (nolock)
			on TT9.D_E_L_E_T_ = ''
			and TT9.TT9_TAREFA = STL.TL_TAREFA

		left join
		(
			select
				SB9010.B9_COD,
				min(SB9010.B9_VINI1/SB9010.B9_QINI) as B9_CM,
				min(SB9010.B9_DATA) as B9_DATA
			from SB9010 (nolock)
			where
					SB9010.D_E_L_E_T_ = ''
				and SB9010.B9_LOCAL = '01'
				and SB9010.B9_COD in ('11380003', '11380004', '11380005')
				and SB9010.B9_QINI != 0
			group by
				SB9010.B9_COD
		) ADESIVO_CUSTO
			on ADESIVO_CUSTO.B9_COD = STL.TL_CODIGO
		
		left join SA2010 SA2 (nolock)
			on SA2.D_E_L_E_T_ = ''
			and SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA
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
		left join STI010 STI (nolock)
			on STI.D_E_L_E_T_ = ''
			and STI.TI_FILIAL = STL.TL_FILIAL
			and STI.TI_PLANO = STL.TL_PLANO
where
		STL.D_E_L_E_T_ = ''
