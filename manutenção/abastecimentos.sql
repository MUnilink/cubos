select
	ABASTECE.TQN_FILIAL,
	ABASTECE.TQN_FROTA,
	ST9010.T9_TIPMOD,
	TQR010.TQR_DESMOD,
	ABASTECE.TQN_VALTOT,
	ABASTECE.TQN_CCUSTO,
	ABASTECE.TQN_LOJA,
	ABASTECE.TQN_NOTFIS,
	ABASTECE.TQN_VALUNI,
	ABASTECE.TQN_POSTO,
	ABASTECE.TQN_CODCOM,
	ABASTECE.TQN_DTABAS,
	ABASTECE.TQN_HRABAS,
	ABASTECE.TQN_QUANT,

	ABASTECE.TQN_HODOM,
	isnull
	(
		(
			select min(TQN010.TQN_HODOM)
			from TQN010 (nolock)
			where
					TQN010.D_E_L_E_T_ = ''
				and TQN010.TQN_FILIAL = ABASTECE.TQN_FILIAL
				and TQN010.TQN_FROTA = ABASTECE.TQN_FROTA
				and 
				(
					datetimefromparts(year(TQN010.TQN_DTABAS), month(TQN010.TQN_DTABAS), day(TQN010.TQN_DTABAS), datepart(hour, cast(TQN010.TQN_HRABAS as time)), datepart(minute, cast(TQN010.TQN_HRABAS as time)), 0, 0)
					-
					datetimefromparts(year(ABASTECE.TQN_DTABAS), month(ABASTECE.TQN_DTABAS), day(ABASTECE.TQN_DTABAS), datepart(hour, cast(ABASTECE.TQN_HRABAS as time)), datepart(minute, cast(ABASTECE.TQN_HRABAS as time)), 0, 0)
				) < 0
			group by
				TQN010.TQN_DTABAS,
				TQN010.TQN_HRABAS,
				TQN010.TQN_FILIAL,
				TQN010.TQN_FROTA
			having
				(
					datetimefromparts(year(TQN010.TQN_DTABAS), month(TQN010.TQN_DTABAS), day(TQN010.TQN_DTABAS), datepart(hour, cast(TQN010.TQN_HRABAS as time)), datepart(minute, cast(TQN010.TQN_HRABAS as time)), 0, 0)
					-
					datetimefromparts(year(ABASTECE.TQN_DTABAS), month(ABASTECE.TQN_DTABAS), day(ABASTECE.TQN_DTABAS), datepart(hour, cast(ABASTECE.TQN_HRABAS as time)), datepart(minute, cast(ABASTECE.TQN_HRABAS as time)), 0, 0)
				)
				> all
				(
					select
						(
							datetimefromparts(year(TQN010.TQN_DTABAS), month(TQN010.TQN_DTABAS), day(TQN010.TQN_DTABAS), datepart(hour, cast(TQN010.TQN_HRABAS as time)), datepart(minute, cast(TQN010.TQN_HRABAS as time)), 0, 0)
							-
							datetimefromparts(year(ABASTECE.TQN_DTABAS), month(ABASTECE.TQN_DTABAS), day(ABASTECE.TQN_DTABAS), datepart(hour, cast(ABASTECE.TQN_HRABAS as time)), datepart(minute, cast(ABASTECE.TQN_HRABAS as time)), 0, 0)
						)
					from TQN010 (nolock)
					where
							TQN010.D_E_L_E_T_ = ''
						and TQN010.TQN_FILIAL = ABASTECE.TQN_FILIAL
						and TQN010.TQN_FROTA = ABASTECE.TQN_FROTA
						and 
						(
							datetimefromparts(year(TQN010.TQN_DTABAS), month(TQN010.TQN_DTABAS), day(TQN010.TQN_DTABAS), datepart(hour, cast(TQN010.TQN_HRABAS as time)), datepart(minute, cast(TQN010.TQN_HRABAS as time)), 0, 0)
							-
							datetimefromparts(year(ABASTECE.TQN_DTABAS), month(ABASTECE.TQN_DTABAS), day(ABASTECE.TQN_DTABAS), datepart(hour, cast(ABASTECE.TQN_HRABAS as time)), datepart(minute, cast(ABASTECE.TQN_HRABAS as time)), 0, 0)
						) < 0
				)
		), 0.0) as DATADIFF,

	year(ABASTECE.TQN_DTABAS) as ANO_ABAS,
	month(ABASTECE.TQN_DTABAS) as MES_ABAS
from TQN010 as ABASTECE (nolock)
	inner join ST9010 (nolock)
		on ST9010.D_E_L_E_T_ = ''
		and ST9010.T9_CODBEM = ABASTECE.TQN_FROTA

		inner join TQR010 (nolock)
			on TQR010.D_E_L_E_T_ = ''
			and TQR010.TQR_TIPMOD = ST9010.T9_TIPMOD
where
		ABASTECE.D_E_L_E_T_ = ''