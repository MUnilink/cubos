select
    substring(TPN.TPN_DTINIC, 1, 6) as PERIODO,
    trim(TPN.TPN_CCUSTO) as CC,
    lag(TPN.TPN_CCUSTO) over(partition by TPN.TPN_CODBEM order by TPN.R_E_C_N_O_) as CC_ANT,
    trim(TPN.TPN_CODBEM) as BEM,
    convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113) as DATA_MOV,
    convert(datetime, isnull(lag(concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.R_E_C_N_O_), '20201231 00:00'), 113) as DATA_ANT,
    cast(datediff(minute, isnull(lag(concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.R_E_C_N_O_), '20201231 00:00'), concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC))/(60*24.0) as numeric(15,2)) as TEMPO_ANT
    
from TPN010 TPN (nolock)
    inner join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and ST9.T9_CODBEM = TPN.TPN_CODBEM
        and ST9.T9_CATBEM != 3
where TPN.D_E_L_E_T_ = ''
