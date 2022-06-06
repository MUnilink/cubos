select
	trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_NOME) as NOME,
	trim(SRJ.RJ_DESC) as FUNCAO,
	cast(convert(date, SRA.RA_ADMISSA, 103) as varchar) as ADMISSAO,

	case SRA.RA_DEMISSA
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else cast(convert(date, SRA.RA_DEMISSA, 103) as varchar)
	end as DEMISSAO,

	trim(SRA.RA_SITFOLH) as SITUACAO,
	
	case year(SRA.RA_DEMISSA) when 1900 then 0 else year(SRA.RA_DEMISSA) end as ANO_DEMISSAO,
	month(SRA.RA_DEMISSA) as MES_DEMISSAO,
	year(SRA.RA_ADMISSA) as ANO_ADMISSAO,
	month(SRA.RA_ADMISSA) as MES_ADMISSAO,
	
	case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as 'NÃO-DEMITIDOS'
from SRA010 as SRA (nolock)
	inner join SRJ010 as SRJ (nolock)
		on SRJ.D_E_L_E_T_ = ''
		and substring(SRA.RA_FILIAL, 1, 4) = SRJ.RJ_FILIAL
        and SRA.RA_CODFUNC = SRJ.RJ_FUNCAO
where SRA.D_E_L_E_T_ = ''