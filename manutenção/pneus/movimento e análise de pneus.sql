select
	ST9.T9_CODBEM as CONTADOR,
	ST9.T9_CODBEM,
	ST9.T9_CCUSTO,
	ST9.T9_ITEMCTA,
	ST9.T9_SITBEM,
    
    ST9.T9_STATUS,
    TQY.TQY_DESTAT,
    
    STZ.TZ_ORDEM,
    convert(date, STZ.TZ_DATAMOV, 103) as TZ_DATAMOV,
	convert(date, STZ.TZ_DATASAI, 103) as TZ_DATASAI,
	STZ.TZ_BEMPAI,
	STZ.TZ_TIPOMOV,
	STZ.TZ_CAUSA,
	ST8_MV.T8_NOME,

    (
        select top 1 cast(convert(datetime, concat(TR4010.TR4_DTANAL, ' ', TR4010.TR4_HRANAL), 103) as varchar)
               +' - '+ trim(SX5010.X5_DESCRI) +' - '+ '(' + trim(ST8010.T8_NOME) + ')'
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
        select top 1 convert(datetime, concat(TR4010.TR4_DTANAL, ' ', TR4010.TR4_HRANAL), 113)
               +' - '+ trim(SX5010.X5_DESCRI) +' - '+ '(' + trim(ST8010.T8_NOME) + ')'
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
    ) as ANALISE_ENT

    /*, TR4.TR4_PAREC,
    TR4.TR4_NUMANA,
    convert(date, TR4.TR4_DTANAL, 103) as TR4_DTANAL,
    ST8_AN.T8_NOME,
    TR4.TR4_PRDORI,
    TR4.TR4_LOCORI,
    TR4.TR4_TM,
    TR4.TR4_PRDDES,
    TR4.TR4_LOCDES*/

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
    /*    
    inner join TR4010 TR4 (nolock)
        on TR4.D_E_L_E_T_ = ''
        and TR4.TR4_CODBEM = TQS.TQS_CODBEM

        inner join ST8010 ST8_AN (nolock)
			on ST8_AN.D_E_L_E_T_ = ''
			and ST8_AN.T8_CODOCOR = TR4.TR4_MOTIVO*/

where TQS.D_E_L_E_T_ = ''
