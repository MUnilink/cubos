select
    TABDATA.DATA,
    TABDATA.PERIODO,
    case when TPN.DTMOV_FIMMES = TABDATA.DATA,
    case when TPN.DTMOV_INIMES = TABDATA.DATA,
    TPN.*
from (select cast(cast(YDATA.ID as varchar(max)) as date) as DATA, substring(cast(YDATA.ID as varchar(max)), 1, 6) as PERIODO from YDATA (nolock) where cast(cast(YDATA.ID as varchar(max)) as date) < getdate()) TABDATA
    left join
    (
        select
            trim(ST9010.T9_CODBEM) as EQUIPAMENTO,
            trim(ST9010.T9_CODFAMI) as FAMILIA,
            case ST9010.T9_SITBEM when 'A' then 'ATIVO' when 'I' then 'INATIVO' else 'OUTROS' end as SITUACAO,
            ST9010.T9_STATUS,
            substring(TPN010.TPN_DTINIC, 1, 6) as PERIODO_MOV,
            
            convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC), 113) as DT_MOV,
            lag(convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC), 113), 1, null) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_DTINIC, TPN010.TPN_HRINIC) as DT_ANT,
            lead(convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC), 113), 1, null) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_DTINIC, TPN010.TPN_HRINIC) as DT_PRO,
            cast(datediff(minute, lag(concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC), 1, null) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_DTINIC, TPN010.TPN_HRINIC), concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC))/(60*24.0) as numeric(15, 2)) as diff,
            
            eomonth(cast(TPN010.TPN_DTINIC as date)) as DTMOV_FIMMES,
            dateadd(day, 1, eomonth(dateadd(month, -1, TPN010.TPN_DTINIC))) as DTMOV_INIMES,

            /* ver se o fim do mês ocorre antes da próxima movimentação; se sim, fim do mês */
            case when eomonth(cast(TPN010.TPN_DTINIC as date)) < lead(convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC), 113), 1, null) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_DTINIC, TPN010.TPN_HRINIC)
                then eomonth(cast(TPN010.TPN_DTINIC as date))
                else lead(convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC), 113), 1, null) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_DTINIC, TPN010.TPN_HRINIC)
            end as DT_FIMMOV,

            /* ver se última movimentação ocorre antes do princípio do mês; se sim, princípio do mês */
            case when dateadd(day, 1, eomonth(dateadd(month, -1, TPN010.TPN_DTINIC))) > lag(convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC), 113), 1, null) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_DTINIC, TPN010.TPN_HRINIC)
                then dateadd(day, 1, eomonth(dateadd(month, -1, TPN010.TPN_DTINIC)))
                else lag(convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC), 113), 1, null) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_DTINIC, TPN010.TPN_HRINIC)
            end as DT_INIMOV,

            lag(trim(TPN010.TPN_CCUSTO), 1, null) over(partition by TPN010.TPN_CODBEM order by TPN010.TPN_DTINIC, TPN010.TPN_HRINIC) as CC_ANT,
            trim(TPN010.TPN_CCUSTO) as CC,
            TPN010.TPN_DTINIC

        from TPN010 (nolock)
            inner join ST9010 (nolock)
                on ST9010.D_E_L_E_T_ = ''
                and ST9010.T9_CODBEM = TPN010.TPN_CODBEM
                and ST9010.T9_CATBEM != 3
        where
                TPN010.D_E_L_E_T_ = ''
    ) TPN
    on TPN.TPN_DTINIC = TABDATA.DATA
