select
	trim(ST9.T9_CODBEM) as EQUIPAMENTO,
	trim(ST9.T9_NOME) as NOME,
	trim(TQR.TQR_DESMOD) as MODELO,
	trim(ST9.T9_CODFAMI) as FAMILIA,
	trim(ST7.T7_NOME) as FABRICANTE,
	ST9.T9_STATUS,
    trim(TQY.TQY_DESTAT) as STATUS,
    STP.PERIODO,

	(
        select top 1 last_value(trim(TPN010.TPN_CCUSTO)) over (partition by TPN010.TPN_CODBEM order by TPN010.TPN_DTINIC, TPN010.TPN_HRINIC)
        from TPN010
        where
                TPN010.D_E_L_E_T_ = ''
            and TPN010.TPN_CODBEM = STP.TP_CODBEM
            and convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC)) <= STP.MESINI
	) as CC_ANT,

    floor
    (
        datediff
        (
            hour,
            STP.MESINI,
            case
                when
                (
                    select max(convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC)))
                    from TPN010
                    where
                            TPN010.D_E_L_E_T_ = ''
                        and TPN010.TPN_CODBEM = STP.TP_CODBEM
                        and convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC)) <= cast(concat(cast(eomonth(STP.MESINI) as varchar), ' 23:59') as datetime)
                ) >= STP.MESINI /* verifica mudança dentro do mês */
                then
                (
                    select max(convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC)))
                    from TPN010
                    where
                            TPN010.D_E_L_E_T_ = ''
                        and TPN010.TPN_CODBEM = STP.TP_CODBEM
                        and convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC)) <= cast(concat(cast(eomonth(STP.MESINI) as varchar), ' 23:59') as datetime)
                ) /* se, pega mudança */
            else cast(concat(cast(eomonth(STP.MESINI) as varchar), ' 23:59') as datetime) end /* senão, fim do mês*/
        )/24.0
    ) as DIAS_ANT,

	(
        select top 1 last_value(trim(TPN010.TPN_CCUSTO)) over (partition by TPN010.TPN_CODBEM order by TPN010.TPN_DTINIC, TPN010.TPN_HRINIC)
        from TPN010
        where
                TPN010.D_E_L_E_T_ = ''
            and TPN010.TPN_CODBEM = STP.TP_CODBEM
            and convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC)) <= cast(concat(cast(eomonth(STP.MESINI) as varchar), ' 23:59') as datetime)
	) as CC_PRO,

	floor
    (
        datediff
        (
            hour,
            case
                when
                (
                    select max(convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC)))
                    from TPN010
                    where
                            TPN010.D_E_L_E_T_ = ''
                        and TPN010.TPN_CODBEM = STP.TP_CODBEM
                        and convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC)) <= cast(concat(cast(eomonth(STP.MESINI) as varchar), ' 23:59') as datetime)
                ) >= STP.MESINI /* verifica mudança dentro do mês */
                then
                (
                    select max(convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC)))
                    from TPN010
                    where
                            TPN010.D_E_L_E_T_ = ''
                        and TPN010.TPN_CODBEM = STP.TP_CODBEM
                        and convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC)) <= cast(concat(cast(eomonth(STP.MESINI) as varchar), ' 23:59') as datetime)
                ) /* se, pega mudança */
            else cast(concat(cast(eomonth(STP.MESINI) as varchar), ' 23:59') as datetime) end, /* senão, fim do mês*/
            
            dateadd(hour, 24, cast(concat(cast(eomonth(STP.MESINI) as varchar), ' 23:59') as datetime))
        )/24.0
    ) as DIAS_PRO,

    ceiling(datediff(hour, STP.MESINI, cast(concat(cast(eomonth(STP.MESINI) as varchar), ' 23:59') as datetime))/24.0) as DIAS_PERIODO,
	STP.MESINI as INI_PERIODO,
	cast(concat(cast(eomonth(STP.MESINI) as varchar), ' 23:59') as datetime) as FIM_PERIODO,

    (
        select max(convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC)))
        from TPN010
        where
                TPN010.D_E_L_E_T_ = ''
            and TPN010.TPN_CODBEM = STP.TP_CODBEM
            and convert(datetime, concat(TPN010.TPN_DTINIC, ' ', TPN010.TPN_HRINIC)) <= cast(concat(cast(eomonth(STP.MESINI) as varchar), ' 23:59') as datetime)
    ) as MUD_CC

from ST9010 ST9 (nolock)
	inner join TQR010 TQR (nolock)
		on TQR.D_E_L_E_T_ = ''
		and TQR.TQR_TIPMOD = ST9.T9_TIPMOD
		
		inner join ST7010 ST7 (nolock)
			on ST7.D_E_L_E_T_ = ''
			and ST7.T7_FABRICA = TQR.TQR_FABRIC
	
	left join TQY010 TQY (nolock)
		on TQY.D_E_L_E_T_ = ''
		and TQY.TQY_STATUS = ST9.T9_STATUS
	inner join
	(
		select distinct
			STP010.TP_CODBEM,
            trim(STP010.TP_CCUSTO) as CC,
			concat(left(STP010.TP_DTLEITU, 6), '01', ' 00:00') as MESINI,
            left(STP010.TP_DTLEITU, 6) as PERIODO
		from STP010 (nolock)
		where STP010.D_E_L_E_T_ = ''
	) STP
		on STP.TP_CODBEM = ST9.T9_CODBEM
where
		ST9.T9_CATBEM != 3
	and ST9.D_E_L_E_T_ = ''
