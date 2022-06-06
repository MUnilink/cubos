select
	STJ.TJ_FILIAL,
	trim(STJ.TJ_CODBEM) as TJ_CODBEM,
	STJ.TJ_ORDEM,
	STJ.TJ_PLANO,
	STJ.TJ_SERVICO,
	STJ.TJ_DTORIGI,
	ST9.T9_CALENDA,
	trim(ST6.T6_CODFAMI) as T6_CODFAMI,

	STJ.TJ_DTMRINI,
	STJ.TJ_HOMRINI,
	STJ.TJ_DTMRFIM,
	STJ.TJ_HOMRFIM,

	STJ.TJ_DTPRINI,
	STJ.TJ_HOPRINI,
	STJ.TJ_DTPRFIM,
	STJ.TJ_HOPRFIM,

	year(STJ.TJ_DTPRINI) ANO_PARINI,
	month(STJ.TJ_DTPRINI) MES_PARINI,
	year(STJ.TJ_DTPRFIM) ANO_PARFIM,
	month(STJ.TJ_DTPRFIM) MES_PARFIM,

	convert(datetime, datetimefromparts(year(STJ.TJ_DTMRINI), month(STJ.TJ_DTMRINI), day(STJ.TJ_DTMRINI), substring(STJ.TJ_HOMRINI, 1, 2), substring(STJ.TJ_HOMRINI, 4, 5), 0, 0), 113) as DATAHORA_MNTINI,
	convert(datetime, datetimefromparts(year(STJ.TJ_DTMRFIM), month(STJ.TJ_DTMRFIM), day(STJ.TJ_DTMRFIM), substring(STJ.TJ_HOMRFIM, 1, 2), substring(STJ.TJ_HOMRFIM, 4, 5), 0, 0), 113) as DATAHORA_MNTFIM,

	convert(datetime, datetimefromparts(year(STJ.TJ_DTPRINI), month(STJ.TJ_DTPRINI), day(STJ.TJ_DTPRINI), substring(STJ.TJ_HOPRINI, 1, 2), substring(STJ.TJ_HOPRINI, 4, 5), 0, 0), 113) as DATAHORA_PARINI,
	convert(datetime, datetimefromparts(year(STJ.TJ_DTPRFIM), month(STJ.TJ_DTPRFIM), day(STJ.TJ_DTPRFIM), substring(STJ.TJ_HOPRFIM, 1, 2), substring(STJ.TJ_HOPRFIM, 4, 5), 0, 0), 113) as DATAHORA_PARFIM,

	case ST9.T9_CALENDA
		when '001' then floor(6.2857142 * datediff(day, dateadd(day, 1, eomonth(STJ.TJ_DTPRINI, -1)), eomonth(STJ.TJ_DTPRINI)))
		when '006' then datediff(hour, dateadd(day, 1, eomonth(STJ.TJ_DTPRINI, -1)), eomonth(STJ.TJ_DTPRINI))
		when '24H' then datediff(hour, dateadd(day, 1, eomonth(STJ.TJ_DTPRINI, -1)), eomonth(STJ.TJ_DTPRINI))
		else 0.0
	end as DISPONIBILIDADE,

	case when ST9.T9_CALENDA = '001' and year(STJ.TJ_DTPRFIM) = 1900 and datediff(month, getdate(), STJ.TJ_DTPRINI) = 0 then
		convert(datetime, getdate(), 113)
	else
		case when (ST9.T9_CALENDA = '006' or ST9.T9_CALENDA = '24H') and year(STJ.TJ_DTPRFIM) = 1900 and datediff(month, getdate(), STJ.TJ_DTPRINI) = 0 then
			convert(datetime, getdate(), 113)
		else
			case when ST9.T9_CALENDA = '001' and year(STJ.TJ_DTPRFIM) = 1900 and datediff(month, getdate(), STJ.TJ_DTPRINI) != 0 then
				convert(datetime, dateadd(day, 1, eomonth(STJ.TJ_DTPRINI)), 113)
			else
				case when (ST9.T9_CALENDA = '006' or ST9.T9_CALENDA = '24H') and year(STJ.TJ_DTPRFIM) = 1900 and datediff(month, getdate(), STJ.TJ_DTPRINI) != 0 then
					convert(datetime, dateadd(day, 1, eomonth(STJ.TJ_DTPRINI)), 113)
				else
					case when ST9.T9_CALENDA = '001' then
						convert(datetime, datetimefromparts(year(STJ.TJ_DTPRFIM), month(STJ.TJ_DTPRFIM), day(STJ.TJ_DTPRFIM), substring(STJ.TJ_HOPRFIM, 1, 2), substring(STJ.TJ_HOPRFIM, 4, 5), 0, 0), 113)
					else
						convert(datetime, datetimefromparts(year(STJ.TJ_DTPRFIM), month(STJ.TJ_DTPRFIM), day(STJ.TJ_DTPRFIM), substring(STJ.TJ_HOPRFIM, 1, 2), substring(STJ.TJ_HOPRFIM, 4, 5), 0, 0), 113)
					end
				end
			end
		end
	end as FIMMNT,

	case when ST9.T9_CALENDA = '001' and year(STJ.TJ_DTPRFIM) = 1900 and datediff(month, getdate(), STJ.TJ_DTPRINI) = 0 then
		cast
		(
			(
				datediff
				(
					minute,
					datetimefromparts(year(STJ.TJ_DTPRINI), month(STJ.TJ_DTPRINI), day(STJ.TJ_DTPRINI), substring(STJ.TJ_HOPRINI, 1, 2), substring(STJ.TJ_HOPRINI, 4, 5), 0, 0),
					cast(getdate() as datetime)
				)
			)/60.0 * (6.2857142)
			as numeric(15,2)
		)
	else
		case when (ST9.T9_CALENDA = '006' or ST9.T9_CALENDA = '24H') and year(STJ.TJ_DTPRFIM) = 1900 and datediff(month, getdate(), STJ.TJ_DTPRINI) = 0 then
			cast
			(
				datediff
				(
					minute,
					datetimefromparts(year(STJ.TJ_DTPRINI), month(STJ.TJ_DTPRINI), day(STJ.TJ_DTPRINI), substring(STJ.TJ_HOPRINI, 1, 2), substring(STJ.TJ_HOPRINI, 4, 5), 0, 0),
					cast(getdate() as datetime)
				)/60.0
				as numeric(15,2)
			)
		else
			case when ST9.T9_CALENDA = '001' and year(STJ.TJ_DTPRFIM) = 1900 and datediff(month, getdate(), STJ.TJ_DTPRINI) != 0 then
				cast
				(
					(
						datediff
						(
							minute,
							datetimefromparts(year(STJ.TJ_DTPRINI), month(STJ.TJ_DTPRINI), day(STJ.TJ_DTPRINI), substring(STJ.TJ_HOPRINI, 1, 2), substring(STJ.TJ_HOPRINI, 4, 5), 0, 0),
							cast(eomonth(STJ.TJ_DTPRINI) as datetime)
						)
					)/60.0 * (6.2857142)
					as numeric(15,2)
				)
			else
				case when (ST9.T9_CALENDA = '006' or ST9.T9_CALENDA = '24H') and year(STJ.TJ_DTPRFIM) = 1900 and datediff(month, getdate(), STJ.TJ_DTPRINI) != 0 then
					cast
					(
						datediff
						(
							minute,
							datetimefromparts(year(STJ.TJ_DTPRINI), month(STJ.TJ_DTPRINI), day(STJ.TJ_DTPRINI), substring(STJ.TJ_HOPRINI, 1, 2), substring(STJ.TJ_HOPRINI, 4, 5), 0, 0),
							cast(eomonth(STJ.TJ_DTPRINI) as datetime)
						)/60.0
						as numeric(15,2)
					)
				else
					case when ST9.T9_CALENDA = '001' then
						cast
						(
							(
								datediff
								(
									minute,
									datetimefromparts(year(STJ.TJ_DTPRINI), month(STJ.TJ_DTPRINI), day(STJ.TJ_DTPRINI), substring(STJ.TJ_HOPRINI, 1, 2), substring(STJ.TJ_HOPRINI, 4, 5), 0, 0),
									datetimefromparts(year(STJ.TJ_DTPRFIM), month(STJ.TJ_DTPRFIM), day(STJ.TJ_DTPRFIM), substring(STJ.TJ_HOPRFIM, 1, 2), substring(STJ.TJ_HOPRFIM, 4, 5), 0, 0)
								)
							)/60.0 * (6.2857142)
							as numeric(15,2)
						)
					else
						cast
						(
							datediff
							(
								minute,
								datetimefromparts(year(STJ.TJ_DTPRINI), month(STJ.TJ_DTPRINI), day(STJ.TJ_DTPRINI), substring(STJ.TJ_HOPRINI, 1, 2), substring(STJ.TJ_HOPRINI, 4, 5), 0, 0),
								datetimefromparts(year(STJ.TJ_DTPRFIM), month(STJ.TJ_DTPRFIM), day(STJ.TJ_DTPRFIM), substring(STJ.TJ_HOPRFIM, 1, 2), substring(STJ.TJ_HOPRFIM, 4, 5), 0, 0)
							)/60.0
						 	as numeric(15,2)
						)
					end
				end
			end
		end
	end as TEMPOMNT
from STJ010 STJ (nolock)
	inner join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = STJ.TJ_CODBEM

		inner join ST6010 ST6 (nolock)
			on ST6.D_E_L_E_T_ = ''
			and ST6.T6_CODFAMI = ST9.T9_CODFAMI
where STJ.D_E_L_E_T_ = '' and trim(ST6.T6_CODFAMI) != 'PN'