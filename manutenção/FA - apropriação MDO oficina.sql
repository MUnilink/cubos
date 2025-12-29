select distinct
    trim(ST1.T1_FILIAL) as FILIAL,
    trim(ST1.T1_CODFUNC) as MATRICULA,
    trim(ST1.T1_CCUSTO) as CC_FUNC,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
    ST1.T1_DTFIMDI as FIM_VINC,
    concat(SH7.H7_CODIGO, ' - ', SH7.H7_DESCRI) as TURNO_FUNC,
    concat(trim(SR8.R8_TIPOAFA), ' - ', (select upper(translate(lower(trim(RCM010.RCM_DESCRI)), 'áéíóúãõç', 'aeiouaoc')) from RCM010 where RCM010.RCM_TIPO = SR8.R8_TIPOAFA)) as TIPO_AFASTA,
    cast(SR8.R8_DURACAO as numeric(15, 2)) as DURACAO_AFASTA,
    cast(SR8.SR8_INI as date) as DATA_AFASTA,

    coalesce
    (
        SPF.CARGA_HPRO,
        (
            select avg(SR6010.R6_HRNORMA)
            from SPF010
                left join SR6010
                    on SR6010.D_E_L_E_T_ = ''
                    and SR6010.R6_TURNO = SPF010.PF_TURNOPA
            where
                    SPF010.D_E_L_E_T_ = ''
                and (left(SPF010.PF_DATA, 6) != left(SPF.DATA_TUR, 6) or SPF.DATA_TUR is null)
                and SPF010.PF_FILIAL = ST1.T1_FILIAL
                and SPF010.PF_MAT = ST1.T1_CODFUNC
        ),
        0.0
    ) as HORAS_PRO,

    /* RM */
    SR8.*,
    cast(SPF.DATA_TUR as date) as DATA_TURNO,
    STL.STL_PERIODO,
    SPF.qtd_SPF as qtd

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
            STL010.TL_DTINICI,
            eomonth(STL010.TL_DTINICI) as STL_DATA,
            concat(left(STL010.TL_DTINICI, 6), '01') as STL_PERIODO
        from STL010 (nolock)
        where
                STL010.D_E_L_E_T_ = ''
            and STL010.TL_TIPOREG = 'M'
            and STL010.TL_SEQRELA != '0'
    ) STL
        on STL.TL_FILIAL = ST1.T1_FILIAL
        and STL.TL_CODIGO = ST1.T1_CODFUNC
        
        full join
        (
            select
                SR8010.R8_FILIAL,
                SR8010.R8_MAT,
                SR8010.R8_TIPOAFA,
                SR8010.R8_DURACAO,
                concat(left(SR8010.R8_DATA, 6), '01') as SR8_PERIODO,
                convert(date, SR8010.R8_DATA, 103) as SR8_INI,
                convert(date, dateadd(day, SR8010.R8_DURACAO, SR8010.R8_DATA), 103) as SR8_FIM
            from SR8010 (nolock)
            where SR8010.D_E_L_E_T_ = ''
        ) SR8
            on SR8.R8_FILIAL = STL.TL_FILIAL
            and SR8.R8_MAT = STL.TL_CODIGO
            and SR8.SR8_INI < STL.TL_DTINICI
            and SR8.SR8_FIM > STL.TL_DTINICI

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
            on SPF.FILIAL = SRA.RA_FILIAL
            and SPF.MATRICULA = SRA.RA_MAT
where
		ST1.D_E_L_E_T_ = ''
    and (SR8.SR8_INI >= '20250601' or SR8.SR8_INI is null)
    and (STL.STL_PERIODO >= '20250601' or STL.STL_PERIODO is null)
