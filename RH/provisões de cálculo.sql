select
	trim(SRT.RT_FILIAL) as FILIAL,
	substring(SRT.RT_DATACAL, 1, 6) as PERIODO,
	trim(SRT.RT_MAT) as MAT,
	trim(SRA.RA_NOMECMP) as NOME,
	trim(SRT.RT_VERBA) as VERBA,
	trim(SRV.RV_DESC) as RV_DESC,
	trim(SRV.RV_DESCDET) as RV_DESCDET,
	trim(SRA.RA_CODFUNC) as FUNCAO,
	trim(SRJ.RJ_DESC) as DESC_FUNCAO,
	
	trim(SRT.RT_CC) as CC,
	trim(SRT.RT_ITEM) as ATIVIDADE,

	case trim(SRT.RT_TIPPROV)
		when '1' then 'PROVENTO'
		when '2' then 'DESCONTO'
		when '3' then 'BASE PROVENTO'
		when '4' then 'BASE DESCONTO'
		else '-'
	end as RV_TIPOCOD,

	case when exists (select * from SX6010 where SX6010.X6_VAR in ('UN_OSVERBA', 'UN_OSVERB1') and SX6010.X6_CONTEUD like '%' || SRV.RV_COD || '%') then 'CUSTOS' else 'OUTRAS' end as VERBA_CUSTO,

	SRT.RT_VALOR /
	(
		select
			case when SRT010.RT_VERBA in (830, 880) then sum(isnull(nullif(SRT010.RT_DFERPRO, 0), 2.5) / 2.5)
				else
				case when SRT010.RT_VERBA = 890 then sum(isnull(nullif(SRT010.RT_DFERPRO, 0), 2.5) / 2.5)
					else 1.0
				end
			end
		from SRT010 (nolock)
		where
				SRT010.D_E_L_E_T_ = ''
			and SRT010.RT_FILIAL = SRT.RT_FILIAL
			and SRT010.RT_MAT = SRT.RT_MAT
			and SRT010.RT_DATACAL = SRT.RT_DATACAL
			and SRT010.RT_VERBA in (830, 880, 890)
			and SRT010.RT_TIPPROV = SRT.RT_TIPPROV
		group by SRT010.RT_VERBA
	) as PROV_MENSAL,
	
	SRT.RT_VALOR as PROV_ACUMULADA,
	SRT.RT_DFERPRO as AVO_FERPRO,
	SRT.RT_AVOS13S as AVOS_13,

	case when SRT.RT_VERBA = 830 then 2.5 * SRT.RT_SALARIO/30 else case when SRT.RT_VERBA in (880, 890) then 2.5 * SRT.RT_SALARIO/30 else 0.0 end end as VL_FERIAS,
	case when SRT.RT_VERBA = 830 then 2.5 * SRT.RT_SALARIO/90 else case when SRT.RT_VERBA in (880, 890) then 2.5 * SRT.RT_SALARIO/90 else 0.0 end end as VL_FTERC,
	case when SRT.RT_VERBA = 830 then .08 * 2.5 * SRT.RT_SALARIO/30 else case when SRT.RT_VERBA in (880, 890) then .08 * 2.5 * SRT.RT_SALARIO/30 else 0.0 end end as VL_FFGTS,
	case when SRT.RT_VERBA = 830 then .14 * 2.5 * SRT.RT_SALARIO/90 else case when SRT.RT_VERBA in (880, 890) then .14 * 2.5 * SRT.RT_SALARIO/90 else 0.0 end end as VL_FINSS,
	case when month(SRT.RT_DATACAL) = 12 then 2.5 * SRT.RT_SALARIO/30 else 2.5 * SRT.RT_SALARIO/30 end as VL_DECIMO,
	case when month(SRT.RT_DATACAL) = 12 then .08 * 2.5 * SRT.RT_SALARIO/30 else .08 * 2.5 * SRT.RT_SALARIO/30 end as VL_13FGTS,
	case when month(SRT.RT_DATACAL) = 12 then .14 * 2.5 * SRT.RT_SALARIO/30 else .14 * 2.5 * SRT.RT_SALARIO/30 end as VL_13INSS,

	SRT.RT_DFERVEN as DIAS_FERVENC,
	isnull(nullif(SRT.RT_DFERVEN, 0), 1) * SRT.RT_SALARIO/30 as VALOR_FERVENC,
	SRT.RT_DFERPRO as DIAS_FERPROP,
	isnull(nullif(SRT.RT_DFERPRO, 0), 1) * SRT.RT_SALARIO/30 as VALOR_FERPROP,
	SRT.RT_DFERANT as DIAS_FERANTP,
	isnull(nullif(SRT.RT_DFERANT, 0), 1) * SRT.RT_SALARIO/30 as VALOR_FERANTP,
	SRT.RT_DFALVEN as DIAS_FALFERV,
	isnull(nullif(SRT.RT_DFALVEN, 0), 1) * SRT.RT_SALARIO/30 as VALOR_FALFERV,
	SRT.RT_DFALPRO as DIAS_FALFERP,
	isnull(nullif(SRT.RT_DFALPRO, 0), 1) * SRT.RT_SALARIO/30 as VALOR_FALFERP,
	SRT.RT_SALARIO as SALARIO_BASE

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
    
	inner join CTT010 CTT (nolock)
        on CTT.D_E_L_E_T_ = ''
        and CTT.CTT_CUSTO = SRT.RT_CC
    inner join CTD010 CTD (nolock)
        on CTD.D_E_L_E_T_ = ''
        and CTD.CTD_ITEM = SRT.RT_ITEM
where
        SRT.D_E_L_E_T_ = ''
