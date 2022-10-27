select
	ST9.T9_CODBEM as CONTADOR,
	trim(ST9.T9_CODBEM) as T9_CODBEM,
	ST9.T9_CCUSTO,
	ST9.T9_ITEMCTA,
	ST9.T9_SITBEM,
    
    ST9.T9_STATUS,
    trim(TQY.TQY_DESTAT) as TQY_DESTAT,
    
    STZ.TZ_ORDEM,
    convert(datetime, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), 103) as TZ_DATAMOV,
    STZ.TZ_POSCONT,
	convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 103) as TZ_DATASAI,
    STZ.TZ_CONTSAI,

    abs(STZ.TZ_CONTSAI - STZ.TZ_POSCONT) as km,

	STZ.TZ_BEMPAI,
	STZ.TZ_TIPOMOV,
	STZ.TZ_CAUSA,
	ST8_MV.T8_NOME,

    (
        select top 1
            case STZ.TZ_CAUSA
                when 7 then concat(convert(datetimeoffset, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 113), ' SEM ANALISE (RODIZIO)')
                when 8 then concat(convert(datetimeoffset, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 113), ' SEM ANALISE (ESTOQUE)')
                else    concat(convert(datetimeoffset, concat(TR4010.TR4_DTANAL, ' ', TR4010.TR4_HRANAL), 113),
                        +' - AN° '+ TR4010.TR4_NUMANA +' - '+ trim(TR4010.TR4_PAREC) +' - '+ trim(SX5010.X5_DESCRI) +' - '+ '(' + trim(ST8010.T8_NOME) + ')')
            end
        from TR4010 (nolock)
            inner join ST8010 (nolock)
                on ST8010.D_E_L_E_T_ = ''
                and ST8010.T8_CODOCOR = TR4010.TR4_MOTIVO
            inner join SX5010 (nolock)
                on SX5010.D_E_L_E_T_ = ''
                and SX5010.X5_TABELA = 'DP'
                and cast(SX5010.X5_CHAVE as int) = cast(TR4010.TR4_DESTIN as int)
        where
                TR4010.D_E_L_E_T_ = ''
            and TR4010.TR4_CODBEM = TQS.TQS_CODBEM
            and TR4010.TR4_DTANAL + TR4010.TR4_HRANAL >= STZ.TZ_DATASAI + STZ.TZ_HORASAI
        order by TR4010.TR4_DTANAL asc
    ) as ANALISE_SAI,
    (
        select top 1
            case STZ.TZ_CAUSA
                when 7 then concat(convert(datetimeoffset, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), 113), ' SEM ANALISE (RODIZIO)')
                when 8 then concat(convert(datetimeoffset, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), 113), ' SEM ANALISE (ESTOQUE)')
                else    concat(convert(datetimeoffset, concat(TR4010.TR4_DTANAL, ' ', TR4010.TR4_HRANAL), 113),
                        +' - AN° '+ TR4010.TR4_NUMANA +' - '+ trim(TR4010.TR4_PAREC) +' - '+ trim(SX5010.X5_DESCRI) +' - '+ '(' + trim(ST8010.T8_NOME) + ')')
            end
        from TR4010 (nolock)
            inner join ST8010 (nolock)
                on ST8010.D_E_L_E_T_ = ''
                and ST8010.T8_CODOCOR = TR4010.TR4_MOTIVO
            inner join SX5010 (nolock)
                on SX5010.D_E_L_E_T_ = ''
                and SX5010.X5_TABELA = 'DP'
                and cast(SX5010.X5_CHAVE as int) = cast(TR4010.TR4_DESTIN as int)
        where
                TR4010.D_E_L_E_T_ = ''
            and TR4010.TR4_CODBEM = TQS.TQS_CODBEM
            and TR4010.TR4_DTANAL + TR4010.TR4_HRANAL <= STZ.TZ_DATAMOV + STZ.TZ_HORAENT
        order by TR4010.TR4_DTANAL desc
    ) as ANALISE_ENT/*,

    (
        select STJ010.TJ_CUSTTER
        from STJ010 (nolock)
        where
                STJ010.D_E_L_E_T_ = ''
            and STJ010.TJ_CODBEM = TQS.TQS_CODBEM
            and STJ010.TJ_DTMRFIM <= STZ.TZ_DATAMOV
    ) as CUSTO*/

from TQS010 TQS (nolock)
    inner join ST9010 ST9
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = TQS.TQS_CODBEM
    inner join STZ010 STZ (nolock)
        on STZ.D_E_L_E_T_ = ''
        and STZ.TZ_CODBEM = TQS.TQS_CODBEM

        left join ST8010 ST8_MV (nolock)
			on ST8_MV.D_E_L_E_T_ = ''
			and ST8_MV.T8_CODOCOR = STZ.TZ_CAUSA
    
    inner join TQY010 TQY (nolock)
        on TQY.D_E_L_E_T_ = ''
        and TQY.TQY_STATUS = ST9.T9_STATUS

where TQS.D_E_L_E_T_ = ''
