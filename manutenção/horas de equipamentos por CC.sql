select
	trim(ST9.T9_CODBEM) as EQUIPAMENTO,
	trim(ST9.T9_NOME) as NOME,
	trim(TQR.TQR_DESMOD) as MODELO,
	trim(ST9.T9_CODFAMI) as FAMILIA,
	trim(ST7.T7_NOME) as FABRICANTE,
	ST9.T9_STATUS,
    trim(TQY.TQY_DESTAT) as STATUS,

    case when ;

from ST9010 ST9 (nolock)
	inner join TQR010 TQR (nolock)
		on TQR.D_E_L_E_T_ = ''
		and TQR.TQR_TIPMOD = ST9.T9_TIPMOD
		
		inner join ST7010 ST7 (nolock)
			on ST7.D_E_L_E_T_ = ''
			and ST7.T7_FABRICA = TQR.TQR_FABRIC
	
	left join TQY010 TQY (nolock)
		on TQY.D_E_L_E_T_ = ''
		and TQY.TQY_STATUS = ST9.T9_STATUS
	left join
	(
		select distinct
			STP010.TP_CODBEM,
            STP010.TP_CCUSTO,
			STP010.TP_TIPOLAN as TIPO,
			cast(STP010.TP_DTORIGI as date) as DATA_ORI,
			cast(STP010.TP_DTLEITU as date) as DATA_LEI,
			left(STP010.TP_DTLEITU, 6) as PERIODO
		from STP010 (nolock)
		where STP.D_E_L_E_T_ = ''
	) STP
		on STP.TP_CODBEM = ST9.T9_CODBEM
where
		ST9.T9_CATBEM != 3
	and ST9.D_E_L_E_T_ = ''
