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
    
	cast(STZ.TZ_POSCONT as int) as CONT_ENT_COM,
    substring(STZ.TZ_DATAMOV, 1, 6) as PERIODO_ENT,
	convert(datetime, concat(STZ.TZ_DATAMOV, ' ', isnull(nullif(STZ.TZ_HORAENT, ''), '00:00')), 113) as DTENT,
    cast(STZ.TZ_CONTSAI as int) as CONT_SAI_COM,
    substring(STZ.TZ_DATASAI, 1, 6) as PERIODO_SAI,
	convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 113) as DTSAI,

    (select min(cast(STP010.TP_POSCONT as int)) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STZ.TZ_BEMPAI and STP010.TP_DTLEITU >= STZ.TZ_DATAMOV) as CONT_ENT_EST,
    (select max(cast(STP010.TP_POSCONT as int)) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STZ.TZ_BEMPAI and STP010.TP_DTLEITU <= STZ.TZ_DATASAI) as CONT_SAI_EST,

    (select max(cast(STP010.TP_POSCONT as int)) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STZ.TZ_BEMPAI and STP010.TP_DTLEITU <= STZ.TZ_DATASAI) - (select min(cast(STP010.TP_POSCONT as int)) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STZ.TZ_BEMPAI and STP010.TP_DTLEITU >= STZ.TZ_DATAMOV) as RODADO_EST,

    case STZ.TZ_CONTSAI when '' then (select max(cast(STP010.TP_ACUMCON as int)) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STZ.TZ_CODBEM and STP010.TP_DTLEITU <= STZ.TZ_DATASAI) else cast(STZ.TZ_CONTSAI as int) end as CONT_ACUM_COM,
    case STZ.TZ_CONTSAI when '' then (select max(cast(STP010.TP_POSCONT as int)) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STZ.TZ_CODBEM and STP010.TP_DTLEITU <= STZ.TZ_DATASAI) else cast(STZ.TZ_CONTSAI as int) end as CONT_ATUAL_COM,

	cast(STZ.TZ_CONTSAI - STZ.TZ_POSCONT as int) as RODADO_COM,
	datediff(minute, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI))/(60*24) as TEMPO_RODADO,
	COM.T9_VALCPA + (select sum(STJ010.TJ_CUSTTER) from STJ010 where STJ010.D_E_L_E_T_ = '' and STJ010.TJ_CODBEM = STZ.TZ_CODBEM and COM.T9_CATBEM = 3) as CUSTO_PNEU

from STZ010 STZ (nolock)
    inner join ST9010 EST
        on EST.D_E_L_E_T_ = ''
        and EST.T9_CODBEM = STZ.TZ_BEMPAI
    
    inner join ST9010 COM
        on COM.D_E_L_E_T_ = ''
        and COM.T9_CODBEM = STZ.TZ_CODBEM

        left join TQS010 TQS
            on TQS.D_E_L_E_T_ = ''
            and TQS.TQS_CODBEM = COM.T9_CODBEM
            
            left join TQT010 TQT
                on TQT.D_E_L_E_T_ = ''
                and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
                
                left join SB1010 SB1
                    on SB1.D_E_L_E_T_ = ''
                    and SB1.B1_XMEDIDA = TQT.TQT_MEDIDA
where
		STZ.D_E_L_E_T_ = ''
