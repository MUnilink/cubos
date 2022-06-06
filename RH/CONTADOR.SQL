select
	ASDF.RC_PERIODO,
	
	count(SRA.RA_MAT) over (partition by SRA.RA_SITFOLH order by SRA.RA_SITFOLH)
from
	(
		select
			SRC.RC_FILIAL,	
			SRC.RC_PERIODO,
			SRC.RC_MAT,
			SRC.RC_PD,
			SRV.RV_DESC,
			SRV.RV_DESCDET,
			SRV.RV_TIPOCOD,
			sum(SRC.RC_VALOR) as RC_VALOR
		from SRC010 as SRC (nolock)
		    inner join SRV010 as SRV (nolock)
		        on SRV.D_E_L_E_T_ = ''
		        and substring(SRC.RC_FILIAL, 1, 4) = SRV.RV_FILIAL
		        and SRC.RC_PD = SRV.RV_COD
		where SRC.D_E_L_E_T_ = ''
		group by
			SRC.RC_FILIAL,
			SRC.RC_PERIODO,
			SRC.RC_MAT,
			SRC.RC_PD,
			SRV.RV_DESC,
			SRV.RV_DESCDET,
			SRV.RV_TIPOCOD
	) as ASDF
	inner join SRA010 as SRA (nolock)
		on SRA.D_E_L_E_T_ = ''
		and SRA.RA_MAT = ASDF.RC_MAT
		and SRA.RA_FILIAL = ASDF.RC_FILIAL
group by
	ASDF.RC_PERIODO,
	SRA.RA_SITFOLH