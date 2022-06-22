select
	trim(isnull(SB1.B1_COD, '-')) as B1_COD,
	trim(isnull(SB1.B1_DESC, '-')) as B1_DESC,
	
	trim(isnull(SBM.BM_GRUPO, '-')) as BM_GRUPO,
	trim(isnull(CTT.CTT_CUSTO, '-')) as CTT_CUSTO
from SB1010 as SB1
	left join SBM010 as SBM
		on SBM.D_E_L_E_T_ = ''
		and SBM.BM_GRUPO = SB1.B1_GRUPO
	left join CTT010 as CTT
		on CTT.D_E_L_E_T_ = ''
		and CTT.CTT_CUSTO = SB1.B1_CC
where SB1.D_E_L_E_T_ = ''
