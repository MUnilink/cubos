select
	trim(TR4.TR4_CODBEM) as TR4_CODBEM,
    TR4.TR4_NUMANA,
    TQS.TQS_MEDIDA,
    TR4.TR4_MOTIVO,
    TR4.TR4_SULCO,
    TR4.TR4_FILIAL,
    trim(TR4.TR4_PAREC) as TR4_PAREC,
    ST9.T9_STATUS,
    ST9.T9_ITEMCTA,
    ST9.T9_CCUSTO,
    
    case TR4.TR4_DESTIN
        when 1 then 'RESSOLAR'
        when 2 then 'CONSERTAR'
        when 3 then 'ESTOQUE USADO'
        when 4 then 'ESTOQUE REFORMADO'
        when 5 then 'ANALISE DO FORNECEDOR'
        when 6 then 'SUCATA'
        when 7 then 'ESTOQUE NOVO'
        else 'OUTROS'
    end as DESTINO,
    
    concat(TR4.TR4_DTANAL, ' ', TR4.TR4_HRANAL) as DATA,
    1 as QTD_ANALISE

from TR4010 TR4 (nolock)
	inner join TQS010 TQS (nolock)
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = TR4.TR4_CODBEM

		inner join ST9010 ST9 (nolock)
			on ST9.D_E_L_E_T_ = ''
			and ST9.T9_CODBEM = TQS.TQS_CODBEM
where
		TR4.D_E_L_E_T_ = ''
