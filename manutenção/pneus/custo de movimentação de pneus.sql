    select
        trim(STZ.TZ_FILIAL) as TZ_FILIAL,
        STZ.TZ_ORDEM as TIPOMOV,
        CM.T9_CODBEM as ESTRUTURA1,
        trim(SR.T9_CODBEM) as ESTRUTURA2,
        
        convert(datetime, concat(STZ.TZ_DATAMOV, ' ', isnull(nullif(STZ.TZ_HORAENT, ''), '00:00')), 113) as DT_ATRELA,
        convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 113) as DT_DESATR,
        
        trim(TQS.TQS_CODBEM) as PNEU,
        trim(TQT.TQT_DESMED) as MEDIDA,
        convert(datetime, concat(STZ.TZ_DATAMOV, ' ', isnull(nullif(STZ.TZ_HORAENT, ''), '00:00')), 113) as ENT_PNEU,
        convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 113) as SAI_PNEU,
        case STZ.TZ_TIPOMOV when 'E' then 'ENTRADA' when 'S' then 'SAIDA' else 'OUTROS' end as MOV_PNEU

    from STZ010 STZ (nolock)
        inner join ST9010 CM
            on CM.D_E_L_E_T_ = ''
            and CM.T9_CODBEM = STZ.TZ_BEMPAI
            and CM.T9_TEMCONT = 'S'

        left join ST9010 SR
            on SR.D_E_L_E_T_ = ''
            and SR.T9_CODBEM = STZ.TZ_CODBEM
            and SR.T9_TEMCONT = 'P'

        left join TQS010 TQS
            on TQS.D_E_L_E_T_ = ''
            and TQS.TQS_CODBEM = STZ.TZ_CODBEM

            left join TQT010 TQT
                on TQT.D_E_L_E_T_ = ''
                and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
    where
            STZ.D_E_L_E_T_ = ''
union
    select
        trim(STZ.TZ_FILIAL) as TZ_FILIAL,
        STZ.TZ_ORDEM as TIPOMOV,
        null as ESTRUTURA1,
        trim(SR.T9_CODBEM) as ESTRUTURA2,
        
        convert(datetime, concat(STZ.TZ_DATAMOV, ' ', isnull(nullif(STZ.TZ_HORAENT, ''), '00:00')), 113) as DT_ATRELA,
        convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 113) as DT_DESATR,
        
        trim(TQS.TQS_CODBEM) as PNEU,
        trim(TQT.TQT_DESMED) as MEDIDA,
        convert(datetime, concat(STZ.TZ_DATAMOV, ' ', isnull(nullif(STZ.TZ_HORAENT, ''), '00:00')), 113) as ENT_PNEU,
        convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 113) as SAI_PNEU,
        case STZ.TZ_TIPOMOV when 'E' then 'ENTRADA' when 'S' then 'SAIDA' else 'OUTROS' end as MOV_PNEU

    from STZ010 STZ (nolock)
        inner join ST9010 SR
            on SR.D_E_L_E_T_ = ''
            and SR.T9_CODBEM = STZ.TZ_BEMPAI
            and SR.T9_TEMCONT = 'P'

        left join TQS010 TQS
            on TQS.D_E_L_E_T_ = ''
            and TQS.TQS_CODBEM = STZ.TZ_CODBEM

            left join TQT010 TQT
                on TQT.D_E_L_E_T_ = ''
                and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
    where
            STZ.D_E_L_E_T_ = ''
