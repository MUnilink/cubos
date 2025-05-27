    select
        trim(SRA.RA_FILIAL) as FILIAL,
        concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        concat(trim(SRD.RD_PD), ' - ', coalesce(nullif(trim(SRV.RV_DESCDET), ''), trim(SRV.RV_DESC))) as VERBA,
        case when SRD.RD_PD = '990' then 'REF' when SRV.RV_YCPOR = 'S' and SRV.RV_YCTMS = 'S' then 'AMBOS' when SRV.RV_YCPOR = 'S' then 'OPP' when SRV.RV_YCTMS = 'S' then 'TMS' else 'OUTRAS' end as VERBA_CUSTO,
        case SRV.RV_TIPOCOD
            when '1' then 'PROVENTO'
            when '2' then 'DESCONTO'
            when '3' then 'BASE PROVENTO'
            when '4' then 'BASE DESCONTO'
        else 'OUTROS' end as TIPO_VERBA,

        (
            select cast(SPH.PH_QUANTC - SPH.PH_QTABONO as numeric(15, 2)) * case SP9.P9_TIPOCOD when 1 then 1 when 2 then -1 else 0 end
            from SPH010
                inner join SP9010 SP9 (nolock)
                    on SP9.D_E_L_E_T_ = ''
                    and SP9.P9_CODIGO = SPH.PH_PD
            
            where
                    SPH010.D_E_L_E_T_ = ''
                and SPH010.PH_FILIAL = SRD.RD_FILIAL
                and SPH010.PH_MAT = SRD.RD_MAT
                and SRD.RD_PD = '990'
        ) as EVENTO_FERIAS,
        (
            select cast(SPH.PH_QUANTC - SPH.PH_QTABONO as numeric(15, 2)) * case SP9.P9_TIPOCOD when 1 then 1 when 2 then -1 else 0 end
            from SPH010
                inner join SP9010 SP9 (nolock)
                    on SP9.D_E_L_E_T_ = ''
                    and SP9.P9_CODIGO = SPH.PH_PD
            
            where
                    SPH010.D_E_L_E_T_ = ''
                and SPH010.PH_FILIAL = SRD.RD_FILIAL
                and SPH010.PH_MAT = SRD.RD_MAT
                and SRD.RD_PD = '990'
        ) as EVENTO_AFASTA,
        (
            select cast(SPH.PH_QUANTC - SPH.PH_QTABONO as numeric(15, 2)) * case SP9.P9_TIPOCOD when 1 then 1 when 2 then -1 else 0 end
            from SPH010
                inner join SP9010 SP9 (nolock)
                    on SP9.D_E_L_E_T_ = ''
                    and SP9.P9_CODIGO = SPH.PH_PD
            
            where
                    SPH010.D_E_L_E_T_ = ''
                and SPH010.PH_FILIAL = SRD.RD_FILIAL
                and SPH010.PH_MAT = SRD.RD_MAT
                and SRD.RD_PD = '990'
        ) as EVENTO_PONTO,
        
        cast(SRA.RA_HRSMES as numeric(15, 2)) as HORAS_FUNC,
        cast(SRA.RA_ADMISSA as date) as ADMISSAO,
        cast(SRA.RA_DEMISSA as date) as DEMISSAO,
        SRD.RD_DATARQ as PERIODO,
        cast(case when SRA.RA_ADMISSA >= concat(SRD.RD_DATARQ, '01') then SRA.RA_ADMISSA else concat(SRD.RD_DATARQ, '01') end as date) as INI_FOLHA,
        cast(case when nullif(SRA.RA_DEMISSA, '') <= eomonth(concat(SRD.RD_DATARQ, '01')) then SRA.RA_DEMISSA else eomonth(concat(SRD.RD_DATARQ, '01')) end as date) as FIM_FOLHA,

        1 + datediff(day, concat(SRD.RD_DATARQ, '01'), eomonth(concat(SRD.RD_DATARQ, '01'))) as DIAS_PERIODO,
        cast(concat(SRD.RD_DATARQ, '01') as date) as INI_PERIODO,
        eomonth(concat(SRD.RD_DATARQ, '01')) as FIM_PERIODO,

        cast(SR7.DATA_MUD as date) as DATA_MUD,
        coalesce(nullif(SR7.CARGO_ANT, ''), (select top 1 last_value(SR7010.R7_CARGO) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ) from SR7010 where SR7010.D_E_L_E_T_ = '' and SR7010.R7_FILIAL = SRD.RD_FILIAL and SR7010.R7_MAT = SRD.RD_MAT and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01'))) as CARGO,
        
        case
            when SR7.CARGO is not null and SR7.CARGO_ANT != SR7.CARGO then datediff(day, case when SRA.RA_ADMISSA >= concat(SRD.RD_DATARQ, '01') then SRA.RA_ADMISSA else concat(SRD.RD_DATARQ, '01') end, SR7.DATA_MUD)
            else 1 + datediff(day, case when SRA.RA_ADMISSA >= concat(SRD.RD_DATARQ, '01') then SRA.RA_ADMISSA else concat(SRD.RD_DATARQ, '01') end, case when nullif(SRA.RA_DEMISSA, '') <= eomonth(concat(SRD.RD_DATARQ, '01')) then SRA.RA_DEMISSA else eomonth(concat(SRD.RD_DATARQ, '01')) end) end as DIAS_CARGO,
        
        cast(case when SRD.RD_PD = '990' then SRA.RA_HRSMES else SRD.RD_HORAS*SRA.RA_HRSMES/30.0 end as numeric(15 ,2)) * case when SRV.RV_TIPOCOD = 2 or exists(select * from RCM010 where RCM010.D_E_L_E_T_ = '' and RCM010.RCM_PD = SRD.RD_PD) then -1 else 1 end as QTD

        /*cast(SPH.PH_QUANTC - SPH.PH_QTABONO as numeric(15, 2)) * case SP9.P9_TIPOCOD when 1 then 1 when 2 then -1 else 0 end*/

    from SRD010 SRD (nolock)
        inner join SRV010 SRV (nolock)
            on SRV.D_E_L_E_T_ = ''
            and SRV.RV_COD = SRD.RD_PD
            and SRV.RV_COD = '990'

        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = SRD.RD_FILIAL
            and SRA.RA_MAT = SRD.RD_MAT

            inner join SRJ010 SRJ (nolock)
                on SRJ.D_E_L_E_T_ = ''
                and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

                inner join SQ3010 SQ3 (nolock)
                    on SQ3.D_E_L_E_T_ = ''
                    and SQ3.Q3_CARGO = SRJ.RJ_CARGO

        left join
        (
            select
                lag(SR7010.R7_CARGO, 1, null) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ, SR7010.R7_SEQ, SR7010.R7_DATA) as CARGO_ANT,
                nullif(SR7010.R7_CARGO, '') as CARGO,
                SR7010.R7_FILIAL as FILIAL,
                SR7010.R7_MAT as MATR,
                nullif(SR7010.R7_DATA, '') as DATA_MUD
            from SR7010
            where SR7010.D_E_L_E_T_ = ''
        ) SR7
            on SR7.FILIAL = SRD.RD_FILIAL
            and SR7.MATR = SRD.RD_MAT
            and left(SR7.DATA_MUD, 6) = SRD.RD_DATARQ
    where SRD.D_E_L_E_T_ = '' and SRD.RD_DATARQ > 202409
union
    select
        trim(SRA.RA_FILIAL) as FILIAL,
        concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        concat(trim(SRD.RD_PD), ' - ', coalesce(nullif(trim(SRV.RV_DESCDET), ''), trim(SRV.RV_DESC))) as VERBA,
        case when SRD.RD_PD = '990' then 'REF' when SRV.RV_YCPOR = 'S' and SRV.RV_YCTMS = 'S' then 'AMBOS' when SRV.RV_YCPOR = 'S' then 'OPP' when SRV.RV_YCTMS = 'S' then 'TMS' else 'OUTRAS' end as VERBA_CUSTO,
        case SRV.RV_TIPOCOD
            when '1' then 'PROVENTO'
            when '2' then 'DESCONTO'
            when '3' then 'BASE PROVENTO'
            when '4' then 'BASE DESCONTO'
        else 'OUTROS' end as TIPO_VERBA,

        (
            select cast(SPH.PH_QUANTC - SPH.PH_QTABONO as numeric(15, 2)) * case SP9.P9_TIPOCOD when 1 then 1 when 2 then -1 else 0 end
            from SPH010
                inner join SP9010 SP9 (nolock)
                    on SP9.D_E_L_E_T_ = ''
                    and SP9.P9_CODIGO = SPH.PH_PD
            
            where
                    SPH010.D_E_L_E_T_ = ''
                and SPH010.PH_FILIAL = SRD.RD_FILIAL
                and SPH010.PH_MAT = SRD.RD_MAT
                and SRD.RD_PD = '990'
        ) as EVENTO_FERIAS,
        (
            select cast(SPH.PH_QUANTC - SPH.PH_QTABONO as numeric(15, 2)) * case SP9.P9_TIPOCOD when 1 then 1 when 2 then -1 else 0 end
            from SPH010
                inner join SP9010 SP9 (nolock)
                    on SP9.D_E_L_E_T_ = ''
                    and SP9.P9_CODIGO = SPH.PH_PD
            
            where
                    SPH010.D_E_L_E_T_ = ''
                and SPH010.PH_FILIAL = SRD.RD_FILIAL
                and SPH010.PH_MAT = SRD.RD_MAT
                and SRD.RD_PD = '990'
        ) as EVENTO_AFASTA,
        (
            select cast(SPH.PH_QUANTC - SPH.PH_QTABONO as numeric(15, 2)) * case SP9.P9_TIPOCOD when 1 then 1 when 2 then -1 else 0 end
            from SPH010
                inner join SP9010 SP9 (nolock)
                    on SP9.D_E_L_E_T_ = ''
                    and SP9.P9_CODIGO = SPH.PH_PD
            
            where
                    SPH010.D_E_L_E_T_ = ''
                and SPH010.PH_FILIAL = SRD.RD_FILIAL
                and SPH010.PH_MAT = SRD.RD_MAT
                and SRD.RD_PD = '990'
        ) as EVENTO_PONTO,
        
        cast(SRA.RA_HRSMES as numeric(15, 2)) as HORAS_FUNC,
        cast(SRA.RA_ADMISSA as date) as ADMISSAO,
        cast(SRA.RA_DEMISSA as date) as DEMISSAO,
        SRD.RD_DATARQ as PERIODO,
        cast(case when SRA.RA_ADMISSA >= concat(SRD.RD_DATARQ, '01') then SRA.RA_ADMISSA else concat(SRD.RD_DATARQ, '01') end as date) as INI_FOLHA,
        cast(case when nullif(SRA.RA_DEMISSA, '') <= eomonth(concat(SRD.RD_DATARQ, '01')) then SRA.RA_DEMISSA else eomonth(concat(SRD.RD_DATARQ, '01')) end as date) as FIM_FOLHA,

        1 + datediff(day, concat(SRD.RD_DATARQ, '01'), eomonth(concat(SRD.RD_DATARQ, '01'))) as DIAS_PERIODO,
        cast(concat(SRD.RD_DATARQ, '01') as date) as INI_PERIODO,
        eomonth(concat(SRD.RD_DATARQ, '01')) as FIM_PERIODO,

        cast(SR7.DATA_MUD as date) as DATA_MUD,
        coalesce(nullif(SR7.CARGO, ''), (select top 1 last_value(SR7010.R7_CARGO) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ) from SR7010 where SR7010.D_E_L_E_T_ = '' and SR7010.R7_FILIAL = SRD.RD_FILIAL and SR7010.R7_MAT = SRD.RD_MAT and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01'))) as CARGO,
        
        case
            when SR7.CARGO is not null and SR7.CARGO_ANT != SR7.CARGO then datediff(day, SR7.DATA_MUD, case when nullif(SRA.RA_DEMISSA, '') <= eomonth(concat(SRD.RD_DATARQ, '01')) then SRA.RA_DEMISSA else eomonth(concat(SRD.RD_DATARQ, '01')) end) + 1
            else 1 + datediff(day, case when SRA.RA_ADMISSA >= concat(SRD.RD_DATARQ, '01') then SRA.RA_ADMISSA else concat(SRD.RD_DATARQ, '01') end, case when nullif(SRA.RA_DEMISSA, '') <= eomonth(concat(SRD.RD_DATARQ, '01')) then SRA.RA_DEMISSA else eomonth(concat(SRD.RD_DATARQ, '01')) end) end as DIAS_CARGO,
        
        cast(case when SRD.RD_PD = '990' then SRA.RA_HRSMES else SRD.RD_HORAS*SRA.RA_HRSMES/30.0 end as numeric(15 ,2)) * case when SRV.RV_TIPOCOD = 2 or exists(select * from RCM010 where RCM010.D_E_L_E_T_ = '' and RCM010.RCM_PD = SRD.RD_PD) then -1 else 1 end as QTD

        /*cast(SPH.PH_QUANTC - SPH.PH_QTABONO as numeric(15, 2)) * case SP9.P9_TIPOCOD when 1 then 1 when 2 then -1 else 0 end*/

    from SRD010 SRD (nolock)
        inner join SRV010 SRV (nolock)
            on SRV.D_E_L_E_T_ = ''
            and SRV.RV_COD = SRD.RD_PD
            and SRV.RV_COD = '990'

        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = SRD.RD_FILIAL
            and SRA.RA_MAT = SRD.RD_MAT

            inner join SRJ010 SRJ (nolock)
                on SRJ.D_E_L_E_T_ = ''
                and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

                inner join SQ3010 SQ3 (nolock)
                    on SQ3.D_E_L_E_T_ = ''
                    and SQ3.Q3_CARGO = SRJ.RJ_CARGO

        left join
        (
            select
                lag(SR7010.R7_CARGO, 1, null) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ, SR7010.R7_SEQ, SR7010.R7_DATA) as CARGO_ANT,
                nullif(SR7010.R7_CARGO, '') as CARGO,
                SR7010.R7_FILIAL as FILIAL,
                SR7010.R7_MAT as MATR,
                nullif(SR7010.R7_DATA, '') as DATA_MUD
            from SR7010
            where SR7010.D_E_L_E_T_ = ''
        ) SR7
            on SR7.FILIAL = SRD.RD_FILIAL
            and SR7.MATR = SRD.RD_MAT
            and left(SR7.DATA_MUD, 6) = SRD.RD_DATARQ
    where SRD.D_E_L_E_T_ = '' and SRD.RD_DATARQ > 202409
