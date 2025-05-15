select
    trim(SRA.RA_FILIAL) as FILIAL,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
    trim(SRJ.RJ_DESC) as FUNCAO,
    trim(SQ3.Q3_DESCSUM) as CARGO,
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

	cast(case when SRA.RA_ADMISSA >= concat(SRD.RD_DATARQ, '01') then SRA.RA_ADMISSA else concat(SRD.RD_DATARQ, '01') end as date) as INI_FOLHA,
	cast(case when nullif(SRA.RA_DEMISSA, '') <= eomonth(concat(SRD.RD_DATARQ, '01')) then SRA.RA_DEMISSA else eomonth(concat(SRD.RD_DATARQ, '01')) end as date) as FIM_FOLHA,

    trim(SRD.RD_PD) as EVENTO,
    case SRV.RV_TIPOCOD
        when '1' then 'PROVENTO'
        when '2' then 'DESCONTO'
        when '3' then 'BASE PROVENTO'
        when '4' then 'BASE DESCONTO'
    else 'OUTROS' end as TIPO_EVENTO,
    
    concat(trim(SRD.RD_PD), ' - ', coalesce(nullif(trim(SRV.RV_DESCDET), ''), trim(SRV.RV_DESC))) as DESC_EVENTO,
    SRD.RD_DATARQ as PERIODO,
    cast(case when SRD.RD_PD = '990' then SRA.RA_HRSMES else SRD.RD_HORAS*SRA.RA_HRSMES/30.0 end as numeric(15 ,2)) * case when SRV.RV_TIPOCOD = 2 or exists(select * from RCM010 where RCM010.D_E_L_E_T_ = '' and RCM010.RCM_PD = SRD.RD_PD) then -1 else 1 end as QTD,

    1 + datediff(day, concat(SRD.RD_DATARQ, '01'), eomonth(concat(SRD.RD_DATARQ, '01'))) as DIAS_PERIODO,
	cast(concat(SRD.RD_DATARQ, '01') as date) as INI_PERIODO,
	eomonth(concat(SRD.RD_DATARQ, '01')) as FIM_PERIODO,

    SR7.DATA_MUD,
    SR7.CARGO_PRO,
    SR7.CARGO_ANT,

    case when SR7.CARGO_PRO != SR7.CARGO_ANT then 1 + datediff(day, concat(SRD.RD_DATARQ, '01'), SR7.DATA_MUD) else 0 end as DIAS_ANT,
    case
        when SR7.CARGO_PRO != SR7.CARGO_ANT then datediff(day, SR7.DATA_MUD, eomonth(concat(SRD.RD_DATARQ, '01')))
        else 1 + datediff(day, concat(SRD.RD_DATARQ, '01'), eomonth(concat(SRD.RD_DATARQ, '01')))
    end as DIAS_FOLHA

from SRD010 SRD (nolock)
    inner join SRV010 SRV (nolock)
        on SRV.D_E_L_E_T_ = ''
        and SRV.RV_COD = SRD.RD_PD
        and SRV.RV_COD = '990'

    inner join SRA010 SRA (nolock)
        on SRA.D_E_L_E_T_ = ''
        and SRA.RA_FILIAL = SRD.RD_FILIAL
        and SRA.RA_MAT = SRD.RD_MAT

        inner join SQB010 SQB (nolock)
            on SQB.D_E_L_E_T_ = ''
            and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
            and SQB.QB_DEPTO = SRA.RA_DEPTO
        inner join SRJ010 SRJ (nolock)
            on SRJ.D_E_L_E_T_ = ''
            and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
            and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

            inner join SQ3010 SQ3 (nolock)
                on SQ3.D_E_L_E_T_ = ''
                and SQ3.Q3_CARGO = SRJ.RJ_CARGO

        inner join CTT010 CTT (nolock)
            on CTT.D_E_L_E_T_ = ''
            and CTT.CTT_CUSTO = SRA.RA_CC
        inner join CTD010 CTD (nolock)
            on CTD.D_E_L_E_T_ = ''
            and CTD.CTD_ITEM = SRA.RA_ITEM

    left join
    (
		select
            lag(SR7010.R7_CARGO, 1, null) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ, SR7010.R7_DATA) as CARGO_ANT,
            SR7010.R7_CARGO as CARGO_PRO,
            SR7010.R7_FILIAL as FILIAL,
            SR7010.R7_MAT as MATR,
            cast(SR7010.R7_DATA as date) as DATA_MUD
        from SR7010
        where SR7010.D_E_L_E_T_ = ''
    ) SR7
        on SR7.FILIAL = SRD.RD_FILIAL
        and SR7.MATR = SRD.RD_MAT
        and year(SR7.DATA_MUD) = left(SRD.RD_DATARQ, 4)
        and month(SR7.DATA_MUD) = right(SRD.RD_DATARQ, 2)

    /*
        inner join SPH010 SPH (nolock)
            on SPH.D_E_L_E_T_ = ''
            and SPH.PH_FILIAL = SRD.RD_FILIAL
            and SPH.PH_MAT = SRD.RD_MAT
            
            inner join SP9010 SP9 (nolock)
                on SP9.D_E_L_E_T_ = ''
                and SP9.P9_CODIGO = SPH.PH_PD
    
    left join
    (
		select
            SRE010.RE_CCP as CC_PRO,
            SRE010.RE_ITEMP as ITEM_PRO,
            SRE010.RE_FILIALP as FILIAL,
            SRE010.RE_MATP as MATR,
            cast(SRE010.RE_DATA as date) as DATA_TRA
        from SRE010
        where SRE010.D_E_L_E_T_ = ''
    ) SRE
        on SRE.FILIAL = SRD.RD_FILIAL
        and SRE.MATR = SRD.RD_MAT
        and year(SRE.DATA_TRA) = left(SRD.RD_DATARQ, 4)
        and month(SRE.DATA_TRA) = right(SRD.RD_DATARQ, 2)*/
where SRD.D_E_L_E_T_ = ''
