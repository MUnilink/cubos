select
    substring(TPN.TPN_DTINIC, 1, 6) as PERIODO,
    TPN.TPN_CCUSTO as CC,
    TPN.TPN_CODBEM as BEM,
    convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113) as DATA_MOV,
    lag(convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113)) over(partition by TPN.TPN_CODBEM order by TPN.R_E_C_N_O_) as DATA_ANT,
    (datediff(minute, lag(concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.R_E_C_N_O_), concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC))/(60*24.0)) as TEMPO_MOV
    
from TPN010 TPN (nolock)
    inner join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and ST9.T9_CODBEM = TPN.TPN_CODBEM
        and ST9.T9_CATBEM != 3
where TPN.D_E_L_E_T_ = ''
