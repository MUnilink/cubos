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
	case ST9.T9_PROPRIE when 1 then 'SIM' when '2' then 'NAO' else 'OUTROS' end as PROPRIO,
	case ST9.T9_SITBEM when 'A' then 'ATIVO' when 'I' then 'INATIVO' else 'OUTROS' end as SITUACAO,
	cast(ST9.T9_DTCOMPR as date) as DTCOMPR,
	ST9.T9_STATUS,
    trim(TQY.TQY_DESTAT) as STATUS,
	substring(TPN.TPN_DTINIC, 1, 6) as PERIODO_MOV,

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
	(select trim(CTD010.CTD_DESC01) from CTD010 where CTD010.D_E_L_E_T_ = '' and CTD010.CTD_ITEM = ST9.T9_ITEMCTA) as DESC_AT_MNT,
	
	convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113) as DT_MOV,
	lag(convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC, TPN.TPN_HRINIC) as DT_ANT,
	lead(convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC, TPN.TPN_HRINIC) as DT_PRO,
	cast(datediff(minute, lag(concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC, TPN.TPN_HRINIC), concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC))/(60*24.0) as numeric(15, 2)) as diff,
	
	eomonth(cast(TPN.TPN_DTINIC as date)) as DTMOV_FIMMES,
	dateadd(day, 1, eomonth(dateadd(month, -1, TPN.TPN_DTINIC))) as DTMOV_INIMES,

	/* ver se o fim do mês ocorre antes da próxima movimentação; se sim, fim do mês */
	case
		when eomonth(cast(TPN.TPN_DTINIC as date)) < lead(convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC, TPN.TPN_HRINIC) then eomonth(cast(TPN.TPN_DTINIC as date))
		else lead(convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC, TPN.TPN_HRINIC)
	end as DT_FIMMOV,

	/* ver se última movimentação ocorre antes do princípio do mês; se sim, princípio do mês */
	case
		when dateadd(day, 1, eomonth(dateadd(month, -1, TPN.TPN_DTINIC))) > lag(convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC, TPN.TPN_HRINIC) then dateadd(day, 1, eomonth(dateadd(month, -1, TPN.TPN_DTINIC)))
		else lag(convert(datetime, concat(TPN.TPN_DTINIC, ' ', TPN.TPN_HRINIC), 113), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC, TPN.TPN_HRINIC)
	end as DT_INIMOV,

	lag(trim(TPN.TPN_CCUSTO), 1, null) over(partition by TPN.TPN_CODBEM order by TPN.TPN_DTINIC, TPN.TPN_HRINIC) as CC_ANT,
	trim(TPN.TPN_CCUSTO) as CC

from TPN010 TPN (nolock)
	inner join ST9010 ST9 (nolock)
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
