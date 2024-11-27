select
	ST9.T9_CODBEM as EQUIPAMENTO,
    ST9.T9_CODBEM as CC,
    ST9.T9_ITEMCTA as ITEM,
	ST9.T9_CODFAMI as FAMILIA,
	STP.TP_POSCONT as CONTADOR,
	STP.TP_ACUMCON as CONT_ACUM,
	STP.TP_TIPOLAN as TIPO,
	cast(STP.TP_DTORIGI as date) as DATA_ORI,
	cast(STP.TP_DTLEITU as date) as DATA_LEI,
	STP.TP_HORA as HORA,
	first_value(STP.TP_POSCONT) over(partition by STP.TP_CODBEM order by STP.TP_DTLEITU, STP.TP_HORA) as MIN_CONT,
	first_value(STP.TP_ACUMCON) over(partition by STP.TP_CODBEM order by STP.TP_DTLEITU, STP.TP_HORA) as MIN_ACUM
from STP010 STP (nolock)
	inner join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = STP.TP_CODBEM
where
		ST9.D_E_L_E_T_ = ''
	and ST9.T9_CODBEM =:CODBEM
