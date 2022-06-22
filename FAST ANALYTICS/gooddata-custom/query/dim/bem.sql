select
	trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,
	trim(isnull(ST9.T9_NOME, '-')) as T9_NOME,
	trim(isnull(ST9.T9_DTCOMPR, '-')) as T9_DTCOMPR,
	trim(isnull(ST9.T9_PLACA, '-')) as T9_PLACA,
	trim(isnull(ST9.T9_NFCOMPR, '-')) as T9_NFCOMPR,
	trim(isnull(ST9.T9_TIPMOD, '-')) as T9_TIPMOD,
	trim(isnull(ST9.T9_CODFAMI, '-')) as T9_CODFAMI,
	trim(isnull(STZ.TZ_BEMPAI, '-')) as TZ_BEMPAI,
	
	trim(isnull(CTT.CTT_CUSTO, '-')) as CCUSTO,

	trim(isnull(CTD.CTD_ITEM, '-')) as ATIVIDADE

from ST9010 ST9
	left join CTD010 CTD
		on CTD.D_E_L_E_T_ = ''
		and CTD.CTD_ITEM = ST9.T9_ITEMCTA
	left join CTT010 CTT
		on CTT.D_E_L_E_T_ = ''
		and CTT.CTT_CUSTO = ST9.T9_CCUSTO
	left join STZ010 STZ
		on STZ.D_E_L_E_T_ = ''
		and STZ.TZ_CODBEM = ST9.T9_CODBEM
where ST9.D_E_L_E_T_ = ''