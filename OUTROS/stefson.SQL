select 
	SRA.RA_NOME as NOME,
	SRA.RA_EXAMEDI as STATUS_EXAM_MEDI,
	isnull(SRA.RA_REGCIVI, '-') as ESTADO_CIVIL,
	isnull(SRA.RA_TIPCERT, '-') as TIPO_DE_CERTIDAO,
	case SRA.RA_TPJORNA 
		when 1 then '8/24'
		end as TIPO_DE_JORNADA
from
	SRA010 SRA (nolock)
where 
	SRA.D_E_L_E_T_ = ''
    and SRA_RA_EXAMEDI != 01/01/1900
order by
	NOME