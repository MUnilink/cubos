select
	trim(SRT.RT_FILIAL) as FILIAL,
	substring(SRT.RT_DATACAL, 1, 6) as PERIODO,
	trim(SRT.RT_MAT) as MAT,
	trim(SRA.RA_NOMECMP) as NOME,
	trim(SRT.RT_VERBA) as VERBA,
	trim(SRV.RV_DESC) as RV_DESC,
	trim(SRV.RV_DESCDET) as RV_DESCDET,
	trim(SRA.RA_CODFUNC) as FUNCAO,
	trim(SRJ.RJ_DESC) as RJ_DESC,
	
	trim(SRT.RT_CC) as CC,
	trim(SRT.RT_ITEM) as ATIVIDADE,

	case trim(SRT.RT_TIPPROV)
		when '1' then 'PROVENTO'
		when '2' then 'DESCONTO'
		when '3' then 'BASE PROVENTO'
		when '4' then 'BASE DESCONTO'
		else '-'
	end as RV_TIPOCOD,

	SRT.RT_VALOR as PROV_ACUMULADA,
	lag(SRT.RT_DFERPRO, 1, 0.0) over (partition by SRT.RT_FILIAL, SRT.RT_MAT, SRT.RT_VERBA, SRT.RT_TIPPROV order by SRT.RT_DATACAL) as AVO_ANT,
	SRT.RT_DFERPRO as AVO_ATU,
	2.5 * SRT.RT_SALARIO/30.0 as VALOR_FERIAS,
	SRT.RT_AVOS13S as AVOS_13,

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
	and exists (select * from SX6010 where SX6010.X6_VAR in ('UN_OSVERBA', 'UN_OSVERB1') and SX6010.X6_CONTEUD like '%' || SRV.RV_COD || '%')
