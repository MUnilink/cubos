select
	trim(isnull(TS1.TS1_NUMSE2, '-')) as TS1_NUMSE2,
	trim(isnull(TS1.TS1_DTEMIS, '-')) as TS1_DTEMIS,
	trim(isnull(SE2.E2_VENCREA, '-')) as TS1_DTVENC,
	TS1.TS1_VALOR,
	TS1.TS1_QTDPAR,

	trim(isnull(TS0.TS0_DOCTO, '-')) as TS0_DOCTO,
	trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,
	trim(isnull(CTT.CTT_CUSTO, '-')) as CTT_CUSTO,
	trim(isnull(CTD.CTD_ITEM, '-')) as CTD_ITEM,

	year(SE2.E2_VENCREA) as ano_VENCTO,
	month(SE2.E2_VENCREA) as mes_VENCTO

from TS1010 TS1
	left join TS0010 TS0
		on TS0.D_E_L_E_T_ = ''
		and TS0.TS0_DOCTO = TS1.TS1_DOCTO
	left join SE2010 SE2
		on SE2.D_E_L_E_T_ = ''
		and trim(SE2.E2_PREFIXO) = 'MNT'
		and SE2.E2_NUM = TS1.TS1_NUMSE2
	left join ST9010 as ST9
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = TS1.TS1_CODBEM
	left join CTT010 as CTT
		on CTT.D_E_L_E_T_ = ''
		and CTT.CTT_CUSTO = TS1.TS1_YCC
	left join CTD010 as CTD 
		on TS0.D_E_L_E_T_ = ''
		and CTD.CTD_ITEM = TS1.TS1_YITEM
where TS1.D_E_L_E_T_ = ''