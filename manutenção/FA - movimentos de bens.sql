select
	trim(STZ.TZ_FILIAL) as TZ_FILIAL,
	trim(STZ.TZ_ORDEM) as TZ_ORDEM,
    trim(ST9.T9_CODBEM) as ESTRUTURA,
	trim(STz.Tz_CODBEM) as COMPONENTE,
	
    trim(SB1.B1_COD) as PRODUTO,
	trim(TQS.TQS_MEDIDA) as TQS_MEDIDA,
	ST9.T9_STATUS,
	case STZ.TZ_TIPOMOV when 'E' then 'ENTRADA' when 'S' then 'SAIDA' else 'OUTROS' end as TZ_TIPOMOV,
	trim(STZ.TZ_CAUSA) as OCORRENCIA,
    
	STZ.TZ_POSCONT,
    substring(STZ.TZ_DATAMOV, 1, 6) as PERIODO_MOV,
	convert(datetime, concat(STZ.TZ_DATAMOV, ' ', isnull(nullif(STZ.TZ_HORAENT, ''), '00:00')), 113) as TZ_DATAMOV,
    STZ.TZ_CONTSAI,
    substring(STZ.TZ_DATASAI, 1, 6) as PERIODO_SAI,
	convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 113) as TZ_DATASAI,

	STZ.TZ_CONTSAI - STZ.TZ_POSCONT as RODADO,
	datediff(minute, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI))/(60*24) as TEMPO_RODADO,
	ST9.T9_VALCPA + (select sum(STJ010.TJ_CUSTTER) from STJ010 where STJ010.D_E_L_E_T_ = '' and STJ010.TJ_CODBEM = STZ.TZ_CODBEM) as CUSTO_PNEU

from STZ010 STZ (nolock)
    inner join ST9010 ST9
        on ST9.D_E_L_E_T_ = ''
        and ST9.T9_CODBEM = STZ.TZ_BEMPAI

    left join TQS010 TQS
        on TQS.D_E_L_E_T_ = ''
        and TQS.TQS_CODBEM = STZ.TZ_CODBEM
        
        left join TQT010 TQT
            on TQT.D_E_L_E_T_ = ''
            and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
            
            left join SB1010 SB1
                on SB1.D_E_L_E_T_ = ''
                and SB1.B1_XMEDIDA = TQT.TQT_MEDIDA
where
		STZ.D_E_L_E_T_ = ''
