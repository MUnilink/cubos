	select
		trim(SC7.C7_FILIAL) as FILIAL,
		trim(SC7.C7_NUM) as NUM,
		'PC' as TIPO,
		trim(SC7.C7_ITEM) as ITEM,
		convert(datetime, concat(SC7.C7_EMISSAO, ' ', isnull(nullif(SC7.C7_YHORAPC, ''), '23:59:59')), 113) as DATAHORA_DOC,
		convert(datetime, concat(SC7.C7_DATPRF, ' ', max(isnull(nullif(SC7.C7_YHORAPC, ''), '00:00:00')) over(partition by SC7.C7_FILIAL, SC7.C7_NUM order by SC7.C7_FILIAL, SC7.C7_NUM)), 113) as DATAHORA_ITEM,
		left(SC7.C7_EMISSAO, 6) as PERIODO,
		cast(SC7.C7_EMISSAO as date) as DATA_DOC,
		cast(SC7.C7_DATPRF as date) as DATA_ITEM,
		trim(SC7.C7_FORNECE) as FORNECEDOR,
		trim(SC7.C7_LOJA) as LOJA,
		trim(SA2.A2_NOME) as NOME_FORNECEDOR,
		
		trim(SB1.B1_COD) as PRODUTO,
		trim(SB1.B1_DESC) as NOMEPRODUTO,
		SB1.B1_UPRC as ULT_PRECO,
		concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO)) as GRUPO_PROD,
		trim(STJ.TJ_ORDEM) as OS,
		trim(STJ.TJ_CODBEM) as EQUIPAMENTO,

		trim(SC7.C7_ITEMCTA) as ATIVIDADE,
        trim(SC7.C7_CC) as CC,
        null as CONTA,
		
		trim(upper(SY1.Y1_NOME)) as SOLICITANTE,
		(select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_COD = SCR.CR_APROV) as QUEM_APROVA,
		trim(SCR.CR_APROV) as ITEM_APROVA,
		trim(SCR.CR_GRUPO) as GRUPO_APROV,
		trim(SCR.CR_ITGRP) as ITEM_GRUPO,
		trim(SCR.CR_NIVEL) as NIVEL,
		convert(datetime, concat(SCR.CR_DATALIB, ' ', SCR.CR_YHRLIB), 113) as DATAHORA_LIB,
		cast(SCR.CR_DATALIB as date) as DATA_LIB,
		(select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_USER = SCR.CR_USERLIB) as APROVADOR,
		cast(SCR.CR_VALLIB as numeric(15, 2)) as VALOR_LIB,
		cast(SCR.CR_TOTAL as numeric(15, 2)) as VALOR_DOC,
		case when SCR.CR_NUM is null then 'SEM ALÇADA' else 'COM ALÇADA' end as ALCADA,

		trim(SCR.CR_STATUS) as CR_STATUS,
		case SCR.CR_STATUS
			when 1 then 'PENDENTE'
			when 2 then 'PENDENTE'
			when 3 then 'LIBERADA'
			when 4 then 'BLOQUEADA'
			when 5 then 'LIBERADA'
			when 6 then 'REJEITADA'
			when 7 then 'REJEITADA'
			else 'OUTROS'
		end as STATUS_APROV
	
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
		left join STJ010 STJ (nolock)
			on STJ.D_E_L_E_T_ = ''
			and STJ.TJ_FILIAL = SC7.C7_FILIAL
			and concat(STJ.TJ_ORDEM, 'OS') = left(SC7.C7_OP, 8)
		left join SY1010 SY1 (nolock)
			on SY1.D_E_L_E_T_ = ''
			and SY1.Y1_USER = SC7.C7_USER
	where
			SC7.D_E_L_E_T_ = ''
		and SC7.C7_EMISSAO between :DATA_INI and :DATA_FIM
union
	select
		trim(SC1.C1_FILIAL) as FILIAL,
		trim(SC1.C1_NUM) as NUM,
		'SC' as TIPO,
		trim(SC1.C1_ITEM) as ITEM,
		convert(datetime, concat(SC1.C1_EMISSAO, ' ', isnull(nullif(SC1.C1_YHORASC, ''), '23:59:59')), 113) as DATAHORA_DOC,
		convert(datetime, concat(SC1.C1_DATPRF, ' ', max(isnull(nullif(SC1.C1_YHORASC, ''), '00:00:00')) over(partition by SC1.C1_FILIAL, SC1.C1_NUM order by SC1.C1_FILIAL, SC1.C1_NUM)), 113) as DATAHORA_ITEM,
		left(SC1.C1_EMISSAO, 6) as PERIODO,
		cast(SC1.C1_EMISSAO as date) as DATA_DOC,
		cast(SC1.C1_DATPRF as date) as DATA_ITEM,
		trim(SC1.C1_FORNECE) as FORNECEDOR,
		trim(SC1.C1_LOJA) as LOJA,
		trim(SA2.A2_NOME) as NOME_FORNECEDOR,
		
		trim(SB1.B1_COD) as PRODUTO,
		trim(SB1.B1_DESC) as NOMEPRODUTO,
		SB1.B1_UPRC as ULT_PRECO,
		concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO)) as GRUPO_PROD,
		trim(STJ.TJ_ORDEM) as OS,
		trim(STJ.TJ_CODBEM) as EQUIPAMENTO,

		trim(SC1.C1_ITEMCTA) as ATIVIDADE,
        trim(SC1.C1_CC) as CC,
        null as CONTA,
		
		trim(upper(SC1.C1_SOLICIT)) as SOLICITANTE,
		(select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_COD = SCR.CR_APROV) as QUEM_APROVA,
		trim(SCR.CR_APROV) as ITEM_APROVA,
		trim(SCR.CR_GRUPO) as GRUPO_APROV,
		trim(SCR.CR_ITGRP) as ITEM_GRUPO,
		trim(SCR.CR_NIVEL) as NIVEL,
		convert(datetime, concat(SCR.CR_DATALIB, ' ', SCR.CR_YHRLIB), 113) as DATAHORA_LIB,
		cast(SCR.CR_DATALIB as date) as DATA_LIB,
		(select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_USER = SCR.CR_USERLIB) as APROVADOR,
		cast(SCR.CR_VALLIB as numeric(15, 2)) as VALOR_LIB,
		cast(SCR.CR_TOTAL as numeric(15, 2)) as VALOR_DOC,
		case when SCR.CR_NUM is null then 'SEM ALÇADA' else 'COM ALÇADA' end as ALCADA,

		trim(SCR.CR_STATUS) as CR_STATUS,
		case SCR.CR_STATUS
			when 1 then 'PENDENTE'
			when 2 then 'PENDENTE'
			when 3 then 'LIBERADA'
			when 4 then 'BLOQUEADA'
			when 5 then 'LIBERADA'
			when 6 then 'REJEITADA'
			when 7 then 'REJEITADA'
			else 'OUTROS'
		end as STATUS_APROV
	
	from SC1010 SC1 (nolock)
		inner join SB1010 SB1 (nolock)
			on SB1.D_E_L_E_T_ = ''
			and SB1.B1_COD = SC1.C1_PRODUTO
		left join SCR010 SCR (nolock)
			on SCR.D_E_L_E_T_ = ''
			and SCR.CR_TIPO = 'SC'
			and SCR.CR_FILIAL = SC1.C1_FILIAL
			and SCR.CR_NUM = SC1.C1_NUM
		left join SA2010 SA2 (nolock)
			on SA2.D_E_L_E_T_ = ''
			and SA2.A2_COD = SC1.C1_FORNECE
			and SA2.A2_LOJA = SC1.C1_LOJA
		left join STJ010 STJ (nolock)
			on STJ.D_E_L_E_T_ = ''
			and STJ.TJ_FILIAL = SC1.C1_FILIAL
			and concat(STJ.TJ_ORDEM, 'OS') = left(SC1.C1_OP, 8)
	where
			SC1.D_E_L_E_T_ = ''
		and SC1.C1_EMISSAO between :DATA_INI and :DATA_FIM
union
	select
		trim(SCP.CP_FILIAL) as FILIAL,
		trim(SCP.CP_NUM) as NUM,
		'SA' as TIPO,
		trim(SCP.CP_ITEM) as ITEM,
		convert(datetime, concat(SCP.CP_EMISSAO, ' ', isnull(nullif(SCP.CP_YHORASA, ''), '23:59:59')), 113) as DATAHORA_DOC,
		convert(datetime, concat(SCP.CP_DATPRF, ' ', max(isnull(nullif(SCP.CP_YHORASA, ''), '00:00:00')) over(partition by SCP.CP_FILIAL, SCP.CP_NUM order by SCP.CP_FILIAL, SCP.CP_NUM)), 113) as DATAHORA_ITEM,
		left(SCP.CP_EMISSAO, 6) as PERIODO,
		cast(SCP.CP_EMISSAO as date) as DATA_DOC,
		cast(SCP.CP_DATPRF as date) as DATA_ITEM,
		null as FORNECEDOR,
		null as LOJA,
		null as NOME_FORNECEDOR,
		
		trim(SB1.B1_COD) as PRODUTO,
		trim(SB1.B1_DESC) as NOMEPRODUTO,
		SB1.B1_UPRC as ULT_PRECO,
		concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO)) as GRUPO_PROD,
		trim(STJ.TJ_ORDEM) as OS,
		trim(STJ.TJ_CODBEM) as EQUIPAMENTO,

		trim(SCP.CP_ITEMCTA) as ATIVIDADE,
        trim(SCP.CP_CC) as CC,
        concat(trim(SCP.CP_CONTA), ' - ', (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SCP.CP_CONTA)) as CONTA,
		
		(select upper(trim(SYS_USR.USR_CODIGO)) from SYS_USR where SYS_USR.D_E_L_E_T_ = '' and SYS_USR.USR_ID = SCP.CP_USER) as SOLICITANTE,
		(select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_COD = SCR.CR_APROV) as QUEM_APROVA,
		trim(SCR.CR_APROV) as ITEM_APROVA,
		trim(SCR.CR_GRUPO) as GRUPO_APROV,
		trim(SCR.CR_ITGRP) as ITEM_GRUPO,
		trim(SCR.CR_NIVEL) as NIVEL,
		convert(datetime, concat(SCR.CR_DATALIB, ' ', SCR.CR_YHRLIB), 113) as DATAHORA_LIB,
		cast(SCR.CR_DATALIB as date) as DATA_LIB,
		(select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_USER = SCR.CR_USERLIB) as APROVADOR,
		cast(SCR.CR_VALLIB as numeric(15, 2)) as VALOR_LIB,
		cast(SCR.CR_TOTAL as numeric(15, 2)) as VALOR_DOC,
		case when SCR.CR_NUM is null then 'SEM ALÇADA' else 'COM ALÇADA' end as ALCADA,

		trim(SCR.CR_STATUS) as CR_STATUS,
		case SCR.CR_STATUS
			when 1 then 'PENDENTE'
			when 2 then 'PENDENTE'
			when 3 then 'LIBERADA'
			when 4 then 'BLOQUEADA'
			when 5 then 'LIBERADA'
			when 6 then 'REJEITADA'
			when 7 then 'REJEITADA'
			else 'OUTROS'
		end as STATUS_APROV
    
	from SCP010 SCP (nolock)
		inner join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SCP.CP_PRODUTO
		left join SCR010 SCR (nolock)
			on SCR.D_E_L_E_T_ = ''
			and SCR.CR_FILIAL = SCP.CP_FILIAL
			and SCR.CR_NUM = SCP.CP_NUM
			and SCR.CR_TIPO ='SA'
        left join STJ010 STJ (nolock)
            on STJ.D_E_L_E_T_ = ''
            and STJ.TJ_FILIAL = SCP.CP_FILIAL
            and STJ.TJ_ORDEM = left(SCP.CP_OP, 6)
    where
            SCP.D_E_L_E_T_ = ''
		and SCP.CP_EMISSAO between :DATA_INI and :DATA_FIM
