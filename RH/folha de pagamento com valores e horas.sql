select
	trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_NOMECMP) as NOME,
	trim(SRA.RA_MUNICIP) as MUNICIPIO,
	trim(SRA.RA_ESTADO) as UF,
	cast(SRA.RA_ADMISSA as date) as ADMISSAO,
	cast(SRA.RA_DEMISSA as date) as DEMISSAO,
	SRA.RA_SITFOLH as SITUACAO,
	case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
	trim(SRD.RD_CC) as CC,
	trim(SRD.RD_ITEM) as ITCT,
	trim(SQB.QB_DEPTO) as DEPTO,
	trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
	trim(SRA.RA_SEXO) as SEXO,
	trim(SRA.RA_CIC) as CPF,
	trim(SRD.RD_PERIODO) as PERIODO,
	trim(SRD.RD_ROTEIR) as ROTEIRO,

	case when SRV.RV_YCPOR = 'S' and SRV.RV_YCTMS = 'S' then 'AMBOS' when SRV.RV_YCPOR = 'S' then 'OPP' when SRV.RV_YCTMS = 'S' then 'TMS' else 'OUTRAS' end as VERBA_CUSTO,
	
	SRD.RD_VALOR as VALOR,
	SRD.RD_HORAS as HORAS,
	SRA.RA_SALARIO as SALARIO,
	SRA.RA_HRSEMAN as HORAS_SEM,
	SRD.RD_DATARQ as DATARQ,
	SRD.RD_STATUS as STATUS_LANC,
	
	trim(SRD.RD_PD) as VERBA,
	trim(SRD.RD_SEQ) as SEQ,
	trim(SRV.RV_DESC) as DESC_VERBA1,
	case SRV.RV_COD
		when '183' then 'VALOR A RECEBER'
		when '999' then 'VALOR A RECEBER'
	else trim(SRV.RV_DESCDET) end as DESC_VERBA2,

	case trim(SRV.RV_TIPOCOD)
		when '1' then 'PROVENTO'
		when '2' then 'DESCONTO'
		when '3' then 'BASE PROVENTO'
		when '4' then 'BASE DESCONTO'
		else '-'
	end as TIPO_VERBA,

	(
		select top 1 last_value(trim(SR7010.R7_CARGO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
		from SR7010
		where
				SR7010.D_E_L_E_T_ = ''
			and SR7010.R7_FILIAL = SRD.RD_FILIAL
			and SR7010.R7_MAT = SRD.RD_MAT
			and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
	) as CARGO_FOLHA,
	(
		select top 1 last_value(trim(SR7010.R7_FUNCAO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
		from SR7010
		where
				SR7010.D_E_L_E_T_ = ''
			and SR7010.R7_FILIAL = SRD.RD_FILIAL
			and SR7010.R7_MAT = SRD.RD_MAT
			and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
	) as FUNCAO_FOLHA,
	(
		select trim(SQ3010.Q3_DESCSUM)
		from SQ3010
		where
				SQ3010.D_E_L_E_T_ = ''
			and SQ3010.Q3_CARGO =
			(
				select top 1 last_value(SR7010.R7_CARGO) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
				from SR7010
				where
						SR7010.D_E_L_E_T_ = ''
					and SR7010.R7_FILIAL = SRD.RD_FILIAL
					and SR7010.R7_MAT = SRD.RD_MAT
					and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
			)
	) as DESC_CARGO,
	(
		select trim(SRJ010.RJ_DESC)
		from SRJ010
		where
				SRJ010.D_E_L_E_T_ = ''
			and SRJ010.RJ_FUNCAO =
			(
				select top 1 last_value(SR7010.R7_FUNCAO) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
				from SR7010
				where
						SR7010.D_E_L_E_T_ = ''
					and SR7010.R7_FILIAL = SRD.RD_FILIAL
					and SR7010.R7_MAT = SRD.RD_MAT
					and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
			)
	) as DESC_FUNCAO,
	(
		select top 1 last_value(trim(SR7010.R7_CARGO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
		from SR7010
		where
				SR7010.D_E_L_E_T_ = ''
			and SR7010.R7_FILIAL = SRD.RD_FILIAL
			and SR7010.R7_MAT = SRD.RD_MAT
			and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')
	) as CARGO_ANT,
	(
		select top 1 last_value(trim(SR7010.R7_CARGO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
		from SR7010
		where
				SR7010.D_E_L_E_T_ = ''
			and SR7010.R7_FILIAL = SRD.RD_FILIAL
			and SR7010.R7_MAT = SRD.RD_MAT
			and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
	) as CARGO_PRO,
	(
		select top 1 last_value(trim(SR7010.R7_FUNCAO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
		from SR7010
		where
				SR7010.D_E_L_E_T_ = ''
			and SR7010.R7_FILIAL = SRD.RD_FILIAL
			and SR7010.R7_MAT = SRD.RD_MAT
			and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')
	) as FUNCAO_ANT,
	(
		select top 1 last_value(trim(SR7010.R7_FUNCAO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
		from SR7010
		where
				SR7010.D_E_L_E_T_ = ''
			and SR7010.R7_FILIAL = SRD.RD_FILIAL
			and SR7010.R7_MAT = SRD.RD_MAT
			and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
	) as FUNCAO_PRO,

    1 + datediff(day, concat(SRD.RD_DATARQ, '01'), eomonth(concat(SRD.RD_DATARQ, '01'))) as DIAS_PERIODO,
	cast(concat(SRD.RD_DATARQ, '01') as date) as INI_PERIODO,
	eomonth(concat(SRD.RD_DATARQ, '01')) as FIM_PERIODO,

    (
        select cast(max(SR7010.R7_DATA) as date)
        from SR7010
        where
                SR7010.D_E_L_E_T_ = ''
            and SR7010.R7_FILIAL = SRD.RD_FILIAL
            and SR7010.R7_MAT = SRD.RD_MAT
            and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
			and
				(
					select top 1 last_value(trim(SR7010.R7_FUNCAO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
					from SR7010
					where
							SR7010.D_E_L_E_T_ = ''
						and SR7010.R7_FILIAL = SRD.RD_FILIAL
						and SR7010.R7_MAT = SRD.RD_MAT
						and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')
				)
				!=
				(
					select top 1 last_value(trim(SR7010.R7_FUNCAO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
					from SR7010
					where
							SR7010.D_E_L_E_T_ = ''
						and SR7010.R7_FILIAL = SRD.RD_FILIAL
						and SR7010.R7_MAT = SRD.RD_MAT
						and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
				)
    ) as MUD_FUNCAO,
    
	(
        select cast(max(SR7010.R7_DATA) as date)
        from SR7010
        where
                SR7010.D_E_L_E_T_ = ''
            and SR7010.R7_FILIAL = SRD.RD_FILIAL
            and SR7010.R7_MAT = SRD.RD_MAT
            and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
			and
				(
					select top 1 last_value(trim(SR7010.R7_CARGO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
					from SR7010
					where
							SR7010.D_E_L_E_T_ = ''
						and SR7010.R7_FILIAL = SRD.RD_FILIAL
						and SR7010.R7_MAT = SRD.RD_MAT
						and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')
				)
				!=
				(
					select top 1 last_value(trim(SR7010.R7_CARGO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
					from SR7010
					where
							SR7010.D_E_L_E_T_ = ''
						and SR7010.R7_FILIAL = SRD.RD_FILIAL
						and SR7010.R7_MAT = SRD.RD_MAT
						and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
				)
    ) as MUD_CARGO,
    
	datediff
	(
		day,
		case when left(SRA.RA_ADMISSA, 6) = SRD.RD_DATARQ then SRA.RA_ADMISSA else concat(SRD.RD_DATARQ, '01') end,
		case when
		(
			select max(SR7010.R7_DATA)
			from SR7010
			where
					SR7010.D_E_L_E_T_ = ''
				and SR7010.R7_FILIAL = SRD.RD_FILIAL
				and SR7010.R7_MAT = SRD.RD_MAT
				and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
		) >= concat(SRD.RD_DATARQ, '01') then /* se a última mudança ocorreu dentro do período da folha, data da mudança; senão, início do período*/
		(
			select max(SR7010.R7_DATA)
			from SR7010
			where
					SR7010.D_E_L_E_T_ = ''
				and SR7010.R7_FILIAL = SRD.RD_FILIAL
				and SR7010.R7_MAT = SRD.RD_MAT
				and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
		)
		else concat(SRD.RD_DATARQ, '01') end
	) as DIAS_ANT,
	
	SRA.RA_HRSMES *
	datediff
	(
		day,
		case when left(SRA.RA_ADMISSA, 6) = SRD.RD_DATARQ then SRA.RA_ADMISSA else concat(SRD.RD_DATARQ, '01') end,
		case when
		(
			select max(SR7010.R7_DATA)
			from SR7010
			where
					SR7010.D_E_L_E_T_ = ''
				and SR7010.R7_FILIAL = SRD.RD_FILIAL
				and SR7010.R7_MAT = SRD.RD_MAT
				and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
		) >= concat(SRD.RD_DATARQ, '01') then /* se a última mudança ocorreu dentro do período da folha, data da mudança; senão, início do período*/
		(
			select max(SR7010.R7_DATA)
			from SR7010
			where
					SR7010.D_E_L_E_T_ = ''
				and SR7010.R7_FILIAL = SRD.RD_FILIAL
				and SR7010.R7_MAT = SRD.RD_MAT
				and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
		)
		else concat(SRD.RD_DATARQ, '01') end
	)/(1 + datediff(day, concat(SRD.RD_DATARQ, '01'), eomonth(concat(SRD.RD_DATARQ, '01')))) as HORAS_ANT,
	
	SRD.RD_VALOR *
	(
		datediff
		(
			day,
			case when left(SRA.RA_ADMISSA, 6) = SRD.RD_DATARQ then SRA.RA_ADMISSA else concat(SRD.RD_DATARQ, '01') end,
			case when
			(
				select max(SR7010.R7_DATA)
				from SR7010
				where
						SR7010.D_E_L_E_T_ = ''
					and SR7010.R7_FILIAL = SRD.RD_FILIAL
					and SR7010.R7_MAT = SRD.RD_MAT
					and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
			) >= concat(SRD.RD_DATARQ, '01') then
			(
				select max(SR7010.R7_DATA)
				from SR7010
				where
						SR7010.D_E_L_E_T_ = ''
					and SR7010.R7_FILIAL = SRD.RD_FILIAL
					and SR7010.R7_MAT = SRD.RD_MAT
					and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
			)
			else concat(SRD.RD_DATARQ, '01') end
		)
	) / (1 + datediff(day, concat(SRD.RD_DATARQ, '01'), eomonth(concat(SRD.RD_DATARQ, '01')))) as VALOR_ANT,

	datediff
	(
		day,
		case when
		(
			select max(SR7010.R7_DATA)
			from SR7010
			where
					SR7010.D_E_L_E_T_ = ''
				and SR7010.R7_FILIAL = SRD.RD_FILIAL
				and SR7010.R7_MAT = SRD.RD_MAT
				and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
		) >= concat(SRD.RD_DATARQ, '01') then /* se a última mudança ocorreu dentro do período da folha, data da mudança; senão, início do período*/
		(
			select max(SR7010.R7_DATA)
			from SR7010
			where
					SR7010.D_E_L_E_T_ = ''
				and SR7010.R7_FILIAL = SRD.RD_FILIAL
				and SR7010.R7_MAT = SRD.RD_MAT
				and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
		)
		else concat(SRD.RD_DATARQ, '01') end,
		case when left(SRA.RA_DEMISSA, 6) = SRD.RD_DATARQ then SRA.RA_DEMISSA else dateadd(day, 1, eomonth(concat(SRD.RD_DATARQ, '01'))) end
	) as DIAS_PRO,

	SRA.RA_HRSMES * datediff
	(
		day,
		case when
		(
			select max(SR7010.R7_DATA)
			from SR7010
			where
					SR7010.D_E_L_E_T_ = ''
				and SR7010.R7_FILIAL = SRD.RD_FILIAL
				and SR7010.R7_MAT = SRD.RD_MAT
				and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
		) >= concat(SRD.RD_DATARQ, '01') then /* se a última mudança ocorreu dentro do período da folha, data da mudança; senão, início do período*/
		(
			select max(SR7010.R7_DATA)
			from SR7010
			where
					SR7010.D_E_L_E_T_ = ''
				and SR7010.R7_FILIAL = SRD.RD_FILIAL
				and SR7010.R7_MAT = SRD.RD_MAT
				and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
		)
		else concat(SRD.RD_DATARQ, '01') end,
		case when left(SRA.RA_DEMISSA, 6) = SRD.RD_DATARQ then SRA.RA_DEMISSA else dateadd(day, 1, eomonth(concat(SRD.RD_DATARQ, '01'))) end
	) / (1 + datediff(day, concat(SRD.RD_DATARQ, '01'), eomonth(concat(SRD.RD_DATARQ, '01')))) as HORAS_PRO,
	
	SRD.RD_VALOR *
	(
		datediff
		(
			day,
			case when
			(
				select max(SR7010.R7_DATA)
				from SR7010
				where
						SR7010.D_E_L_E_T_ = ''
					and SR7010.R7_FILIAL = SRD.RD_FILIAL
					and SR7010.R7_MAT = SRD.RD_MAT
					and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
			) >= concat(SRD.RD_DATARQ, '01') then
			(
				select max(SR7010.R7_DATA)
				from SR7010
				where
						SR7010.D_E_L_E_T_ = ''
					and SR7010.R7_FILIAL = SRD.RD_FILIAL
					and SR7010.R7_MAT = SRD.RD_MAT
					and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
			)
			else concat(SRD.RD_DATARQ, '01') end,
			case when left(SRA.RA_DEMISSA, 6) = SRD.RD_DATARQ then SRA.RA_DEMISSA else dateadd(day, 1, eomonth(concat(SRD.RD_DATARQ, '01'))) end
		)
	) / (1 + datediff(day, concat(SRD.RD_DATARQ, '01'), eomonth(concat(SRD.RD_DATARQ, '01')))) as VALOR_PRO

from SRD010 SRD (nolock)
	inner join SRV010 SRV (nolock)
		on SRV.D_E_L_E_T_ = ''
		and substring(SRD.RD_FILIAL, 1, 4) = SRV.RV_FILIAL
		and SRD.RD_PD = SRV.RV_COD
	inner join SRA010 SRA (nolock)
		on SRA.D_E_L_E_T_ = ''
		and SRA.RA_FILIAL = SRD.RD_FILIAL
		and SRA.RA_MAT = SRD.RD_MAT
	
		left join SQB010 SQB (nolock)
			on SQB.D_E_L_E_T_ = ''
			and SQB.QB_DEPTO = isnull(SRD.RD_DEPTO, SRA.RA_DEPTO)
		left join SRJ010 SRJ (nolock)
			on SRJ.D_E_L_E_T_ = ''
			and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
			and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
			
			left join SQ3010 SQ3 (nolock)
				on SQ3.D_E_L_E_T_ = ''
				and SQ3.Q3_CARGO = SRJ.RJ_CARGO
where
		SRD.RD_PERIODO =:PERIODO_FOLHA
	and SRD.D_E_L_E_T_ = ''
