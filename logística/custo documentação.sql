select
    trim(isnull(TS1.TS1_DTEMIS, '-')) as TS1_DTEMIS,
    trim(isnull(SE2.E2_VENCREA, '-')) as TS1_DTVENC,
    TS1.TS1_QTDPAR,
    TS1.TS1_VALOR/TS1.TS1_QTDPAR as VALPARC,
    TS1.TS1_VALOR,

    trim(isnull(TS0.TS0_NOMDOC, '-')) as TS0_DOCTO,
    trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,

    lag(TPN.TPN_CCUSTO) over (partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC) as CC_ant,
    TPN.TPN_CCUSTO as CC_atu,
    case when TPN.TPN_CCUSTO != lag(TPN.TPN_CCUSTO) over (partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC) then TS1.TS1_VALOR * datediff(day, eomonth(TPN.TPN_DTINIC, -1), TPN.TPN_DTINIC) / datediff(day, eomonth(TPN.TPN_DTINIC, -1), eomonth(TPN.TPN_DTINIC)) else TS1.TS1_VALOR end /12 as CUSTO_INICC,
    case when TPN.TPN_CCUSTO != lag(TPN.TPN_CCUSTO) over (partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC) then TS1.TS1_VALOR * datediff(day, TPN.TPN_DTINIC, eomonth(TPN.TPN_DTINIC)) / datediff(day, eomonth(TPN.TPN_DTINIC, -1), eomonth(TPN.TPN_DTINIC)) else TS1.TS1_VALOR end /12 as CUSTO_FIMCC

from TS1010 TS1
    left join TS0010 TS0
        on TS0.D_E_L_E_T_ = ''
        and TS0.TS0_DOCTO = TS1.TS1_DOCTO
    left join SE2010 SE2
        on SE2.D_E_L_E_T_ = ''
        and trim(SE2.E2_PREFIXO) = 'MNT'
        and SE2.E2_NUM = TS1.TS1_NUMSE2
    left join ST9010 as ST9
        on ST9.D_E_L_E_T_ = ''
        and ST9.T9_CODBEM = TS1.TS1_CODBEM
        
        left join TPN010 TPN (nolock)
            on TPN.D_E_L_E_T_ = ''
            and TPN.TPN_CODBEM = ST9.T9_CODBEM
where
        TS1.D_E_L_E_T_ = ''
    and SE2.E2_VENCREA > 20211231
