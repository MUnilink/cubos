select
    ZD3.ZD3_VEICUL,
    ZD3.TQN_CCUSTO,
    sum(ZD3.ZD3_KMRD) as km,
    sum(ZD3.ZD3_TOTAL) as CUSTO,
    ZD3.PERIODO_ABA,
    trim(isnull(TQM.TQM_NOMCOM, '-')) as TQM_NOMCOM
from
    (
        select
            case cast(ZD3010.ZD3_TANQUE as int)
                when 12 then '010102'
                else trim(isnull(ZD3010.ZD3_FILIAL, '-'))
            end as ZD3_FILIAL,
            ZD3010.ZD3_KM as ZD3_HODOM,
            
            case when ZD3010.ZD3_LITROS = 0 then 'PARCIAL' else 'COMPLETO' end as TIPO_ABA,
            ZD3010.ZD3_VEICUL,
            ZD3010.ZD3_LITROS,
            ZD3010.ZD3_VLUNI,
            ZD3010.ZD3_TOTAL,
            
            ZD3010.ZD3_TANQUE as ZD3_TANQUE,
            ZD3010.ZD3_COMB,
            substring(ZD3010.ZD3_DATA, 1, 8) as ZD3_DATA,
            substring(ZD3010.ZD3_DATA, 1, 6) as PERIODO_ABA,
            ZD3010.ZD3_KML,
            case ZD3010.ZD3_COMB when 2 then 0.0 else ZD3010.ZD3_KMRD end as ZD3_KMRD,
            TQN010.TQN_CCUSTO
        from ZD3010 (nolock)
            inner join TQN010 (nolock)
                on TQN010.D_E_L_E_T_ = ''
                and TQN010.TQN_FROTA = ZD3010.ZD3_VEICUL
                and TQN010.TQN_DTABAS + TQN010.TQN_HRABAS = substring(ZD3010.ZD3_DATA, 1, 8) + substring(ZD3010.ZD3_DATA, 10, 14)
        where ZD3010.D_E_L_E_T_ = ''
    ) as ZD3

        left join ST9010 as ST9
            on ST9.D_E_L_E_T_ = ''
            and ST9.T9_CODBEM = ZD3.ZD3_VEICUL
            and ST9.T9_CODFAMI in ('VP', 'VM')
        left join TQM010 as TQM
            on TQM.D_E_L_E_T_ = ''
            and TQM.TQM_CODCOM = ZD3.ZD3_COMB
group by
    ZD3.ZD3_VEICUL,
    ZD3.TQN_CCUSTO,
    ZD3.PERIODO_ABA,
    TQM.TQM_NOMCOM
