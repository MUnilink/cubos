select
	trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_MAT) as contador,
	trim(SRA.RA_NOMECMP) as NOME,
	trim(SRA.RA_MUNICIP) as MUNICIPIO,
	trim(SRA.RA_ESTADO) as UF,
	trim(SRJ.RJ_CODCBO) as CBO,
	trim(SRA.RA_SEXO) as SEXO,
	trim(SRA.RA_CIC) as CPF,
	trim(SRJ.RJ_FUNCAO) as COD_FUNCAO,
	trim(SRJ.RJ_DESC) as FUNCAO,
	trim(SQ3.Q3_CARGO) as COD_CARGO,
	trim(SQ3.Q3_DESCSUM) as CARGO,
	SRA.RA_SITFOLH as SITUACAO,
    case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
	
	trim(CTT.CTT_CUSTO) as COD_CC,
	trim(CTT.CTT_DESC01) as CENTRO_CUSTO,
	trim(CTD.CTD_ITEM) as COD_ITEM,
	trim(CTD.CTD_DESC01) as ATIVIDADE,
	trim(SQB.QB_DEPTO) as DEPTO,
    trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
	
	cast(SRA.RA_NASC as date) as NASCIMENTO,
	cast(SRA.RA_ADMISSA as date) as ADMISSAO,
	cast(SRA.RA_DEMISSA as date) as DEMISSAO,
	cast(SRA.RA_DTFIMCT as date) as FIM_CONTRATO,
	
    cast(RF0.RF0_DTPREI as date) as DATA_INI,
    left(RF0.RF0_DTPREI, 6) as PERIODO_INI,
    cast(RF0.RF0_HORINI as numeric(15, 2)) as HORAS_INI,
    cast(RF0.RF0_DTPREF as date) as DATA_FIM,
    left(RF0.RF0_DTPREF, 6) as PERIODO_FIM,
    cast(RF0.RF0_HORFIM as numeric(15, 2)) as HORAS_FIM,
    
    concat(trim(RF0.RF0_CODABO), ' - ', (select trim(SP6010.P6_DESC) from SP6010 where SP6010.D_E_L_E_T_ = '' and SP6010.P6_CODIGO = RF0.RF0_CODABO)) as MOTIVO_ABONO,
    RF0.RF0_HORTAB as TAB_PADRAO,
    RF0.RF0_ABONA as UTILIZADO,
    RF0.RF0_NATEST as ORIGEM,
    upper(trim(RF0.RF0_USUAR)) as USUARIO

from RF0010 RF0 (nolock)
	inner join SRA010 SRA (nolock)
		on SRA.D_E_L_E_T_ = ''
		and RF0.RF0_FILIAL = SRA.RA_FILIAL
		and RF0.RF0_MAT = SRA.RA_MAT
        
		left join CTT010 CTT (nolock)
			on CTT.D_E_L_E_T_ = ''
			and left(SRA.RA_FILIAL, 4) = CTT.CTT_FILIAL
			and SRA.RA_CC = CTT.CTT_CUSTO
		left join SQB010 SQB (nolock)
			on SQB.D_E_L_E_T_ = ''
			and SQB.QB_FILIAL = left(SRA.RA_FILIAL, 4)
			and SQB.QB_DEPTO = SRA.RA_DEPTO
		left join CTD010 CTD (nolock)
			on CTD.D_E_L_E_T_ = ''
			and CTD.CTD_ITEM = SRA.RA_ITEM
		left join SRJ010 SRJ (nolock)
			on SRJ.D_E_L_E_T_ = ''
			and SRJ.RJ_FILIAL = left(SRA.RA_FILIAL, 4)
			and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

			left join SQ3010 SQ3 (nolock)
				on SQ3.D_E_L_E_T_ = ''
				and SQ3.Q3_CARGO = SRJ.RJ_CARGO
				
where RF0.D_E_L_E_T_ = ''
