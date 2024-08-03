select
	trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_ESTADO) as UF,
	convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
	case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
	case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

	trim(CTT.CTT_CUSTO) as CC,
	trim(CTD.CTD_ITEM) as ITCT,
	trim(SQB.QB_DEPTO) as DEPTO,

	trim(SRA.RA_SEXO) as SEXO,

	trim(isnull(SRD.RD_PERIODO, '-')) as PERIODO,
	trim(isnull(SRD.RD_PD, '-')) as VERBA,
	trim(isnull(SRD.RD_SEQ, '-')) as SEQ,
	trim(isnull(SRD.RD_ROTEIR, '-')) as ROTEIRO,
	
	trim(isnull(SRV.RV_DESC, '-')) as DESC_VERBA1,

	case trim(SRV.RV_TIPOCOD)
		when '1' then 'PROVENTO'
		when '2' then 'DESCONTO'
		when '3' then 'BASE PROVENTO'
		when '4' then 'BASE DESCONTO'
		else '-'
	end as TIPO_VERBA,

	SRD.RD_VALOR as VALOR,
	SRD.RD_HORAS as HORAS,
	SRA.RA_SALARIO as SALARIO,
	SRA.RA_HRSEMAN as HORAS_SEM,

	cast(concat(SRD.RD_DATARQ, '01') as date) as DATA_ARQ,

	(select top 1 last_value(SR7010.R7_CARGO) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ) from SR7010 where SR7010.D_E_L_E_T_ = '' and SR7010.R7_FILIAL = SRD.RD_FILIAL and SR7010.R7_MAT = SRD.RD_MAT and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')) as CARGO_FOLHA,
	(select top 1 last_value(SR7010.R7_FUNCAO) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ) from SR7010 where SR7010.D_E_L_E_T_ = '' and SR7010.R7_FILIAL = SRD.RD_FILIAL and SR7010.R7_MAT = SRD.RD_MAT and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')) as FUNCAO_FOLHA,
	(select SQ3010.Q3_DESCSUM from SQ3010 where SQ3010.D_E_L_E_T_ = '' and SQ3010.Q3_CARGO = (select top 1 last_value(SR7010.R7_CARGO) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ) from SR7010 where SR7010.D_E_L_E_T_ = '' and SR7010.R7_FILIAL = SRD.RD_FILIAL and SR7010.R7_MAT = SRD.RD_MAT and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01'))) as DESC_CARGO,
	(select SRJ010.RJ_DESC from SRJ010 where SRJ010.D_E_L_E_T_ = '' and SRJ010.RJ_FUNCAO = (select top 1 last_value(SR7010.R7_FUNCAO) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ) from SR7010 where SR7010.D_E_L_E_T_ = '' and SR7010.R7_FILIAL = SRD.RD_FILIAL and SR7010.R7_MAT = SRD.RD_MAT and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01'))) as DESC_FUNCAO,
	(select max(cast(SR7010.R7_DATA as date)) from SR7010 where SR7010.D_E_L_E_T_ = '' and SR7010.R7_FILIAL = SRD.RD_FILIAL and SR7010.R7_MAT = SRD.RD_MAT and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')) as ULT_MUD

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

	left join CTT010 CTT (nolock)
		on CTT.D_E_L_E_T_ = ''
		and CTT.CTT_CUSTO = SRD.RD_CC
	left join CTD010 CTD (nolock)
		on CTD.D_E_L_E_T_ = ''
		and CTD.CTD_ITEM = SRD.RD_ITEM

where SRA.RA_MAT = 2589 and SRD.D_E_L_E_T_ = ''
