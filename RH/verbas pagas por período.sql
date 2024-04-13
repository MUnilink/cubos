	select
		trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOMECMP) as NOME,
		trim(SRJ.RJ_FUNCAO) as COD_FUNCAO,
        trim(SRJ.RJ_DESC) as FUNCAO,
		trim(SRA.RA_MUNICIP) as MUNICIPIO,
		trim(SRA.RA_ESTADO) as UF,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
        case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

        trim(CTT.CTT_CUSTO) as CC,
        trim(CTT.CTT_DESC01) as CCUSTO,
        trim(CTD.CTD_ITEM) as ITCT,
        trim(CTD.CTD_DESC01) as ATIVIDADE,
        trim(SQB.QB_DEPTO) as DEPTO,
        trim(SQB.QB_DESCRIC) as DEPARTAMENTO,

        trim(SRJ.RJ_CODCBO) as CBO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,

		trim(isnull(SRC.RC_PERIODO, '-')) as PERIODO,
		trim(isnull(SRC.RC_PD, '-')) as VERBA,
		trim(isnull(SRC.RC_SEQ, '-')) as SEQ,
		trim(isnull(SRC.RC_ROTEIR, '-')) as ROTEIRO,
		
		case when SRC.RC_PD in ('008', '020', '025', '031', '039', '041', '051', '072', '094', '106', '201', '215', '220', '223', '343', '365', '783') then '02 Salários e Ordenados'
		else
			case when SRC.RC_PD in ('029', '111', '113') then '03 Hora Extra'
			else
				case when SRC.RC_PD in ('038', '711', '719', '738', '749', '796') then '04 Benefícios'
				else
					case when SRC.RC_PD in ('739', '759', '760', '800', '817', '950', '955', '960', '961', '962') then '05 Encargos Sociais'
					else
						case when SRC.RC_PD in ('845', '846') then '06 13º Salário'
						else
							case when SRC.RC_PD in ('833', '834', '847', '848') then '07 Encargos Sociais (13º e Férias)'
							else
								case when SRC.RC_PD in ('830', '831', '832') then '08 Férias'
								else '01 N/A Custo'
								end
							end
						end
					end
				end
			end
		end as CONTA,

		case when exists (select * from SX6010 where SX6010.X6_VAR in ('UN_OSVERBA', 'UN_OSVERB1') and SX6010.X6_CONTEUD like '%' || SRV.RV_COD || '%') then 'CUSTOS' else 'OUTRAS' end as VERBA_CUSTO,
		
		trim(isnull(SRV.RV_DESC, '-')) as DESC_VERBA1,
		case SRV.RV_COD
			when '183' then 'VALOR A RECEBER'
			when '999' then 'VALOR A RECEBER'
		else SRV.RV_DESCDET end as DESC_VERBA2,

		case trim(SRV.RV_TIPOCOD)
			when '1' then 'PROVENTO'
			when '2' then 'DESCONTO'
			when '3' then 'BASE PROVENTO'
			when '4' then 'BASE DESCONTO'
			else 'OUTROS'
		end as TIPO_VERBA,

		SRC.RC_VALOR as VALOR,
		SRC.RC_HORAS as HORAS,
		SRA.RA_SALARIO as SALARIO,
		SRA.RA_HRSEMAN as HORAS_SEM,
		SRJ.RJ_YHRPADR as HORAS_PADRAO,

		null as DATARQ,
		null as STATUS_LANC,
		null as INSS,
		null as IR,
		null as FGTS,

		case when lag(SRC.RC_MAT, 1, 0) over (partition by SRC.RC_FILIAL, SRC.RC_PERIODO, SRC.RC_MAT order by SRC.R_E_C_N_O_) = 0 then SRA.RA_HRSMES else 0 end as HORAS_MES,
		case when lag(SRC.RC_MAT, 1, 0) over (partition by SRC.RC_FILIAL, SRC.RC_PERIODO, SRC.RC_MAT order by SRC.R_E_C_N_O_) = 0 then 1 else 0 end as contador_func

	from SRC010 SRC (nolock)
		inner join SRV010 SRV (nolock)
			on SRV.D_E_L_E_T_ = ''
			and substring(SRC.RC_FILIAL, 1, 4) = SRV.RV_FILIAL
			and SRC.RC_PD = SRV.RV_COD
		inner join SRA010 SRA (nolock)
			on SRA.D_E_L_E_T_ = ''
			and SRA.RA_FILIAL = SRC.RC_FILIAL
			and SRA.RA_MAT = SRC.RC_MAT
		inner join SQB010 SQB (nolock)
			on SQB.D_E_L_E_T_ = ''
			and SQB.QB_DEPTO = SRC.RC_DEPTO

			inner join SRJ010 SRJ (nolock)
				on SRJ.D_E_L_E_T_ = ''
				and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
				and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
		
		left join CTT010 CTT (nolock)
			on CTT.D_E_L_E_T_ = ''
			and CTT.CTT_CUSTO = SRC.RC_CC
		left join CTD010 CTD (nolock)
			on CTD.D_E_L_E_T_ = ''
			and CTD.CTD_ITEM = SRC.RC_ITEM
	where SRC.D_E_L_E_T_ = ''
union
	select
		trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOMECMP) as NOME,
		trim(SRJ.RJ_FUNCAO) as COD_FUNCAO,
        trim(SRJ.RJ_DESC) as FUNCAO,
		trim(SRA.RA_MUNICIP) as MUNICIPIO,
		trim(SRA.RA_ESTADO) as UF,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
        case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

        trim(CTT.CTT_CUSTO) as CC,
        trim(CTT.CTT_DESC01) as CCUSTO,
        trim(CTD.CTD_ITEM) as ITCT,
        trim(CTD.CTD_DESC01) as ATIVIDADE,
        trim(SQB.QB_DEPTO) as DEPTO,
        trim(SQB.QB_DESCRIC) as DEPARTAMENTO,

        trim(SRJ.RJ_CODCBO) as CBO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,

		trim(isnull(SRD.RD_PERIODO, '-')) as PERIODO,
		trim(isnull(SRD.RD_PD, '-')) as VERBA,
		trim(isnull(SRD.RD_SEQ, '-')) as SEQ,
		trim(isnull(SRD.RD_ROTEIR, '-')) as ROTEIRO,
		
		case when SRD.RD_PD in ('008', '020', '025', '031', '039', '041', '051', '072', '094', '106', '201', '215', '220', '223', '343', '365', '783') then '02 Salários e Ordenados'
		else
			case when SRD.RD_PD in ('029', '111', '113') then '03 Hora Extra'
			else
				case when SRD.RD_PD in ('038', '711', '719', '738', '749', '796') then '04 Benefícios'
				else
					case when SRD.RD_PD in ('739', '759', '760', '800', '817', '950', '955', '960', '961', '962') then '05 Encargos Sociais'
					else
						case when SRD.RD_PD in ('845', '846') then '06 13º Salário'
						else
							case when SRD.RD_PD in ('833', '834', '847', '848') then '07 Encargos Sociais (13º e Férias)'
							else
								case when SRD.RD_PD in ('830', '831', '832') then '08 Férias'
								else '01 N/A Custo'
								end
							end
						end
					end
				end
			end
		end as CONTA,

		case when exists (select * from SX6010 where SX6010.X6_VAR in ('UN_OSVERBA', 'UN_OSVERB1') and SX6010.X6_CONTEUD like '%' || SRV.RV_COD || '%') then 'CUSTOS' else 'OUTRAS' end as VERBA_CUSTO,
		
		trim(isnull(SRV.RV_DESC, '-')) as DESC_VERBA1,
		case SRV.RV_COD
			when '183' then 'VALOR A RECEBER'
			when '999' then 'VALOR A RECEBER'
		else SRV.RV_DESCDET end as DESC_VERBA2,

		case trim(SRV.RV_TIPOCOD)
			when '1' then 'PROVENTO'
			when '2' then 'DESCONTO'
			when '3' then 'BASE PROVENTO'
			when '4' then 'BASE DESCONTO'
			else '-'
		end as TIPO_VERBA,

		SRD.RD_VALOR as VALOR,
		SRD.RD_HORAS as HORAS,
		SRA.RA_SALARIO as SALARIO,
		SRA.RA_HRSEMAN as HORAS_SEM,
		SRJ.RJ_YHRPADR as HORAS_PADRAO,

		SRD.RD_DATARQ as DATARQ,
		SRD.RD_STATUS as STATUS_LANC,
		SRD.RD_INSS as INSS,
		SRD.RD_IR as IR,
		SRD.RD_FGTS as FGTS,

		case when lag(SRD.RD_MAT, 1, 0) over (partition by SRD.RD_FILIAL, SRD.RD_PERIODO, SRD.RD_MAT order by SRD.R_E_C_N_O_) = 0 then SRA.RA_HRSMES else 0 end as HORAS_MES,
		case when lag(SRD.RD_MAT, 1, 0) over (partition by SRD.RD_FILIAL, SRD.RD_PERIODO, SRD.RD_MAT order by SRD.R_E_C_N_O_) = 0 then 1 else 0 end as contador_func

	from SRD010 SRD (nolock)
		inner join SRV010 SRV (nolock)
			on SRV.D_E_L_E_T_ = ''
			and substring(SRD.RD_FILIAL, 1, 4) = SRV.RV_FILIAL
			and SRD.RD_PD = SRV.RV_COD
		inner join SRA010 SRA (nolock)
			on SRA.D_E_L_E_T_ = ''
			and SRA.RA_FILIAL = SRD.RD_FILIAL
			and SRA.RA_MAT = SRD.RD_MAT
		
			left join SQB010 SQB (nolock)
				on SQB.D_E_L_E_T_ = ''
				and SQB.QB_DEPTO = isnull(SRD.RD_DEPTO, SRA.RA_DEPTO)
			inner join SRJ010 SRJ (nolock)
				on SRJ.D_E_L_E_T_ = ''
				and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
				and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

		left join CTT010 CTT (nolock)
			on CTT.D_E_L_E_T_ = ''
			and CTT.CTT_CUSTO = SRD.RD_CC
		left join CTD010 CTD (nolock)
			on CTD.D_E_L_E_T_ = ''
			and CTD.CTD_ITEM = SRD.RD_ITEM
	where
			SRD.D_E_L_E_T_ = ''
		and substring(SRD.RD_PERIODO, 1, 4) > 2022
