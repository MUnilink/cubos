    select
        STJ.TJ_FILIAL,
        STJ.TJ_ORDEM as OS,
        trim(STJ.TJ_CODBEM) as CODBEM,
        STJ.TJ_USUAFIM as USUARIO_FIM,

        ST4.T4_NOME as SERVICO,

        convert(datetime, datetimefromparts(
                            year(STJ.TJ_DTPRINI),
                            month(STJ.TJ_DTPRINI), 
                            day(STJ.TJ_DTPRINI), 
                            substring(STJ.TJ_HOPRINI, 1, 2), 
                            substring(STJ.TJ_HOPRINI, 4, 5), 0, 0), 113) 
                as DATA_INICIO,
        convert(datetime, datetimefromparts(
                            year(STJ.TJ_DTPRFIM), 
                            month(STJ.TJ_DTPRFIM), 
                            day(STJ.TJ_DTPRFIM),
                            substring(STJ.TJ_HOPRFIM, 1, 2), 
                            substring(STJ.TJ_HOPRFIM, 4, 5), 0, 0), 113) 
                as DATA_FIM,

        datediff(
            minute,
            datetimefromparts(
                            year(STJ.TJ_DTPRINI),
                            month(STJ.TJ_DTPRINI), 
                            day(STJ.TJ_DTPRINI), 
                            substring(STJ.TJ_HOPRINI, 1, 2), 
                            substring(STJ.TJ_HOPRINI, 4, 5), 0, 0),
            datetimefromparts(
                            year(STJ.TJ_DTPRFIM), 
                            month(STJ.TJ_DTPRFIM), 
                            day(STJ.TJ_DTPRFIM),
                            substring(STJ.TJ_HOPRFIM, 1, 2), 
                            substring(STJ.TJ_HOPRFIM, 4, 5), 0, 0)
        )/60.0 as QTD_HORAS_OS,

        substring(STJ.TJ_DTORIGI, 1, 6) as PERIODO,
        STL.TL_TAREFA as COD_TAREFA,
        case STL.TL_TIPOREG
            when 'M' then 'MANUTENCAO'
            when 'T' then 'TERCEIROS'
            else 'OUTROS'
        end as TIPO_INSUMO,

        case STL.TL_TIPOREG
            when 'M' then ST1.T1_CODFUNC
            else ''
        end as COD_FUNC,

        case STL.TL_TIPOREG
            when 'M' then trim(ST1.T1_NOME)
            when 'T' then trim(SA2.A2_NOME)
            else '-'
        end as DESC_INSUMO,

        last_value(STL.TL_SEQRELA) over(partition by STJ.TJ_FILIAL, STJ.TJ_ORDEM, STL.TL_CODIGO order by STJ.TJ_FILIAL, STJ.TJ_ORDEM, STL.TL_CODIGO, STL.TL_SEQRELA) as ITEM,
        STJ.TJ_TERMINO as TERMINO

        /* coalesce(TT9.TT9_DESCRI, ST5.T5_DESCRIC, '-') as DESC_TAREFA */

    from STL010 STL (nolock)
        inner join STJ010 STJ (nolock)
            on STJ.D_E_L_E_T_ = ''
            and STJ.TJ_ORDEM = STL.TL_ORDEM
            and STJ.TJ_PLANO = STL.TL_PLANO
            and STJ.TJ_FILIAL = STL.TL_FILIAL
            and STJ.TJ_SERVICO not in ('CONSEP', 'REFORP', 'PNEMOV')
            and year(STJ.TJ_DTORIGI) > 2022
                inner join ST4010 ST4 (nolock)
                    on ST4.D_E_L_E_T_ = ''
                    and ST4.T4_SERVICO = STJ.TJ_SERVICO

        left join ST1010 ST1 (nolock)
            on ST1.D_E_L_E_T_ = ''
            and ST1.T1_CODFUNC = STL.TL_CODIGO  
        left join ST0010 ST0 (nolock)
            on ST0.D_E_L_E_T_ = ''
            and ST0.T0_ESPECIA = STL.TL_CODIGO
        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = STL.TL_CODIGO
        left join SA2010 SA2 (nolock)
            on SA2.D_E_L_E_T_ = ''
            and SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA
        /* left join TT9010 TT9 (nolock)
            on TT9.D_E_L_E_T_ = ''
            and TT9.TT9_TAREFA = STL.TL_TAREFA
        left join ST5010 ST5 (nolock)
            on ST5.D_E_L_E_T_ = ''
            and ST5.T5_TAREFA = STL.TL_TAREFA */
    where STL.D_E_L_E_T_ = ''
        and STL.TL_SEQRELA != 0
        and STL.TL_TIPOREG in ('M', 'T')