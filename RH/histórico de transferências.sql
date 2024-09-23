select
	trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_NOMECMP) as NOME,
	trim(SRA.RA_MUNICIP) as MUNICIPIO,
	trim(SRA.RA_ESTADO) as UF,
	cast(SRA.RA_ADMISSA as date) as ADMISSAO,
	case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
	case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
	trim(SRA.RA_SEXO) as SEXO,
	trim(SRA.RA_CIC) as CPF,
	
    left(SRE.RE_DATA, 6) as PERIODO,
    cast(SRE.RE_DATA as date) as DATA,
    SRE.RE_SEQ as SEQUENCIA,
    (select trim(SX5010.X5_DESCRI) from SX5010 where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = '41' and SX5010.X5_CHAVE = SRE.RE_TIPO) as TIPO,
    trim(SRE.RE_TIPO) as TIPO_ALTER,
    SRJ.RJ_FUNCAO as COD_FUNCAO,
    trim(SRJ.RJ_DESC) as FUNCAO,
	lag(trim(SRJ.RJ_DESC), 1, null) over (partition by SRE.RE_FILIAL, SRE.RE_MAT order by SRE.RE_DATA) as FUNCAO_ANTERIOR,
	trim(SQ3.Q3_DESCSUM) as CARGO,
	lag(trim(SQ3.Q3_DESCSUM), 1, null) over (partition by SRE.RE_FILIAL, SRE.RE_MAT order by SRE.RE_DATA) as CARGO_ANTERIOR,
    trim(SRJ.RJ_CODCBO) as CBO,
	
    SRA.RA_SALARIO as SALARIO,
	SRA.RA_HRSEMAN as HORAS_SEM,

    SRE.RE_FILIALD as FILIAL_INI,
    SRE.RE_FILIALP as FILIAL_FIM,
    SRE.RE_MATD as MATRICULA_INI,
    SRE.RE_MATP as MATRICULA_FIM,
    SRE.RE_CCD as CC_INI, left join CTT010 CTT (nolock) on CTT.D_E_L_E_T_ = '' and CTT.CTT_CUSTO = SRA.RA_CC
    SRE.RE_CCP as CC_FIM,
    SRE.RE_ITEMD as ITEM_INI, left join CTD010 CTD (nolock) on CTD.D_E_L_E_T_ = '' and CTD.CTD_ITEM = SRA.RA_ITEM
    SRE.RE_ITEMP as ITEM_FIM, left join SQB010 SQB (nolock) on SQB.D_E_L_E_T_ = '' and SQB.QB_DEPTO = SRA.RA_DEPTO
    SRE.RE_DEPTOD AS DEPTO_INI,
    SRE.RE_DEPTOP AS DEPTO_FIM,
    SRE.RE_PROCESD as PROCESSO_INI,
    SRE.RE_PROCESP as PROCESSO_FIM,
    SRE.RE_EMPD as EMPRESA_INI,
    SRE.RE_EMPP as EMPRESA_FIM

from SRE010 SRE (nolock)
	inner join SRJ010 SRJ (nolock)
        on SRJ.D_E_L_E_T_ = ''
        and SRJ.RJ_FILIAL = substring(SRE.RE_FILIAL, 1, 4)
        and SRJ.RJ_FUNCAO = SRE.RE_FUNCAO
	inner join SRA010 SRA (nolock)
		on SRA.D_E_L_E_T_ = ''
		and SRA.RA_FILIAL = SRE.RE_FILIAL
		and SRA.RA_MAT = SRE.RE_MAT
	left join SQ3010 SQ3 (nolock)
		on SQ3.D_E_L_E_T_ = ''
		and SQ3.Q3_CARGO = SRE.RE_CARGO

where SRE.D_E_L_E_T_ = ''
