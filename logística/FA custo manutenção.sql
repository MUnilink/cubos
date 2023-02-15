select
    STJ.TJ_CODBEM,
    STJ.TJ_ORDEM,
    STL.TL_DTINICI,
    sum(STL.TL_QUANTID) as TL_QUANTID,

    trim(isnull(STL.TL_CODIGO, '-')) as INSUMO,

    case STL.TL_TIPOREG
        when 'M' then 'MÃO-DE-OBRA'
        when 'E' then 'MÃO-DE-OBRA'
        when 'P' then 'PEÇAS'
        when 'T' then 'TERCEIROS'
        else 'OUTROS'
    end as TL_TIPOREG,

    case STL.TL_TIPOREG
        when 'M' then trim(ST1.T1_NOME)
        when 'E' then trim(ST0.T0_NOME)
        when 'P' then trim(SB1.B1_DESC)
        when 'T' then trim(SA2.A2_NOME)
        else 'OUTROS'
    end as DESC_INSUMO,

    substring(STL.TL_DTINICI, 1, 6) as PERIODO_MNT,

    case when STJ.TJ_SERVICO = 'PNEMOV' then 'PNEU' else 'MANUTENÇÃO' end as TIPO_CUSTO,

    case when trim(STL.TL_CODIGO) in ('11380003', '11380004', '11380005') and STL.TL_LOCAL = '80' then sum(ADESIVO_CUSTO.B9_CM * STL.TL_QUANTID)
    else
        case when trim(STL.TL_CODIGO) like '1130%' then sum(PNEU_CUSTO.B9_CM * STL.TL_QUANTID)
        else
            sum(STL.TL_CUSTO)
        end
    end as TL_CUSTO

from STJ010 STJ (nolock)
    inner join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and ST9.T9_CODBEM = STJ.TJ_CODBEM

    inner join STL010 STL (nolock)
        on STL.D_E_L_E_T_ = ''
        and STL.TL_ORDEM = STJ.TJ_ORDEM
        and STL.TL_PLANO = STJ.TJ_PLANO
        and STL.TL_FILIAL = STJ.TJ_FILIAL

        left join SA2010 SA2 (nolock)
            on SA2.D_E_L_E_T_ = ''
            and SA2.A2_COD = STL.TL_FORNEC
            and SA2.A2_LOJA = STL.TL_LOJA
        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = STL.TL_CODIGO
        left join
        (
            select
                SB9010.B9_COD,
                min(SB9010.B9_VINI1/SB9010.B9_QINI) as B9_CM,
                min(SB9010.B9_DATA) as B9_DATA
            from SB9010 (nolock)
            where
                    SB9010.D_E_L_E_T_ = ''
                and SB9010.B9_LOCAL = '01'
                and SB9010.B9_COD in ('11380003', '11380004', '11380005')
                and SB9010.B9_QINI != 0
            group by
                SB9010.B9_COD
        ) ADESIVO_CUSTO
            on ADESIVO_CUSTO.B9_COD = STL.TL_CODIGO
        left join
        (
            select
                SB9010.B9_COD,
                min(SB9010.B9_VINI1/SB9010.B9_QINI) as B9_CM,
                min(SB9010.B9_DATA) as B9_DATA
            from SB9010 (nolock)
            where
                    SB9010.D_E_L_E_T_ = ''
                and SB9010.B9_LOCAL = '20'
                and SB9010.B9_COD like '1130%'
                and SB9010.B9_QINI != 0
            group by
                SB9010.B9_COD
        ) PNEU_CUSTO
            on PNEU_CUSTO.B9_COD = STL.TL_CODIGO
        left join SH4010 SH4 (nolock)
            on SH4.D_E_L_E_T_ = ''
            and SH4.H4_CODIGO = STL.TL_CODIGO
        left join ST0010 ST0 (nolock)
            on ST0.D_E_L_E_T_ = ''
            and ST0.T0_ESPECIA = STL.TL_CODIGO
        left join ST1010 ST1 (nolock)
            on ST1.D_E_L_E_T_ = ''
            and ST1.T1_FILIAL = STL.TL_FILIAL
            and ST1.T1_CODFUNC = STL.TL_CODIGO
where
        STJ.D_E_L_E_T_ = ''
    and STL.TL_TIPOREG in ('P', 'T')
    and ST9.T9_CODFAMI in ('VP', 'VM')
    and STL.TL_SEQRELA > 0
    and STL.TL_DTINICI > 20211231
    and STJ.TJ_CCUSTO = 304 /* ver veículo portuário do BRANDAO */
group by
    STJ.TJ_CODBEM,
    STJ.TJ_ORDEM,
    STL.TL_DTINICI,
    STL.TL_UNIDADE,
    STL.TL_CODIGO,
    STL.TL_TIPOREG,
    STJ.TJ_SERVICO,
    ST1.T1_NOME,
    ST0.T0_NOME,
    SB1.B1_DESC,
    SA2.A2_NOME,
    STL.TL_LOCAL