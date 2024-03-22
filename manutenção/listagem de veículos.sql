select
	trim(isnull(ST9.T9_CODBEM, '-')) as EQUIPAMENTO,
	trim(isnull(TQR.TQR_DESMOD, '-')) as MODELO,
	trim(isnull(ST9.T9_PLACA, '-')) as PLACA,
	trim(isnull(ST9.T9_CODFAMI, '-')) as FAMILIA,
	convert(date, ST9.T9_DTCOMPR, 103) as DTCOMPR,
	trim(isnull(ST7.T7_NOME, '-')) as FABRICANTE,
	trim(isnull(ST9.T9_CHASSI, '-')) as CHASSI,
	trim(isnull(ST9.T9_ANOMOD, '-')) as ANOMODELO,
	trim(isnull(ST9.T9_ANOFAB, '-')) as ANOFABRIC,
	trim(isnull(ST9.T9_RENAVAM, '-')) as RENAVAM,
	trim(isnull(ST9.T9_SITBEM, '-')) as SITUACAO,

	trim(isnull(SN1.N1_GRUPO, '-')) as N1_GRUPO,
	trim(isnull(SN1.N1_CBASE, '-')) as N1_CBASE,
	trim(isnull(SN1.N1_DESCRIC, '-')) as N1_DESCRIC,

	trim(isnull(SN3.N3_CCUSTO, '-')) as CC_ATF,
	trim(isnull(SN3.N3_SUBCTA, '-')) as ATIVIDADE_ATF,

	trim(isnull(ST9.T9_ITEMCTA, '-')) as CC_MNT,
	trim(isnull(ST9.T9_CCUSTO, '-')) as ATIVIDADE_MNT,

	(select max(convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC), 113)) from TPN010 (nolock) where TPN010.D_E_L_E_T_ = '' and TPN010.TPN_CODBEM = ST9.T9_CODBEM) as ULT_TRANSFERENCIA

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
where
		ST9.D_E_L_E_T_ = ''
	and ST9.T9_CATBEM != 3
