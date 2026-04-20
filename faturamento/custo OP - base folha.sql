select
	ZC2.ZC2_FILIAL as FILIAL,
	ZC2.ZC2_COMPET as PERIODO,
	trim(ZC2.ZC2_COD) as INSUMO,
	
	case ZC2.ZC2_TIPO
        when 2 then (select trim(SRJ010.RJ_DESC) from SRJ010 (nolock) where SRJ010.D_E_L_E_T_ = '' and SRJ010.RJ_FUNCAO = trim(ZC2.ZC2_COD) and ZC2.ZC2_TIPO = 2)
        else trim(ZC2.ZC2_DESC)
    end as DESC_INSUMO,
	
	ZC2.ZC2_NUM as NUM_OS,
	cast(substring(ZC2.ZC2_NUM, 6, 10) as int) as OS,
	ZC2.ZC2_ITEM as ITEM,
	
	cast(sum(ZC2.ZC2_QTDPRV) as numeric(15, 2)) as QTD_PREV,
	cast(sum(ZC2.ZC2_QTDREA) as numeric(15, 2)) as QTD_REAL,
	cast(sum(ZC2.ZC2_VLUPRV) as numeric(15, 2)) as VAL_PREV,
	cast(sum(ZC2.ZC2_VLUREA) as numeric(15, 2)) as VAL_REAL,
	cast(sum(datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0) as numeric(15, 4)) as HORAS_APONT,
	cast(avg(ZC2.ZC2_QTDREC) * sum(datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0) as numeric(15, 4)) as HORAS_TOTAIS,

	(
		select sum(SRD010.RD_VALOR)
		from SRD010 (nolock)
			inner join SRA010 (nolock)
				on SRA010.D_E_L_E_T_ = ''
				and SRA010.RA_FILIAL = SRD010.RD_FILIAL
				and SRA010.RA_MAT = SRD010.RD_MAT
			inner join SRV010 SRV (nolock)
				on SRV.D_E_L_E_T_ = ''
				and SRV.RV_FILIAL = substring(SRD010.RD_FILIAL, 1, 4)
				and SRV.RV_COD = SRD010.RD_PD
		where
				SRD010.D_E_L_E_T_ = ''
			and SRD010.RD_FILIAL = ZC2.ZC2_FILIAL
			and SRD010.RD_PERIODO = substring(ZC2.ZC2_COMPET, 1, 6)
			and SRA010.RA_CODFUNC = ZC2.ZC2_COD
			and exists (select * from SX6010 where SX6010.X6_VAR in ('UN_OSVERBA', 'UN_OSVERB1') and SX6010.X6_CONTEUD like '%' || SRV.RV_COD || '%')
	) as VALOR_FOLHA,
	(
		select sum(SRT010.RT_VALOR)
		from SRT010 (nolock)
			inner join SRA010 (nolock)
				on SRA010.D_E_L_E_T_ = ''
				and SRA010.RA_FILIAL = SRT010.RT_FILIAL
				and SRA010.RA_MAT = SRT010.RT_MAT
				
				inner join SRJ010 (nolock)
					on SRJ010.D_E_L_E_T_ = ''
					and SRJ010.RJ_FILIAL = substring(SRA010.RA_FILIAL, 1, 4)
					and SRJ010.RJ_FUNCAO = SRA010.RA_CODFUNC

			inner join SRV010 SRV (nolock)
				on SRV.D_E_L_E_T_ = ''
				and SRV.RV_FILIAL = substring(SRT010.RT_FILIAL, 1, 4)
				and SRV.RV_COD = SRT010.RT_VERBA
		where
				SRT010.D_E_L_E_T_ = ''
			and SRT010.RT_FILIAL = ZC2.ZC2_FILIAL
			and SRT010.RT_DATACAL = ZC2.ZC2_COMPET
			and SRA010.RA_CODFUNC = ZC2.ZC2_COD
			and exists (select * from SX6010 where SX6010.X6_VAR in ('UN_OSVERBA', 'UN_OSVERB1') and SX6010.X6_CONTEUD like '%' || SRV.RV_COD || '%')
	) as VALOR_PROV,

	(
		select sum(SRD010.RD_HORAS) * avg(cast(SRJ010.RJ_YHRPADR as int))
		from SRD010 (nolock)
			inner join SRA010 (nolock)
				on SRD010.D_E_L_E_T_ = ''
				and SRD010.RD_FILIAL = SRA010.RA_FILIAL
				and SRD010.RD_MAT = SRA010.RA_MAT
				
				inner join SRJ010 (nolock)
					on SRJ010.D_E_L_E_T_ = ''
					and SRJ010.RJ_FILIAL = substring(SRA010.RA_FILIAL, 1, 4)
					and SRJ010.RJ_FUNCAO = SRA010.RA_CODFUNC

			inner join SRV010 SRV (nolock)
				on SRV.D_E_L_E_T_ = ''
				and substring(SRD010.RD_FILIAL, 1, 4) = SRV.RV_FILIAL
				and SRD010.RD_PD = SRV.RV_COD
		where
				SRD010.D_E_L_E_T_ = ''
			and SRD010.RD_FILIAL = ZC2.ZC2_FILIAL
			and SRD010.RD_PERIODO = substring(ZC2.ZC2_COMPET, 1, 6)
			and SRA010.RA_CODFUNC = ZC2.ZC2_COD
			and SRD010.RD_PD in (20, 130, 51, 50, 200, 358) /* DIAS TRABALHADOS, FÉRIAS, AUX. DOENÇA, AUX. MATERNIDADE, VALOR DE AFASTAMENTO,  AUX. ACIDENTE*/
	)/30 as DIAS_FOLHA,

	avg(ZG1.ZG1_HRPAD) as HORA_PADRAO,
    avg(ZG1.ZG1_VLTOTL) as VALOR_TOTAL,
    avg(ZG1.ZG1_VLHORA) as VALOR_HORA,
    avg(ZG1.ZG1_HRPRO) as HORA_PRODT,
    avg(ZG1.ZG1_VLPROD) as VALOR_PRODT,
    avg(ZG1.ZG1_HRIMPR) as HORA_IMPRO,
    avg(ZG1.ZG1_VLIMPR) as VALOR_IMPRO,

	count(ZC2.ZC2_NUM) as QTD_OS,
	count(ZC2.ZC2_COD) as QTD_APONT

from ZC2010 ZC2 (nolock)
	left join ZG1010 ZG1 (nolock)
        on ZG1.D_E_L_E_T_ = ''
        and ZG1.ZG1_CODIGO = ZC2.ZC2_COD
        and ZG1.ZG1_FILORI = ZC2.ZC2_FILIAL
        and ZG1.ZG1_COMPET = substring(ZC2.ZC2_COMPET, 1, 6)
		and ZG1.ZG1_TABELA = 'SRJ'
		and ZG1.ZG1_ATIVO = 'S'
where
		ZC2.D_E_L_E_T_ = ''
	and ZC2.ZC2_TIPO = 2
	and nullif(nullif(ZC2.ZC2_DTINI, ''), '  :  ') is not null
	and nullif(nullif(ZC2.ZC2_HRINI, ''), '  :  ') is not null
	and nullif(nullif(ZC2.ZC2_DTFIM, ''), '  :  ') is not null
	and nullif(nullif(ZC2.ZC2_HRFIM, ''), '  :  ') is not null
group by
	ZC2.ZC2_FILIAL,
	ZC2.ZC2_NUM,
	ZC2.ZC2_COD,
	ZC2.ZC2_COMPET,
	ZC2.ZC2_ITEM,
	ZC2.ZC2_TIPO,
	ZC2.ZC2_DESC
