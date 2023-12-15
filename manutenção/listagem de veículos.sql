select
	trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,
	trim(isnull(TQR.TQR_DESMOD, '-')) as MODELO,
	trim(isnull(ST9.T9_PLACA, '-')) as T9_PLACA,
	trim(isnull(ST9.T9_CODFAMI, '-')) as T9_CODFAMI,
	trim(isnull(ST6.T6_NOME, '-')) as T6_NOMEFAMI,
	convert(date, ST9.T9_DTCOMPR, 103) as T9_DTCOMPR,
	trim(isnull(ST7.T7_NOME, '-')) as FABRICANTE,
	trim(isnull(ST9.T9_CHASSI, '-')) as T9_CHASSI,
	trim(isnull(ST9.T9_ANOMOD, '-')) as T9_ANOMOD,
	trim(isnull(ST9.T9_ANOFAB, '-')) as T9_ANOFAB,
	trim(isnull(ST9.T9_RENAVAM, '-')) as T9_RENAVAM,
	
	trim(isnull(ST9.T9_SITMAN, '-')) as T9_SITMAN,
	trim(isnull(ST9.T9_SITBEM, '-')) as T9_SITBEM,

	trim(isnull(SN1.N1_GRUPO, '-')) as N1_GRUPO,
	trim(isnull(SN1.N1_CBASE, '-')) as N1_CBASE,
	trim(isnull(SN1.N1_DESCRIC, '-')) as N1_DESCRIC,

	trim(isnull(SN3.N3_CCUSTO, '-')) as N3_CCUSTO,
	trim(isnull(SN3.N3_SUBCTA, '-')) as N3_SUBCTA,
	trim(isnull(CC_PAT.CTT_DESC01, '-')) as CC_ATIVO,
	trim(isnull(ATIVIDADE_PAT.CTD_DESC01, '-')) as ATIVIDADE_ATIVO,

	trim(isnull(ST9.T9_ITEMCTA, '-')) as T9_ITEMCTA,
	trim(isnull(ST9.T9_CCUSTO, '-')) as T9_CCUSTO,
	trim(isnull(CC_MNT.CTT_DESC01, '-')) as CC_MNT,
	trim(isnull(ATIVIDADE_MNT.CTD_DESC01, '-')) as ATIVIDADE_MNT

from ST9010 ST9 (nolock)
	left join ST6010 as ST6 (nolock)
		on ST6.D_E_L_E_T_ = ''
		and ST6.T6_CODFAMI = ST9.T9_CODFAMI

	inner join TQR010 TQR (nolock)
		on TQR.D_E_L_E_T_ = ''
		and TQR.TQR_TIPMOD = ST9.T9_TIPMOD
		
		inner join ST7010 ST7 (nolock)
			on ST7.D_E_L_E_T_ = ''
			and ST7.T7_FABRICA = TQR.TQR_FABRIC
	
	left join SN1010 SN1 (nolock)
        on SN1.D_E_L_E_T_ = ''
        and SN1.N1_CODBEM = ST9.T9_CODBEM

		left join SN3010 SN3 (nolock)
			on SN3.D_E_L_E_T_ = ''
			and SN3.N3_CBASE = SN1.N1_CBASE
			and SN3.N3_ITEM = SN1.N1_ITEM

			left join CTT010 CC_PAT (nolock)
				on CC_PAT.D_E_L_E_T_ = ''
				and CC_PAT.CTT_CUSTO = SN3.N3_CCUSTO
			left join CTD010 ATIVIDADE_PAT (nolock)
				on ATIVIDADE_PAT.D_E_L_E_T_ = ''
				and ATIVIDADE_PAT.CTD_ITEM = SN3.N3_SUBCTA

	left join CTT010 CC_MNT (nolock)
		on CC_MNT.D_E_L_E_T_ = ''
		and CC_MNT.CTT_CUSTO = ST9.T9_CCUSTO
	left join CTD010 ATIVIDADE_MNT (nolock)
		on ATIVIDADE_MNT.D_E_L_E_T_ = ''
		and ATIVIDADE_MNT.CTD_ITEM = ST9.T9_ITEMCTA
	left join TPN010 TPN (nolock)
		on TPN.D_E_L_E_T_ = ''
		and TPN.TPN_CODBEM = ST9.T9_CODBEM
where
		ST9.D_E_L_E_T_ = ''
	and ST9.T9_CODFAMI != 'PN'
