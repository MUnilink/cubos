    select
        trim(SRD.RD_FILIAL) as FILIAL,
        concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        cast(SRA.RA_ADMISSA as date) as ADMISSAO,
        cast(SRA.RA_DEMISSA as date) as DEMISSAO,
        cast(SR7.DATA_MUD as date) as DATA_MUD,
        
        concat(SRD.RD_DATARQ, '01') as PERIODO,
        cast(concat(SRD.RD_DATARQ, '01') as date) as INI_PERIODO,
        eomonth(concat(SRD.RD_DATARQ, '01')) as FIM_PERIODO,
        trim(SRD.RD_PD) as VERBA,
        
        coalesce(nullif(SR7.CARGO_ANT, ''), nullif((select top 1 last_value(SR7010.R7_CARGO) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ) from SR7010 where SR7010.D_E_L_E_T_ = '' and SR7010.R7_TIPO = '002' and SR7010.R7_FILIAL = SRD.RD_FILIAL and SR7010.R7_MAT = SRD.RD_MAT and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')), '')) as CARGO,
        
        case
            when SR7.CARGO is not null and SR7.CARGO_ANT != SR7.CARGO then datediff(day, case when SRA.RA_ADMISSA >= concat(SRD.RD_DATARQ, '01') then SRA.RA_ADMISSA else concat(SRD.RD_DATARQ, '01') end, SR7.DATA_MUD)
            else 1 + datediff(day, case when SRA.RA_ADMISSA >= concat(SRD.RD_DATARQ, '01') then SRA.RA_ADMISSA else concat(SRD.RD_DATARQ, '01') end, case when nullif(SRA.RA_DEMISSA, '') <= eomonth(concat(SRD.RD_DATARQ, '01')) then SRA.RA_DEMISSA else eomonth(concat(SRD.RD_DATARQ, '01')) end) end as DIAS_CARGO,
        
        case when exists (select * from RCM010 where RCM010.D_E_L_E_T_ = '' and RCM010.RCM_PD = SRD.RD_PD and RCM010.RCM_TIPO = '001') then SRD.RD_HORAS * SRA.RA_HRSMES/30.0 else 0.0 end as EVENTO_FERIAS,
        case when exists (select * from RCM010 where RCM010.D_E_L_E_T_ = '' and RCM010.RCM_PD = SRD.RD_PD and RCM010.RCM_TIPO != '001') then SRD.RD_HORAS * SRA.RA_HRSMES/30.0 else 0.0 end as EVENTO_AFASTA,
        (
            select sum(cast(SPH010.PH_QUANTC - SPH010.PH_QTABONO as numeric(15, 2)) * case SP9010.P9_TIPOCOD when 1 then 1 when 2 then -1 else 0 end)
            from SPH010 (nolock)
                inner join SP9010 (nolock)
                    on SP9010.P9_CLASEV in ('02', '03', '04', '05')
                    and SP9010.P9_CODIGO = SPH010.PH_PD
                    and SP9010.D_E_L_E_T_ = ''
                inner join SRA010 (nolock)
                    on SRA010.RA_REGRA != '00'
                    and SRA010.RA_FILIAL = SPH010.PH_FILIAL
                    and SRA010.RA_MAT = SPH010.PH_MAT
                    and SRA010.D_E_L_E_T_ = ''
            where
                    SPH010.D_E_L_E_T_ = ''
                and SPH010.PH_FILIAL = SRD.RD_FILIAL
                and SPH010.PH_MAT = SRD.RD_MAT
                and left(SPH010.PH_DATA, 6) = SRD.RD_DATARQ
                and SPH010.PH_ABONO not in ('02', '04', '11', '19', '23')
                and SRD.RD_PD = '990'
        ) as EVENTOS_PONTO,
        cast(SRD.RD_HORAS as numeric(15, 2)) as HORAS,
        cast(SRD.RD_VALOR as numeric(15, 2)) as VALOR,
        case when exists (select * from SRV010 where SRV010.D_E_L_E_T_ = '' and SRV010.RV_COD = SRD.RD_PD and SRV010.RV_COD = '990') then cast(SRA.RA_HRSMES as numeric(15, 2)) else 0.0 end as HORAS_FUNC

    from SRD010 SRD (nolock)
        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = SRD.RD_FILIAL
            and SRA.RA_MAT = SRD.RD_MAT
        left join
        (
            select
                lag(SR7010.R7_CARGO, 1, null) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ, SR7010.R7_SEQ, SR7010.R7_DATA) as CARGO_ANT,
                nullif(SR7010.R7_CARGO, '') as CARGO,
                SR7010.R7_FILIAL as FILIAL,
                SR7010.R7_MAT as MATR,
                nullif(SR7010.R7_DATA, '') as DATA_MUD
            from SR7010
            where SR7010.D_E_L_E_T_ = '' and SR7010.R7_TIPO = '002'
        ) SR7
            on SR7.FILIAL = SRD.RD_FILIAL
            and SR7.MATR = SRD.RD_MAT
            and left(SR7.DATA_MUD, 6) = SRD.RD_DATARQ
    where
            SRD.D_E_L_E_T_ = ''
        and SRD.RD_DATARQ =:PERIODO
        and exists (select * from SRV010 where SRV010.D_E_L_E_T_ = '' and SRV010.RV_COD = SRD.RD_PD and (SRV010.RV_YCPOR = 'S' or SRV010.RV_YCTMS = 'S' or SRV010.RV_COD = '990'))
union
    select
        trim(SRD.RD_FILIAL) as FILIAL,
        concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        cast(SRA.RA_ADMISSA as date) as ADMISSAO,
        cast(SRA.RA_DEMISSA as date) as DEMISSAO,
        cast(SR7.DATA_MUD as date) as DATA_MUD,
        
        concat(SRD.RD_DATARQ, '01') as PERIODO,
        cast(concat(SRD.RD_DATARQ, '01') as date) as INI_PERIODO,
        eomonth(concat(SRD.RD_DATARQ, '01')) as FIM_PERIODO,
        trim(SRD.RD_PD) as VERBA,
        
        coalesce(nullif(SR7.CARGO_ANT, ''), nullif((select top 1 last_value(SR7010.R7_CARGO) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ) from SR7010 where SR7010.D_E_L_E_T_ = '' and SR7010.R7_TIPO = '002' and SR7010.R7_FILIAL = SRD.RD_FILIAL and SR7010.R7_MAT = SRD.RD_MAT and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')), '')) as CARGO,
        
        case
            when SR7.CARGO is not null and SR7.CARGO_ANT != SR7.CARGO then datediff(day, SR7.DATA_MUD, case when nullif(SRA.RA_DEMISSA, '') <= eomonth(concat(SRD.RD_DATARQ, '01')) then SRA.RA_DEMISSA else eomonth(concat(SRD.RD_DATARQ, '01')) end) + 1
            else 1 + datediff(day, case when SRA.RA_ADMISSA >= concat(SRD.RD_DATARQ, '01') then SRA.RA_ADMISSA else concat(SRD.RD_DATARQ, '01') end, case when nullif(SRA.RA_DEMISSA, '') <= eomonth(concat(SRD.RD_DATARQ, '01')) then SRA.RA_DEMISSA else eomonth(concat(SRD.RD_DATARQ, '01')) end) end as DIAS_CARGO,
        
        case when exists (select * from RCM010 where RCM010.D_E_L_E_T_ = '' and RCM010.RCM_PD = SRD.RD_PD and RCM010.RCM_TIPO = '001') then SRD.RD_HORAS * SRA.RA_HRSMES/30.0 else 0.0 end as EVENTO_FERIAS,
        case when exists (select * from RCM010 where RCM010.D_E_L_E_T_ = '' and RCM010.RCM_PD = SRD.RD_PD and RCM010.RCM_TIPO != '001') then SRD.RD_HORAS * SRA.RA_HRSMES/30.0 else 0.0 end as EVENTO_AFASTA,
        (
            select sum(cast(SPH010.PH_QUANTC - SPH010.PH_QTABONO as numeric(15, 2)) * case SP9010.P9_TIPOCOD when 1 then 1 when 2 then -1 else 0 end)
            from SPH010 (nolock)
                inner join SP9010 (nolock)
                    on SP9010.P9_CLASEV in ('02', '03', '04', '05')
                    and SP9010.P9_CODIGO = SPH010.PH_PD
                    and SP9010.D_E_L_E_T_ = ''
                inner join SRA010 (nolock)
                    on SRA010.RA_REGRA != '00'
                    and SRA010.RA_FILIAL = SPH010.PH_FILIAL
                    and SRA010.RA_MAT = SPH010.PH_MAT
                    and SRA010.D_E_L_E_T_ = ''
            where
                    SPH010.D_E_L_E_T_ = ''
                and SPH010.PH_FILIAL = SRD.RD_FILIAL
                and SPH010.PH_MAT = SRD.RD_MAT
                and left(SPH010.PH_DATA, 6) = SRD.RD_DATARQ
                and SPH010.PH_ABONO not in ('02', '04', '11', '19', '23')
                and SRD.RD_PD = '990'
        ) as EVENTOS_PONTO,
        cast(SRD.RD_HORAS as numeric(15, 2)) as HORAS,
        cast(SRD.RD_VALOR as numeric(15, 2)) as VALOR,
        case when exists (select * from SRV010 where SRV010.D_E_L_E_T_ = '' and SRV010.RV_COD = SRD.RD_PD and SRV010.RV_COD = '990') then cast(SRA.RA_HRSMES as numeric(15, 2)) else 0.0 end as HORAS_FUNC

    from SRD010 SRD (nolock)
        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = SRD.RD_FILIAL
            and SRA.RA_MAT = SRD.RD_MAT
        left join
        (
            select
                lag(SR7010.R7_CARGO, 1, null) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ, SR7010.R7_SEQ, SR7010.R7_DATA) as CARGO_ANT,
                nullif(SR7010.R7_CARGO, '') as CARGO,
                SR7010.R7_FILIAL as FILIAL,
                SR7010.R7_MAT as MATR,
                nullif(SR7010.R7_DATA, '') as DATA_MUD
            from SR7010
            where SR7010.D_E_L_E_T_ = '' and SR7010.R7_TIPO = '002'
        ) SR7
            on SR7.FILIAL = SRD.RD_FILIAL
            and SR7.MATR = SRD.RD_MAT
            and left(SR7.DATA_MUD, 6) = SRD.RD_DATARQ
    where
            SRD.D_E_L_E_T_ = ''
        and SRD.RD_DATARQ =:PERIODO
        and exists (select * from SRV010 where SRV010.D_E_L_E_T_ = '' and SRV010.RV_COD = SRD.RD_PD and (SRV010.RV_YCPOR = 'S' or SRV010.RV_YCTMS = 'S' or SRV010.RV_COD = '990'))
