select
	trim(ST9.T9_CODBEM) as PNEU,
	ST9.T9_STATUS,
	ST9.T9_STATUS as STATUS,
	trim(ST9.T9_CCUSTO) as CCUSTO,
	trim(ST9.T9_ITEMCTA) as ATIVIDADE,
	ST9.T9_ESTRUTU as APLICADO,
	ST9.T9_SITBEM as SITUACAO,
	trim(TQT.TQT_DESMED) as MEDIDA,
	ST9.T9_TEMCONT as TIPO_CONT,

	ZC6.ZC6_FILIAL,
	ZC6.ZC6_LOCALI as POSICAO,
	ZC5.ZC5_VLRCOM as VL_COMPRA,
	ZC5.ZC5_VLRMAN as VL_SERVICOS,
	ZC5.ZC5_BANDA as NUM_VIDA,
	ZC5.ZC5_KMEXPE as CONT_ESTIMA,
	ZC5.ZC5_KMRODM as CONT_RODADO,
	case when ZC6.ZC6_LOCALI is null then 0 else 1 end as QTD_POS,

	ST9.T9_VALCPA as T9_VALCPA,
	cast(ST9.T9_DTCOMPR as date) as T9_DTCOMPR,

    ZC6.ZC6_BEMPAI as ESTRUTURA,
    ZC6.ZC6_BEMPA2 as COMPONENTE,
    cast(ZC6.ZC6_DTIAPL as date) as DT_INIAPP,
    cast(ZC6.ZC6_DTFAPL as date) as DT_FIMAPP,
    cast(ZC6.ZC6_DTICUS as date) as DT_INICUSTO,
    cast(ZC6.ZC6_DTFCUS as date) as DT_FIMCUSTO,
    ZC6.ZC6_HODOMI as HODOMINI,
    ZC6.ZC6_HODOMF as HODOMFIM,
    cast(ZC6.ZC6_KMRODA as numeric(15, 2)) as RODADO_ESTR,
    cast(ZC6.ZC6_CUSTO as numeric(15, 2)) as CUSTO_PNEUS,
    ZC6.ZC6_ANOMES as PERIODO

from ZC5010 ZC5 (nolock)
	left join TQS010 TQS
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = ZC5.ZC5_PNEU
		
		left join TQT010 TQT
			on TQT.D_E_L_E_T_ = ''
			and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
		left join ST9010 ST9
			on ST9.D_E_L_E_T_ = ''
			and ST9.T9_CODBEM = TQS.TQS_CODBEM

			left join TQY010 TQY
                on TQY.D_E_L_E_T_ = ''
                and TQY.TQY_STATUS = ST9.T9_STATUS
	
    left join ZC6010 ZC6 (nolock)
        on ZC6.D_E_L_E_T_ = ''
        and ZC6.ZC6_PNEU = ZC5.ZC5_PNEU
		and ZC6.ZC6_ANOMES = ZC5.ZC5_ANOMES
where
		ZC5.D_E_L_E_T_ = ''
