select
	trim(isnull(SRT.RT_FILIAL, '-')) as RT_FILIAL,
	convert(date, SRT.RT_DATACAL, 103) as RT_PERIODO,
    trim(isnull(SRT.RT_TIPPROV, '-')) as RT_TIPPROV,
	trim(isnull(SRT.RT_MAT, '-')) as RT_MAT,
	trim(isnull(SRA.RA_NOME, '-')) as RA_NOME,
	trim(isnull(SRT.RT_VERBA, '-')) as RT_PD,
	trim(isnull(SRV.RV_DESC, '-')) as RV_DESC,
	trim(isnull(SRV.RV_DESCDET, '-')) as RV_DESCDET,
	trim(isnull(SRJ.RJ_DESC, '-')) as RJ_DESC,
	trim(isnull(SRA.RA_CC, '-')) as RA_CC,
	trim(isnull(SRA.RA_ITEM, '-')) as RA_ITEM,

	case trim(SRV.RV_TIPOCOD)
		when '1' then 'PROVENTO'
		when '2' then 'DESCONTO'
		when '3' then 'BASE PROVENTO'
		when '4' then 'BASE DESCONTO'
		else '-'
	end as RV_TIPOCOD,

	SRT.RT_VALOR as RT_ACUMULADO,
	SRT.RT_SALARIO as RT_SALARIO
from SRT010 SRT (nolock)
    inner join SRV010 SRV (nolock)
    	on SRV.D_E_L_E_T_ = ''
        and substring(SRT.RT_FILIAL, 1, 4) = SRV.RV_FILIAL
        and SRT.RT_VERBA = SRV.RV_COD
    inner join SRA010 SRA (nolock)
    	on SRA.D_E_L_E_T_ = ''
    	and SRA.RA_FILIAL = SRT.RT_FILIAL
    	and SRA.RA_MAT = SRT.RT_MAT

    	inner join SRJ010 SRJ (nolock)
            on SRJ.D_E_L_E_T_ = ''
            and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
            and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
where
        SRT.D_E_L_E_T_ = ''
