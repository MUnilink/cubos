select
    case
        when TQN_YTIPO = 'C' then DATA_HORA
        else DATA_HORA +'*'
    end as ZD3_DATA,
    
    TQN_PLACA as ZD3_PLACA,
    TQN_FROTA as ZD3_VEICUL,
    TQN_TANQUE as ZD3_TANQUE,
    TQN_CODCOM as ZD3_COMB,
    QTD_LITROS as ZD3_LITROS,
    HODOM_ATUAL as ZD3_KM,
    KMRD as ZD3_KMRD,
    KML as ZD3_KML,
    VALOR_UNIT as ZD3_VLUNI,
    VALOR_TOTAL as ZD3_TOTAL
from
    (select *,
            case
                when KMRD > 0
                     and QTD_LITROS > 0 then ROUND(KMRD/QTD_LITROS, 2)
                else 0
            end as KML
     from
         (select *,
                 case
                     when VALOR_TOTAL > 0
                          and QTD_LITROS > 0 then ROUND(VALOR_TOTAL/QTD_LITROS, 4)
                     else 0
                 end as VALOR_UNIT,
                 case
                     when HODOM_ATUAL >= ULT_HODOM_COMP then HODOM_ATUAL - ULT_HODOM_COMP
                     else HODOM_ATUAL + 1000000 - ULT_HODOM_COMP
                 end as KMRD
          from
              (select TQN_PLACA,
                      TQN_DTABAS,
                      DATA_HORA,
                      TQN_FROTA,
                      TQN_TANQUE,
                      TQN_YTIPO,
                      TQN_CODCOM,
                      TQN_HRABAS,
                      HODOM_ATUAL,
                      ULT_COMPLETO,
                      ULT_PARC,

                   (select TQN2.TQN_HODOM
                    from TQN010 TQN2
                    where TQN2.TQN_PLACA = A.TQN_PLACA
                        and TQN2.TQN_YTIPO = 'C'
                        and TQN2.TQN_CODCOM = A.TQN_CODCOM
                        and TQN2.D_E_L_E_T_= ' '
                        and TQN2.TQN_DTABAS+TQN2.TQN_HRABAS = ULT_COMPLETO) as ULT_HODOM_COMP,
                      case
                          when TQN_YTIPO = 'C' then
                                   (select SUM(ISNULL(TQN2.TQN_QUANT, 0))
                                    from TQN010 TQN2
                                    where TQN2.TQN_PLACA = A.TQN_PLACA
                                        and TQN2.TQN_CODCOM = A.TQN_CODCOM
                                        and TQN2.D_E_L_E_T_= ' '
                                        and TQN2.TQN_DTABAS+TQN2.TQN_HRABAS between ULT_PARC and A.TQN_DTABAS+A.TQN_HRABAS
                                        and TQN2.TQN_DTABAS+TQN2.TQN_HRABAS > ULT_COMPLETO)
                          else 0
                      end as QTD_LITROS,
                      case
                          when TQN_YTIPO = 'C' then
                                   (select SUM(ISNULL(TQN2.TQN_VALTOT, 0))
                                    from TQN010 TQN2
                                    where TQN2.TQN_PLACA = A.TQN_PLACA
                                        and TQN2.TQN_CODCOM = A.TQN_CODCOM
                                        and TQN2.D_E_L_E_T_= ' '
                                        and TQN2.TQN_DTABAS+TQN2.TQN_HRABAS between ULT_PARC and A.TQN_DTABAS+A.TQN_HRABAS
                                        and TQN2.TQN_DTABAS+TQN2.TQN_HRABAS > ULT_COMPLETO)
                          else 0
                      end as VALOR_TOTAL
               from
                (
                    select
                        TQN_PLACA,
                        TQN_DTABAS,
                        concat(TQN.TQN_DTABAS + ' ' + TQN.TQN_HRABAS) as DATA_HORA,
                        TQN_FROTA,
                        TQN_TANQUE,
                        TQN_YTIPO,
                        TQN_CODCOM,
                        TQN_HRABAS,
                        TQN_HODOM as HODOM_ATUAL,

                        (select TOP 1 TQN2.TQN_DTABAS+TQN2.TQN_HRABAS
                            from TQN010 TQN2
                            where TQN2.TQN_PLACA = TQN.TQN_PLACA
                                and TQN2.TQN_YTIPO = 'C'
                                and TQN2.TQN_CODCOM = TQN.TQN_CODCOM
                                and TQN2.D_E_L_E_T_= ' '
                                and TQN2.TQN_DTABAS+TQN2.TQN_HRABAS < TQN.TQN_DTABAS+TQN.TQN_HRABAS
                            order by TQN2.TQN_DTABAS desc) as ULT_COMPLETO,

                        (select TOP 1 TQN2.TQN_DTABAS+TQN2.TQN_HRABAS
                            from TQN010 TQN2
                            where TQN2.TQN_PLACA = TQN.TQN_PLACA
                                and TQN2.TQN_YTIPO = 'P'
                                and TQN2.TQN_CODCOM = TQN.TQN_CODCOM
                                and TQN2.D_E_L_E_T_= ' '
                                and TQN2.TQN_DTABAS+TQN2.TQN_HRABAS < TQN.TQN_DTABAS+TQN.TQN_HRABAS
                            order by TQN2.TQN_DTABAS) as ULT_PARC
                    from TQN010 TQN
                    where TQN.D_E_L_E_T_ = ' '
                ) A
            ) B
        ) C
    ) D
order by TQN_FROTA, TQN_DTABAS, TQN_HRABAS
