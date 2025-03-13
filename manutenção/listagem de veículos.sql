select
	trim(ST9.T9_CODBEM) as EQUIPAMENTO,
	trim(ST9.T9_NOME) as NOME,
	trim(TQR.TQR_DESMOD) as MODELO,
	trim(ST9.T9_PLACA) as PLACA,
	trim(ST9.T9_CODFAMI) as FAMILIA,
	trim(ST7.T7_NOME) as FABRICANTE,
	trim(ST9.T9_CHASSI) as CHASSI,
	trim(ST9.T9_ANOMOD) as ANOMODELO,
	trim(ST9.T9_ANOFAB) as ANOFABRIC,
	trim(ST9.T9_RENAVAM) as RENAVAM,
	(select TQ0010.TQ0_EIXOS from TQ0010 where TQ0010.D_E_L_E_T_ = '' and TQ0010.TQ0_DESENH = ST9.T9_CODFAMI and TQ0010.TQ0_TIPMOD = ST9.T9_TIPMOD) as EIXOS,
	case ST9.T9_PROPRIE when 1 then 'SIM' when '2' then 'NAO' else 'OUTROS' end as PROPRIO,
	case ST9.T9_SITBEM when 'A' then 'ATIVO' when 'I' then 'INATIVO' else 'OUTROS' end as SITUACAO,
	cast(ST9.T9_DTCOMPR as date) as DTCOMPR,
	cast(ST9.T9_DTBAIXA as date) as DTBAIXA,
	(select trim(TPJ010.TPJ_DESMOT) from TPJ010 (nolock) where TPJ010.D_E_L_E_T_ = '' and TPJ010.TPJ_CODMOT = ST9.T9_MTBAIXA) as DESC_BAIXA,
	ST9.T9_STATUS,
    trim(TQY.TQY_DESTAT) as STATUS,

	trim(SN1.N1_GRUPO) as GRUPO_ATF,
	trim(SN1.N1_CBASE) as ATIVO,
	trim(SN1.N1_DESCRIC) as DESC_ATIVO,
	trim(SN3.N3_CCUSTO) as CC_ATF,
	trim(SN3.N3_SUBCTA) as ATIVIDADE_ATF,
	(select trim(CTT010.CTT_DESC01) from CTT010 where CTT010.D_E_L_E_T_ = '' and CTT010.CTT_CUSTO = SN3.N3_CCUSTO) as DESC_CC_ATF,
	(select trim(CTD010.CTD_DESC01) from CTD010 where CTD010.D_E_L_E_T_ = '' and CTD010.CTD_ITEM = SN3.N3_SUBCTA) as DESC_AT_ATF,

	trim(ST9.T9_CCUSTO) as CC_MNT,
	trim(ST9.T9_ITEMCTA) as ATIVIDADE_MNT,
	(select trim(CTT010.CTT_DESC01) from CTT010 where CTT010.D_E_L_E_T_ = '' and CTT010.CTT_CUSTO = ST9.T9_CCUSTO) as DESC_CC_MNT,
	(select trim(CTD010.CTD_DESC01) from CTD010 where CTD010.D_E_L_E_T_ = '' and CTD010.CTD_ITEM = ST9.T9_ITEMCTA) as DESC_AT_MNT

from ST9010 ST9 (nolock)
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
		ST9.D_E_L_E_T_ = ''
