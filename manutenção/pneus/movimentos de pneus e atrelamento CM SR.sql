select
	trim(isnull(STZ.TZ_FILIAL, '-')) as TJ_FILIAL,
	trim(isnull(STZ.TZ_ORDEM, '-')) as TZ_ORDEM,
	trim(isnull(PNEU.T9_CODBEM, '-')) as IDPNEU,
	trim(isnull(CARRO.T9_CODBEM, '-')) as IDCARRO,

	(
		select
			(
                select min(substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT)))
                from DTW010
                    inner join ZB1010
                        on ZB1010.D_E_L_E_T_ = ''
                        and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                        and
                            dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                            =
                            datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
					and
					(
						concat(DTW010.DTW_DATREA, ' '. DTW010.DTW_HORREA) >= concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT)
					)
                    and DTW010.DTW_ATIVID = 50
            )
			-
            (
                select max(substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT)))
                from DTW010
                    inner join ZB1010
                        on ZB1010.D_E_L_E_T_ = ''
                        and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                        and
                            dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                            =
                            datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
                where
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DUD.DUD_FILORI
                    and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                    and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
					and
					(
						concat(DTW010.DTW_DATREA, ' '. DTW010.DTW_HORREA) <= concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI)
					)
                    and DTW010.DTW_ATIVID = 49
            ) as km
		from DUD010 DUD (nolock)
            left join DTR010 DTR (nolock)
                on DTR.D_E_L_E_T_ = ''
                and DTR.DTR_FILORI = DUD.DUD_FILORI
                and DTR.DTR_VIAGEM = DUD.DUD_VIAGEM
		where DTR.D_E_L_E_T_ = '' and DTR.DTR_CODRB1 like 'SR%' and DTR.DTR_CODRB1 = CARRO.T9_CODBEM
	),

	STZ.TZ_POSCONT,
	STZ.TZ_CONTSAI,
	convert(datetime, concat(STZ.TZ_DATAMOV, ' ', STZ.TZ_HORAENT), 103) as TZ_DATAMOV,
	convert(datetime, concat(STZ.TZ_DATASAI, ' ', STZ.TZ_HORASAI), 103) as TZ_DATASAI,
	trim(isnull(STZ.TZ_TIPOMOV, '-')) as TZ_TIPOMOV,
	trim(isnull(STZ.TZ_HORAENT, '-')) as TZ_HORAENT,
	trim(isnull(STZ.TZ_HORASAI, '-')) as TZ_HORASAI,

	TQS.TQS_KMOR,
	TQS.TQS_KMR1,
	TQS.TQS_KMR2,
	TQS.TQS_KMR3,
	TQS.TQS_KMR4,
	TQS.TQS_KMR5,
	TQS.TQS_KMR6,
	TQS.TQS_KMR7,

	substring(STZ.TZ_DATAMOV, 1, 6) as PERIODO_ENT,
	substring(STZ.TZ_DATASAI, 1, 6) as PERIODO_SAI,	
	TQS.TQS_KMOR + TQS.TQS_KMR1 + TQS.TQS_KMR2 + TQS.TQS_KMR3 + TQS.TQS_KMR4 + TQS.TQS_KMR5 + TQS.TQS_KMR6 + TQS.TQS_KMR7 as kmTOT,
	case when cast(PNEU.T9_CODBEM as int) > 11140 then 'PNEU NOVO' else 'PNEU ANTIGO' end as TIPO_PNEU

from STZ010 STZ (nolock)			
	inner join TQS010 TQS (nolock)
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = STZ.TZ_CODBEM

		inner join ST9010 PNEU (nolock)
			on PNEU.D_E_L_E_T_ = ''
			and PNEU.T9_CODBEM = TQS.TQS_CODBEM
			and trim(PNEU.T9_CODBEM) like '[0-9]%'

	inner join ST9010 CARRO (nolock)
		on CARRO.D_E_L_E_T_ = ''
		and CARRO.T9_CODBEM = STZ.TZ_BEMPAI
		and trim(CARRO.T9_CODBEM) not like '[0-9]%'
where
		STZ.D_E_L_E_T_ = ''
