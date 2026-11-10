with SCRSA as
(
	select
		SCR010.CR_FILIAL as FILIAL,
		SCR010.CR_NUM as DOC,
		SCR010.CR_NIVEL as NIVEL,
		SCR010.CR_STATUS as STATUS_CR,
		SCR010.CR_LIBAPRO as APR_LIB,
		SCR010.CR_USERLIB as USR_LIB,
		upper(trim(SAK010.AK_LOGIN)) as USR_APROVA,
		SCR010.CR_VALLIB as VALOR_LIB,
		SCR010.CR_TOTAL as VALOR_DOC,
		convert(datetime, concat(SCR010.CR_DATALIB, ' ', SCR010.CR_YHRLIB), 113) as DATA_HORA
	from SCR010
		inner join SAK010
			on SAK010.D_E_L_E_T_ = ''
			and SAK010.AK_USER = SCR010.CR_USERLIB
	where
			SCR010.D_E_L_E_T_ = ''
		and SCR010.CR_TIPO = 'SA'
),
SCRSC as
(
	select
		SCR010.CR_FILIAL as FILIAL,
		SCR010.CR_NUM as DOC,
		SCR010.CR_NIVEL as NIVEL,
		SCR010.CR_STATUS as STATUS_CR,
		SCR010.CR_LIBAPRO as APR_LIB,
		SCR010.CR_USERLIB as USR_LIB,
		upper(trim(SAK010.AK_LOGIN)) as USR_APROVA,
		SCR010.CR_VALLIB as VALOR_LIB,
		SCR010.CR_TOTAL as VALOR_DOC,
		convert(datetime, concat(SCR010.CR_DATALIB, ' ', SCR010.CR_YHRLIB), 113) as DATA_HORA
	from SCR010
		inner join SAK010
			on SAK010.D_E_L_E_T_ = ''
			and SAK010.AK_USER = SCR010.CR_USERLIB
	where
			SCR010.D_E_L_E_T_ = ''
		and SCR010.CR_TIPO = 'SC'
),
SCRPC as
(
	select
		SCR010.CR_FILIAL as FILIAL,
		SCR010.CR_NUM as DOC,
		SCR010.CR_NIVEL as NIVEL,
		SCR010.CR_STATUS as STATUS_CR,
		SCR010.CR_LIBAPRO as APR_LIB,
		SCR010.CR_USERLIB as USR_LIB,
		upper(trim(SAK010.AK_LOGIN)) as USR_APROVA,
		SCR010.CR_VALLIB as VALOR_LIB,
		SCR010.CR_TOTAL as VALOR_DOC,
		convert(datetime, concat(SCR010.CR_DATALIB, ' ', SCR010.CR_YHRLIB), 113) as DATA_HORA
	from SCR010
		inner join SAK010
			on SAK010.D_E_L_E_T_ = ''
			and SAK010.AK_USER = SCR010.CR_USERLIB
	where
			SCR010.D_E_L_E_T_ = ''
		and SCR010.CR_TIPO = 'PC'
)
SELECT
    'P |01|01' AS BK_EMPRESA,
    concat('SF1', trim(SD1.D1_FILIAL), trim(SD1.D1_FORNECE), trim(SD1.D1_LOJA), trim(SD1.D1_DOC), trim(SD1.D1_SERIE)) as ID_NF,
    concat(trim(SC7.C7_FILIAL), trim(SC7.C7_NUM)) as ID_PEDIDO,
    concat(trim(SC1.C1_FILIAL), trim(SC1.C1_NUM)) as ID_SOLICITACAO,
    case when SD1.D1_FILIAL is null then 'P |01||' else 'P |01|01'+ CAST(SD1.D1_FILIAL as char (6)) end as BK_FILIAL,
    'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_COD, ' ')), ' '), '|') AS BK_ITEM,
    'P |01|SBM010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SBM.BM_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_GRUPO, ' ')), ' '), '|') AS BK_GRUPO_ESTOQUE,
    'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_FORNECE, ' '))+RTRIM(COALESCE(SD1.D1_LOJA, ' ')), ' '), '|') AS BK_FORNECEDOR,
    'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(GRPFOR.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA2.A2_GRUPO, ' ')), ' '), '|') AS BK_GRUPO_FORNECEDOR,
    'P |01|SA4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA4.A4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SF1.F1_TRANSP, ' ')), ' '), '|') AS BK_TRANSPORTADORA,
    'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(FAMAT.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_TIPO, ' ')), ' '), '|') AS BK_FAMILIA_MATERIAL,
    'P |01|ACU010|'+ COALESCE(NULLIF(RTRIM(COALESCE(ACU.ACU_FILIAL, ' '))+'|'+RTRIM(COALESCE(ACU.ACU_COD, ' ')), ' '), '|') AS BK_FAMILIA_COMERCIAL,
    'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_DIG.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_DIG.Y1_COD, ' ')), ' '), '|') AS BK_COMPRADOR,
    'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SF1.F1_COND, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO,
    'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CFOP.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_CF, ' ')), ' '), '|') AS BK_CFOP,
    'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_CC, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
    'P |01|SF4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SF4.F4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_TES, ' ')), ' '), '|') AS BK_TES,
    'P |01|SAH010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAH.AH_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_UM, ' ')), ' '), '|') AS BK_UNIDADE_DE_MEDIDA,
    case when SA2.A2_COD_MUN = ' ' then 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_EST, ' ')), ' '), '|') else 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_EST, ' '))+RTRIM(COALESCE(SA2.A2_COD_MUN, ' ')), ' '), '|') end as BK_REGIAO,
    'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_ITEMCTA, ' ')), ' '), '|') AS BK_ITEM_CONTABIL,
    
    case when Y1_COM.Y1_COD is null or Y1_COM.Y1_COD = ''
        then 'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_DIG.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_DIG.Y1_COD, ' ')), ' '), '|')
        else 'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_COM.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_COM.Y1_COD, ' ')), ' '), '|')
    end as ID_NEGOCIADOR,
    
    case
        when (SC7.C7_QUJE > 0) and (SC7.C7_QUJE < SC7.C7_QUANT) then 'P |'+ COALESCE(NULLIF(RTRIM(COALESCE('R', ' ')), ' '), '|')
        when (SC7.C7_QUJE >= SC7.C7_QUANT) then 'P |'+ COALESCE(NULLIF(RTRIM(COALESCE('I', ' ')), ' '), '|')
    else 'P |'+'|' end as BK_SITUACAO_COMPRA,
    
    (
        select top 1 'P |01|SAK010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAK010.AK_FILIAL, ' '))+'|'+RTRIM(COALESCE(SAK010.AK_COD, ' ')), ' '), '|')
        from SCR010 SCR
            inner join SAK010
                on SAK010.D_E_L_E_T_ = ''
                and SAK010.AK_COD = SCR.CR_LIBAPRO
        where
                SCR.D_E_L_E_T_ = ''
            and SCR.CR_NIVEL =
            (
                select max(SCR010.CR_NIVEL)
                from SCR010 (nolock)
                where
                        SCR010.D_E_L_E_T_ = ''
                    and SCR010.CR_FILIAL = SCR.CR_FILIAL
                    and SCR010.CR_TIPO = SCR.CR_TIPO
                    and SCR010.CR_NUM = SCR.CR_NUM
                group by
                    SCR010.CR_FILIAL,
                    SCR010.CR_TIPO,
                    SCR010.CR_NUM
            )
            and SCR.CR_STATUS = 3
            and SCR.CR_FILIAL = SC7.C7_FILIAL
            and SCR.CR_NUM = SC7.C7_NUM
    ) as BK_APROVOU_PC,

    (
        select top 1 'P |01|SAK010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAK010.AK_FILIAL, ' '))+'|'+RTRIM(COALESCE(SAK010.AK_COD, ' ')), ' '), '|')
        from SCR010 SCR
            inner join SAK010
                on SAK010.D_E_L_E_T_ = ''
                and SAK010.AK_COD = SCR.CR_LIBAPRO
        where
            SCR.D_E_L_E_T_ = ''
            and SCR.CR_NIVEL =
            (
                select max(SCR010.CR_NIVEL)
                from SCR010 (nolock)
                where
                        SCR010.D_E_L_E_T_ = ''
                    and SCR010.CR_FILIAL = SCR.CR_FILIAL
                    and SCR010.CR_TIPO = SCR.CR_TIPO
                    and SCR010.CR_NUM = SCR.CR_NUM
                group by
                    SCR010.CR_FILIAL,
                    SCR010.CR_TIPO,
                    SCR010.CR_NUM
            )
            and SCR.CR_STATUS = 3
            and SCR.CR_FILIAL = SC1.C1_FILIAL
            and SCR.CR_NUM = SC1.C1_NUM
    ) as BK_APROVOU_SC,
    
    null as BK_APROVOU_SA,

    SD1.D1_QUANT as QTD_ATENDIDA,
    SD1.D1_TOTAL as VALOR_TOTAL,

    trim(concat(SC1.C1_EMISSAO, ' ', SC1.C1_YHORASC)) as DATA_SC,
    trim(SD1.D1_EMISSAO) as DATA_EMINF,
    trim(concat(SF1.F1_DTDIGIT, ' ', SF1.F1_YHORANF)) as DATA_DIGNF, /* data */
    trim(concat(SC7.C7_EMISSAO, ' ', SC7.C7_YHORAPC)) as DATA_EMIPC,
    trim(SC7.C7_DATPRF) as DATA_PRVPC,
    
    SCRPC.DATA_HORA as DATAAPROV_PC, /* data aprovação PC */
    SCRSC.DATA_HORA as DATAAPROV_SC, /* data aprovação SC */

    SCP.CP_EMISSAO as DATA_SA, /* data emissão SA * ver datas "reais", pois SAs costumam manter a data original */
    SCRSA.DATA_HORA as DATAAPROV_SA, /* data aprovação SA */

    datediff(minute, SCP.CP_EMISSAO, SCRSA.DATA_HORA) as tempoAprovaSA,
    datediff(minute, SCRSA.DATA_HORA, trim(concat(SC1.C1_EMISSAO, ' ', SC1.C1_YHORASC))) as tempoEmiteSC,
    datediff(minute, trim(concat(SC1.C1_EMISSAO, ' ', SC1.C1_YHORASC)), SCRSC.DATA_HORA) as tempoAprovaSC,
    datediff(minute, SCRSC.DATA_HORA, trim(concat(SC7.C7_EMISSAO, ' ', SC7.C7_YHORAPC))) as tempoEmitePC,
    datediff(minute, trim(concat(SC7.C7_EMISSAO, ' ', SC7.C7_YHORAPC)), SCRPC.DATA_HORA) as tempoAprovaPC,
    datediff(minute, SCRPC.DATA_HORA, trim(concat(SF1.F1_DTDIGIT, ' ', SF1.F1_YHORANF))) as tempoClassNF,
    
    case
        when
            (COALESCE(SC7.C7_DATPRF, ' ') = ' ')
            or (SC7.C7_DATPRF = NULL)
            or (COALESCE(SD1.D1_DTDIGIT, ' ') = ' ')
            or (SD1.D1_DTDIGIT = NULL)
            or (SD1.D1_DTDIGIT > SC7.C7_DATPRF)
        then 0
        else datediff(day, SD1.D1_DTDIGIT, SC7.C7_DATPRF)
    end as QTD_DIAS_ADIANTADO,
    case
        when
            (COALESCE(SC7.C7_DATPRF, ' ') = ' ')
            or (SC7.C7_DATPRF = NULL)
            or (COALESCE(SD1.D1_DTDIGIT, ' ') = ' ')
            or (SD1.D1_DTDIGIT = NULL)
            or (SC7.C7_DATPRF > SD1.D1_DTDIGIT)
        then 0
        else datediff(day, SC7.C7_DATPRF, SD1.D1_DTDIGIT)
    end as QTD_DIAS_ATRASO,
    
    case when datediff(day, SD1.D1_DTDIGIT, SC7.C7_DATPRF) > 0 then 1 else 0 end as QTD_ADIANTADA, /* diferença entre data classificação e data prevista */
    case when datediff(day, SC7.C7_DATPRF, SD1.D1_DTDIGIT) < 0 then 1 else 0 end as QTD_ATRASADA, /* diferença entre data prevista e data classificação */
    case when (datediff(day, SD1.D1_DTDIGIT, SC7.C7_DATPRF) = 0) and (datediff(day, SC7.C7_DATPRF, SD1.D1_DTDIGIT) = 0) then 1 else 0 end as QTD_EMDIA, /* recebimento em dia */
    case when (SD1.D1_QUANT >= SC7.C7_QUANT) then 1 else 0 end as QRECUN /* se quantidade atendida maior que quantidade pedida */

FROM SD1010 SD1
    LEFT JOIN SB1010 SB1
        ON SB1.B1_FILIAL = '      '
        AND SB1.B1_COD = SD1.D1_COD
        AND SB1.D_E_L_E_T_ = ' '
        
        LEFT JOIN SBM010 SBM
            ON SBM.BM_FILIAL = SB1.B1_FILIAL
            AND SBM.BM_GRUPO = SB1.B1_GRUPO
            AND SBM.D_E_L_E_T_ = ' '
        LEFT JOIN SX5010 FAMAT
            ON FAMAT.X5_FILIAL = '      '
            AND FAMAT.X5_TABELA = '02'
            AND FAMAT.X5_CHAVE = B1_TIPO
            AND FAMAT.D_E_L_E_T_ = ' '

    LEFT JOIN SA2010 SA2
        ON SA2.A2_FILIAL = '      '
        AND SA2.A2_COD = SD1.D1_FORNECE
        AND SA2.A2_LOJA = SD1.D1_LOJA
        AND SA2.D_E_L_E_T_ = ' '

        LEFT JOIN SX5010 GRPFOR
            ON GRPFOR.X5_FILIAL = '      '
            AND GRPFOR.X5_TABELA = 'Y7'
            AND GRPFOR.X5_CHAVE = SA2.A2_GRUPO
            AND GRPFOR.D_E_L_E_T_ = ' '
    
    LEFT JOIN CTT010 CTT
        ON CTT.CTT_FILIAL = substring(SD1.D1_FILIAL, 1, 4)
        AND CTT.CTT_CUSTO = SD1.D1_CC
        AND CTT.D_E_L_E_T_ = ' '
    LEFT JOIN CTD010 CTD
        ON CTD.CTD_FILIAL = '      '
        AND CTD.CTD_ITEM = SD1.D1_ITEMCTA
        AND CTD.D_E_L_E_T_ = ' '
    left join SF1010 SF1
        on SF1.F1_FILIAL = SD1.D1_FILIAL
        and SF1.F1_DOC = SD1.D1_DOC
        and SF1.F1_SERIE = SD1.D1_SERIE
        and SF1.F1_FORNECE = SD1.D1_FORNECE
        and SF1.F1_LOJA = SD1.D1_LOJA
        and SF1.D_E_L_E_T_ = ' '
        
        LEFT JOIN SA4010 SA4
            ON SA4.A4_FILIAL = '      '
            AND SA4.A4_COD = SF1.F1_TRANSP
            AND SA4.D_E_L_E_T_ = ' '
        LEFT JOIN SE4010 SE4
            ON SE4.E4_FILIAL = '      '
            AND SE4.E4_CODIGO = SF1.F1_COND
            AND SE4.D_E_L_E_T_ = ' '
    
    LEFT JOIN ACV010 ACV
        ON ACV.ACV_FILIAL = substring(SD1.D1_FILIAL, 1, 4)
        AND ACV.ACV_CODPRO = SD1.D1_COD
        AND ACV.D_E_L_E_T_ = ' '
        
        LEFT JOIN ACU010 ACU
            ON ACU.ACU_FILIAL = ACV.ACV_FILIAL
            AND ACU.ACU_COD = ACV.ACV_CATEGO
            AND ACU.D_E_L_E_T_ = ' '
    
    inner join SC7010 SC7
        on SC7.C7_FILIAL = SD1.D1_FILIAL
        and SC7.C7_NUM = SD1.D1_PEDIDO
        and SC7.C7_ITEM = SD1.D1_ITEMPC
        and SC7.C7_PRODUTO = SD1.D1_COD
        and SC7.D_E_L_E_T_ = ' '
        
        left join SY1010 Y1_DIG
            on Y1_DIG.Y1_FILIAL = left(SC7.C7_FILIAL, 2)
            and Y1_DIG.Y1_USER = SC7.C7_USER
            and Y1_DIG.Y1_COD not in (1, 6, 11, 19)
        left join SY1010 Y1_COM
            on Y1_COM.Y1_FILIAL = left(SC7.C7_FILIAL, 2)
            and Y1_COM.Y1_COD = SC7.C7_YNEGOCI
            and Y1_COM.Y1_COD not in (1, 6, 11, 19)

            left join SCRPC
                on CRPC.FILIAL = SC7.C7_FILIAL
                and CRPC.DOC = SC7.C7_NUM

            left join SC1010 SC1
                on SC1.C1_FILIAL = SC7.C7_FILIAL
                and SC1.C1_PEDIDO = SC7.C7_NUM
                and SC1.C1_ITEMPED = SC7.C7_ITEM
                and SC1.C1_PRODUTO = SC7.C7_PRODUTO
                and SC1.D_E_L_E_T_ = ' '

                left join SCRSC
                    on CRSC.FILIAL = SC1.C1_FILIAL
                    and CRSC.DOC = SC1.C1_NUM

                left join SCP010 SCP
                    on SCP.CP_FILIAL = SC1.C1_FILIAL
                    and SCP.CP_NUMSC = SC1.C1_NUM
                    and SCP.CP_ITSC = SC1.C1_ITEM
                    and SCP.CP_PRODUTO = SC1.C1_PRODUTO
                    and SCP.D_E_L_E_T_ = ' '

                    left join SCRSA
                        on CRSA.FILIAL = SCP.CP_FILIAL
                        and CRSA.DOC = SCP.CP_NUM
    
    LEFT JOIN SX5010 CFOP
        ON CFOP.X5_FILIAL = '      '
        AND CFOP.X5_TABELA = '13'
        AND CFOP.X5_CHAVE = SD1.D1_CF
        AND CFOP.D_E_L_E_T_ = ' '
    LEFT JOIN SF4010 SF4
        ON SF4.F4_FILIAL = '      '
        AND SF4.F4_CODIGO = SD1.D1_TES
        AND SF4.D_E_L_E_T_ = ' '
    LEFT JOIN SAH010 SAH
        ON SAH.AH_FILIAL = '      '
        AND SAH.AH_UNIMED = SD1.D1_UM
        AND SAH.D_E_L_E_T_ = ' '
WHERE
        SD1.D1_DTDIGIT > '20240101'
    and SD1.D1_ORIGLAN <> 'LF'
    and SD1.D1_TIPO NOT IN ('D', 'B')
    and SD1.D_E_L_E_T_ = ' '
