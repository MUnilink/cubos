select
	trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
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
	case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
	trim(SRA.RA_SITFOLH) as SITUACAO,
	
    substring(SR7.R7_DATA, 1, 6) as PERIODO,
    convert(date, SR7.R7_DATA, 103) as DATA,
    SR7.R7_SEQ as SEQUENCIA,
    (select trim(SX5010.X5_DESCRI) from SX5010 where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = '41' and SX5010.X5_CHAVE = SR7.R7_TIPO) as TIPO,
    trim(SR7.R7_TIPO) as TIPO_ALTER,
	lag(trim(SRJ.RJ_DESC), 1, null) over (partition by SR7.R7_FILIAL, SR7.R7_MAT order by SR7.R7_DATA) as FUNCAO_ANTERIOR,
	lag(trim(SQ3.Q3_DESCSUM), 1, null) over (partition by SR7.R7_FILIAL, SR7.R7_MAT order by SR7.R7_DATA) as CARGO_ANTERIOR,
	SR3.R3_VALOR as SALARIO

from SR7010 SR7 (nolock)
	inner join SRJ010 SRJ (nolock)
        on SRJ.D_E_L_E_T_ = ''
        and SRJ.RJ_FILIAL = substring(SR7.R7_FILIAL, 1, 4)
        and SRJ.RJ_FUNCAO = SR7.R7_FUNCAO
	left join SQ3010 SQ3 (nolock)
		on SQ3.D_E_L_E_T_ = ''
		and SQ3.Q3_CARGO = SR7.R7_CARGO
	inner join SRA010 SRA (nolock)
		on SRA.D_E_L_E_T_ = ''
		and SRA.RA_FILIAL = SR7.R7_FILIAL
		and SRA.RA_MAT = SR7.R7_MAT
	
        left join CTT010 CTT (nolock)
            on CTT.D_E_L_E_T_ = ''
            and CTT.CTT_CUSTO = SRA.RA_CC
        left join CTD010 CTD (nolock)
            on CTD.D_E_L_E_T_ = ''
            and CTD.CTD_ITEM = SRA.RA_ITEM
        left join SQB010 SQB (nolock)
            on SQB.D_E_L_E_T_ = ''
            and SQB.QB_DEPTO = SRA.RA_DEPTO
	
	left join SR3010 SR3 (nolock)
		on SR3.D_E_L_E_T_ = ''
		and SR3.R3_FILIAL = SR7.R7_FILIAL
		and SR3.R3_MAT = SR7.R7_MAT
		and SR3.R3_DATA = SR7.R7_DATA
		and SR3.R3_TIPO = SR7.R7_TIPO

where SR7.D_E_L_E_T_ = ''
