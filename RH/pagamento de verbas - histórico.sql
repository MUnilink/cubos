select

	trim(isnull(SRD.RD_MAT, '-')) as RD_MAT,
	trim(isnull(SRA.RA_NOME, '-')) as RA_NOME,
	trim(isnull(SRD.RD_PD, '-')) as RD_PD,
	trim(isnull(SRV.RV_DESC, '-')) as RV_DESC,
	trim(isnull(SRV.RV_DESCDET, '-')) as RV_DESCDET,
	
	case trim(SRV.RV_TIPOCOD)
		when '1' then 'PROVENTO'
		when '2' then 'DESCONTO'
		when '3' then 'BASE PROVENTO'
		when '4' then 'BASE DESCONTO'
		else '-'
	end as RV_TIPOCOD,

	SRD.RD_VALOR as RD_VALOR,
	SRD.RD_HORAS as RD_HORAS,

	substring(SRD.RD_PERIODO, 1, 4) as ANO_PERIODO,
	substring(SRD.RD_PERIODO, 5, 6) as MES_PERIODO
from SRD010 SRD (nolock)
    inner join SRV010 SRV (nolock)
    	on SRV.D_E_L_E_T_ = ''
        and substring(SRD.RD_FILIAL, 1, 4) = SRV.RV_FILIAL
        and SRD.RD_PD = SRV.RV_COD
    inner join SRA010 SRA (nolock)
    	on SRA.D_E_L_E_T_ = ''
    	and SRA.RA_MAT = SRD.RD_MAT
where
		SRD.D_E_L_E_T_ = ''
	and SRD.RD_PERIODO like '202%'
