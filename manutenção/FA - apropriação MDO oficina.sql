select
	convert(datetime, getdate(), 113) as ULTIMA_CARGA,
	cast(trim(STL.TL_SEQRELA) as int) as TL_SEQRELA,
	cast(STL.TL_QUANTID as numeric(15, 2)) as TL_QUANTID,

	STL.TL_CUSTO,

	case
		when isdate(concat(STL.TL_DTINICI, ' ', STL.TL_HOINICI)) = 1 then convert(datetime, concat(STL.TL_DTINICI, ' ', STL.TL_HOINICI), 120)
		when isdate(STL.TL_DTINICI) = 1 then convert(datetime, concat(STL.TL_DTINICI, ' ', '00:00:00'), 120)
	else convert(datetime, concat(STJ.TJ_DTORIGI , ' ', '00:00:00'), 120) end as DTINI_APP,
	
	case
		when isdate(concat(STL.TL_DTFIM, ' ', STL.TL_HOFIM)) = 1 then convert(datetime, concat(STL.TL_DTFIM, ' ', STL.TL_HOFIM), 120)
		when isdate(STL.TL_DTFIM) = 1 then convert(datetime, concat(STL.TL_DTFIM, ' ', '00:00:00'), 120)
	else convert(datetime, concat(STJ.TJ_DTPRFIM , ' ', '00:00:00'), 120) end as DTFIM_APP,
	
	cast(STJ.TJ_DTORIGI as date) as DATA_INIOS,
	cast(STJ.TJ_DTPRFIM as date) as DATA_FIMOS,
	STJ.TJ_TERMINO as OS_ENCERRADA,
	STJ.TJ_SITUACA as SITUACAO,
	STJ.TJ_POSCONT,
	case when left(ST9.T9_DTCOMPR, 6) = left(STL.TL_DTINICI, 6) then ST9.T9_VALCPA else 0.0 end as T9_VALCPA,
	(select max(ST6010.T6_YHRPADR) from ST6010 where ST6010.D_E_L_E_T_ = '' and ST6010.T6_CODFAMI = ST9.T9_CODFAMI) as HORA_PADRAO,
	trim(STL.TL_CODIGO) as INSUMO,
	trim(STL.TL_LOCAL) as ARMAZEM,

	case STL.TL_TIPOREG
		when 'M' then 'MÃO-DE-OBRA'
		when 'E' then 'ESPECIALIDADE'
		else 'OUTROS'
	end as TIPO_CUSTO,

	case STL.TL_TIPOREG
		when 'M' then trim(ST1.T1_NOME)
		when 'E' then trim(ST0.T0_NOME)
		else 'OUTROS'
	end as DESC_INSUMO,

	trim(STJ.TJ_ORDEM) as TJ_ORDEM,
	trim(STL.TL_TAREFA) as T5_TAREFA,
	trim(STJ.TJ_CODBEM) as TJ_CODBEM,
	null as H4_CODIGO,
	trim(ST0.T0_ESPECIA) as T0_ESPECIA,
	trim(ST1.T1_CODFUNC) as T1_CODFUNC,
	null as B1_GRUPO,
	null as B1_COD,
	null as ID_FORNECEDOR,
	trim(STL.TL_PLANO) as TI_PLANO,
	trim(STL.TL_FILIAL) as COD_FILIAL,
	trim(STJ.TJ_SERVICO) as T4_SERVICO,
	trim(STJ.TJ_CCUSTO) as CC,
	coalesce(nullif(trim(STJ.TJ_YITMCT), ''), nullif((select top 1 first_value(TPN010.TPN_XITEMC) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_CODBEM, TPN010.TPN_DTINIC, TPN010.TPN_HRINIC) from TPN010 where TPN010.D_E_L_E_T_ = '' and TPN010.TPN_CODBEM = STJ.TJ_CODBEM and TPN010.TPN_DTINIC >= STL.TL_DTINICI), ''), nullif(ST9.T9_ITEMCTA, '')) as ATIVIDADE,
	trim(SD1.D1_PEDIDO) as PEDCOMPRA,
	null as B1_UPRC,
	null as T1_SALARIO,

    case
        when STL.TL_TIPOREG = 'M' and ST1.T1_CCUSTO = '302' and ST1.T1_DTFIMDI <= STL.TL_DTFIM and SH7.H7_CODIGO = '001' then 220.0
        when STL.TL_TIPOREG = 'M' and ST1.T1_CCUSTO = '303' and ST1.T1_DTFIMDI <= STL.TL_DTFIM and SH7.H7_CODIGO = '015' then 220.0
        when STL.TL_TIPOREG = 'M' and ST1.T1_CCUSTO = '303' and ST1.T1_DTFIMDI <= STL.TL_DTFIM and SH7.H7_CODIGO = '016' then 180.0
        when STL.TL_TIPOREG = 'M' and ST1.T1_CCUSTO = '303' and ST1.T1_DTFIMDI <= STL.TL_DTFIM and SH7.H7_CODIGO = '017' then 180.0
    else 0.0 end as HORAS_FUNC

    /* PARA RM */
	convert(datetime, datetimefromparts(year(STL.TL_DTINICI), month(STL.TL_DTINICI), day(STL.TL_DTINICI), substring(STL.TL_HOINICI, 1, 2), substring(STL.TL_HOINICI, 4, 5), 0, 0), 113) as INI_APONT,
	convert(datetime, datetimefromparts(year(STL.TL_DTFIM), month(STL.TL_DTFIM), day(STL.TL_DTFIM), substring(STL.TL_HOFIM, 1, 2), substring(STL.TL_HOFIM, 4, 5), 0, 0), 113) as FIM_APONT,
	datediff(minute, concat(STL.TL_DTINICI, ' ', STL.TL_HOINICI), concat(STL.TL_DTFIM, ' ', STL.TL_HOFIM))/60.0 as HORAS_APONT,

	convert(date, STL.TL_DTINICI, 103) as DT_INI,
	convert(date, STL.TL_DTFIM, 103) as DT_FIM,

	trim(STL.TL_HOINICI) as HORA_INI,
	trim(STL.TL_HOFIM) as HORA_FIM,

	substring(STL.TL_DTINICI, 1, 6) as PERIODO_INI,
	substring(STL.TL_DTFIM, 1, 6) as PERIODO_FIM,

	SRA.RA_MAT as MATRICULA,
    case isnull(SPF.qtd_SPF, 0) when 0 then
    (
        select avg(SR6010.R6_HRNORMA)
        from SPF010
            inner join SR6010
                on SR6010.D_E_L_E_T_ = ''
                and SR6010.R6_TURNO = SPF010.PF_TURNOPA
        where
                SPF010.D_E_L_E_T_ = ''
            and left(SPF010.PF_DATA, 6) = left(STL.TL_DTFIM, 6)
            and SPF010.PF_FILIAL = STL.TL_FILIAL
            and SPF010.PF_MAT = STL.TL_CODIGO
    )
    else SPF.CARGA_HPRO
    end as HORAS_PRO

from STL010 STL (nolock)
	left join ST0010 ST0 (nolock)
		on ST0.D_E_L_E_T_ = ''
		and ST0.T0_ESPECIA = STL.TL_CODIGO
	left join ST1010 ST1 (nolock)
		on ST1.D_E_L_E_T_ = ''
		and ST1.T1_FILIAL = STL.TL_FILIAL
		and ST1.T1_CODFUNC = STL.TL_CODIGO

		left join SRA010 SRA (nolock)
			on ST1.D_E_L_E_T_ = ''
			and ST1.T1_FILIAL = SRA.RA_FILIAL
			and ST1.T1_CODFUNC = SRA.RA_MAT
	
	inner join STJ010 STJ (nolock)
		on STJ.D_E_L_E_T_ = ''
		and STJ.TJ_ORDEM = STL.TL_ORDEM
		and STJ.TJ_PLANO = STL.TL_PLANO
		and STJ.TJ_FILIAL = STL.TL_FILIAL

    left join
    (
        select
            SPF010.PF_FILIAL as FILIAL,
            SPF010.PF_MAT as MATRICULA,
            SPF010.PF_DATA as DATA_TUR,
            SPF010.PF_TURNODE as TURNO_ANT,
            SPF010.PF_TURNOPA as TURNO_PRO,

            cast(isnull(SR6_ANT.R6_HRNORMA, 0) as numeric(15, 2)) as CARGA_HANT,
            cast(isnull(SR6_PRO.R6_HRNORMA, 0) as numeric(15, 2)) as CARGA_HPRO,

            datediff
            (
                day, /* se a última mudança ocorreu dentro do período da folha, data da mudança; senão, e se demitido antes do fim do período, demissão, senão, fim do período*/
                case when SRA010.RA_ADMISSA >= concat(left(SPF010.PF_DATA, 6), '01') then SRA010.RA_ADMISSA else concat(left(SPF010.PF_DATA, 6), '01') end,
                case when SPF010.PF_DATA >= concat(left(SPF010.PF_DATA, 6), '01') then SPF010.PF_DATA
                    else
                    case when nullif(SRA010.RA_DEMISSA, '') <= eomonth(concat(left(SPF010.PF_DATA, 6), '01')) then SRA010.RA_DEMISSA else eomonth(concat(left(SPF010.PF_DATA, 6), '01')) end
                end
            ) as DIASANT_TURNO,
                
            datediff
            (
                day, /* se a última mudança ocorreu dentro do período da folha, data da mudança; senão, se admitido após o início do período, admissão, senão, início do período */
                case when SPF010.PF_DATA >= concat(left(SPF010.PF_DATA, 6), '01') then SPF010.PF_DATA
                    else
                    case when SRA010.RA_ADMISSA >= concat(left(SPF010.PF_DATA, 6), '01') then SRA010.RA_ADMISSA else concat(left(SPF010.PF_DATA, 6), '01') end
                end,
                case when left(SRA010.RA_DEMISSA, 6) = left(SPF010.PF_DATA, 6) then SRA010.RA_DEMISSA else dateadd(day, 1, eomonth(concat(left(SPF010.PF_DATA, 6), '01'))) end
            ) as DIASPRO_TURNO,
            
            1 as qtd_SPF
        from SPF010
            inner join SRA010 (nolock)
                on SRA010.D_E_L_E_T_ = ''
                and SRA010.RA_FILIAL = SPF010.PF_FILIAL
                and SRA010.RA_MAT = SPF010.PF_MAT
            inner join SR6010 SR6_ANT (nolock)
                on SR6_ANT.D_E_L_E_T_ = ''
                and SR6_ANT.R6_TURNO = SPF010.PF_TURNODE
            inner join SR6010 SR6_PRO (nolock)
                on SR6_PRO.D_E_L_E_T_ = ''
                and SR6_PRO.R6_TURNO = SPF010.PF_TURNOPA
        where
                SPF010.D_E_L_E_T_ = ''
            and SPF010.PF_TURNODE != SPF010.PF_TURNOPA
    ) SPF
        on left(SPF.DATA_TUR, 6) = left(STL.TL_DTFIM, 6)
        and SPF.FILIAL = STL.TL_FILIAL
        and SPF.MATRICULA = STL.TL_CODIGO
where
		STL.D_E_L_E_T_ = ''
	and STL.TL_TIPOREG in ('E', 'M')
    and STL.TL_DTFIM like '202511%'
