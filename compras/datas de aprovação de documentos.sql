select
	trim(SC7.C7_FILIAL) as FILIAL,
	trim(SC7.C7_NUM) as PC,
	trim(SC7.C7_ITEM) as ITEM_PC,
	cast(SC7.C7_EMISSAO as date) as DATA_PC,
	left(SC7.C7_EMISSAO, 6) as PERIODO_PC,
	trim(SB1.B1_COD) as PRODUTO,
	trim(SB1.B1_DESC) as NOMEPRODUTO,
	trim(SB1.B1_GRUPO) as GRUPO_PROD,
	trim(SCR.CR_USER) as USUARIO,
	trim(SCR.CR_APROV) as APROVADOR,
	trim(SCR.CR_GRUPO) as GRUPO_APROV,
	trim(SCR.CR_ITGRP) as ITEM_GRUPO,
	trim(SCR.CR_NIVEL) as NIVEL,
	cast(SCR.CR_DATALIB as date) as DATA_LIB,
	SCR.CR_USERLIB as USR_LIB,
	SCR.CR_LIBAPRO as APR_LIB,
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
	) as STATUS
from SC7010 SC7 (nolock)
	inner join SB1010 SB1 (nolock)
		on SB1.D_E_L_E_T_ = ''
		and SB1.B1_COD = SC7.C7_PRODUTO
	left join SCR010 SCR
		on SCR.D_E_L_E_T_ = ''
		and SCR.CR_TIPO = 'PC'
		and SCR.CR_FILIAL = SC7.C7_FILIAL
		and SCR.CR_NUM = SC7.C7_NUM
where
        SC7.C7_num in ('039830', '039847', '038824', '038657', '039846', '039848', '038657', '038936', '038500', '038657', '039831', '039863', '039862', '039824', '039842', '039825', '039864', '039866', '039652', '039844', '039841', '039838', '039850', '039833', '039827', '039852', '039854', '039832', '039861', '039860', '039845', '039853', '039849', '039834', '039836', '039840', '039851', '039856', '039859', '039839', '039865', '039858', '039855', '039837', '039857', '039843')
    and SC7.D_E_L_E_T_ = ''
