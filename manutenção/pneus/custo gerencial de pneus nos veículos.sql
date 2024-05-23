select
	trim(STZ.TZ_FILIAL) as TZ_FILIAL,
	trim(STZ.TZ_ORDEM) as TZ_ORDEM,
    trim(EST.T9_CODBEM) as ESTRUTURA,

    case EST.T9_CATBEM
		when 1 then 'BEM'
		when 2 then 'FROTA NAO INTEGRADA'
		when 3 then 'PNEU'
		when 4 then 'FROTA INTEGRADA'
		else '-'
	end as EST_CATBEM,
	
    trim(COM.T9_CODBEM) as COMPONENTE,
    case COM.T9_CATBEM
		when 1 then 'BEM'
		when 2 then 'FROTA NAO INTEGRADA'
		when 3 then 'PNEU'
		when 4 then 'FROTA INTEGRADA'
		else '-'
	end as COM_CATBEM,

    case COM.T9_CATBEM when 3 then 'PNEU' else 'ATRELAMENTO' end as MOVIMENTACAO,
    trim(SB1.B1_COD) as PRODUTO,
	trim(TQS.TQS_MEDIDA) as TQS_MEDIDA,
	case STZ.TZ_TIPOMOV when 'E' then 'ENTRADA' when 'S' then 'SAIDA' else 'OUTROS' end as TZ_TIPOMOV,
	trim(STZ.TZ_CAUSA) as OCORRENCIA,
    
    substring(STZ.TZ_DATAMOV, 1, 6) as PERIODO_ENT,
	convert(datetime, concat(STZ.TZ_DATAMOV, ' ', isnull(nullif(STZ.TZ_HORAENT, ''), '00:00')), 113) as DTENT,
    substring(STZ.TZ_DATASAI, 1, 6) as PERIODO_SAI,
	convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 113) as DTSAI,

	datediff(minute, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI))/(60*24) as TEMPO_RODADO

from STZ010 STZ (nolock)
    inner join ST9010 EST
        on EST.D_E_L_E_T_ = ''
        and EST.T9_CODBEM = STZ.TZ_BEMPAI
    
    inner join ST9010 COM
        on COM.D_E_L_E_T_ = ''
        and COM.T9_CODBEM = STZ.TZ_CODBEM

        inner join TQS010 TQS
            on TQS.D_E_L_E_T_ = ''
            and TQS.TQS_CODBEM = COM.T9_CODBEM
            
            left join TQT010 TQT
                on TQT.D_E_L_E_T_ = ''
                and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
                
                left join SB1010 SB1
                    on SB1.D_E_L_E_T_ = ''
                    and SB1.B1_XMEDIDA = TQT.TQT_MEDIDA
     
    left join ZC6010 ZC6 (nolock)
where
		STZ.D_E_L_E_T_ = ''
