select
	FILIAIS.CODFILIAL,
	trim(isnull(TQF.TQF_COMBOI, '-')) as TQF_COMBOI,
	isnull(trim(TQF.TQF_CODIGO) + trim(TQF.TQF_LOJA), '-') as ID_POSTO,
	isnull(trim(SA2.A2_COD) + trim(SA2.A2_LOJA), '-') as ID_FORNECE
from
	(
		select
			TQF010.TQF_CODFIL as TQF_FILIAL,
			TQF010.TQF_CODIGO,
			TQF010.TQF_LOJA,
			isnull(trim(TQF010.TQF_CODIGO) + trim(TQF010.TQF_LOJA), '-') as ID_POSTO,
			
			case TQF010.TQF_COMBOI
				when 1 then 'SIM'
				when 2 then	'NÃO'
				else '-'
			end as TQF_COMBOI
		from TQF010
		where TQF010.D_E_L_E_T_ = ''
	) TQF
	
	left join
	(
		select distinct TQF010.TQF_CODFIL as CODFILIAL, isnull(trim(TQF010.TQF_CODIGO) + trim(TQF010.TQF_LOJA), '-') as ID_POSTO
		from TQF010
		where TQF010.D_E_L_E_T_ = ''
	) FILIAIS
		on FILIAIS.CODFILIAL = TQF.TQF_FILIAL
		and FILIAIS.ID_POSTO = isnull(trim(TQF.TQF_CODIGO) + trim(TQF.TQF_LOJA), '-')
	
	left join SA2010 SA2
		on SA2.D_E_L_E_T_ = ''
		and SA2.A2_COD = TQF.TQF_CODIGO
		and SA2.A2_LOJA = TQF.TQF_LOJA
