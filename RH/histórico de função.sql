select
	trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_NOMECMP) as NOME,
	trim(SRA.RA_MUNICIP) as MUNICIPIO,
	trim(SRA.RA_ESTADO) as UF,
	convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
	case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
	case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

	trim(CTT.CTT_CUSTO) as CC,
	trim(CTT.CTT_DESC01) as CCUSTO,
	trim(CTD.CTD_ITEM) as ITCT,
	trim(CTD.CTD_DESC01) as ATIVIDADE,
	trim(SQB.QB_DEPTO) as DEPTO,
	trim(SQB.QB_DESCRIC) as DEPARTAMENTO,

	trim(SRA.RA_SEXO) as SEXO,
	trim(SRA.RA_CIC) as CPF,
	
    substring(SR7.R7_DATA, 1, 6) as PERIODO,
    convert(date, SR7.R7_DATA, 103) as DATA,
    SR7.R7_SEQ as SEQUENCIA,
    (select trim(SX5010.X5_DESCRI) from SX5010 where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = '41' and SX5010.X5_CHAVE = SR7.R7_TIPO) as TIPO,
    trim(SR7.R7_TIPO) as TIPO_ALTER,
    SRJ.RJ_FUNCAO as COD_FUNCAO,
    trim(SRJ.RJ_DESC) as FUNCAO,
	lag(trim(SRJ.RJ_DESC), 1, null) over (partition by SR7.R7_FILIAL, SR7.R7_MAT order by SR7.R7_DATA) as FUNCAO_ANTERIOR,
	trim(SQ3.Q3_DESCSUM) as CARGO,
	lag(trim(SQ3.Q3_DESCSUM), 1, null) over (partition by SR7.R7_FILIAL, SR7.R7_MAT order by SR7.R7_DATA) as CARGO_ANTERIOR,
    trim(SRJ.RJ_CODCBO) as CBO,
	SR3.R3_VALOR as SALARIO,
	SRA.RA_HRSEMAN as HORAS_SEM

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
