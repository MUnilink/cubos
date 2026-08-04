select distinct
    trim(ST1.T1_FILIAL) as FILIAL,
    trim(ST1.T1_CODFUNC) as MATRICULA,
    trim(ST1.T1_CCUSTO) as CC_FUNC,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
    ST1.T1_DTFIMDI as FIM_VINC,
    concat(SH7.H7_CODIGO, ' - ', trim(SH7.H7_DESCRI)) as TURNO_FUNC,
    (select upper(translate(lower(trim(RCM010.RCM_DESCRI)), 'áéíóúãõç', 'aeiouaoc')) from RCM010 where RCM010.RCM_TIPO = SR8.R8_TIPOAFA) as TIPO_AFASTA,
    
    cast
    (
        isnull
        (
            case
                when SR8.SR8_INI < STL.STL_INI and SR8.SR8_FIM > STL.STL_FIM then 1 + datediff(day, STL.STL_INI, STL.STL_FIM)
                when SR8.SR8_INI >= STL.STL_INI and SR8.SR8_FIM > STL.STL_FIM then 1 + datediff(day, SR8.SR8_INI, STL.STL_FIM)
                when SR8.SR8_INI < STL.STL_INI and SR8.SR8_FIM <= STL.STL_FIM then 1 + datediff(day, STL.STL_INI, SR8.SR8_FIM)
                else SR8.DIAS_AFA
            end * (case when SH7.H7_CODIGO in ('001', '015') then 7.333333 else 12.0 end), 0
        )
        as numeric(15, 2)
    ) as DURACAO_AFASTA,
    
    SR8.SR8_INI as DT_AFAINI,
    SR8.SR8_FIM as DT_AFAFIM,
    
    STL.STL_PERIODO,
    
    coalesce
    (
        nullif(SPF.CARGA_HPRO, 0),
        nullif
        (
            (
                select avg(SR6010.R6_HRNORMA)
                from SPF010 PF2
                    left join SR6010
                        on SR6010.D_E_L_E_T_ = ''
                        and SR6010.R6_TURNO = PF2.PF_TURNOPA
                where
                        PF2.D_E_L_E_T_ = ''
                    and PF2.PF_FILIAL = ST1.T1_FILIAL
                    and PF2.PF_MAT = ST1.T1_CODFUNC
                    and PF2.PF_TURNOPA = (select top 1 last_value(SPF010.PF_TURNOPA) over(partition by SPF010.PF_FILIAL, SPF010.PF_MAT order by SPF010.PF_FILIAL, SPF010.PF_MAT, SPF010.PF_DATA) from SPF010 where SPF010.D_E_L_E_T_ = '' and SPF010.PF_FILIAL = PF2.PF_FILIAL and SPF010.PF_MAT = PF2.PF_MAT and SPF010.PF_DATA < PF2.PF_DATA)
            ), 0
        ),
        (select avg(SR6010.R6_HRNORMA) from SR6010 where SR6010.D_E_L_E_T_ = '' and SR6010.R6_TURNO = SRA.RA_TNOTRAB),
        case when SH7.H7_CODIGO in ('001', '015') then 220.0 else 180.0 end,
        0.0
    ) as HORAS_PRO

from ST1010 ST1 (nolock)
    left join SH7010 SH7 (nolock)
        on SH7.D_E_L_E_T_ = ''
        and SH7.H7_CODIGO = ST1.T1_TURNO

    left join ST2010 ST2 (nolock)
        on ST2.D_E_L_E_T_ = ''
        and ST2.T2_CODFUNC = ST1.T1_CODFUNC

        left join ST0010 ST0 (nolock)
            on ST0.D_E_L_E_T_ = ''
            and ST0.T0_ESPECIA = ST2.T2_ESPECIA
    
    inner join SRA010 SRA (nolock)
        on SRA.D_E_L_E_T_ = ''
        and SRA.RA_FILIAL = ST1.T1_FILIAL
        and SRA.RA_MAT = ST1.T1_CODFUNC
        
    left join
    (
        select distinct
            STL010.TL_FILIAL,
            STL010.TL_CODIGO,
            concat(left(STL010.TL_DTINICI, 6), '01') as STL_PERIODO,
            convert(date, eomonth(STL010.TL_DTINICI), 112) as STL_FIM,
            convert(date, concat(left(STL010.TL_DTINICI, 6), '01'), 112) as STL_INI,
            1 as qtd_STL
        from STL010 (nolock)
        where
                STL010.D_E_L_E_T_ = ''
            and STL010.TL_TIPOREG = 'M'
            and STL010.TL_SEQRELA != '0'
    ) STL
        on STL.STL_PERIODO between <<START_DATE>> AND <<FINAL_DATE>>
        and STL.TL_FILIAL = ST1.T1_FILIAL
        and STL.TL_CODIGO = ST1.T1_CODFUNC
        
        full join
        (
            select distinct
                SR8010.R8_FILIAL,
                SR8010.R8_MAT,
                SR8010.R8_TIPOAFA,
                cast(SR8010.R8_DURACAO as numeric(15, 2)) as DIAS_AFA,
                concat(left(SR8010.R8_DATAINI, 6), '01') as SR8_PERINI,
                convert(date, SR8010.R8_DATAINI, 112) as SR8_INI,
                convert(date, dateadd(day, SR8010.R8_DURACAO, SR8010.R8_DATAINI), 112) as SR8_FIM,
                1 as qtd_SR8
            from SR8010 (nolock)
            where SR8010.D_E_L_E_T_ = ''
        ) SR8
            on SR8.SR8_PERINI between <<START_DATE>> AND <<FINAL_DATE>>
            and SR8.R8_FILIAL = STL.TL_FILIAL
            and SR8.R8_MAT = STL.TL_CODIGO
            and (SR8.SR8_INI between STL.STL_INI and STL.STL_FIM or SR8.SR8_FIM between STL.STL_INI and STL.STL_FIM)

        left join
        (
            select
                SPF010.PF_FILIAL as FILIAL,
                SPF010.PF_MAT as MATRICULA,
                convert(date, SPF010.PF_DATA, 112) as DATA_TUR,
                convert(date, SRA010.RA_ADMISSA, 112) as DATA_ADM,
                convert(date, SRA010.RA_DEMISSA, 112) as DATA_DEM,
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
                left join SRA010 (nolock)
                    on SRA010.D_E_L_E_T_ = ''
                    and SRA010.RA_FILIAL = SPF010.PF_FILIAL
                    and SRA010.RA_MAT = SPF010.PF_MAT
                left join SR6010 SR6_ANT (nolock)
                    on SR6_ANT.D_E_L_E_T_ = ''
                    and SR6_ANT.R6_TURNO = SPF010.PF_TURNODE
                left join SR6010 SR6_PRO (nolock)
                    on SR6_PRO.D_E_L_E_T_ = ''
                    and SR6_PRO.R6_TURNO = SPF010.PF_TURNOPA
            where
                    SPF010.D_E_L_E_T_ = ''
                and SPF010.PF_TURNODE != SPF010.PF_TURNOPA
        ) SPF
            on SPF.FILIAL = STL.TL_FILIAL
            and SPF.MATRICULA = STL.TL_CODIGO
            and SPF.DATA_TUR between STL.STL_INI and STL.STL_FIM
where
		ST1.D_E_L_E_T_ = ''
