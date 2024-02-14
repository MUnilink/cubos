select
	trim(isnull(SRD.RD_FILIAL, '-')) as RD_FILIAL,
	trim(isnull(SRD.RD_PERIODO, '-')) as RD_PERIODO,
	trim(isnull(SRD.RD_MAT, '-')) as RD_MAT,
	trim(isnull(SRA.RA_NOME, '-')) as RA_NOME,
	trim(isnull(SRD.RD_PD, '-')) as RD_PD,
	trim(isnull(SRV.RV_DESC, '-')) as RV_DESC,
	trim(isnull(SRV.RV_DESCDET, '-')) as RV_DESCDET,
	trim(isnull(SRJ.RJ_DESC, '-')) as RJ_DESC,
	trim(isnull(SRD.RD_CC, '-')) as RA_CC,

	case trim(SRV.RV_TIPOCOD)
		when '1' then 'PROVENTO'
		when '2' then 'DESCONTO'
		when '3' then 'BASE PROVENTO'
		when '4' then 'BASE DESCONTO'
		else '-'
	end as RV_TIPOCOD,

	case when lag(SRD.RD_PD, 1, 0) over (partition by SRD.RD_FILIAL, SRD.RD_PERIODO, SRD.RD_MAT, SRD.RD_PD order by SRD.R_E_C_N_O_) = 0 then SRD.RD_VALOR else 0 end as RD_VALOR,

	ZC2.*

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
	
	left join 
	(
		select
			ZC1010.ZC1_FILIAL as FILIAL,
			ZC1010.ZC1_NUM as NUM_OS,
			ZC2010.ZC2_ITEM as ITEM,
			trim(ZC2010.ZC2_COD) as INSUMO,
			cast(substring(ZC1010.ZC1_NUM, 6, 10) as int) as OS,
			ZC2010.ZC2_COMPET,
			substring(ZC1010.ZC1_EMISSA, 1, 6) as PERIODO_OS,
			ZC2010.ZC2_DTINI,
			ZC2010.ZC2_HRINI,
			ZC2010.ZC2_DTFIM,
			ZC2010.ZC2_HRFIM,
			case ZC1010.ZC1_STATUS
				when 1 then 'ABERTA'
				when 6 then 'FECHADA'
				when 9 then 'PEDIDO CRIADO'
				else 'OUTROS'
			end as STATUS_OS
		from ZC2010 (nolock)
			left join ZC1010 (nolock)
				on ZC1010.D_E_L_E_T_ = ''
				and ZC1010.ZC1_FILIAL = ZC2010.ZC2_FILIAL
				and ZC1010.ZC1_NUM = ZC2010.ZC2_NUM
		where
				ZC2010.D_E_L_E_T_ = ''
			and ZC2010.ZC2_TIPO = 2
	) ZC2
		on SRD.RD_PERIODO = substring(ZC2.ZC2_COMPET, 1, 6)
		and trim(SRA.RA_CODFUNC) = ZC2.INSUMO
where
        SRD.D_E_L_E_T_ = ''
    and SRD.RD_PERIODO = 202310
	and substring(ZC2.ZC2_DTFIM, 1, 6) = 202310
	and SRD.RD_PD in (020,113,344,039,030,029,749,719,796,738,800,962,950,955,960,961,817,830,845,442,440,441,444,446,591,038,025,051,134,170,171,172,173,371,445,739,831,832,833,834,846,847,848)
