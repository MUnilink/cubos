select
	trim(isnull(SRD.RD_FILIAL, '-')) as RD_FILIAL,
	trim(isnull(SRD.RD_PERIODO, '-')) as RD_PERIODO,
	trim(isnull(SRD.RD_MAT, '-')) as RD_MAT,
	trim(isnull(SRA.RA_NOME, '-')) as RA_NOME,
	trim(isnull(SRD.RD_PD, '-')) as RD_PD,
	trim(isnull(SRV.RV_DESC, '-')) as RV_DESC,
	trim(isnull(SRV.RV_DESCDET, '-')) as RV_DESCDET,
	trim(isnull(SRJ.RJ_DESC, '-')) as RJ_DESC,
	trim(isnull(SRA.RA_CC, '-')) as RA_CC

	case trim(SRV.RV_TIPOCOD)
		when '1' then 'PROVENTO'
		when '2' then 'DESCONTO'
		when '3' then 'BASE PROVENTO'
		when '4' then 'BASE DESCONTO'
		else '-'
	end as RV_TIPOCOD,

	sum(SRD.RD_VALOR) as RD_VALOR,
	sum(SRD.RD_HORAS) as RD_HORAS
from SRD010 SRD (nolock)
    inner join SRV010 SRV (nolock)
    	on SRV.D_E_L_E_T_ = ''
        and substring(SRD.RD_FILIAL, 1, 4) = SRV.RV_FILIAL
        and SRD.RD_PD = SRV.RV_COD
    inner join SRA010 SRA (nolock)
    	on SRA.D_E_L_E_T_ = ''
    	and SRA.RA_FILIAL = SRD.RD_FILIAL
    	and SRA.RA_MAT = SRD.RD_MAT

    	inner join SRJ010 SRJ (nolock)
            on SRJ.D_E_L_E_T_ = ''
            and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
            and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
where
        SRD.D_E_L_E_T_ = ''
    and (SRA.RA_CC = 304 or SRA.RA_CC = 302 or SRA.RA_CC = 206 or SRA.RA_MAT = '002282')
    and SRD.RD_PERIODO > 202112
group by
	SRD.RD_FILIAL,
	SRD.RD_PERIODO,
	SRD.RD_PD,
	SRV.RV_DESC,
	SRV.RV_DESCDET,
	SRV.RV_TIPOCOD,
	SRD.RD_MAT,
	SRA.RA_NOME,
	SRJ.RJ_DESC,
	SRA.RA_CC,
	SRA.RA_ITEM
