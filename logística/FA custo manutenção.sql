select
    STJ.TJ_CODBEM,
    STJ.TJ_ORDEM,
    STL.TL_TIPOREG,
    STL.PERIODO_MNT,
    STL.TIPO_CUSTO,
    sum(STL.TL_QUANTID) as TL_QUANTID,
    sum(STL.TL_CUSTO) as TL_CUSTO

from STJ010 STJ (nolock)
    inner join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and ST9.T9_CODBEM = STJ.TJ_CODBEM

    inner join
    (
        select
            STL010.TL_ORDEM,
            STL010.TL_PLANO,
            STL010.TL_FILIAL,
            substring(STL010.TL_DTINICI, 1, 6) as PERIODO_MNT,
            STL010.TL_CODIGO,
            STL010.TL_QUANTID,
            STL010.TL_CUSTO,

            case STL010.TL_TIPOREG
                when 'M' then 'MÃO-DE-OBRA'
                when 'E' then 'MÃO-DE-OBRA'
                when 'P' then 'PEÇAS'
                when 'T' then 'TERCEIROS'
                else 'OUTROS'
            end as TL_TIPOREG,

            case when STL010.TL_LOCAL in ('20', '21', '22', '23', '24', '26') then 'PNEU' else 'MANUTENÇÃO' end as TIPO_CUSTO,
            case when STL010.TL_LOCAL in ('20', '21', '22', '23', '24', '26') then PNEU_CUSTO.B9_CM * STL010.TL_QUANTID else STL010.TL_CUSTO end as TL_CUSTO

        from STL010
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
            ) PNEU_CUSTO /* custo médio de pneu novo do período */
                on PNEU_CUSTO.B9_COD = STL010.TL_CODIGO
        where
                STL010.D_E_L_E_T_ = ''
            and STL010.TL_TIPOREG in ('P', 'T')
            and STL010.TL_SEQRELA > 0
            and STL010.TL_DTINICI > 20211231
    ) STL (nolock)
        on STL.TL_FILIAL = STJ.TJ_FILIAL
        and STL.TL_ORDEM = STJ.TJ_ORDEM
        and STL.TL_PLANO = STJ.TJ_PLANO
where
        STJ.D_E_L_E_T_ = ''
    and ST9.T9_CODFAMI in ('VP', 'VM')
    and STJ.TJ_CCUSTO = 304 /* ver veículo portuário do BRANDAO */
group by
    STJ.TJ_CODBEM,
    STJ.TJ_ORDEM,
    STL.TL_TIPOREG,
    STL.PERIODO_MNT,
    STL.TIPO_CUSTO
