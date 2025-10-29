	select
		trim(SC7.C7_FILIAL) as FILIAL,
		trim(SC7.C7_NUM) as NUM,
		'PC' as TIPO,
		trim(SC7.C7_ITEM) as ITEM,
		convert(datetime, concat(SC7.C7_EMISSAO, ' ', SC7.C7_YHORAPC), 113) as DATAHORA_DOC,
		left(SC7.C7_EMISSAO, 6) as PERIODO,
		cast(SC7.C7_EMISSAO as date) as DATA_DOC,
		cast(SC7.C7_DATPRF as date) as DATA_ITEM,
		trim(SC7.C7_FORNECE) as FORNECEDOR,
		trim(SC7.C7_LOJA) as LOJA,
		trim(SA2.A2_NOME) as NOME_FORNECEDOR,
		
		trim(SB1.B1_COD) as PRODUTO,
		trim(SB1.B1_DESC) as NOMEPRODUTO,
		trim(SB1.B1_GRUPO) as GRUPO_PROD,
		null as OS,
		null as EQUIPAMENTO,

		trim(SC7.C7_ITEMCTA) as ATIVIDADE,
        trim(SC7.C7_CC) as CC,
        null as CONTA,
		
		trim(SCR.CR_USER) as USUARIO,
		trim(SCR.CR_APROV) as APROVA,
		trim(SCR.CR_GRUPO) as GRUPO_APROV,
		trim(SCR.CR_ITGRP) as ITEM_GRUPO,
		trim(SCR.CR_NIVEL) as NIVEL,
		cast(SCR.CR_DATALIB as date) as DATA_LIB,
		trim(SCR.CR_USERLIB) as USR_LIB,
		trim(SCR.CR_LIBAPRO) as APR_LIB,
		(select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_COD = SCR.CR_LIBAPRO) as APROVADOR,
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
		and datediff(month, SC7.C7_EMISSAO, getdate()) < 7
union
	select
		trim(SC1.C1_FILIAL) as FILIAL,
		trim(SC1.C1_NUM) as NUM,
		'SC' as TIPO,
		trim(SC1.C1_ITEM) as ITEM,
		convert(datetime, concat(SC1.C1_EMISSAO, ' ', SC1.C1_YHORASC), 113) as DATAHORA_DOC,
		left(SC1.C1_EMISSAO, 6) as PERIODO,
		cast(SC1.C1_EMISSAO as date) as DATA_DOC,
		cast(SC1.C1_DATPRF as date) as DATA_ITEM,
		trim(SC1.C1_FORNECE) as FORNECEDOR,
		trim(SC1.C1_LOJA) as LOJA,
		trim(SA2.A2_NOME) as NOME_FORNECEDOR,
		
		trim(SB1.B1_COD) as PRODUTO,
		trim(SB1.B1_DESC) as NOMEPRODUTO,
		trim(SB1.B1_GRUPO) as GRUPO_PROD,
		null as OS,
		null as EQUIPAMENTO,

		trim(SC1.C1_ITEMCTA) as ATIVIDADE,
        trim(SC1.C1_CC) as CC,
        null as CONTA,
		
		trim(SCR.CR_USER) as USUARIO,
		trim(SCR.CR_APROV) as APROVA,
		trim(SCR.CR_GRUPO) as GRUPO_APROV,
		trim(SCR.CR_ITGRP) as ITEM_GRUPO,
		trim(SCR.CR_NIVEL) as NIVEL,
		cast(SCR.CR_DATALIB as date) as DATA_LIB,
		trim(SCR.CR_USERLIB) as USR_LIB,
		trim(SCR.CR_LIBAPRO) as APR_LIB,
		(select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_COD = SCR.CR_LIBAPRO) as APROVADOR,
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
	from SC1010 SC1 (nolock)
		inner join SB1010 SB1 (nolock)
			on SB1.D_E_L_E_T_ = ''
			and SB1.B1_COD = SC1.C1_PRODUTO
		left join SCR010 SCR (nolock)
			on SCR.D_E_L_E_T_ = ''
			and SCR.CR_TIPO = 'PC'
			and SCR.CR_FILIAL = SC1.C1_FILIAL
			and SCR.CR_NUM = SC1.C1_NUM
		left join SA2010 SA2 (nolock)
			on SA2.D_E_L_E_T_ = ''
			and SA2.A2_COD = SC1.C1_FORNECE
			and SA2.A2_LOJA = SC1.C1_LOJA
	where
			SC1.D_E_L_E_T_ = ''
		and datediff(month, SC1.C1_EMISSAO, getdate()) < 7
union
	select
		trim(SCP.CP_FILIAL) as FILIAL,
		trim(SCP.CP_NUM) as NUM,
		'SA' as TIPO,
		trim(SCP.CP_ITEM) as ITEM,
		convert(datetime, concat(SCP.CP_EMISSAO, ' ', SCP.CP_YHORASA), 113) as DATA_DOC,
		left(SCP.CP_EMISSAO, 6) as PERIODO,
		cast(SCP.CP_EMISSAO as date) as DATA_DOC,
		cast(SCP.CP_DATPRF as date) as DATA_ITEM,
		null as FORNECEDOR,
		null as LOJA,
		null as NOME_FORNECEDOR,
		
		trim(SB1.B1_COD) as PRODUTO,
		trim(SB1.B1_DESC) as NOMEPRODUTO,
		trim(SB1.B1_GRUPO) as GRUPO_PROD,
		trim(STJ.TJ_ORDEM) as OS,
		trim(STJ.TJ_CODBEM) as EQUIPAMENTO,

		trim(SCP.CP_ITEMCTA) as ATIVIDADE,
        trim(SCP.CP_CC) as CC,
        concat(trim(SCP.CP_CONTA), ' - ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SCP.CP_CONTA)) as CONTA,
		
		trim(SCR.CR_USER) as USUARIO,
		trim(SCR.CR_APROV) as APROVA,
		trim(SCR.CR_GRUPO) as GRUPO_APROV,
		trim(SCR.CR_ITGRP) as ITEM_GRUPO,
		trim(SCR.CR_NIVEL) as NIVEL,
		cast(SCR.CR_DATALIB as date) as DATA_LIB,
		trim(SCR.CR_USERLIB) as USR_LIB,
		trim(SCR.CR_LIBAPRO) as APR_LIB,
		(select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_COD = SCR.CR_LIBAPRO) as APROVADOR,
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
    from SCP010 SCP (nolock)
        left join DBM010 DBM (nolock)
            on DBM.D_E_L_E_T_ = ''
            and DBM.DBM_FILIAL = SCP.CP_FILIAL
            and DBM.DBM_NUM = SCP.CP_NUM
            and DBM.DBM_ITEM = SCP.CP_ITEM
            and DBM.DBM_TIPO = 'SA'
            
            left join SCR010 SCR (nolock)
                on SCR.D_E_L_E_T_ = ''
                and SCR.CR_FILIAL = DBM.DBM_FILIAL
                and SCR.CR_NUM = DBM.DBM_NUM
                and SCR.CR_TIPO = DBM.DBM_TIPO
                and SCR.CR_GRUPO = DBM.DBM_GRUPO
                and SCR.CR_ITGRP = DBM.DBM_ITGRP

        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SCP.CP_PRODUTO
        left join STJ010 STJ (nolock)
            on STJ.D_E_L_E_T_ = ''
            and STJ.TJ_FILIAL = SCP.CP_FILIAL
            and STJ.TJ_ORDEM = left(SCP.CP_OP, 6)
    where
            SCP.D_E_L_E_T_ = ''
		and datediff(month, SCP.CP_EMISSAO, getdate()) < 7
