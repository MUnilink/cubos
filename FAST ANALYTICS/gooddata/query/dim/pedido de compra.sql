select
    concat(trim(SC7.C7_FILIAL), trim(SC7.C7_NUM), trim(SC7.C7_ITEM)) as ID_PEDIDO,
	trim(SC7.C7_NUM) as NUM_PC,
	trim(SC7.C7_ITEM) as ITEM_PC,
	trim(SC7.C7_OBS) as OBS_PC,
	trim(replace(replace(replace(replace(replace(replace(string_escape(SC7.C7_OBSM, 'json'), '\n', ' '), '\r', ' '), '\"', '<<'), '\\', '\'), '\/', '/'), '\u0000', '')) as MEMO_PC,
	trim(SC7.C7_RESIDUO) as RESIDUO_PC

from SC7010 SC7
where SC7.D_E_L_E_T_ = ''
