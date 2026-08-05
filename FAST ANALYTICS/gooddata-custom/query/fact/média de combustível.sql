with MEDIACOMB as
(
	select
		trim(TQN.TQN_FILIAL) as FILIAL,
		trim(TQI.TQI_TANQUE) as TANQUE,
		trim(TQF.TQF_FILIAL) as FILIAL_POSTO,
		trim(TQF.TQF_CODIGO) as COD_POSTO,
		trim(TQF.TQF_LOJA) as LOJA,
		trim(TQF.TQF_CNPJ) as CNPJ,
		trim(TQF.TQF_NREDUZ) as DESC_POSTO,
		trim(TQF.TQF_CIDADE) as CIDADE_POSTO,
		trim(TQN.TQN_CCUSTO) as CC,
		trim(TQN.TQN_YITMCT) as ATIVIDADE,
		trim(TQM.TQM_CODCOM) as COD_COMB,
		trim(TQM.TQM_NOMCOM) as COMBUSTIVEL,
		TQN.TQN_FROTA as FROTA,
		
		TQN.TQN_YTIPO as TIPO_ABA,
		case when TQN.TQN_YTIPO = 'C' then cast(TQN.TQN_VALUNI as numeric(15, 2)) else 0.0 end as VLUNI_MEDIA,
		case when TQN.TQN_YTIPO = 'C' then cast(TQN.TQN_QUANT as numeric(15, 2)) else 0.0 end as LITROS_MEDIA,
		case when TQN.TQN_YTIPO = 'C' then cast(TQN.TQN_VALTOT as numeric(15, 2)) else 0.0 end as VLTOTAL_MEDIA,
		cast(TQN.TQN_VALUNI as numeric(15, 2)) as VLUNI_ORI,
		cast(TQN.TQN_QUANT as numeric(15, 2)) as LITROS_ORI,
		cast(TQN.TQN_VALTOT as numeric(15, 2)) as VLTOTAL_ORI,
		TQN.TQN_HODOM as CONTADOR,
		left(TQN.TQN_DTABAS, 6) as PERIODO,
		convert(datetime, concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS), 113) as DATA_ABA,
		lag(TQN.TQN_HODOM, 1, null) over(partition by TQN.TQN_FROTA order by TQN.TQN_FROTA, TQN.TQN_DTABAS, TQN.TQN_HRABAS) as CONTADOR_ANT,
		sum(case when TQN.TQN_YTIPO = 'C' then 1 else 0 end) over(partition by TQN.TQN_FROTA order by TQN.TQN_FROTA, TQN.TQN_DTABAS, TQN.TQN_HRABAS) as SEQ_CONT,
		case when TQN.TQN_YTIPO = 'P' then 1 else 0 end + sum(case when TQN.TQN_YTIPO = 'C' then 1 else 0 end) over(partition by TQN.TQN_FROTA order by TQN.TQN_FROTA, TQN.TQN_DTABAS, TQN.TQN_HRABAS) as SEQ_VALORES

		,TQN.TQN_DTABAS
	from TQN010 TQN
		inner join TQI010 TQI
			on TQI.D_E_L_E_T_ = ''
			and TQI.TQI_FILIAL = TQN.TQN_FILIAL
			and TQI.TQI_CODPOS = TQN.TQN_POSTO
			and TQI.TQI_LOJA = TQN.TQN_LOJA
			and TQI.TQI_TANQUE = TQN.TQN_TANQUE
		inner join TQF010 TQF
			on TQF.D_E_L_E_T_ = ''
			and TQF.TQF_FILIAL = TQN.TQN_FILIAL
			and TQF.TQF_CODIGO = TQN.TQN_POSTO
			and TQF.TQF_LOJA = TQN.TQN_LOJA
		inner join TQM010 TQM
			on TQM.D_E_L_E_T_ = ''
			and TQM.TQM_CODCOM = TQN.TQN_CODCOM
	where
			TQN.D_E_L_E_T_ = ''
		and TQN.TQN_CODCOM != '002'
)
select
	ZD3.QTD_LITROS as ZD3_LITROS,
	(select sum(SD1010.D1_TOTAL) from SD1010 where SD1010.D_E_L_E_T_ = '' and SD1010.D1_COD = '11100008' and left(SD1010.D1_DTDIGIT, 6) = left(ZD3.DATA_HORA, 6))/
	(select sum(SD1010.D1_QUANT) from SD1010 where SD1010.D_E_L_E_T_ = '' and SD1010.D1_COD = '11100008' and left(SD1010.D1_DTDIGIT, 6) = left(ZD3.DATA_HORA, 6)) as ZD3_VLUNI,
	
	ZD3.HODOM_ATUAL as ZD3_HODOM,
    ZD3.KMRD as ZD3_KMRD,
    ZD3.KML as ZD3_KML,
	ZD3.VALOR_TOTAL as ZD3_TOTAL,
	trim(ZD3.DATA_HORA) as ZD3_DATA,

	trim(TQI.TQI_TANQUE) as TQI_TANQUE,
	trim(ST9.T9_CODBEM) as T9_CODBEM,
	trim(TQM.TQM_CODCOM) as TQM_CODCOM,
	trim(ZD3.TQN_CCUSTO) as TQN_CCUSTO,
	trim(ZD3.TQN_YITMCT) as TQN_YITMCT
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
where ST9.T9_CODFAMI in ('VP', 'VM') and ZD3.DATA_HORA between <<START_DATE>> AND <<FINAL_DATE>>
union
select
	cast(sum(MEDIACOMB.LITROS_ORI) over(partition by MEDIACOMB.FROTA, MEDIACOMB.SEQ_VALORES order by MEDIACOMB.DATA_ABA) as numeric(15, 2)) as ZD3_LITROS,
	(select sum(SD1010.D1_TOTAL) from SD1010 where SD1010.D_E_L_E_T_ = '' and SD1010.D1_COD = '11100008' and SD1010.D1_TES in (42, 44) and left(SD1010.D1_DTDIGIT, 6) = MEDIACOMB.PERIODO)/
	(select sum(SD1010.D1_QUANT) from SD1010 where SD1010.D_E_L_E_T_ = '' and SD1010.D1_COD = '11100008' and SD1010.D1_TES in (42, 44) and left(SD1010.D1_DTDIGIT, 6) = MEDIACOMB.PERIODO) as VALOR_COMPRA,
	MEDIACOMB.CONTADOR as ZD3_HODOM,
	MEDIACOMB.CONTADOR - min(MEDIACOMB.CONTADOR_ANT) over(partition by MEDIACOMB.FROTA, MEDIACOMB.SEQ_VALORES order by MEDIACOMB.DATA_ABA) as ZD3_KMRD,
	0.0 as ZD3_KML,
	cast(sum(MEDIACOMB.VLTOTAL_ORI) over(partition by MEDIACOMB.FROTA, MEDIACOMB.SEQ_VALORES order by MEDIACOMB.DATA_ABA) as numeric(15, 2)) as ZD3_TOTAL,
	MEDIACOMB.DATA_ABA,
	
	MEDIACOMB.TANQUE as TQI_TANQUE,
	trim(ST9.T9_CODBEM) as T9_CODBEM,
	MEDIACOMB.COD_COMB as TQM_CODCOM,
	MEDIACOMB.CC as TQN_CCUSTO,
	MEDIACOMB.ATIVIDADE as TQN_YITMCT
from MEDIACOMB
	left join ST9010 ST9
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = MEDIACOMB.FROTA
where
		ST9.T9_CODFAMI in ('GD', 'GD AUX', 'MP', 'ML')
    and MEDIACOMB.TQN_DTABAS between <<START_DATE>> AND <<FINAL_DATE>>
