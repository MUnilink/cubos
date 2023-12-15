select
    concat(trim(SC1.C1_FILIAL), trim(SC1.C1_NUM), trim(SC1.C1_ITEM)) as ID_SOLICITACAO,
    trim(SC1.C1_NUM) as NUM_SC,
	trim(SC1.C1_ITEM) as ITEM_SC,
    trim(replace(SC1.C1_OBS, '/', ' ')) as OBS_SC,
    trim(upper(SC1.C1_SOLICIT)) as SOLICITANTE_SC,
    trim(SC1.C1_RESIDUO) as RESIDUO_SC

from SC1010 SC1
where SC1.D_E_L_E_T_ = ''
