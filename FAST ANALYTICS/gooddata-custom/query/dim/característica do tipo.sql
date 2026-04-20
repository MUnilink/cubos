select
	trim(STE.TE_TIPOMAN) as TE_TIPOMAN,
	trim(STE.TE_NOME) as TE_NOME,
	
    case STE.TE_CARACTE
        when 'P' then 'PREVENTIVA'
        when 'C' then 'CORRETIVA'
        else 'OUTROS'
    end as TE_CARACTE

from STE010 STE
where STE.D_E_L_E_T_ = ''
