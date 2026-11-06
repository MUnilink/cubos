with MEDIACOMB as
(
	select
		trim(TQN.TQN_FILIAL) as FILIAL,
		trim(TQI.TQI_TANQUE) as TANQUE,
		trim(TQF.TQF_FILIAL) as FILIAL_POSTO,
		trim(TQF.TQF_CODIGO) as COD_POSTO,
		trim(TQF.TQF_LOJA) as LOJA,
		trim(TQF.TQF_CNPJ) as CNPJ,
		trim(TQF.TQF_NREDUZ) as DESC_POSTO,
		trim(TQF.TQF_CIDADE) as CIDADE_POSTO,
		trim(TQN.TQN_CCUSTO) as CC,
		trim(TQN.TQN_YITMCT) as ATIVIDADE,
		trim(TQM.TQM_CODCOM) as COD_COMB,
		trim(TQM.TQM_NOMCOM) as COMBUSTIVEL,
		TQN.TQN_FROTA as FROTA,
		
		TQN.TQN_YTIPO as TIPO_ABA,
		case when TQN.TQN_YTIPO = 'C' then cast(TQN.TQN_VALUNI as numeric(15, 2)) else 0.0 end as VLUNI_MEDIA,
		case when TQN.TQN_YTIPO = 'C' then cast(TQN.TQN_QUANT as numeric(15, 2)) else 0.0 end as LITROS_MEDIA,
		case when TQN.TQN_YTIPO = 'C' then cast(TQN.TQN_VALTOT as numeric(15, 2)) else 0.0 end as VLTOTAL_MEDIA,
		cast(TQN.TQN_VALUNI as numeric(15, 2)) as VLUNI_ORI,
		cast(TQN.TQN_QUANT as numeric(15, 2)) as LITROS_ORI,
		cast(TQN.TQN_VALTOT as numeric(15, 2)) as VLTOTAL_ORI,
		TQN.TQN_HODOM as CONTADOR,
		left(TQN.TQN_DTABAS, 6) as PERIODO,
		case when isdate(concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS)) = 1 then concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS) end as DATA_ABA,
		lag(TQN.TQN_HODOM, 1, null) over(partition by TQN.TQN_FROTA order by TQN.TQN_FROTA, TQN.TQN_DTABAS, TQN.TQN_HRABAS) as CONTADOR_ANT,
		sum(case when TQN.TQN_YTIPO = 'C' then 1 else 0 end) over(partition by TQN.TQN_FROTA order by TQN.TQN_FROTA, TQN.TQN_DTABAS, TQN.TQN_HRABAS) as SEQ_CONT,
		case when TQN.TQN_YTIPO = 'P' then 1 else 0 end + sum(case when TQN.TQN_YTIPO = 'C' then 1 else 0 end) over(partition by TQN.TQN_FROTA order by TQN.TQN_FROTA, TQN.TQN_DTABAS, TQN.TQN_HRABAS) as SEQ_VALORES

		,TQN.TQN_DTABAS
	from TQN010 TQN
		inner join TQI010 TQI
			on TQI.D_E_L_E_T_ = ''
			and TQI.TQI_FILIAL = TQN.TQN_FILIAL
			and TQI.TQI_CODPOS = TQN.TQN_POSTO
			and TQI.TQI_LOJA = TQN.TQN_LOJA
			and TQI.TQI_TANQUE = TQN.TQN_TANQUE
		inner join TQF010 TQF
			on TQF.D_E_L_E_T_ = ''
			and TQF.TQF_FILIAL = TQN.TQN_FILIAL
			and TQF.TQF_CODIGO = TQN.TQN_POSTO
			and TQF.TQF_LOJA = TQN.TQN_LOJA
		inner join TQM010 TQM
			on TQM.D_E_L_E_T_ = ''
			and TQM.TQM_CODCOM = TQN.TQN_CODCOM
	where
			TQN.D_E_L_E_T_ = ''
		and TQN.TQN_CODCOM != '002'
)
select
    case when MEDIACOMB.TIPO_ABA = 'C' then cast(sum(MEDIACOMB.LITROS_ORI) over(partition by MEDIACOMB.FROTA, MEDIACOMB.SEQ_VALORES order by MEDIACOMB.DATA_ABA) as numeric(15, 2)) else 0.0 end as ZD3_LITROS,
	(select sum(SD1010.D1_TOTAL) from SD1010 where SD1010.D_E_L_E_T_ = '' and SD1010.D1_COD = '11100008' and SD1010.D1_TES in (42, 44) and left(SD1010.D1_DTDIGIT, 6) = MEDIACOMB.PERIODO)/
	(select sum(SD1010.D1_QUANT) from SD1010 where SD1010.D_E_L_E_T_ = '' and SD1010.D1_COD = '11100008' and SD1010.D1_TES in (42, 44) and left(SD1010.D1_DTDIGIT, 6) = MEDIACOMB.PERIODO) as VALOR_COMPRA,
	MEDIACOMB.CONTADOR as ZD3_HODOM,
	case when MEDIACOMB.TIPO_ABA = 'C' then MEDIACOMB.CONTADOR - min(MEDIACOMB.CONTADOR_ANT) over(partition by MEDIACOMB.FROTA, MEDIACOMB.SEQ_VALORES order by MEDIACOMB.DATA_ABA) else 0.0 end as ZD3_KMRD,
	0.0 as ZD3_KML,
	case when MEDIACOMB.TIPO_ABA = 'C' then cast(sum(MEDIACOMB.VLTOTAL_ORI) over(partition by MEDIACOMB.FROTA, MEDIACOMB.SEQ_VALORES order by MEDIACOMB.DATA_ABA) as numeric(15, 2)) else 0.0 end as ZD3_TOTAL,
	MEDIACOMB.DATA_ABA as DATA_ABA,
	
	MEDIACOMB.TANQUE as TQI_TANQUE,
	trim(ST9.T9_CODBEM) as T9_CODBEM,
	MEDIACOMB.COD_COMB as TQM_CODCOM,
	MEDIACOMB.CC as TQN_CCUSTO,
	MEDIACOMB.ATIVIDADE as TQN_YITMCT
from MEDIACOMB
	left join ST9010 ST9
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = MEDIACOMB.FROTA
where
		MEDIACOMB.TQN_DTABAS between <<START_DATE>> AND <<FINAL_DATE>>
