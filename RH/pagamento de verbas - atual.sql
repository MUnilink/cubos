select
	trim(isnull(SRC.RC_FILIAL, '-')) as RC_FILIAL,
	trim(isnull(SRC.RC_PERIODO, '-')) as RC_PERIODO,
	trim(isnull(SRC.RC_MAT, '-')) as RC_MAT,
	trim(isnull(SRA.RA_NOME, '-')) as RA_NOME,
	trim(isnull(SRC.RC_PD, '-')) as RC_PD,
	trim(isnull(SRV.RV_DESC, '-')) as RV_DESC,
	
	case SRC.RC_PD
		when '183' then 'VALOR A RECEBER'
		when '999' then 'VALOR A RECEBER'
	else '' end as RV_DESCDET,
	
	trim(isnull(SRJ.RJ_DESC, '-')) as RJ_DESC,

	trim(SRA.RA_CC) + ' - ' + trim(CTT.CTT_DESC01) as CENTRO_CUSTO,
	trim(SRA.RA_ITEM) + ' - ' + trim(CTD.CTD_DESC01) as ATIVIDADE,

	case trim(SRV.RV_TIPOCOD)
		when '1' then 'PROVENTO'
		when '2' then 'DESCONTO'
		when '3' then 'BASE PROVENTO'
		when '4' then 'BASE DESCONTO'
		else '-'
	end as RV_TIPOCOD,

	sum(SRC.RC_VALOR) as RC_VALOR,
	sum(SRC.RC_HORAS) as RC_HORAS,
	sum(SRA.RA_SALARIO) as RA_SALARIO

from SRC010 SRC (nolock)
    inner join SRV010 SRV (nolock)
    	on SRV.D_E_L_E_T_ = ''
        and substring(SRC.RC_FILIAL, 1, 4) = SRV.RV_FILIAL
        and SRC.RC_PD = SRV.RV_COD
    inner join SRA010 SRA (nolock)
    	on SRA.D_E_L_E_T_ = ''
    	and SRA.RA_FILIAL = SRC.RC_FILIAL
    	and SRA.RA_MAT = SRC.RC_MAT

    	inner join SRJ010 SRJ (nolock)
            on SRJ.D_E_L_E_T_ = ''
            and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
            and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
        left join CTT010 CTT (nolock)
	    	on CTT.D_E_L_E_T_ = ''
	    	and SRC.RC_CC = CTT.CTT_CUSTO
		left join CTD010 CTD (nolock)
	    	on CTD.D_E_L_E_T_ = ''
	    	and SRC.RC_ITEM = CTD.CTD_ITEM
where SRC.D_E_L_E_T_ = ''
group by
	SRC.RC_FILIAL,
	SRC.RC_PERIODO,
	SRC.RC_PD,
	SRV.RV_DESC,
	SRV.RV_DESCDET,
	SRV.RV_TIPOCOD,
	SRC.RC_MAT,
	SRA.RA_NOME,
	SRJ.RJ_DESC,
	CTT.CTT_DESC01,
	CTD.CTD_DESC01,
	SRA.RA_CC,
	SRA.RA_ITEM
