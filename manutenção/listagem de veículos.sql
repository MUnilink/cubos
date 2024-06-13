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
	case ST9.T9_SITBEM when 'A' then 'ATIVO' when 'I' then 'INATIVO' else 'OUTROS' end as SITUACAO,
	ST9.T9_STATUS,
    trim(TQY.TQY_DESTAT) as STATUS,

	trim(isnull(SN1.N1_GRUPO, '-')) as GRUPO_ATF,
	trim(isnull(SN1.N1_CBASE, '-')) as ATIVO,
	trim(isnull(SN1.N1_DESCRIC, '-')) as DESC_ATIVO,

	trim(isnull(SN3.N3_CCUSTO, '-')) as CC_ATF,
	trim(isnull(SN3.N3_SUBCTA, '-')) as ATIVIDADE_ATF,
	(select trim(CTT010.CTT_DESC01) from CTT010 where CTT010.D_E_L_E_T_ = '' and CTT010.CTT_CUSTO = SN3.N3_CCUSTO) as DESC_CC_ATF,
	(select trim(CTD010.CTD_DESC01) from CTD010 where CTD010.D_E_L_E_T_ = '' and CTD010.CTD_ITEM = SN3.N3_SUBCTA) as DESC_AT_ATF,

	trim(isnull(ST9.T9_CCUSTO, '-')) as CC_MNT,
	trim(isnull(ST9.T9_ITEMCTA, '-')) as ATIVIDADE_MNT,
	(select trim(CTT010.CTT_DESC01) from CTT010 where CTT010.D_E_L_E_T_ = '' and CTT010.CTT_CUSTO = ST9.T9_CCUSTO) as DESC_CC_MNT,
	(select trim(CTD010.CTD_DESC01) from CTD010 where CTD010.D_E_L_E_T_ = '' and CTD010.CTD_ITEM = ST9.T9_ITEMCTA) as DESC_AT_MNT,

	(select max(convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC), 113)) from TPN010 (nolock) where TPN010.D_E_L_E_T_ = '' and TPN010.TPN_CODBEM = ST9.T9_CODBEM) as ULT_TRANSFERENCIA,

	trim(TPN.TPN_CCUSTO) as CC,
	substring(TPN.TPN_DTINIC, 1, 6) as PERIODO_MOV,
	convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113) as DT_MOV,
	eomonth(cast(TPN.TPN_DTINIC as date)) as DTMOV_FIMMES,
	dateadd(day, 1, eomonth(dateadd(month, -1, TPN.TPN_DTINIC))) as DTMOV_INIMES

from TPN010 TPN (nolock)
	left join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = TPN.TPN_CODBEM
		and ST9.T9_CATBEM != 3

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
		
		left join TQY010 TQY (nolock)
			on TQY.D_E_L_E_T_ = ''
			and TQY.TQY_STATUS = ST9.T9_STATUS
where
		TPN.D_E_L_E_T_ = ''
