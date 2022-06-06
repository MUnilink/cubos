select *
from STJ010 as STJ (nolock)
	inner join TR8010 as TR8 (nolock)
		on TR8.D_E_L_E_T_ = ''
		and TR8.TR8_FILIAL = STJ.TJ_FILIAL
		and TR8.TR8_ORDEM = STJ.TJ_ORDEM
		and TR8.TR8_PLANO = STJ.TJ_PLANO

		inner join TR7010 as TR7 (nolock)
			on TR7.D_E_L_E_T_ = ''
			and TR7.TR7_FILIAL = TR8.TR8_FILIAL
			and TR7.TR7_LOTE = TR8.TR8_LOTE
where STJ.D_E_L_E_T_ = ''