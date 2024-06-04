select
    ZC6.ZC6_PNEU as PNEU,
	ST9.T9_STATUS,
	ST9.T9_CONTACU,
	trim(TQT.TQT_DESMED) as MEDIDA,

	ZC5.ZC5_VLRCOM as VLR_COMPRA,
	ZC5.ZC5_VLRMAN as VLR_SERVIC,
	ZC5.ZC5_BANDA as VIDAS,
	ZC5.ZC5_KMEXPE as km_PREVISTO,
	ZC5.ZC5_KMRODM as km_MES,

    ZC6.ZC6_BEMPAI as ESTRUTURA1,
    ZC6.ZC6_TEMCON as TEMCONT,
    ZC6.ZC6_LOCALI as POSICAO,
    cast(ZC6.ZC6_DTIAPL as date) as DATAMOV,
    cast(ZC6.ZC6_DTFAPL as date) as DATASAI,
    cast(ZC6.ZC6_DTICUS as date) as DATA_INI,
    cast(ZC6.ZC6_DTFCUS as date) as DATA_FIM,
    ZC6.ZC6_HODOMI as km_INI,
    ZC6.ZC6_HODOMF as km_FIM,
    ZC6.ZC6_KMRODA as km,
    ZC6.ZC6_ANOMES as PERIODO,
    ZC6.ZC6_BEMPA2 as ESTRUTURA2,

	cast(ST9.T9_DTCOMPR as date) as T9_DTCOMPR,
	ST9.T9_SITBEM

from ZC6010 ZC6 (nolock)
    inner join TQS010 TQS
        on TQS.D_E_L_E_T_ = ''
        and TQS.TQS_CODBEM = ZC6.ZC6_PNEU
        
        left join TQT010 TQT
            on TQT.D_E_L_E_T_ = ''
            and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
        left join ST9010 ST9
            on ST9.D_E_L_E_T_ = ''
            and ST9.T9_CODBEM = TQS.TQS_CODBEM
        inner join ZC5010 ZC5 (nolock)
            on ZC5.D_E_L_E_T_ = ''
            and ZC5.ZC5_PNEU = TQS.TQS_CODBEM
where
		ZC6.D_E_L_E_T_ = ''
