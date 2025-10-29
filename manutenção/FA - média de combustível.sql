select
	ZD3.QTD_LITROS as ZD3_LITROS,
	(select sum(SD1010.D1_TOTAL) from SD1010 where SD1010.D_E_L_E_T_ = '' and SD1010.D1_COD = '11100008' and left(SD1010.D1_DTDIGIT, 6) = left(ZD3.DATA_HORA, 6))/
	(select sum(SD1010.D1_QUANT) from SD1010 where SD1010.D_E_L_E_T_ = '' and SD1010.D1_COD = '11100008' and left(SD1010.D1_DTDIGIT, 6) = left(ZD3.DATA_HORA, 6)) as ZD3_VLUNI,
	
	ZD3.HODOM_ATUAL as ZD3_HODOM,
    ZD3.KMRD as ZD3_KMRD,
    ZD3.KML as ZD3_KML,
	ZD3.VALOR_TOTAL,
	trim(ZD3.DATA_HORA) as ZD3_DATA,

	trim(TQI.TQI_TANQUE) as TQI_TANQUE,
	trim(ST9.T9_CODBEM) as T9_CODBEM,
	trim(TQM.TQM_CODCOM) as TQM_CODCOM,
	null as TQN_CCUSTO,
	null as TQN_YITMCT,

    /* RM */
    case when ZD3.TQN_YTIPO = 'C' then ZD3.DATA_HORA else ZD3.DATA_HORA +'*' end as ZD3_DATA,
    ZD3.TQN_PLACA as ZD3_PLACA,
    ZD3.TQN_FROTA as ZD3_VEICUL,
    ZD3.TQN_TANQUE as ZD3_TANQUE,
    ZD3.TQN_CODCOM as ZD3_COMB,
    ZD3.QTD_LITROS as ZD3_LITROS,
    ZD3.HODOM_ATUAL as ZD3_KM,
    ZD3.KMRD as ZD3_KMRD,
    ZD3.KML as ZD3_KML,
    ZD3.VALOR_UNIT as ZD3_VLUNI,
    ZD3.VALOR_TOTAL as ZD3_TOTAL,
    left(ZD3.ZD3_DATA, 6) as PERIODO
from
    (
        select *, case when KMRD > 0 and QTD_LITROS > 0 then ROUND(KMRD/QTD_LITROS, 2) else 0 end as KML
        from
            (
                select *,
                    case when VALOR_TOTAL > 0 and QTD_LITROS > 0 then ROUND(VALOR_TOTAL/QTD_LITROS, 4) else 0 end as VALOR_UNIT,
                    case when HODOM_ATUAL >= ULT_HODOM_COMP then HODOM_ATUAL - ULT_HODOM_COMP else HODOM_ATUAL + 1000000 - ULT_HODOM_COMP end as KMRD
            from
                (
                    select
                        TQN_PLACA,
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
                        (
                            select TQN2.TQN_HODOM
                            from TQN010 TQN2
                            where TQN2.TQN_PLACA = A.TQN_PLACA
                                and TQN2.TQN_YTIPO = 'C'
                                and TQN2.TQN_CODCOM = A.TQN_CODCOM
                                and TQN2.D_E_L_E_T_= ' '
                                and TQN2.TQN_DTABAS+TQN2.TQN_HRABAS = ULT_COMPLETO
                        ) as ULT_HODOM_COMP,

                        case when TQN_YTIPO = 'C' then
                            (
                                select SUM(ISNULL(TQN2.TQN_QUANT, 0))
                                from TQN010 TQN2
                                where TQN2.TQN_PLACA = A.TQN_PLACA
                                    and TQN2.TQN_CODCOM = A.TQN_CODCOM
                                    and TQN2.D_E_L_E_T_= ' '
                                    and TQN2.TQN_DTABAS+TQN2.TQN_HRABAS between ULT_PARC and A.TQN_DTABAS+A.TQN_HRABAS
                                    and TQN2.TQN_DTABAS+TQN2.TQN_HRABAS > ULT_COMPLETO
                            )
                            else 0
                        end as QTD_LITROS,
                            
                        case when TQN_YTIPO = 'C' then
                            (
                                select SUM(ISNULL(TQN2.TQN_VALTOT, 0))
                                from TQN010 TQN2
                                where TQN2.TQN_PLACA = A.TQN_PLACA
                                    and TQN2.TQN_CODCOM = A.TQN_CODCOM
                                    and TQN2.D_E_L_E_T_= ' '
                                    and TQN2.TQN_DTABAS+TQN2.TQN_HRABAS between ULT_PARC and A.TQN_DTABAS+A.TQN_HRABAS
                                    and TQN2.TQN_DTABAS+TQN2.TQN_HRABAS > ULT_COMPLETO
                            )
                            else 0
                        end as VALOR_TOTAL
                from
                    (
                        select
                            TQN_PLACA,
                            TQN_DTABAS,
                            concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS) as DATA_HORA,
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
    ) ZD3
	left join ST9010 ST9
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = ZD3.ZD3_VEICUL

	left join TQI010 TQI
		on TQI.D_E_L_E_T_ = ''
		and TQI.TQI_FILIAL = ZD3.ZD3_FILIAL
		and TQI.TQI_TANQUE = ZD3.ZD3_TANQUE

		left join TQF010 TQF
			on TQF.D_E_L_E_T_ = ''
			and TQF.TQF_CODFIL = TQI.TQI_FILIAL
			and TQF.TQF_CODIGO = TQI.TQI_CODPOS
			and TQF.TQF_LOJA = TQI.TQI_LOJA

	left join TQM010 TQM
		on TQM.D_E_L_E_T_ = ''
		and TQM.TQM_CODCOM = ZD3.ZD3_COMB
