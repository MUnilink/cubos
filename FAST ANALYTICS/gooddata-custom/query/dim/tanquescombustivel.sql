select
	trim(isnull(TQI.TQI_TANQUE, '-')) as TQI_TANQUE,
	trim(isnull(TQI.TQI_YDETAN, '-')) as TQI_YDETAN,

	trim(isnull(TQM.TQM_CODCOM, '-')) as TQM_CODCOM,
	trim(isnull(SB1.B1_COD, '-')) as B1_COD,
	isnull(trim(TQF.TQF_CODIGO) + trim(TQF.TQF_LOJA), '-') as ID_POSTO
from
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

	left join TQM010 as TQM
		on TQM.D_E_L_E_T_ = ''
		and TQM.TQM_CODCOM = TQI.TQI_CODCOM
	left join SB1010 as SB1
		on SB1.D_E_L_E_T_ = ''
		and SB1.B1_COD = TQI.TQI_PRODUT