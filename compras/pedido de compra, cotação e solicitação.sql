with CRSA as
(
	select
		SCR010.CR_FILIAL as FILIAL,
		SCR010.CR_NUM as NUM,
		SCR010.CR_NIVEL as NIVEL,
		SCR010.CR_STATUS as STATUS_CR,
		SCR010.CR_LIBAPRO as APR_LIB,
		SCR010.CR_USERLIB as USR_LIB,
		upper(trim(SAK010.AK_LOGIN)) as USR_APROVA,
		SCR010.CR_VALLIB as VALOR_LIB,
		SCR010.CR_TOTAL as VALOR_DOC,
		convert(datetime, concat(SCR010.CR_DATALIB, ' ', SCR010.CR_YHRLIB), 113) as DATA_HORA
	from SCR010
		left join SAK010
			on SAK010.D_E_L_E_T_ = ''
			and SAK010.AK_USER = SCR010.CR_USERLIB
	where
			SCR010.D_E_L_E_T_ = ''
		and SCR010.CR_TIPO = 'SA'
)

select
	trim(SC7.C7_FILIAL) as FILIAL,
	concat(trim(SB1.B1_COD), ' - ', trim(SB1.B1_DESC)) as PROD_NOME,
	concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO)) as GRUPO_PROD,
	trim(SB1.B1_UM) as UN,
	trim(SC7.C7_ITEMCTA) as AT,
	trim(SC7.C7_CC) as CC,
	trim(SC1.C1_NUM) as SC,
	trim(SC1.C1_ITEM) as ITEM_SC,
	trim(upper(SC1.C1_SOLICIT)) as SOLICITANTE_SC,
	left(SC1.C1_OP, 6) as OS,
	
	SC1.C1_QUANT as QTD_SC_PEDIDA,
	SC1.C1_QUJE as QTD_SC_ATENDIDA,
	case SC1.C1_RESIDUO when 'S' then 'ELIMINADA' else '' end as SC_ELIMINADA,

	SC8.C8_NUM as COTACAO,
    SC8.C8_ITEM as ITEM_COTA,
	SC8.C8_QUANT as QTD_COTADA,

	trim(SC7.C7_NUM) as PEDIDO,
	trim(SC7.C7_ITEM) as ITEM_PC,
	trim(SC7.C7_FORNECE) as FORNECEDOR,
	trim(SC7.C7_LOJA) as LOJA,
	trim(SA2.A2_NOME) as NOME_FORNECEDOR,
	trim(replace(replace(SC7.C7_OBS, char(10), ''), char(13), '')) as OBS_PC,
	trim(replace(replace(SC7.C7_OBSM, char(10), ''), char(13), '')) as MEMO_PC,

	left(SC7.C7_EMISSAO, 6) as PERIODO_PC,

	case SC7.C7_CONAPRO
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as APROVACAO_PC,

	SC7.C7_QUANT as QTD_PC_PEDIDA,
	SC7.C7_QUJE as QTD_PC_ATENDIDA,
	SC7.C7_PRECO as PC_PRECO,
	SC7.C7_TOTAL as PC_TOTAL,

	SD1.D1_DOC as NF_DOC,
	SD1.D1_SERIE as NF_SERIE,
	cast(SD1.D1_EMISSAO as date) as NF_EMI,
	cast(SD1.D1_DTDIGIT as date) as NF_DATA,
	left(SD1.D1_DTDIGIT, 6) as NF_PERIODO,

	convert(datetime, concat(SC1.C1_EMISSAO, ' ', isnull(nullif(SC1.C1_YHORASC, ''), '00:00:00')), 113) as DATA_SC,
	left(SC1.C1_EMISSAO, 6) as PERIODO_SC,
	as DATAAPROV_SC,
	datediff(minute, SC1.C1_EMISSAO, )/(60*24.0) as DIASAPROV_SC,
	cast(SC8.C8_EMISSAO as date) as DATA_COTACAO,
	datediff(minute, concat(SC7.C7_EMISSAO, ' ', isnull(nullif(SC7.C7_YHORAPC, ''), '00:00:00')), )/(60*24.0) as DIASAPROV_SC_CO,
	convert(datetime, concat(SC7.C7_EMISSAO, ' ', isnull(nullif(SC7.C7_YHORAPC, ''), '00:00:00')), 113) as DATA_PC,
	as DATAAPROV_PC,
	datediff(minute, concat(SC7.C7_EMISSAO, ' ', isnull(nullif(SC7.C7_YHORAPC, ''), '00:00:00')), )/(60*24.0) as DIASAPROV_PC,
	datediff(minute, , SD1.D1_DTDIGIT)/(60*24.0) as DIASAPROV_PC_NF

from SC7010 SC7 (nolock)
	left join SC8010 SC8 (nolock)
		on SC8.D_E_L_E_T_ = ''
		and SC8.C8_FILIAL = SC7.C7_FILIAL
		and SC8.C8_NUM = SC7.C7_NUM
		and SC8.C8_ITEM = SC7.C7_ITEM
	left join SB1010 SB1 (nolock)
		on SB1.D_E_L_E_T_ = ''
		and SB1.B1_COD = SC7.C7_PRODUTO
	inner join SA2010 SA2 (nolock)
		on SA2.D_E_L_E_T_ = ''
		and SA2.A2_COD = SC7.C7_FORNECE
		and SA2.A2_LOJA = SC7.C7_LOJA
	left join SY1010 SY1 (nolock)
		on SY1.Y1_USER = SC7.C7_USER
	left join SD1010 SD1 (nolock)
		on SD1.D_E_L_E_T_ = ''
		and SD1.D1_FILIAL = SC7.C7_FILIAL
		and SD1.D1_PEDIDO = SC7.C7_NUM
		and SD1.D1_ITEMPC = SC7.C7_ITEM

    full join SC1010 SC1
        on SC1.C1_FILIAL = SC7.C7_FILIAL
        and SC1.C1_PEDIDO = SC7.C7_NUM
        and SC1.C1_ITEMPED = SC7.C7_ITEM
        and SC1.C1_PRODUTO = SC7.C7_PRODUTO
        and SC1.D_E_L_E_T_ = ' '

        full join SCP010 SCP
            on SCP.CP_FILIAL = SC1.C1_FILIAL
            and SCP.CP_NUMSC = SC1.C1_NUM
            and SCP.CP_ITSC = SC1.C1_ITEM
            and SCP.CP_PRODUTO = SC1.C1_PRODUTO
            and SCP.D_E_L_E_T_ = ' '
where
		SC7.D_E_L_E_T_ = ''
	and SC7.C7_EMISSAO >= '20260101'
