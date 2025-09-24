select
	trim(SRA.RA_FILIAL) as FILIAL,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_NOMECMP) as NOME,
	trim(SRA.RA_MUNICIP) as MUNICIPIO,
	trim(SRA.RA_ESTADO) as UF,
	cast(SRA.RA_ADMISSA as date) as ADMISSAO,
	cast(SRA.RA_DEMISSA as date) as DEMISSAO,
	SRA.RA_SITFOLH as SITUACAO,
	case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
	trim(SRD.RD_CC) as CC,
	trim(SRD.RD_ITEM) as ITCT,
	trim(SQB.QB_DEPTO) as DEPTO,
	trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
	trim(SRA.RA_SEXO) as SEXO,
	trim(SRA.RA_CIC) as CPF,
	trim(SRD.RD_PERIODO) as PERIODO,
	trim(SRD.RD_ROTEIR) as ROTEIRO,

	case when SRD.RD_PD = '990' then 'REF' when SRV.RV_YCPOR = 'S' and SRV.RV_YCTMS = 'S' then 'AMBOS' when SRV.RV_YCPOR = 'S' then 'OPP' when SRV.RV_YCTMS = 'S' then 'TMS' else 'OUTRAS' end as VERBA_CUSTO,
	case when SRV.RV_TIPOCOD = 2 then SRD.RD_VALOR*-1 else SRD.RD_VALOR end as VALOR,
	
	cast(SRD.RD_HORAS as numeric(15, 2)) as HORAS_VERBA,
	cast(SRA.RA_HRSMES as numeric(15, 2)) as HORAS_MES,
	cast(SRA.RA_HRSEMAN as numeric(15, 2)) as HORAS_SEM,
	SRA.RA_SALARIO as SALARIO,
	SRD.RD_DATARQ as DATARQ,
	SRD.RD_STATUS as STATUS_LANC,
	trim(SRD.RD_PD) as VERBA,
	trim(SRD.RD_SEQ) as SEQ_FOLHA,
	isnull(nullif(trim(SRV.RV_DESC), ''), SRV.RV_DESCDET) as DESC_VERBA,

	case trim(SRV.RV_TIPOCOD)
		when '1' then 'PROVENTO'
		when '2' then 'DESCONTO'
		when '3' then 'BASE PROVENTO'
		when '4' then 'BASE DESCONTO'
		else '-'
	end as TIPO_VERBA,
    SR7.*

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
		left join SRJ010 SRJ (nolock)
			on SRJ.D_E_L_E_T_ = ''
			and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
			and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
			
			left join SQ3010 SQ3 (nolock)
				on SQ3.D_E_L_E_T_ = ''
				and SQ3.Q3_CARGO = SRJ.RJ_CARGO
	left join
	(
        select
            SR7010.R7_FILIAL as FILIAL,
            SR7010.R7_MAT as MATRICULA,
            SR7010.R7_DATA as DATA_MUD,
            SR7010.R7_SEQ as SEQ_CARGO,
            SR7010.R7_CARGO as CARGO,

            datediff
            (
                day,
                case when SRA010.RA_ADMISSA >= concat(left(SR7010.R7_DATA, 6), '01') then SRA010.RA_ADMISSA else concat(left(SR7010.R7_DATA, 6), '01') end,
                case when SR7010.R7_DATA >= concat(left(SR7010.R7_DATA, 6), '01') then SR7010.R7_DATA /* se a última mudança ocorreu dentro do período da folha, data da mudança; senão, e se demitido antes do fim do período, demissão, senão, fim do período*/
                else case when nullif(SRA010.RA_DEMISSA, '') <= eomonth(concat(left(SR7010.R7_DATA, 6), '01')) then SRA010.RA_DEMISSA else eomonth(concat(left(SR7010.R7_DATA, 6), '01')) end end
            ) as DIAS_ANT,
            
            datediff
            (
                day,
                case when SR7010.R7_DATA >= concat(left(SR7010.R7_DATA, 6), '01') then SR7010.R7_DATA
                    else case when SRA010.RA_ADMISSA >= concat(left(SR7010.R7_DATA, 6), '01') then SRA010.RA_ADMISSA else concat(left(SR7010.R7_DATA, 6), '01') end
                end, /* se a última mudança ocorreu dentro do período da folha, data da mudança; senão, se admitido após o início do período, admissão, senão, início do período */
                case when left(SRA010.RA_DEMISSA, 6) = left(SR7010.R7_DATA, 6) then SRA010.RA_DEMISSA else dateadd(day, 1, eomonth(concat(left(SR7010.R7_DATA, 6), '01'))) end
            ) as DIAS_PRO
        from SR7010
            inner join SRA010 (nolock)
                on SRA010.D_E_L_E_T_ = ''
                and SRA010.RA_FILIAL = SR7010.R7_FILIAL
                and SRA010.RA_MAT = SR7010.R7_MAT
        where SR7010.D_E_L_E_T_ = ''
    ) SR7
        on left(SR7.DATA_MUD, 6) = SRD.RD_DATARQ
        and SR7.FILIAL = SRD.RD_FILIAL
        and SR7.MATRICULA = SRD.RD_MAT

	left join
	(
        select
            SPF010.PF_FILIAL as FILIAL,
            SPF010.PF_MAT as MATRICULA,
            SPF010.PF_DATA as DATA_TRA,
            SPF010.PF_SEQ as SEQ_CARGO,
            SPF010.PF_CARGO as CARGO,

            datediff
            (
                day,
                case when SRA010.RA_ADMISSA >= concat(left(SPF010.PF_DATA, 6), '01') then SRA010.RA_ADMISSA else concat(left(SPF010.PF_DATA, 6), '01') end,
                case when SPF010.PF_DATA >= concat(left(SPF010.PF_DATA, 6), '01') then SPF010.PF_DATA /* se a última mudança ocorreu dentro do período da folha, data da mudança; senão, e se demitido antes do fim do período, demissão, senão, fim do período*/
                else case when nullif(SRA010.RA_DEMISSA, '') <= eomonth(concat(left(SPF010.PF_DATA, 6), '01')) then SRA010.RA_DEMISSA else eomonth(concat(left(SPF010.PF_DATA, 6), '01')) end end
            ) as DIAS_ANT,
            
            datediff
            (
                day,
                case when SPF010.PF_DATA >= concat(left(SPF010.PF_DATA, 6), '01') then SPF010.PF_DATA
                    else case when SRA010.RA_ADMISSA >= concat(left(SPF010.PF_DATA, 6), '01') then SRA010.RA_ADMISSA else concat(left(SPF010.PF_DATA, 6), '01') end
                end, /* se a última mudança ocorreu dentro do período da folha, data da mudança; senão, se admitido após o início do período, admissão, senão, início do período */
                case when left(SRA010.RA_DEMISSA, 6) = left(SPF010.PF_DATA, 6) then SRA010.RA_DEMISSA else dateadd(day, 1, eomonth(concat(left(SPF010.PF_DATA, 6), '01'))) end
            ) as DIAS_PRO
        from SPF010
            inner join SRA010 (nolock)
                on SRA010.D_E_L_E_T_ = ''
                and SRA010.RA_FILIAL = SPF010.PF_FILIAL
                and SRA010.RA_MAT = SPF010.PF_MAT
        where SPF010.D_E_L_E_T_ = ''
    ) SPF
        on left(SPF.DATA_TRA, 6) = SRD.RD_DATARQ
        and SPF.FILIAL = SRD.RD_FILIAL
        and SPF.MATRICULA = SRD.RD_MAT
where
		SRD.RD_PERIODO =:PERIODO
	and SRD.D_E_L_E_T_ = ''
