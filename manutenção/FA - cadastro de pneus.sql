select
distinct
	ST9.T9_FILIAL as FILIAL,
	trim(ST9.T9_CODBEM) as T9_CODBEM,
	trim(ST9.T9_STATUS) as STATUS,
	trim(TQS.TQS_MEDIDA) as TQS_MEDIDA,
	ST9.T9_TIPMOD as MODELO,
	ST9.T9_DTCOMPR as DATA,
	
    trim(ST9.T9_ITEMCTA) as T9_ITEMCTA,
    trim(ST9.T9_CCUSTO) as T9_CCUSTO,

	case when exists
	(
		select *
		from ST9010
		where
				ST9010.D_E_L_E_T_ = ''
			and ST9010.T9_CODBEM = ST9.T9_CODBEM
			and ST9010.T9_CATBEM = 3
			and ST9010.T9_NFCOMPR in
			(
				select SD1010.D1_DOC
				from SD1010
				where
						SD1010.D_E_L_E_T_ = ''
					and SD1010.D1_CF = 1126
					and SD1010.D1_LOCAL = 20
			)
	) then ST9.T9_VALCPA else 0.0 end as CUSTO_COMPRA,
	
	ST9.T9_CONTACU as CONT_ACUMULADO,
	(select top 1 TQX010.TQX_KMESPO from TQX010 where TQX010.D_E_L_E_T_ = '' and TQX010.TQX_MEDIDA = TQS.TQS_MEDIDA) as km_ESPERADO,
	case when year(ST9.T9_DTCOMPR) > 2020 then 0.0 else TQS.TQS_XVLR1 + TQS.TQS_XVLR2 + TQS.TQS_XVLR3 + TQS.TQS_XVLR4 + TQS.TQS_XVLR5 end as VLR_SERV_LEGADO,
	TQS.TQS_KMOR + TQS.TQS_KMR1 + TQS.TQS_KMR2 + TQS.TQS_KMR3 + TQS.TQS_KMR4 + TQS.TQS_KMR5 + TQS.TQS_KMR6 + TQS.TQS_KMR7 as TOTAL_VIDAS

from TQS010 TQS (nolock)
	inner join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = TQS.TQS_CODBEM
	inner join TQT010 TQT (nolock)
        on TQT.D_E_L_E_T_ = ''
        and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
where
		TQS.D_E_L_E_T_ = ''
