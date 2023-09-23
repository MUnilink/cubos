select
	TQS.TQS_CODBEM as TQS_CODBEM,
	TQS.TQS_MEDIDA,
    trim(TQT.TQT_DESMED) as MEDIDA,
    TQZ.TQZ_STATUS as STATUS,
	TQZ.TQZ_PRODUT as PRODUTO,
    TQZ.TQZ_ALMOX as ARMAZEM,

    TR4.TR4_NUMANA as NUMANA,
    TR4.TR4_DESTIN as DESTINO,
    case TR4.TR4_DESTIN
        when 1 then 'RESSOLAR'
        when 2 then 'CONSERTAR' 
        when 3 then 'ESTOQUE USADO'
        when 5 then 'ANALISE DO FORNECEDOR'
        when 6 then 'SUCATA'
        when 7 then 'ESTOQUE NOVO'
        else '-'                     
    end as DESCRI_DESTIN,
    trim(ST8.T8_NOME) as MOTIVO,
    TR4.TR4_MOTIVO,
    TR4.TR4_SULCO as SULCO,
    TR4.TR4_PAREC as PARECER,

    concat(TR4.TR4_DTANAL, ' ', TR4.TR4_HRANAL) as DATA,

    1 as QTD_ANALISE

from TR4010 TR4 (nolock)
	inner join TQS010 TQS (nolock)
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = TR4.TR4_CODBEM

		inner join ST9010 ST9 (nolock)
			on ST9.D_E_L_E_T_ = ''
			and ST9.T9_CODBEM = TQS.TQS_CODBEM
        inner join TQT010 TQT (nolock)
            on TQT.D_E_L_E_T_ = ''
            and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
    
    inner join TQZ010 TQZ (nolock)
        on TQZ.D_E_L_E_T_ = ''
        and TQZ.TQZ_CODBEM = TR4.TR4_CODBEM
        and TQZ.TQZ_DTSTAT = TR4.TR4_DTANAL
        and TQZ.TQZ_HRSTAT = TR4.TR4_HRANAL
    inner join ST8010 ST8 (nolock)
        on ST8.D_E_L_E_T_ = ''
        and ST8.T8_CODOCOR = TR4.TR4_MOTIVO
where
		TR4.D_E_L_E_T_ = ''
