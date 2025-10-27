select
	trim(SC7.C7_FILIAL) as FILIAL,
	trim(SC7.C7_NUM) as NUM,
	trim(SC7.C7_ITEM) as ITEM,
	cast(SC7.C7_EMISSAO as date) as DATA,
	left(SC7.C7_EMISSAO, 6) as PERIODO,
	trim(SC7.C7_FORNECE) as FORNECEDOR,
	trim(SC7.C7_LOJA) as LOJA,
	trim(SA2.A2_NOME) as NOME_FORNECEDOR,
	
	trim(SB1.B1_COD) as PRODUTO,
	trim(SB1.B1_DESC) as NOMEPRODUTO,
	trim(SB1.B1_GRUPO) as GRUPO_PROD,
	
	trim(SCR.CR_USER) as USUARIO,
	trim(SCR.CR_APROV) as APROVADOR,
	trim(SCR.CR_GRUPO) as GRUPO_APROV,
	trim(SCR.CR_ITGRP) as ITEM_GRUPO,
	trim(SCR.CR_NIVEL) as NIVEL,
	cast(SCR.CR_DATALIB as date) as DATA_LIB,
	trim(SCR.CR_USERLIB) as USR_LIB,
	trim(SCR.CR_LIBAPRO) as APR_LIB,
    (select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_COD = SCR.CR_LIBAPRO) as APROVA,
	cast(SCR.CR_VALLIB as numeric(15, 2)) as VALOR_LIB,

	concat
	(
		trim(SCR.CR_STATUS), ' - ',
		case SCR.CR_STATUS
			when 1 then 'PENDENTE DE OUTREM'
			when 2 then 'PENDENTE'
			when 3 then 'LIBERADA'
            when 4 then 'BLOQUEADA'
			when 5 then 'LIBERADA POR OUTREM'
			when 6 then 'REJEITADA'
			when 7 then 'REJEITADA POR OUTREM'
			else 'OUTROS'
		end
	) as STATUS_APROV
from SC7010 SC7 (nolock)
	inner join SB1010 SB1 (nolock)
		on SB1.D_E_L_E_T_ = ''
		and SB1.B1_COD = SC7.C7_PRODUTO
	left join SCR010 SCR (nolock)
		on SCR.D_E_L_E_T_ = ''
		and SCR.CR_TIPO = 'PC'
		and SCR.CR_FILIAL = SC7.C7_FILIAL
		and SCR.CR_NUM = SC7.C7_NUM
	inner join SA2010 SA2 (nolock)
		on SA2.D_E_L_E_T_ = ''
		and SA2.A2_COD = SC7.C7_FORNECE
		and SA2.A2_LOJA = SC7.C7_LOJA
where
        SC7.D_E_L_E_T_ = ''
