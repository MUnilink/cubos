select
	trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_NOMECMP) as NOME,
	trim(SRA.RA_MUNICIP) as MUNICIPIO,
	trim(SRA.RA_ESTADO) as UF,
	convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
	case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
	case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
	trim(SRD.RD_CC) as CC,
	trim(SRD.RD_ITEM) as ITCT,
	trim(SQB.QB_DEPTO) as DEPTO,
	trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
	trim(SRA.RA_SEXO) as SEXO,
	trim(SRA.RA_CIC) as CPF,
	trim(isnull(SRD.RD_PERIODO, '-')) as PERIODO,
	trim(isnull(SRD.RD_ROTEIR, '-')) as ROTEIRO,

	case when exists (select * from SX6010 where SX6010.X6_VAR in ('UN_OSVERBA', 'UN_OSVERB1') and SX6010.X6_CONTEUD like '%' || SRD.RD_PD || '%') then 'CUSTOS' else 'OUTRAS' end as VERBA_CUSTO,
	SRD.RD_VALOR as VALOR,
	SRD.RD_HORAS as HORAS,
	SRA.RA_SALARIO as SALARIO,
	SRA.RA_HRSEMAN as HORAS_SEM,
	SRD.RD_DATARQ as DATARQ,
	SRD.RD_STATUS as STATUS_LANC,
	
	trim(SRD.RD_PD) as VERBA,
	trim(isnull(SRV.RV_DESC, '-')) as DESC_VERBA1,
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

	isnull
	(
		(
			select top 1 last_value(trim(SR7010.R7_CARGO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
			from SR7010
			where
					SR7010.D_E_L_E_T_ = ''
				and SR7010.R7_FILIAL = SRD.RD_FILIAL
				and SR7010.R7_MAT = SRD.RD_MAT
				and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')
		), trim(SQ3.Q3_CARGO)
	) as CARGO_FOLHA,
	isnull
	(
		(
			select top 1 last_value(trim(SR7010.R7_FUNCAO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
			from SR7010
			where
					SR7010.D_E_L_E_T_ = ''
				and SR7010.R7_FILIAL = SRD.RD_FILIAL
				and SR7010.R7_MAT = SRD.RD_MAT
				and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')
		), trim(SRJ.RJ_FUNCAO)
	) as FUNCAO_FOLHA,
	
	isnull
	(
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
						and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')
				)
		), trim(SQ3.Q3_DESCSUM)
	) as DESC_CARGO,
	isnull
	(
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
						and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')
				)
		), trim(SRJ.RJ_DESC)
	) as DESC_FUNCAO,

	isnull
	(
		(
			select top 1 last_value(trim(SR7010.R7_FUNCAO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
			from SR7010
			where
					SR7010.D_E_L_E_T_ = ''
                and year(SR7010.R7_DATA) > 2022
				and SR7010.R7_FILIAL = SRD.RD_FILIAL
				and SR7010.R7_MAT = SRD.RD_MAT
				and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')
		), trim(SRJ.RJ_FUNCAO)
	) as FUNCAO_ANT,
	isnull
	(
		(
			select top 1 last_value(trim(SR7010.R7_FUNCAO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
			from SR7010
			where
					SR7010.D_E_L_E_T_ = ''
                and year(SR7010.R7_DATA) > 2022
				and SR7010.R7_FILIAL = SRD.RD_FILIAL
				and SR7010.R7_MAT = SRD.RD_MAT
				and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
		), trim(SRJ.RJ_FUNCAO)
	) as FUNCAO_ATU,

    1 + datediff(day, concat(SRD.RD_DATARQ, '01'), eomonth(concat(SRD.RD_DATARQ, '01'))) as DIAS_PERIODO,

    (
        select cast(max(SR7010.R7_DATA) as date)
        from SR7010
        where
                SR7010.D_E_L_E_T_ = ''
            and year(SR7010.R7_DATA) > 2022
            and SR7010.R7_FILIAL = SRD.RD_FILIAL
            and SR7010.R7_MAT = SRD.RD_MAT
            and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
    ) as MUD_FUNCAO,

    datediff(day,
		concat(SRD.RD_DATARQ, '01'),
		(
			select max(SR7010.R7_DATA)
			from SR7010
			where
					SR7010.D_E_L_E_T_ = ''
				and year(SR7010.R7_DATA) > 2022
				and SR7010.R7_FILIAL = SRD.RD_FILIAL
				and SR7010.R7_MAT = SRD.RD_MAT
				and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
		)
	) as DIAS_ANT,

	datediff(day,
		(
			select max(SR7010.R7_DATA)
			from SR7010
			where
					SR7010.D_E_L_E_T_ = ''
				and year(SR7010.R7_DATA) > 2022
				and SR7010.R7_FILIAL = SRD.RD_FILIAL
				and SR7010.R7_MAT = SRD.RD_MAT
				and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
		),
		eomonth(concat(SRD.RD_DATARQ, '01'))
	) + 1 as DIAS_ATU

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
		SRD.RD_PERIODO =:ANOMES
	and SRD.D_E_L_E_T_ = ''
