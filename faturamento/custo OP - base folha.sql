select
	trim(SRD.RD_FILIAL) as RD_FILIAL,
	trim(SRD.RD_PERIODO) as RD_PERIODO,
	trim(SRD.RD_MAT) as RD_MAT,
	trim(SRA.RA_NOME) as RA_NOME,
	trim(SRD.RD_PD) as RD_PD,
	trim(SRV.RV_DESC) as RV_DESC,
	trim(SRJ.RJ_DESC) as RJ_DESC,
	trim(SRJ.RJ_YHRPADR) as HORAS_PADRAO,
	
	SRD.RD_VALOR,
	SRD.RD_HORAS,
	
	ZC2.OS,
	ZC2.INSUMO,
	ZC2.QTD_REAL,
	ZC2.VAL_REAL,
	cast(ZC2.HORAS_APONT as numeric(15, 2)) as HORAS_APONT,

	case
		when lag(ZC2.OS, 1, 0) over (partition by SRD.RD_FILIAL, SRD.RD_PERIODO, SRD.RD_MAT, SRD.RD_PD order by SRD.R_E_C_N_O_) = 0 and SRD.RD_PD = 20 then SRD.RD_VALOR
		when lag(ZC2.OS, 1, 0) over (partition by SRD.RD_FILIAL, SRD.RD_PERIODO, SRD.RD_MAT, SRD.RD_PD order by SRD.R_E_C_N_O_) = 0 and SRD.RD_PD in (440, 445) then SRD.RD_VALOR
	else 0 end as VALOR_FOLHA,
	
	case when lag(ZC2.OS, 1, 0) over (partition by SRD.RD_FILIAL, SRD.RD_PERIODO, SRD.RD_MAT, SRD.RD_PD order by SRD.R_E_C_N_O_) = 0 and SRD.RD_PD = 20 then SRD.RD_HORAS*SRJ.RJ_YHRPADR/30
	else 0 end as HORAS_FOLHA,

	case trim(SRV.RV_TIPOCOD)
		when '1' then 'PROVENTO'
		when '2' then 'DESCONTO'
		when '3' then 'BASE PROVENTO'
		when '4' then 'BASE DESCONTO'
		else '-'
	end as RV_TIPOCOD

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
			and SRJ.RJ_YPORTAL = 'S'
	
	left join 
	(
		select
			ZC1010.ZC1_FILIAL as FILIAL,
			ZC1010.ZC1_NUM as NUM_OS,
			trim(ZC2010.ZC2_COD) as INSUMO,
			cast(substring(ZC1010.ZC1_NUM, 6, 10) as int) as OS,
			ZC2010.ZC2_COMPET as PERIODO,
			cast(sum(ZC2010.ZC2_QTDPRV) as numeric(15, 2)) as QTD_PREV,
			cast(sum(ZC2010.ZC2_QTDREA) as numeric(15, 2)) as QTD_REAL,
			cast(sum(ZC2010.ZC2_VLUPRV) as numeric(15, 2)) as VAL_PREV,
			cast(sum(ZC2010.ZC2_VLUREA) as numeric(15, 2)) as VAL_REAL,
			sum(datediff(minute, concat(ZC2010.ZC2_DTINI, ' ', ZC2010.ZC2_HRINI), concat(ZC2010.ZC2_DTFIM, ' ', ZC2010.ZC2_HRFIM))/60.0) as HORAS_APONT
		from ZC2010 (nolock)
			left join ZC1010 (nolock)
				on ZC1010.D_E_L_E_T_ = ''
				and ZC1010.ZC1_FILIAL = ZC2010.ZC2_FILIAL
				and ZC1010.ZC1_NUM = ZC2010.ZC2_NUM
				and substring(ZC1010.ZC1_NUM, 1, 4) > 2022
		where
				ZC2010.D_E_L_E_T_ = ''
			and ZC2010.ZC2_TIPO = 2
			and ZC2010.ZC2_HRINI != '  :  '
			and ZC2010.ZC2_HRFIM != '  :  '
		group by
			ZC1010.ZC1_FILIAL,
			ZC1010.ZC1_NUM,
			ZC2010.ZC2_COD,
			ZC2010.ZC2_COMPET
	) ZC2
		on SRD.RD_FILIAL = ZC2.FILIAL
		and SRD.RD_PERIODO = substring(ZC2.PERIODO, 1, 6)
		and trim(SRA.RA_CODFUNC) = ZC2.INSUMO
where
        SRD.D_E_L_E_T_ = ''
	and SRD.RD_PD in (020,113,344,039,030,029,749,719,796,738,800,962,950,955,960,961,817,830,845,442,440,441,444,446,591,038,025,051,134,170,171,172,173,371,445,739,831,832,833,834,846,847,848)
