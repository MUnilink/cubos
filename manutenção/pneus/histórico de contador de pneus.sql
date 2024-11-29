select
    trim(ST9.T9_CODBEM) as PNEU,
	SB1.B1_COD as PRODUTO,
	STP.TP_CCUSTO as CC,
	ST9.T9_ITEMCTA as ATIVIDADE,
    ST9.T9_LOCPAD as ARMAZEM,
	ST9.T9_SITBEM as SITUACAO,
	TQS.TQS_MEDIDA,
    trim(TQT.TQT_DESMED) as MEDIDA,
	ST9.T9_STATUS as STATUS,
    trim(TQY.TQY_DESTAT) as DESC_STATUS,
    ST9.T9_CONTACU as CONT_ACUM,
    ST9.T9_TEMCONT as TIPO_CONT,

	ST9.T9_VALCPA as T9_VALCPA,
	cast(ST9.T9_DTCOMPR as date) as DATA_COMPRA,
	ST9.T9_FORNECE,
	trim(SA2.A2_NOME) as RAZAO_SOCIAL,
    trim(SA2.A2_NREDUZ) as NOME_FANTASIA,

	ST9.T9_CCUSTO as CCUSTO,
	ST9.T9_ITEMCTA as ATIVIDADE,
	ST9.T9_ESTRUTU as APLICADO,

	TQS.TQS_KMOR,
	TQS.TQS_KMR1,
	TQS.TQS_KMR2,
	TQS.TQS_KMR3,
	TQS.TQS_KMR4,
	TQS.TQS_KMR5,
	TQS.TQS_KMR6,
	TQS.TQS_KMR7,
	TQS.TQS_KMOR + TQS.TQS_KMR1 + TQS.TQS_KMR2 + TQS.TQS_KMR3 + TQS.TQS_KMR4 + TQS.TQS_KMR5 + TQS.TQS_KMR6 + TQS.TQS_KMR7 as kmTOT,
	
    STP.TP_POSCONT as CONTADOR,
	STP.TP_ACUMCON as CONT_ACUM,
	STP.TP_TIPOLAN as TIPO,
	cast(STP.TP_DTORIGI as date) as DATA_ORI,
	cast(STP.TP_DTLEITU as date) as DATA_LEI,
	STP.TP_HORA as HORA,

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
    inner join TQS010 TQS (nolock)
        on TQS.D_E_L_E_T_ = ''
        and TQS.TQS_CODBEM = STP.TP_CODBEM
	
        inner join ST9010 ST9 (nolock)
            on ST9.D_E_L_E_T_ = ''
            and ST9.T9_CODBEM = TQS.TQS_CODBEM

            left join TQY010 TQY
                on TQY.D_E_L_E_T_ = ''
                and TQY.TQY_STATUS = ST9.T9_STATUS

        left join SA2010 SA2
			on SA2.D_E_L_E_T_ = ''
			and SA2.A2_COD + SA2.A2_LOJA = ST9.T9_FORNECE + ST9.T9_LOJA
    
    left join TQT010 TQT
        on TQT.D_E_L_E_T_ = ''
        and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
        
        left join SB1010 SB1
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_XMEDIDA = TQT.TQT_MEDIDA
where
        ST9.T9_CATBEM = 3
	and STP.D_E_L_E_T_ = ''
