select top 1 first_value(concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))) over (partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
        ,*
from DTW010
where DTW010.D_E_L_E_T_ = '' and DTW010.DTW_HORREA != '' and DTW010.DTW_DATREA != '' and DTW010.DTW_ATIVID = 57 and DTW_VIAGEM = 11332
