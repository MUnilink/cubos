select
	ZC2.ZC2_FILIAL as FILIAL,
	ZC2.ZC2_NUM as NUM_OS,
	trim(ZC2.ZC2_COD) as INSUMO,
	cast(substring(ZC2.ZC2_NUM, 6, 10) as int) as OS,
	ZC2.ZC2_COMPET as PERIODO,
	
	cast(sum(ZC2.ZC2_QTDPRV) as numeric(15, 2)) as QTD_PREV,
	cast(sum(ZC2.ZC2_QTDREA) as numeric(15, 2)) as QTD_REAL,
	cast(sum(ZC2.ZC2_VLUPRV) as numeric(15, 2)) as VAL_PREV,
	cast(sum(ZC2.ZC2_VLUREA) as numeric(15, 2)) as VAL_REAL,
	sum(datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0) as HORAS_APONT,

	case when lag(ZC2.ZC2_NUM, 1, 0) over (partition by SRD.FILIAL, SRD.PERIODO, SRD.FUNCAO, SRD.VERBA order by SRD.FILIAL, SRD.PERIODO, SRD.FUNCAO, SRD.VERBA) = 0 then sum(SRD.RD_VALOR) else 0 end as VALOR_FOLHA,
	case when lag(ZC2.ZC2_NUM, 1, 0) over (partition by SRT.FILIAL, SRT.PERIODO, SRT.FUNCAO, SRT.VERBA order by SRT.FILIAL, SRT.PERIODO, SRT.FUNCAO, SRT.VERBA) = 0 then sum(SRT.RT_VALOR) else 0 end as VALOR_PROV,
	case when lag(ZC2.ZC2_NUM, 1, 0) over (partition by SRD.FILIAL, SRD.PERIODO, SRD.FUNCAO, SRD.VERBA order by SRD.FILIAL, SRD.PERIODO, SRD.FUNCAO, SRD.VERBA) = 0 and SRD.VERBA = 20 then sum(SRD.RD_HORAS*SRD.HORAS_PADRAO/30) else 0 end as HORAS_FOLHA

from ZC2010 ZC2 (nolock)
	left join
	(
		select
			trim(SRD010.RD_FILIAL) as FILIAL,
			trim(SRD010.RD_PERIODO) as PERIODO,
			trim(SRA010.RA_CODFUNC) as FUNCAO,
			
			trim(SRA010.RA_MAT) as MATRICULA,
			trim(SRA010.RA_NOME) as NOME,
			trim(SRD010.RD_PD) as PD,
			trim(SRV010.RV_DESC) as VERBA,
			trim(SRJ010.RJ_DESC) as DESC_FUNCAO,
			trim(SRJ010.RJ_YHRPADR) as HORAS_PADRAO,
			trim(SRD010.RD_CC) as CC,
			trim(SRD010.RD_ITEM) as ATIVIDADE,
			
			SRD010.RD_VALOR,
			SRD010.RD_HORAS,
			
			case trim(SRV010.RV_TIPOCOD)
				when '1' then 'PROVENTO'
				when '2' then 'DESCONTO'
				when '3' then 'BASE PROVENTO'
				when '4' then 'BASE DESCONTO'
				else '-'
			end as RV_TIPOCOD
		from SRD010 (nolock)
			left join SRA010 (nolock)
				on SRD010.D_E_L_E_T_ = ''
				and SRD010.RD_FILIAL = SRA010.RA_FILIAL
				and SRD010.RD_MAT = SRA010.RA_MAT
				
				left join SRJ010 (nolock)
					on SRJ010.D_E_L_E_T_ = ''
					and SRJ010.RJ_FILIAL = substring(SRA010.RA_FILIAL, 1, 4)
					and SRJ010.RJ_FUNCAO = SRA010.RA_CODFUNC
					and SRJ010.RJ_YPORTAL = 'S'

			inner join SRV010 (nolock)
				on SRV010.D_E_L_E_T_ = ''
				and substring(SRD010.RD_FILIAL, 1, 4) = SRV010.RV_FILIAL
				and SRD010.RD_PD = SRV010.RV_COD
		where
				SRD010.D_E_L_E_T_ = ''
			and SRD010.RD_PERIODO > 202212
			and SRD010.RD_PD in (20, 25, 29, 30, 38, 39, 51, 113, 134, 170, 171, 172, 173, 224, 255, 336, 344, 371, 371, 440, 441, 442, 444, 445, 446, 591, 719, 738, 739, 749, 796, 800, 817, 830, 831, 832, 833, 834, 845, 846, 847, 848, 950, 955, 960, 961, 962)
	) SRD
		on SRD.FILIAL = ZC2.ZC2_FILIAL
		and SRD.PERIODO = substring(ZC2.ZC2_COMPET, 1, 6)
		and SRD.FUNCAO = ZC2.ZC2_COD
	left join
	(
		select
			trim(SRT010.RT_FILIAL) as FILIAL,
			trim(SRT010.RT_DATACAL) as PERIODO,
			trim(SRA010.RA_CODFUNC) as FUNCAO,
			
			trim(SRA010.RA_MAT) as MATRICULA,
			trim(SRA010.RA_NOME) as NOME,
			trim(SRT010.RT_VERBA) as PD,
			trim(SRV010.RV_DESC) as VERBA,
			trim(SRJ010.RJ_DESC) as DESC_FUNCAO,
			trim(SRJ010.RJ_YHRPADR) as HORAS_PADRAO,
			trim(SRT010.RT_CC) as CC,
			trim(SRT010.RT_ITEM) as ATIVIDADE,
			
			SRT010.RT_VALOR,
			
			case trim(SRV010.RV_TIPOCOD)
				when '1' then 'PROVENTO'
				when '2' then 'DESCONTO'
				when '3' then 'BASE PROVENTO'
				when '4' then 'BASE DESCONTO'
				else '-'
			end as RV_TIPOCOD
		from SRT010 (nolock)
			left join SRA010 (nolock)
				on SRT010.D_E_L_E_T_ = ''
				and SRT010.RT_FILIAL = SRA010.RA_FILIAL
				and SRT010.RT_MAT = SRA010.RA_MAT
				
				left join SRJ010 (nolock)
					on SRJ010.D_E_L_E_T_ = ''
					and SRJ010.RJ_FILIAL = substring(SRA010.RA_FILIAL, 1, 4)
					and SRJ010.RJ_FUNCAO = SRA010.RA_CODFUNC
					and SRJ010.RJ_YPORTAL = 'S'

			inner join SRV010 (nolock)
				on SRV010.D_E_L_E_T_ = ''
				and substring(SRT010.RT_FILIAL, 1, 4) = SRV010.RV_FILIAL
				and SRT010.RT_VERBA = SRV010.RV_COD
		where
				SRT010.D_E_L_E_T_ = ''
			and year(SRT010.RT_DATACAL) > 2022
			and SRT010.RT_VERBA in (20, 25, 29, 30, 38, 39, 51, 113, 134, 170, 171, 172, 173, 224, 255, 336, 344, 371, 371, 440, 441, 442, 444, 445, 446, 591, 719, 738, 739, 749, 796, 800, 817, 830, 831, 832, 833, 834, 845, 846, 847, 848, 950, 955, 960, 961, 962)
	) SRT
		on SRT.FILIAL = ZC2.ZC2_FILIAL
		and SRT.PERIODO = ZC2.ZC2_COMPET
		and SRT.FUNCAO = ZC2.ZC2_COD
where
		ZC2.D_E_L_E_T_ = ''
	and substring(ZC2.ZC2_NUM, 1, 4) > 2022
	and ZC2.ZC2_TIPO = 2
	and ZC2.ZC2_HRINI != '  :  '
	and ZC2.ZC2_HRFIM != '  :  '
group by
	ZC2.ZC2_FILIAL,
	ZC2.ZC2_NUM,
	ZC2.ZC2_COD,
	ZC2.ZC2_COMPET,
	SRD.FILIAL,
	SRD.PERIODO,
	SRT.FILIAL,
	SRT.PERIODO,
	SRD.FUNCAO,
	SRT.FUNCAO,
	SRD.VERBA,
	SRT.VERBA