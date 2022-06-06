select
	TQN.TQN_QUANT,
	TQN.TQN_VALUNI,
	TQN.TQN_HODOM,
	trim(isnull(TQN.TQN_DTABAS, '-')) as TQN_DTABAS,

	trim(isnull(TQN.TQN_TANQUE, '-')) as TQN_TANQUE,
	trim(isnull(TQN.TQN_FROTA, '-')) as TQN_FROTA,
	trim(isnull(TQN.TQN_CODCOM, '-')) as TQN_CODCOM
from
	(
		select
			case cast(TQN010.TQN_POSTO as int)
				when 59 then '010102'
				else trim(isnull(TQN010.TQN_FILIAL, '-'))
			end as TQN_FILIAL,
			TQN010.TQN_QUANT,
			TQN010.TQN_VALUNI,
			TQN010.TQN_HODOM,
			TQN010.TQN_FROTA,
			TQN010.TQN_CODCOM,
			TQN010.TQN_POSTO,
			TQN010.TQN_LOJA,
			TQN010.TQN_TANQUE,
			TQN010.TQN_DTABAS
		from TQN010
		where TQN010.D_E_L_E_T_ = ''
	) as TQN

	left join	
	(
		select
			case cast(TQI010.TQI_CODPOS as int)
				when 59 then '010102'
				else trim(isnull(TQI010.TQI_FILIAL, '-'))
			end as TQI_FILIAL,

			TQI010.TQI_CODPOS,
			TQI010.TQI_LOJA,
			TQI010.TQI_TANQUE,
			TQI010.TQI_YDETAN,
			TQI010.TQI_CODCOM,
			TQI010.TQI_PRODUT,
			TQI010.TQI_FABRIC
		from TQI010
		where TQI010.D_E_L_E_T_ = ''
	) as TQI
		on TQI.TQI_FILIAL = TQN.TQN_FILIAL
		and TQI.TQI_TANQUE = TQN.TQN_TANQUE

		left join
		(
			select
				case cast(TQF010.TQF_CODIGO as int)
					when 59 then '010102'
					else trim(isnull(TQF010.TQF_CODFIL, '-'))
				end as TQF_FILIAL,
				TQF010.TQF_CODIGO,
				TQF010.TQF_LOJA
			from TQF010
			where TQF010.D_E_L_E_T_ = ''
		) as TQF
			on TQF.TQF_FILIAL = TQI.TQI_FILIAL
			and TQF.TQF_CODIGO + TQF.TQF_LOJA = TQI.TQI_CODPOS + TQI.TQI_LOJA

	left join ST9010 as ST9
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = TQN.TQN_FROTA
	left join TQM010 as TQM
		on TQM.D_E_L_E_T_ = ''
		and TQM.TQM_CODCOM = TQN.TQN_CODCOM