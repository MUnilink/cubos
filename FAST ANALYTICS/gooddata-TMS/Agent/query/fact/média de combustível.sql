select
	ZD3.QTD_LITROS as ZD3_LITROS,
	(select sum(SD1010.D1_TOTAL) from SD1010 where SD1010.D_E_L_E_T_ = '' and SD1010.D1_COD = '11100008' and left(SD1010.D1_DTDIGIT, 6) = left(ZD3.DATA_HORA, 6))/
	(select sum(SD1010.D1_QUANT) from SD1010 where SD1010.D_E_L_E_T_ = '' and SD1010.D1_COD = '11100008' and left(SD1010.D1_DTDIGIT, 6) = left(ZD3.DATA_HORA, 6)) as ZD3_VLUNI,
	
	ZD3.HODOM_ATUAL as ZD3_HODOM,
    cast(ZD3.KMRD as numeric(15, 2)) as ZD3_KMRD,
    cast(ZD3.KML as numeric(15, 2)) as ZD3_KML,
	cast(ZD3.VALOR_TOTAL as numeric(15, 2)) as ZD3_TOTAL,
	trim(ZD3.DATA_HORA) as ZD3_DATA,

	trim(ST9.T9_CODBEM) as T9_CODBEM,
	trim(TQM.TQM_CODCOM) as TQM_CODCOM,
	trim(ZD3.TQN_CCUSTO) as TQN_CCUSTO,
	trim(ZD3.TQN_YITMCT) as TQN_YITMCT,
    ZD3.ULT_HODOM_COMP as CONT_ANT
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
                        TQN_FILIAL,
                        TQN_PLACA,
                        TQN_DTABAS,
                        TQN_CCUSTO,
                        TQN_YITMCT,
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
                            TQN_FILIAL,
                            TQN_PLACA,
                            TQN_DTABAS,
                            TQN_CCUSTO,
                            TQN_YITMCT,
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
		and ST9.T9_CODBEM = ZD3.TQN_FROTA

	left join TQI010 TQI
		on TQI.D_E_L_E_T_ = ''
		and TQI.TQI_FILIAL = ZD3.TQN_FILIAL
		and TQI.TQI_TANQUE = ZD3.TQN_TANQUE

		left join TQF010 TQF
			on TQF.D_E_L_E_T_ = ''
			and TQF.TQF_CODFIL = TQI.TQI_FILIAL
			and TQF.TQF_CODIGO = TQI.TQI_CODPOS
			and TQF.TQF_LOJA = TQI.TQI_LOJA

	left join TQM010 TQM
		on TQM.D_E_L_E_T_ = ''
		and TQM.TQM_CODCOM = ZD3.TQN_CODCOM
where ZD3.TQN_YTIPO = 'C'