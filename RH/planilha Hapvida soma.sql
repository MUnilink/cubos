select
	hapvida.FILIAL,
	hapvida.MATRICULA,
	hapvida.VERBA,
	hapvida.CENTRO_CUSTO,
	hapvida.PERIODO_ANO,
	hapvida.PERIODO_MES,
	hapvida.contador,
	sum(hapvida.VALOR_FUNCIONARIO_M) as VALOR_FUNCIONARIO_M,
	sum(hapvida.VALOR_FUNCIONARIO_F) as VALOR_FUNCIONARIO_F,
	sum(hapvida.VALOR_EMPRESA_M) as VALOR_EMPRESA_M,
	sum(hapvida.VALOR_EMPRESA_F) as VALOR_EMPRESA_F
from
(
	select
		FOLHA.RD_FILIAL as FILIAL,
		FOLHA.RD_MAT as MATRICULA,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
		FOLHA.RD_CC as COD_CC,
		FOLHA.RD_PD as VERBA,
		CC.CTT_DESC01 as CENTRO_CUSTO,
		year(concat(FOLHA.RD_PERIODO, '01')) as PERIODO_ANO,
		month(concat(FOLHA.RD_PERIODO, '01')) as PERIODO_MES,

		row_number() over
		(
			partition by
	            FOLHA.RD_FILIAL,
	            FOLHA.RD_PERIODO,
	            FOLHA.RD_MAT,
	            FOLHA.RD_PD,
	            FOLHA.RD_SEMANA ,
	            FOLHA.RD_SEQ ,
	            FOLHA.RD_CC,
	            FOLHA.RD_PROCES
			order by
				FOLHA.RD_FILIAL,
				FOLHA.RD_MAT,
				FOLHA.RD_CC,
				FOLHA.RD_PERIODO
		) as contador,
		(
			select sum(SRD010.RD_VALOR)
			from SRD010 (nolock)
				inner join SRA010 (nolock)
					on SRA010.D_E_L_E_T_ = ''
					and SRA010.RA_FILIAL = SRD010.RD_FILIAL
					and SRA010.RA_MAT = SRD010.RD_MAT
					and SRA010.RA_SEXO = 'M'
					and SRA010.RA_SITFOLH != 'D'
			where
						SRD010.D_E_L_E_T_ = ''
	                and SRD010.RD_MAT = FOLHA.RD_MAT
	                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
	                and SRD010.RD_PD = FOLHA.RD_PD
	                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
	                and SRD010.RD_PD in ('565')
		) as VALOR_FUNCIONARIO_M,
		(
			select sum(SRD010.RD_VALOR)
			from SRD010 (nolock)
				inner join SRA010 (nolock)
					on SRA010.D_E_L_E_T_ = ''
					and SRA010.RA_FILIAL = SRD010.RD_FILIAL
					and SRA010.RA_MAT = SRD010.RD_MAT
					and SRA010.RA_SEXO = 'F'
					and SRA010.RA_SITFOLH != 'D'
			where
						SRD010.D_E_L_E_T_ = ''
	                and SRD010.RD_MAT = FOLHA.RD_MAT
	                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
	                and SRD010.RD_PD = FOLHA.RD_PD
	                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
	                and SRD010.RD_PD in ('565')
		) as VALOR_FUNCIONARIO_F,
		(
			select sum(SRD010.RD_VALOR)
			from SRD010 (nolock)
				inner join SRA010 (nolock)
					on SRA010.D_E_L_E_T_ = ''
					and SRA010.RA_FILIAL = SRD010.RD_FILIAL
					and SRA010.RA_MAT = SRD010.RD_MAT
					and SRA010.RA_SEXO = 'M'
					and SRA010.RA_SITFOLH != 'D'
			where
						SRD010.D_E_L_E_T_ = ''
	                and SRD010.RD_MAT = FOLHA.RD_MAT
	                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
	                and SRD010.RD_PD = FOLHA.RD_PD
	                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
	                and SRD010.RD_PD in ('738')
		) as VALOR_EMPRESA_M,
		(
			select sum(SRD010.RD_VALOR)
			from SRD010 (nolock)
				inner join SRA010 (nolock)
					on SRA010.D_E_L_E_T_ = ''
					and SRA010.RA_FILIAL = SRD010.RD_FILIAL
					and SRA010.RA_MAT = SRD010.RD_MAT
					and SRA010.RA_SEXO = 'F'
					and SRA010.RA_SITFOLH != 'D'
			where
						SRD010.D_E_L_E_T_ = ''
	                and SRD010.RD_MAT = FOLHA.RD_MAT
	                and SRD010.RD_FILIAL = FOLHA.RD_FILIAL
	                and SRD010.RD_PD = FOLHA.RD_PD
	                and SRD010.RD_PERIODO = FOLHA.RD_PERIODO
	                and SRD010.RD_PD in ('738')
		) as VALOR_EMPRESA_F

	from SRD010 as FOLHA (nolock)
		inner join CTT010 as CC (nolock)
	    	on CC.D_E_L_E_T_ = ''
	    	and substring(FOLHA.RD_FILIAL, 1, 4) = CC.CTT_FILIAL
	    	and FOLHA.RD_CC = CC.CTT_CUSTO
	where
			FOLHA.D_E_L_E_T_ = ''
		and year(concat(FOLHA.RD_PERIODO, '01')) = 2021 and month(concat(FOLHA.RD_PERIODO, '01')) = 5 and FOLHA.RD_PD in ('565', '571', '738')
) as hapvida
group by
	hapvida.FILIAL,
	hapvida.MATRICULA,
	hapvida.VERBA,
	hapvida.CENTRO_CUSTO,
	hapvida.PERIODO_ANO,
	hapvida.PERIODO_MES,
	hapvida.contador