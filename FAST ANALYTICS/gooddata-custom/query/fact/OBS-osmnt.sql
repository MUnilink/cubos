select
	trim(isnull(STL.TL_SEQRELA, '-')) as TL_SEQRELA,
	STL.TL_QUANTID,

	case when trim(STL.TL_CODIGO) in ('11380003', '11380004', '11380005') and STL.TL_LOCAL = '80' then ADESIVO_CUSTO.B9_CM * STL.TL_QUANTID
	else
		case when trim(STL.TL_CODIGO) in ('T12', 'T15') then ST1.T1_SALARIO * STL.TL_QUANTID
		else STL.TL_CUSTO
		end
	end as TL_CUSTO,

	trim(isnull(STL.TL_DTINICI, '-')) as TL_DTINICI,
	trim(isnull(STL.TL_DTFIM, '-')) as TL_DTFIM,
	trim(isnull(STJ.TJ_DTORIGI, '-')) as TJ_DTORIGI,

	STJ.TJ_POSCONT,
	case when substring(ST9.T9_DTCOMPR, 1, 6) = substring(STL.TL_DTINICI, 1, 6) then ST9.T9_VALCPA else 0.0 end as T9_VALCPA,	
	STJ.TJ_CUSTMDO,
	STJ.TJ_CUSTMAT,
	STJ.TJ_CUSTMAA,
	STJ.TJ_CUSTMAS,
	STJ.TJ_CUSTTER,

	trim(isnull(STL.TL_CODIGO, '-')) as INSUMO,
	trim(isnull(STL.TL_LOCAL, '-')) as ARMAZEM,

	case when STL.TL_CODIGO = ST0.T0_ESPECIA or STL.TL_CODIGO = ST1.T1_CODFUNC then 'MÃO-DE-OBRA'
	else
		case when STL.TL_CODIGO = SB1.B1_COD and SB1.B1_COD like '1%' then 'PEÇAS'
		else
			case when SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA then 'TERCEIROS'
			else
				case when STL.TL_CODIGO = SH4.H4_CODIGO then 'FERRAMENTA'
				else 'OUTROS'
				end
			end
		end
	end as TIPO_CUSTO,

	case when STL.TL_CODIGO = ST0.T0_ESPECIA or STL.TL_CODIGO = ST1.T1_CODFUNC then trim(isnull(ST1.T1_NOME, isnull(ST0.T0_NOME, '-')))
	else
		case when STL.TL_CODIGO = SB1.B1_COD and SB1.B1_COD like '1%' then trim(SB1.B1_DESC)
		else
			case when SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA then trim(SA2.A2_NOME)
			else
				case when STL.TL_CODIGO = SH4.H4_CODIGO then trim(SH4.H4_DESCRI)
				else 'OUTROS'
				end
			end
		end
	end as DESC_INSUMO,

	trim(isnull(STJ.TJ_ORDEM, '-')) as TJ_ORDEM,
	trim(isnull(ST5.T5_TAREFA, '-')) as T5_TAREFA,
	trim(isnull(STJ.TJ_CODBEM, '-')) as TJ_CODBEM,
	trim(isnull(SH4.H4_CODIGO, '-')) as H4_CODIGO,
	trim(isnull(ST0.T0_ESPECIA, '-')) as T0_ESPECIA,
	trim(isnull(ST1.T1_CODFUNC, '-')) as T1_CODFUNC,

	trim(isnull(SB1.B1_GRUPO, '-')) as B1_GRUPO,
	trim(isnull(SB1.B1_COD, '-')) as B1_COD,
	trim(isnull(SA2.A2_COD + SA2.A2_LOJA, '-')) as ID_FORNECEDOR,
	trim(isnull(STI.TI_PLANO, '-')) as TI_PLANO,
	trim(isnull(STJ.TJ_FILIAL, '-')) as COD_FILIAL,
	trim(isnull(ST4.T4_SERVICO, '-')) as T4_SERVICO,
	null as B1_UPRC,
	null as T1_SALARIO

from STJ010 as STJ /**/
	inner join ST9010 as ST9
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = STJ.TJ_CODBEM

		left join TQR010 as TQR
			on 	TQR.D_E_L_E_T_ = ''
			and TQR.TQR_TIPMOD = ST9.T9_TIPMOD

	inner join ST4010 as ST4
		on ST4.D_E_L_E_T_ = ''
		and ST4.T4_SERVICO = STJ.TJ_SERVICO
	inner join STL010 as STL
		on STL.D_E_L_E_T_ = ''
		and STL.TL_ORDEM = STJ.TJ_ORDEM
		and STL.TL_PLANO = STJ.TJ_PLANO
		and STL.TL_FILIAL = STJ.TJ_FILIAL

		left join ST5010 as ST5
			on ST5.D_E_L_E_T_ = ''
			and ST5.T5_CODBEM = STL.TL_CODBEM
			and ST5.T5_TAREFA = STL.TL_TAREFA/*
		left join SB1010 as SB1
			on SB1.D_E_L_E_T_ = ''
			and SB1.B1_COD = STL.TL_CODIGO

			left join SD1010 as SD1
				on SD1.D_E_L_E_T_ = ''
				and SD1.D1_COD = SB1.B1_COD*/
				
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

		left join SA2010 as SA2
			on SA2.D_E_L_E_T_ = ''
			and SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA
		left join SB1010 as SB1
			on SB1.D_E_L_E_T_ = ''
			and SB1.B1_COD = STL.TL_CODIGO
		left join SH4010 as SH4
			on SH4.D_E_L_E_T_ = ''
			and SH4.H4_CODIGO = STL.TL_CODIGO
		left join ST0010 as ST0
			on ST0.D_E_L_E_T_ = ''
			and ST0.T0_ESPECIA = STL.TL_CODIGO
		left join ST1010 as ST1
			on ST1.D_E_L_E_T_ = ''
			and ST1.T1_FILIAL = STL.TL_FILIAL
			and ST1.T1_CODFUNC = STL.TL_CODIGO
		left join STI010 as STI
			on STI.D_E_L_E_T_ = ''
			and STI.TI_FILIAL = STL.TL_FILIAL
			and STI.TI_PLANO = STL.TL_PLANO
where
		STL.TL_DTINICI between <<START_DATE>> AND <<FINAL_DATE>>
	and STL.D_E_L_E_T_ = ''
	/*and trim(ST9.T9_CODBEM) not like '[0-9]%'*/
	and year(STJ.TJ_DTORIGI) between 2019 and 2029