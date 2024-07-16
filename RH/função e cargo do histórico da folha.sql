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

	cast(SR7.R7_DATA as date) as DATA_MUD,
	(select max(cast(SR7010.R7_DATA as date)) from SR7010 where SR7010.D_E_L_E_T_ = '' and SR7010.R7_FILIAL = SRD.RD_FILIAL and SR7010.R7_MAT = SRD.RD_MAT and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')) as ULT_MUD,
	cast(concat(SRD.RD_DATARQ, '01') as date) as DATA_ARQ,
	(select max(SR7010.R7_FUNCAO) from SR7010 where SR7010.D_E_L_E_T_ = '' and SR7010.R7_FILIAL = SRD.RD_FILIAL and SR7010.R7_MAT = SRD.RD_MAT and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')) as COD_FUNCAO,
	(select max(SR7010.R7_CARGO) from SR7010 where SR7010.D_E_L_E_T_ = '' and SR7010.R7_FILIAL = SRD.RD_FILIAL and SR7010.R7_MAT = SRD.RD_MAT and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')) as COD_CARGO,
	trim(SR7.RJ_DESC) as FUNCAO,
	trim(SR7.Q3_DESCSUM) as CARGO

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
	
	left join
	(
		select
			trim(SR7010.R7_FILIAL) as R7_FILIAL,
			trim(SR7010.R7_MAT) as R7_MAT,
			cast(SR7010.R7_DATA as date) as R7_DATA,
			trim(SR7010.R7_SEQ) as R7_SEQ,
			trim(SR7010.R7_TIPO) as R7_TIPO,
			trim(SR7010.R7_FUNCAO) as R7_FUNCAO,
			trim(SR7010.R7_CARGO) as R7_CARGO,
			
			trim(SRJ010.RJ_DESC) as RJ_DESC,
			trim(SQ3010.Q3_DESCSUM) as Q3_DESCSUM,
			trim(SX5010.X5_DESCRI) as TIPO
		from SR7010
			left join SRJ010
				on SRJ010.D_E_L_E_T_ = ''
				and SRJ010.RJ_FILIAL = substring(SR7010.R7_FILIAL, 1, 4)
				and SRJ010.RJ_FUNCAO = SR7010.R7_FUNCAO
			left join SQ3010
				on SQ3010.D_E_L_E_T_ = ''
				and SQ3010.Q3_CARGO = SR7010.R7_CARGO
			left join SX5010
				on SX5010.D_E_L_E_T_ = ''
				and SX5010.X5_TABELA = '41'
				and SX5010.X5_CHAVE = SR7010.R7_TIPO
		where SR7010.D_E_L_E_T_ = ''
	) SR7
		on SR7.R7_FILIAL = SRD.RD_FILIAL
		and SR7.R7_MAT = SRD.RD_MAT
		and SR7.R7_DATA <= concat(SRD.RD_DATARQ, '01')

where SRA.RA_MAT = 2589 and SRD.D_E_L_E_T_ = ''
