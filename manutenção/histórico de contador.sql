select
	trim(ST9.T9_CODBEM) as EQUIPAMENTO,
	trim(ST9.T9_NOME) as NOME,
	trim(TQR.TQR_DESMOD) as MODELO,
	trim(ST9.T9_PLACA) as PLACA,
	trim(ST9.T9_CODFAMI) as FAMILIA,
	trim(ST7.T7_NOME) as FABRICANTE,
    trim(STP.TP_CCUSTO) as CC,
    trim(ST9.T9_ITEMCTA) as ITEM,
	trim(ST9.T9_TEMCONT) as TIPO_CONT,
	ST9.T9_STATUS as STATUS,
	case ST9.T9_PROPRIE when 1 then 'SIM' when '2' then 'NAO' else 'OUTROS' end as PROPRIO,
	case ST9.T9_SITBEM when 'A' then 'ATIVO' when 'I' then 'INATIVO' else 'OUTROS' end as SITUACAO,
	cast(ST9.T9_DTCOMPR as date) as DTCOMPR,
	STP.TP_POSCONT as CONTADOR,
	STP.TP_ACUMCON as CONT_ACUM,
	STP.TP_TIPOLAN as TIPO,
	cast(STP.TP_DTORIGI as date) as DATA_ORI,
	convert(datetime, case isdate(concat(STP.TP_DTLEITU, ' ', STP.TP_HORA)) when 1 then concat(STP.TP_DTLEITU, ' ', STP.TP_HORA) else concat(STP.TP_DTLEITU, ' ', '08:00') end, 113) as DT_LEITURA,
	left(STP.TP_DTLEITU, 6) as PERIODO,

	first_value(cast(nullif(STP.TP_DTORIGI, '') as date)) over(partition by STP.TP_CODBEM order by STP.TP_DTLEITU, STP.TP_HORA) as MIN_DATA_ORI,
	first_value(cast(nullif(STP.TP_DTLEITU, '') as date)) over(partition by STP.TP_CODBEM order by STP.TP_DTLEITU, STP.TP_HORA) as MIN_DATA_LEI,
    first_value(STP.TP_TIPOLAN) over(partition by STP.TP_CODBEM order by STP.TP_DTLEITU, STP.TP_HORA) as MIN_TIPO,
	first_value(STP.TP_HORA) over(partition by STP.TP_CODBEM order by STP.TP_DTLEITU, STP.TP_HORA) as MIN_HORA,
	first_value(STP.TP_POSCONT) over(partition by STP.TP_CODBEM order by STP.TP_DTLEITU, STP.TP_HORA) as MIN_CONT,
	first_value(STP.TP_ACUMCON) over(partition by STP.TP_CODBEM order by STP.TP_DTLEITU, STP.TP_HORA) as MIN_ACUM,
	
	first_value(cast(nullif(STP.TP_DTORIGI, '') as date)) over(partition by STP.TP_CODBEM order by STP.TP_DTLEITU desc, STP.TP_HORA desc) as MAX_DATA_ORI,
	first_value(cast(nullif(STP.TP_DTLEITU, '') as date)) over(partition by STP.TP_CODBEM order by STP.TP_DTLEITU desc, STP.TP_HORA desc) as MAX_DATA_LEI,
    first_value(STP.TP_TIPOLAN) over(partition by STP.TP_CODBEM order by STP.TP_DTLEITU desc, STP.TP_HORA desc) as MAX_TIPO,
	first_value(STP.TP_HORA) over(partition by STP.TP_CODBEM order by STP.TP_DTLEITU desc, STP.TP_HORA desc) as MAX_HORA,
	first_value(STP.TP_POSCONT) over(partition by STP.TP_CODBEM order by STP.TP_DTLEITU desc, STP.TP_HORA desc) as MAX_CONT,
	first_value(STP.TP_ACUMCON) over(partition by STP.TP_CODBEM order by STP.TP_DTLEITU desc, STP.TP_HORA desc) as MAX_ACUM

from STP010 STP (nolock)
	inner join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = STP.TP_CODBEM
		and ST9.T9_CATBEM != 3

		inner join TQR010 TQR (nolock)
			on TQR.D_E_L_E_T_ = ''
			and TQR.TQR_TIPMOD = ST9.T9_TIPMOD
			
			inner join ST7010 ST7 (nolock)
				on ST7.D_E_L_E_T_ = ''
				and ST7.T7_FABRICA = TQR.TQR_FABRIC
where
		STP.D_E_L_E_T_ = ''
