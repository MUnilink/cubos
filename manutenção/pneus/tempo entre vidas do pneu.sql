select
	trim(ST9.T9_CODBEM) as T9_CODBEM,
    year(ST9.T9_DTCOMPR) as ANO_PNEU,
    convert(date, ST9.T9_DTCOMPR, 103) as T9_DTCOMPR,
    ST9.T9_SITBEM,
    trim(TQT.TQT_DESMED) as MEDIDA,

    TQZ.TQZ_STATUS,
    trim(TQY.TQY_DESTAT) as STATUS_ST9,
	convert(datetime, concat(TQZ.TQZ_DTSTAT, ' ', TQZ.TQZ_HRSTAT), 103) as DATA_STATUS,
	substring(TQZ.TQZ_DTSTAT, 1, 6) as PERIODO,

    case when (TQZ.TQZ_STATUS = 50 or TQZ.TQZ_STATUS = 61) and lag(TQZ.TQZ_STATUS, 1, null) over(partition by ST9.T9_CODBEM order by TQZ.R_E_C_N_O_) = 57 then convert(datetime, concat(TQZ.TQZ_DTSTAT, ' ', TQZ.TQZ_HRSTAT), 103) else null end as ENTRADA_REFORP,
    case when TQZ.TQZ_STATUS = 53 and lead(TQZ.TQZ_STATUS, 1, null) over(partition by ST9.T9_CODBEM order by TQZ.R_E_C_N_O_) = 51 then convert(datetime, concat(TQZ.TQZ_DTSTAT, ' ', TQZ.TQZ_HRSTAT), 103) else null end as SAIDA_REFORP,

    case when (TQZ.TQZ_STATUS = 50 or TQZ.TQZ_STATUS = 61)
        and lag(TQZ.TQZ_STATUS, 1, null) over(partition by ST9.T9_CODBEM order by TQZ.R_E_C_N_O_) = 57
        and lead(TQZ.TQZ_STATUS, 1, null) over(partition by ST9.T9_CODBEM order by TQZ.R_E_C_N_O_) = 53
        then convert(datetime, concat(TQZ.TQZ_DTSTAT, ' ', TQZ.TQZ_HRSTAT), 103)
        else
            case when TQZ.TQZ_STATUS = 53
                and lead(TQZ.TQZ_STATUS, 1, null) over(partition by ST9.T9_CODBEM order by TQZ.R_E_C_N_O_) = 51
                and lag(TQZ.TQZ_STATUS, 1, null) over(partition by ST9.T9_CODBEM order by TQZ.R_E_C_N_O_) = 50
                then convert(datetime, concat(TQZ.TQZ_DTSTAT, ' ', TQZ.TQZ_HRSTAT), 103)
                else
                    case when TQZ.TQZ_STATUS = 53
                        and lead(TQZ.TQZ_STATUS, 1, null) over(partition by ST9.T9_CODBEM order by TQZ.R_E_C_N_O_) = 50
                        and lag(TQZ.TQZ_STATUS, 1, null) over(partition by ST9.T9_CODBEM order by TQZ.R_E_C_N_O_) = 50
                        then lag(concat(TQZ.TQZ_DTSTAT, ' ', TQZ.TQZ_HRSTAT), 1, null) over(partition by ST9.T9_CODBEM order by TQZ.R_E_C_N_O_)
                        else
                            case when TQZ.TQZ_STATUS = 50
                                and lead(TQZ.TQZ_STATUS, 1, null) over(partition by ST9.T9_CODBEM order by TQZ.R_E_C_N_O_) = 53
                                and lag(TQZ.TQZ_STATUS, 1, null) over(partition by ST9.T9_CODBEM order by TQZ.R_E_C_N_O_) = 53
                                then lag(concat(TQZ.TQZ_DTSTAT, ' ', TQZ.TQZ_HRSTAT), 2, null) over(partition by ST9.T9_CODBEM order by TQZ.R_E_C_N_O_)
                                else null
                            end
                    end
            end
    end as DATAS_RODADO,

    case when (TQZ.TQZ_STATUS = 50 or TQZ.TQZ_STATUS = 61) and lag(TQZ.TQZ_STATUS, 1, null) over(partition by ST9.T9_CODBEM order by TQZ.R_E_C_N_O_) = 57 then null
        else
        case when TQZ.TQZ_STATUS = 53 and lead(TQZ.TQZ_STATUS, 1, null) over(partition by ST9.T9_CODBEM order by TQZ.R_E_C_N_O_) = 51 then datediff(minute, lag(concat(TQZ.TQZ_DTSTAT, ' ', TQZ.TQZ_HRSTAT), 1, null) over(partition by ST9.T9_CODBEM order by TQZ.R_E_C_N_O_), concat(TQZ.TQZ_DTSTAT, ' ', TQZ.TQZ_HRSTAT))/(60*24.0)
            else null
        end
    end as TEMPO_RODADO

from TQZ010 TQZ (nolock)
	left join TQS010 TQS (nolock)
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = TQZ.TQZ_CODBEM

		left join ST9010 ST9 (nolock)
			on ST9.D_E_L_E_T_ = ''
			and ST9.T9_CODBEM = TQS.TQS_CODBEM
			and trim(ST9.T9_CODBEM) like '[0-9]%'

    left join TQT010 as TQT (nolock)
		on TQT.D_E_L_E_T_ = ''
		and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
    inner join TQY010 TQY (nolock)
        on TQY.D_E_L_E_T_ = ''
        and TQY.TQY_STATUS = TQZ.TQZ_STATUS
where
		TQZ.D_E_L_E_T_ = ''
