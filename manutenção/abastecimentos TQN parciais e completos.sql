select
    TQN.TQN_FILIAL,
    TQN.TQN_FROTA,
	trim(isnull(TQM.TQM_CODCOM, '-')) as TQM_CODCOM,
	trim(TQM.TQM_NOMCOM) as TQM_NOMCOM,
	(
		select avg(SD1010.D1_VUNIT)
		from SD1010
		where
				SD1010.D_E_L_E_T_ = ''
			and SD1010.D1_COD = '11100008'
			and SD1010.D1_TES = 42
			and substring(SD1010.D1_DTDIGIT, 1, 6) = isnull(substring(TQN.TQN_DTABAS, 1, 6), TQN.TQN_DTABAS)
	) as VALOR_COMPRA,

	TQN.TQN_DTABAS as PERIODO_TQN,
	convert(datetime, concat(TQN.TQN_DTABAS, ' ', TQN.TQN_HRABAS), 113) as DATA_ABA,
	SD3.D3_NUMSEQ,
	SD3.D3_LOCAL,
	SD3.D3_DOC,
	SD3.D3_TM,
	SD3.D3_CF,
	SD3.D3_QUANT,
	SD3.D3_CUSTO1,

    TQN.TQN_QUANT,
    TQN.TQN_VALUNI,
    TQN.TQN_VALTOT,
    TQN.TQN_YTIPO,

    TQN.TQN_HODOM as km_ATU,
    lag(TQN.TQN_HODOM, 1, 0.0) over (partition by TQN.TQN_FROTA, TQN.TQN_YTIPO order by TQN.R_E_C_N_O_) as km_ANT,
    case TQN.TQN_YTIPO when 'P' then 0.0 else TQN.TQN_HODOM - lag(TQN.TQN_HODOM, 1, 0.0) over (partition by TQN.TQN_FROTA, TQN.TQN_YTIPO order by TQN.R_E_C_N_O_) end as RODADO,
    TQN.R_E_C_N_O_

from TQN010 TQN (nolock)
    left join SD3010 SD3 (nolock)
        on SD3.D_E_L_E_T_ = ''
        and SD3.D3_FILIAL = TQN.TQN_FILIAL
        and SD3.D3_LOCAL = TQN.TQN_TANQUE
        and SD3.D3_NUMSEQ = TQN.TQN_NUMSEQ
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
		from TQI010 (nolock)
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
			from TQF010 (nolock)
			where TQF010.D_E_L_E_T_ = ''
		) as TQF
			on TQF.TQF_FILIAL = TQI.TQI_FILIAL
			and TQF.TQF_CODIGO + TQF.TQF_LOJA = TQI.TQI_CODPOS + TQI.TQI_LOJA

	left join TQM010 TQM (nolock)
		on TQM.D_E_L_E_T_ = ''
		and TQM.TQM_CODCOM = TQN.TQN_CODCOM
where 
		TQN.D_E_L_E_T_ = ''
    and TQN.TQN_FROTA like 'CM5%'
