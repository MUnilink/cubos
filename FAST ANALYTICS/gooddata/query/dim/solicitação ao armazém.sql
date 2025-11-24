select distinct
    concat(trim(SCP.CP_FILIAL), trim(SCP.CP_NUM)) as ID_SOLICITAARM,
    trim(SCP.CP_NUM) as NUM_SA,
    trim(upper(SCP.CP_SOLICIT)) as SOLICITANTE_SA,

	case
		when trim(SC1.C1_RESIDUO) = 'S' then 'SC ELIMINADA'
		when trim(SC7.C7_RESIDUO) = 'S' then 'PC ELIMINADO'
		when cast(SC1.C1_QUJE as numeric(15, 2)) = 0.00 then 'SC PENDENTE'
		when cast(SC1.C1_QUJE as numeric(15, 2)) != 0.00 and SC1.C1_QUJE < SC1.C1_QUANT then 'SC PARCIAL'
		when SC1.C1_QUJE >= SC1.C1_QUANT and cast(SC7.C7_QUJE as numeric(15, 2)) = 0.00 then 'SC ATENDIDA'
		when cast(SC1.C1_QUJE as numeric(15, 2)) != 0.00 and SC1.C1_QUJE >= SC1.C1_QUANT and cast(SC7.C7_QUJE as numeric(15, 2)) != 0.00 and SC7.C7_QUJE < SC7.C7_QUANT then 'RECEBIMENTO PARCIAL'
		when cast(SC1.C1_QUJE as numeric(15, 2)) != 0.00 and SC1.C1_QUJE >= SC1.C1_QUANT and cast(SC7.C7_QUJE as numeric(15, 2)) != 0.00 and SC7.C7_QUJE >= SC7.C7_QUANT then 'RECEBIMENTO TOTAL'
	else 'OUTROS' end as STATUS_COMPRA
from SCP010 SCP
    left join SC1010 SC1
        on SC1.D_E_L_E_T_ = ' '
        and SC1.C1_FILIAL = SCP.CP_FILIAL
        and SC1.C1_NUM = SCP.CP_NUMSC
        and SC1.C1_ITEM = SCP.CP_ITSC

        left join SC7010 SC7
            on SC7.D_E_L_E_T_ = ' '
            and SC7.C7_FILIAL = SC1.C1_FILIAL
            and SC7.C7_NUMSC = SC1.C1_NUM
            and SC7.C7_ITEMSC = SC1.C1_ITEM
where SCP.D_E_L_E_T_ = ''

union select null, null, null, null
