with SR8 as
(
	select
		SR8010.R8_MAT as MATRICULA,
		SR8010.R8_FILIAL as FILIAL,
		cast
		(
			case
				when SR8010.R8_TIPOAFA = '001' then SR8010.R8_DATAINI
				when SR8010.R8_DURACAO > 15 and datediff(month, SR8010.R8_DATAINI, eomonth(SR8010.R8_DATAFIM)) = 0 then SR8010.R8_DATAINI /* afastamento no mês */
				when SR8010.R8_DURACAO > 15 and floor(datediff(month, SR8010.R8_DATAINI, eomonth(SR8010.R8_DATAFIM))) = 1 and 1 + datediff(day, concat(left(SR8010.R8_DATAFIM, 6), '01'), SR8010.R8_DATAFIM) > 14 then concat(left(SR8010.R8_DATAFIM, 6), '01') /* afastamento no mês e longo no subsequente */
				when SR8010.R8_DURACAO > 15 and floor(datediff(month, SR8010.R8_DATAINI, eomonth(SR8010.R8_DATAFIM))) = 1 and 1 + datediff(day, SR8010.R8_DATAINI, eomonth(SR8010.R8_DATAINI)) > 14 then SR8010.R8_DATAINI /* afastamento longo no mês e ao subsequente */
			end as date
		) as DATA_INI,

		cast
		(
			case
				when SR8010.R8_TIPOAFA = '001' then SR8010.R8_DATAFIM
				when SR8010.R8_DURACAO > 15 and datediff(month, SR8010.R8_DATAINI, eomonth(SR8010.R8_DATAFIM)) = 0 then SR8010.R8_DATAFIM /* afastamento no mês */
				when SR8010.R8_DURACAO > 15 and floor(datediff(month, SR8010.R8_DATAINI, eomonth(SR8010.R8_DATAFIM))) = 1 and 1 + datediff(day, concat(left(SR8010.R8_DATAFIM, 6), '01'), SR8010.R8_DATAFIM) > 14 then SR8010.R8_DATAFIM /* afastamento no mês e longo no subsequente */
				when SR8010.R8_DURACAO > 15 and floor(datediff(month, SR8010.R8_DATAINI, eomonth(SR8010.R8_DATAFIM))) = 1 and 1 + datediff(day, SR8010.R8_DATAINI, eomonth(SR8010.R8_DATAINI)) > 14 then eomonth(SR8010.R8_DATAINI) /* afastamento longo no mês e ao subsequente */
			end as date
		) as DATA_FIM,

		SR8010.R8_TIPOAFA,
		case when SR8010.R8_TIPOAFA = '001' then 'F' when SR8010.R8_DURACAO > 15 then 'A' end as SITUACAO,
		cast(SR8010.R8_DATA as date) as DATA_ALTER,
		cast(SR8010.R8_DATAINI as date) as DATA_INIAFA,
		cast(SR8010.R8_DATAFIM as date) as DATA_FIMAFA,
		cast(SR8010.R8_DURACAO as numeric(15, 2)) as DURACAO,
		left(SR8010.R8_PER, 6) as PERIODO

	from SR8010 (nolock)
	where SR8010.D_E_L_E_T_ = ''
)

select
	trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
	concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
	trim(SRA.RA_NOMECMP) as NOME,
	trim(SRA.RA_MUNICIP) as MUNICIPIO,
	trim(SRA.RA_ESTADO) as UF,
	cast(SRA.RA_ADMISSA as date) as ADMISSAO,
	trim(CTT.CTT_CUSTO) as CC,
	trim(CTT.CTT_DESC01) as CCUSTO,
	trim(CTD.CTD_ITEM) as ITCT,
	trim(CTD.CTD_DESC01) as ATIVIDADE,
	trim(SQB.QB_DEPTO) as DEPTO,
	trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
	null as CBO,
	trim(SRA.RA_SEXO) as SEXO,
	trim(SRA.RA_CIC) as CPF,

	trim(SQ3.Q3_CARGO) as CARGO,
	trim(SQ3.Q3_DESCSUM) as DESC_CARGO,
	trim(SRJ.RJ_FUNCAO) as FUNCAO,
	trim(SRJ.RJ_DESC) as DESC_FUNCAO,
	concat(trim(SRA.RA_CATEFD), ' - ', substring((select max(upper(trim(RCC010.RCC_CONTEU))) from RCC010 where RCC010.D_E_L_E_T_ = '' and RCC010.RCC_CODIGO = 'S049' and left(RCC010.RCC_CONTEU, 3) = SRA.RA_CATEFD), 6, 250)) as CAT_ESOCIAL,

	trim(SRD.RD_PERIODO) as PERIODO,
	trim(SRD.RD_PD) as VERBA,
	trim(SRD.RD_SEQ) as SEQ,
	trim(SRD.RD_ROTEIR) as ROTEIRO,

	case when SRV.RV_YCPOR = 'S' and SRV.RV_YCTMS = 'S' then 'AMBOS' when SRV.RV_YCPOR = 'S' then 'OPP' when SRV.RV_YCTMS = 'S' then 'TMS' else 'OUTRAS' end as VERBA_CUSTO,
	
	trim(isnull(SRV.RV_DESC, '-')) as DESC_VERBA1,
	trim(SRV.RV_DESCDET) as DESC_VERBA2,

	case trim(SRV.RV_TIPOCOD)
		when '1' then 'PROVENTO'
		when '2' then 'DESCONTO'
		when '3' then 'BASE PROVENTO'
		when '4' then 'BASE DESCONTO'
		else '-'
	end as TIPO_VERBA,

	SRD.RD_VALOR as VALOR,
	SRD.RD_HORAS as HORAS,
	
	concat(trim(SR8.R8_TIPOAFA), ' - ', (select upper(trim(RCM010.RCM_DESCRI)) from RCM010 where RCM010.RCM_TIPO = SR8.R8_TIPOAFA)) as TIPO_AFASTA,
	SR8.*

from SRD010 SRD
	left join SR8 on eomonth(concat(SRD.RD_DATARQ, '01')) between eomonth(SR8.DATA_INI) and eomonth(SR8.DATA_INI) and SR8.MATRICULA = SRD.RD_MAT and SR8.FILIAL = SRD.RD_FILIAL
	inner join SRV010 SRV (nolock)
		on SRV.D_E_L_E_T_ = ''
		and substring(SRD.RD_FILIAL, 1, 4) = SRV.RV_FILIAL
		and SRD.RD_PD = SRV.RV_COD
			
		left join RCN010 RCN (nolock)
			on RCN.D_E_L_E_T_ = ''
			and RCN.RCN_CODIGO = SRV.RV_CODFOL
	
	inner join SRA010 SRA (nolock)
		on SRA.D_E_L_E_T_ = ''
		and SRA.RA_FILIAL = SRD.RD_FILIAL
		and SRA.RA_MAT = SRD.RD_MAT
	
		left join SQB010 SQB (nolock)
			on SQB.D_E_L_E_T_ = ''
			and SQB.QB_DEPTO = isnull(SRD.RD_DEPTO, SRA.RA_DEPTO)
		left join SRJ010 SRJ (nolock)
			on SRJ.D_E_L_E_T_ = ''
			and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
			and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

			left join SQ3010 SQ3 (nolock)
				on SQ3.D_E_L_E_T_ = ''
				and SQ3.Q3_CARGO = SRJ.RJ_CARGO

	left join CTT010 CTT (nolock)
		on CTT.D_E_L_E_T_ = ''
		and CTT.CTT_CUSTO = SRD.RD_CC
	left join CTD010 CTD (nolock)
		on CTD.D_E_L_E_T_ = ''
		and CTD.CTD_ITEM = SRD.RD_ITEM
where SRD.RD_PD = '990' and SRD.RD_DATARQ like '2026%'
