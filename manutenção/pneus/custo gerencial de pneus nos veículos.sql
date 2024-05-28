select
	trim(STZ.TZ_FILIAL) as TZ_FILIAL,
	trim(STZ.TZ_ORDEM) as TZ_ORDEM,
    ST9.T9_CODBEM,
    COM.SR,
    coalesce(COM.PNEU, trim(TQS.TQS_CODBEM)) as PNEU,
    coalesce(COM.MEDIDA, trim(TQT.TQT_DESMED)) as MEDIDA,
    coalesce(COM.DTENT, convert(datetime, concat(STZ.TZ_DATAMOV, ' ', isnull(nullif(STZ.TZ_HORAENT, ''), '00:00')), 113)) as DTENT,
    coalesce(COM.DTSAI, convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 113)) as DTSAI,
    coalesce(COM.MOVIMENTO, case STZ.TZ_TIPOMOV when 'E' then 'ENTRADA' when 'S' then 'SAIDA' else 'OUTROS' end) as MOVIMENTO

from STZ010 STZ (nolock)
    inner join ST9010 ST9
        on ST9.D_E_L_E_T_ = ''
        and ST9.T9_CODBEM = STZ.TZ_BEMPAI
        and ST9.T9_TEMCONT = 'S'
    left join
    (
        select
            case ST9010.T9_TEMCONT when 'P' then trim(STZ010.TZ_BEMPAI) else null end as SR,
            trim(TQS010.TQS_CODBEM) as PNEU,
            trim(TQT010.TQT_DESMED) as MEDIDA,
        	case STZ010.TZ_TIPOMOV when 'E' then 'ENTRADA' when 'S' then 'SAIDA' else 'OUTROS' end as MOVIMENTO,
            trim(STZ010.TZ_CAUSA) as OCORRENCIA,
            substring(STZ010.TZ_DATAMOV, 1, 6) as PERIODO_ENT,
            convert(datetime, concat(STZ010.TZ_DATAMOV, ' ', isnull(nullif(STZ010.TZ_HORAENT, ''), '00:00')), 113) as DTENT,
            substring(STZ010.TZ_DATASAI, 1, 6) as PERIODO_SAI,
            convert(datetime, concat(STZ010.TZ_DATASAI, ' ', STZ010.TZ_HORASAI), 113) as DTSAI,
            datediff(minute, concat(STZ010.TZ_DATAMOV, ' ', STZ010.TZ_HORAENT), concat(STZ010.TZ_DATASAI, ' ', STZ010.TZ_HORASAI))/(60*24) as TEMPO_RODADO
        from STZ010
            inner join ST9010
                on ST9010.D_E_L_E_T_ = ''
                and ST9010.T9_CODBEM = STZ010.TZ_BEMPAI
                and ST9010.T9_TEMCONT = 'P'

            left join TQS010
                on TQS010.D_E_L_E_T_ = ''
                and TQS010.TQS_CODBEM = STZ010.TZ_CODBEM

                left join TQT010
                    on TQT010.D_E_L_E_T_ = ''
                    and TQT010.TQT_MEDIDA = TQS010.TQS_MEDIDA
        where
                STZ010.D_E_L_E_T_ = ''
    ) COM
        on COM.SR = trim(STZ.TZ_CODBEM)

    left join TQS010 TQS
        on TQS.D_E_L_E_T_ = ''
        and TQS.TQS_CODBEM = STZ.TZ_CODBEM

        left join TQT010 TQT
            on TQT.D_E_L_E_T_ = ''
            and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
where
		STZ.D_E_L_E_T_ = ''
