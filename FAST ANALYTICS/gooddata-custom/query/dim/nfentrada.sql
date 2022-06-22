select
	trim(isnull(SF1.F1_FILIAL, '-')) as F1_FILIAL,
	isnull(trim(SF1.F1_FILIAL) + trim(SF1.F1_DOC) + trim(SF1.F1_SDOC) + trim(SF1.F1_FORNECE) + trim(SF1.F1_LOJA), '-') as ID_NF,
	isnull(trim(SA2.A2_COD) + trim(SA2.A2_LOJA), '-') as ID_FORNECE,
	trim(isnull(SF1.F1_DOC, '-')) as F1_DOC,
	trim(isnull(SF1.F1_SDOC, '-')) as F1_SDOC,
	trim(isnull(SF1.F1_DTDIGIT, '-')) as F1_DTDIGIT,
	
	trim(isnull(SD1.D1_ITEM, '-')) as D1_ITEM,

	trim(isnull(SB1.B1_COD, '-')) B1_COD
from SF1010 as SF1 (nolock) /* cabeçalho das NFs de entrada */
	inner join SD1010 as SD1 (nolock) /* itens das NFs de entrada*/
		on SD1.D_E_L_E_T_ = ''
		and SD1.D1_FILIAL = SF1.F1_FILIAL
		and SD1.D1_DOC = SF1.F1_DOC
		and SD1.D1_SERIE = SF1.F1_SERIE
		and SD1.D1_FORNECE = SF1.F1_FORNECE
		and SD1.D1_LOJA = SF1.F1_LOJA

		left join SB1010 as SB1 /* produtos */
			on SB1.D_E_L_E_T_ = ''
			and SD1.D1_COD = SB1.B1_COD

	left join SA2010 as SA2 /* fornecedores */
		on SA2.D_E_L_E_T_ = ''
		and SD1.D1_FORNECE = SA2.A2_COD
		and SD1.D1_LOJA = SA2.A2_LOJA
where SF1.D_E_L_E_T_ = ''