select
    trim(STZ.TZ_FILIAL) as TZ_FILIAL,
    STZ.TZ_ORDEM as TIPOMOV,
    CM.T9_CODBEM as ESTRUTURA1,
    trim(SR.T9_CODBEM) as ESTRUTURA2,
    
    case when nullif(STZ.TZ_ORDEM, '') is null then convert(datetime, concat(STZ.TZ_DATAMOV, ' ', isnull(nullif(STZ.TZ_HORAENT, ''), '00:00')), 113) else null end as DT_ATRELA,
    case when nullif(STZ.TZ_ORDEM, '') is null then convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 113) else null end as DT_DESATR,
    
    trim(TQS.TQS_CODBEM) as CM_PNEU,
    trim(TQT.TQT_DESMED) as CM_MEDIDA,
    case when nullif(STZ.TZ_ORDEM, '') is not null then convert(datetime, concat(STZ.TZ_DATAMOV, ' ', isnull(nullif(STZ.TZ_HORAENT, ''), '00:00')), 113) else null end as CM_ENT_PNEU,
    case when nullif(STZ.TZ_ORDEM, '') is not null then convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 113) else null end as CM_SAI_PNEU,
    case STZ.TZ_TIPOMOV when 'E' then 'ENTRADA' when 'S' then 'SAIDA' else 'OUTROS' end as CM_MOV_PNEU,

    PNSR.PNEU as SR_PNEU,
    PNSR.MEDIDA as SR_MEDIDA,
    PNSR.ENT_PNEU as SR_ENT_PNEU,
    PNSR.SAI_PNEU as SR_SAI_PNEU,
    PNSR.TIPOMOV as SR_MOV_PNEU

from STZ010 STZ (nolock)
    inner join ST9010 CM
        on CM.D_E_L_E_T_ = ''
        and CM.T9_CODBEM = STZ.TZ_BEMPAI
        and CM.T9_TEMCONT = 'S'

    left join ST9010 SR
        on SR.D_E_L_E_T_ = ''
        and SR.T9_CODBEM = STZ.TZ_CODBEM
        and SR.T9_TEMCONT = 'P'

        left join
        (
            select
                trim(STZ010.TZ_FILIAL) as TZ_FILIAL,
                null as ESTRUTURA1,
                trim(ST9010.T9_CODBEM) as ESTRUTURA2,
                trim(TQS010.TQS_CODBEM) as PNEU,
                trim(TQT010.TQT_DESMED) as MEDIDA,
                case when concat(STZ.TZ_DATAMOV, ' ', isnull(nullif(STZ.TZ_HORAENT, ''), '00:00')) > eomonth(PNSR.ENT_PNEU) concat(STZ010.TZ_DATAMOV, ' ', isnull(nullif(STZ010.TZ_HORAENT, ''), '00:00') then concat(STZ010.TZ_DATAMOV, ' ', isnull(nullif(STZ010.TZ_HORAENT, ''), '00:00')) else eomonth(PNSR.ENT_PNEU) as ENT_PNEU,
                convert(datetime, concat(STZ010.TZ_DATASAI, ' ', STZ010.TZ_HORASAI), 113) as SAI_PNEU,
                STZ010.TZ_TIPOMOV as TIPOMOV

            from STZ010 (nolock)
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

        ) PNSR
            on PNSR.ESTRUTURA2 = SR.T9_CODBEM
            and STZ.TZ_TEMCPAI = 'S'
            and
            (
                (
                        PNSR.ENT_PNEU >= concat(STZ.TZ_DATAMOV, ' ', isnull(nullif(STZ.TZ_HORAENT, ''), '00:00')) /* se pneu entra após atrelamento */
                    and PNSR.ENT_PNEU <= case when PNSR.ENT_PNEU >= concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI) then PNSR.ENT_PNEU else eomonth(PNSR.ENT_PNEU) end /* se pneu entra antes do desatrelamento */
                )
                or
                (
                        PNSR.SAI_PNEU >= concat(STZ.TZ_DATAMOV, ' ', isnull(nullif(STZ.TZ_HORAENT, ''), '00:00')) /* se pneu sai após atrelamento */
                    and PNSR.SAI_PNEU <= case when PNSR.SAI_PNEU >= concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI) then PNSR.SAI_PNEU else eomonth(PNSR.SAI_PNEU) end /* se pneu sai antes do desatrelamento */
                )
            )

    left join TQS010 TQS
        on TQS.D_E_L_E_T_ = ''
        and TQS.TQS_CODBEM = STZ.TZ_CODBEM

        left join TQT010 TQT
            on TQT.D_E_L_E_T_ = ''
            and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
where
        STZ.D_E_L_E_T_ = ''
