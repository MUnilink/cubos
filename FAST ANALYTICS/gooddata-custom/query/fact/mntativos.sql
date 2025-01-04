select
	trim(STL.TL_SEQRELA) as TL_SEQRELA,
	STL.TL_QUANTID,

	case
		when trim(STL.TL_CODIGO) in ('11380003', '11380004', '11380005') and STL.TL_LOCAL = '80' then ADESIVO_CUSTO.B9_CM * STL.TL_QUANTID
		when STL.TL_TIPOREG = 'M' and trim(STL.TL_CODIGO) like 'T%' then ST1.T1_SALARIO * STL.TL_QUANTID
		when STL.TL_TIPOREG = 'M' and left(STL.TL_DTINICI, 6) > (select trim(SX6010.X6_CONTEUD) from SX6010 where SX6010.X6_VAR = 'MV_GPMESCT') then
		(
			select avg(STL010.TL_CUSTO)
			from STL010
			where
					STL010.D_E_L_E_T_ = ''
				and STL010.TL_CODIGO = STL.TL_CODIGO
				and left(STL010.TL_DTINICI, 6) = (select trim(SX6010.X6_CONTEUD) from SX6010 where SX6010.X6_VAR = 'MV_GPMESCT')
		)
		else STL.TL_CUSTO
	end as TL_CUSTO,

	case when isdate(concat(STL.TL_DTINICI, ' ', STL.TL_HOINICI)) = 1 then convert(datetime, concat(STL.TL_DTINICI, ' ', STL.TL_HOINICI), 120) else null end as DTINI_APP,
	case when isdate(concat(STL.TL_DTFIM, ' ', STL.TL_HOFIM)) = 1 then convert(datetime, concat(STL.TL_DTFIM, ' ', STL.TL_HOFIM), 120) else null as DTFIM_APP,
	STJ.TJ_DTORIGI as DATA_INIOS,
	STJ.TJ_DTPRFIM as DATA_FIMOS,
	STJ.TJ_TERMINO as OS_ENCERRADA,

	STJ.TJ_POSCONT,
	(select max(ST6010.T6_YHRPADR) from ST6010 where ST6010.D_E_L_E_T_ = '' and ST6010.T6_CODFAMI = ST9.T9_CODFAMI) as HORA_PADRAO,

	trim(STL.TL_CODIGO) as INSUMO,
	trim(STL.TL_LOCAL) as ARMAZEM,

	case STL.TL_TIPOREG
		when 'M' then 'MÃO-DE-OBRA'
		when 'E' then 'MÃO-DE-OBRA'
		when 'P' then 'PEÇAS'
		when 'T' then 'TERCEIROS'
		else 'OUTROS'
	end as TIPO_CUSTO,

	case STL.TL_TIPOREG
		when 'M' then trim(ST1.T1_NOME)
		when 'E' then trim(ST0.T0_NOME)
		when 'P' then trim(SB1.B1_DESC)
		when 'T' then trim(SA2.A2_NOME)
		else 'OUTROS'
	end as DESC_INSUMO,

	trim(STJ.TJ_TIPO) as CARAC_TIPO,
	trim(STJ.TJ_ORDEM) as TJ_ORDEM,
	trim(STL.TL_TAREFA) as T5_TAREFA,
	trim(STJ.TJ_CODBEM) as TJ_CODBEM,
	trim(SH4.H4_CODIGO) as H4_CODIGO,
	trim(ST0.T0_ESPECIA) as T0_ESPECIA,
	trim(ST1.T1_CODFUNC) as T1_CODFUNC,
	trim(SB1.B1_GRUPO) as B1_GRUPO,
	trim(SB1.B1_COD) as B1_COD,
	trim(SA2.A2_COD) + trim(SA2.A2_LOJA) as ID_FORNECEDOR,
	
	trim(STL.TL_PLANO) as TI_PLANO,
	trim(STL.TL_FILIAL) as COD_FILIAL,
	trim(STJ.TJ_SERVICO) as T4_SERVICO,
	trim(STJ.TJ_CCUSTO) as CC,
	trim(STJ.TJ_YITMCT) as ATIVIDADE

from STJ010 STJ
	inner join ST9010 ST9
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = STJ.TJ_CODBEM
	inner join STL010 STL
		on STL.D_E_L_E_T_ = ''
		and STL.TL_ORDEM = STJ.TJ_ORDEM
		and STL.TL_PLANO = STJ.TJ_PLANO
		and STL.TL_FILIAL = STJ.TJ_FILIAL

		left join TT9010 TT9
			on TT9.D_E_L_E_T_ = ''
			and TT9.TT9_TAREFA = STL.TL_TAREFA
				
		left join
		(
			select
				SB9010.B9_COD,
				min(SB9010.B9_VINI1/SB9010.B9_QINI) as B9_CM,
				min(SB9010.B9_DATA) as B9_DATA
			from SB9010
			where
					SB9010.D_E_L_E_T_ = ''
				and SB9010.B9_LOCAL = '01'
				and SB9010.B9_COD in ('11380003', '11380004', '11380005')
				and SB9010.B9_QINI != 0
			group by
				SB9010.B9_COD
		) ADESIVO_CUSTO
			on ADESIVO_CUSTO.B9_COD = STL.TL_CODIGO

		left join SA2010 SA2
			on SA2.D_E_L_E_T_ = ''
			and SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA
		left join SB1010 SB1
			on SB1.D_E_L_E_T_ = ''
			and SB1.B1_COD = STL.TL_CODIGO
		left join SH4010 SH4
			on SH4.D_E_L_E_T_ = ''
			and SH4.H4_CODIGO = STL.TL_CODIGO
		left join ST0010 ST0
			on ST0.D_E_L_E_T_ = ''
			and ST0.T0_ESPECIA = STL.TL_CODIGO
		left join ST1010 ST1
			on ST1.D_E_L_E_T_ = ''
			and ST1.T1_FILIAL = STL.TL_FILIAL
			and ST1.T1_CODFUNC = STL.TL_CODIGO
where
		STL.TL_DTINICI between <<START_DATE>> AND <<FINAL_DATE>>
	and STL.TL_SEQRELA > 0
	and year(STJ.TJ_DTORIGI) between 2019 and 2029
	and STL.D_E_L_E_T_ = ''
