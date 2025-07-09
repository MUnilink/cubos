select
    STL.TL_FILIAL as FILIAL,
    STL.TL_ORDEM as OS,
    trim(STJ.TJ_CODBEM) as EQUIPAMENTO,
    trim(ST9.T9_NOME) as NOME,
	trim(TQR.TQR_DESMOD) as MODELO,
	trim(ST9.T9_PLACA) as PLACA,
	trim(ST9.T9_CODFAMI) as FAMILIA,
	trim(ST7.T7_NOME) as FABRICANTE,
	trim(ST9.T9_CHASSI) as CHASSI,
	trim(ST9.T9_ANOMOD) as ANOMODELO,
	trim(ST9.T9_ANOFAB) as ANOFABRIC,
	trim(ST9.T9_RENAVAM) as RENAVAM,
    (select TQ0010.TQ0_EIXOS from TQ0010 where TQ0010.D_E_L_E_T_ = '' and TQ0010.TQ0_DESENH = ST9.T9_CODFAMI and TQ0010.TQ0_TIPMOD = ST9.T9_TIPMOD) as EIXOS,
    
    cast(ST9.T9_DTBAIXA as date) as DT_BAIXA,
	trim(STJ.TJ_USUAFIM) as USR_FIM,
    trim(STJ.TJ_USUARIO) as USR_INI,
    trim(STJ.TJ_TERMINO) as TERMINO,
    trim(STJ.TJ_SITUACA) as SITUACAO,

    cast(STI.TI_DATAPLA as date) as DATA_PLANO,
    trim(STI.TI_DESCRIC) as NOME_PLANO,
    trim(STI.TI_PLANO) as NUM_PLANO,
    
    case STE.TE_CARACTE
        when 'P' then 'PREVENTIVA'
        when 'C' then 'CORRETIVA'
        else 'OUTROS'
    end as TIPO_MNT,
    
    case STJ.TJ_SERVICO when 'PNEMOV' then 'PNEUS' when 'CONSEP' then 'PNEUS' when 'REFORP' then 'PNEUS' when 'PNEROD' then 'PNEUS' else 'MNT' end as TIPO_SERV,
    
    case when isdate(concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI)) = 1 then convert(datetime, concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI), 113) else null end as DTH_INIMNT,
    case when isdate(concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI)) = 1 then convert(datetime, concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI), 113) else null end as DTH_INIPAR,
	case when isdate(concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM)) = 1 then convert(datetime, concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM), 113) else null end as DTH_FIMMNT,
    case when isdate(concat(STJ.TJ_DTPRFIM, ' ', STJ.TJ_HOPRFIM)) = 1 then convert(datetime, concat(STJ.TJ_DTPRFIM, ' ', STJ.TJ_HOPRFIM), 113) else null end as DTH_FIMPAR,

    case when isdate(concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI)) = 1 and isdate(concat(STJ.TJ_DTPRFIM, ' ', STJ.TJ_HOPRFIM)) = 1 then cast(datediff(minute, concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI), concat(STJ.TJ_DTPRFIM, ' ', STJ.TJ_HOPRFIM))/60.0 as numeric(15, 2)) else 0.0 end as TEMPO_PAR,
    case when isdate(concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI)) = 1 and isdate(concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM)) = 1 then cast(datediff(minute, concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI), concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM))/60.0 as numeric(15, 2)) else 0.0 end as TEMPO_MNT,
    
    left(STL.TL_DTFIM, 6) as PERIODO_APP,
    cast(STL.TL_DTFIM as date) as DATA_APP,
    case when isdate(concat(STL.TL_DTINICI, ' ', STL.TL_HOINICI)) = 1 then convert(datetime, concat(STL.TL_DTINICI, ' ', STL.TL_HOINICI), 120) else null end as DTHINI_APP,
	case when isdate(concat(STL.TL_DTFIM, ' ', STL.TL_HOFIM)) = 1 then convert(datetime, concat(STL.TL_DTFIM, ' ', STL.TL_HOFIM), 120) else null end as DTHFIM_APP,
	
    STL.TL_SEQRELA as ITEM_OS,
    STL.TL_LOCAL as ARMAZEM,
	STJ.TJ_POSCONT as CONTADOR,
    STL.TL_QUANTID as QTD_INSUMO,
    STJ.TJ_CCUSTO as CC,
    STJ.TJ_YITMCT as ATIVIDADE,

    case STL.TL_SEQRELA when 0 then 'PREVISTO' else 'REALIZADO' end as APP_INSUMO,
 
    trim(SB1.B1_GRUPO) as B1_GRUPO,

	case STL.TL_TIPOREG
		when 'M' then 'MÃO-DE-OBRA'
		when 'E' then 'ESPECIALIDADE'
		when 'P' then case STL.TL_ORIGNFE when 'SD1' then 'PEÇAS DIRETAS' else 'PEÇAS' end
		when 'T' then 'TERCEIROS'
		else 'OUTROS'
	end as TIPO_CUSTO,

    trim(STL.TL_CODIGO) as INSUMO,
	case STL.TL_TIPOREG
		when 'M' then trim(ST1.T1_NOME)
		when 'E' then trim(ST0.T0_NOME)
		when 'P' then trim(SB1.B1_DESC)
		when 'T' then trim(SA2.A2_NOME)
		else 'OUTROS'
	end as DESC_INSUMO,
    
    trim(STJ.TJ_TIPO) as COD_CTIPO,
    trim(STE.TE_TIPOMAN) as TE_TIPOMAN,
	trim(STE.TE_NOME) as CARAC_TIPO,
    trim(ST4.T4_SERVICO) as COD_SERVICO,
	trim(ST4.T4_NOME) as SERVICO,
    trim(STL.TL_TAREFA) as COD_TAREFA,
	trim(TT9.TT9_DESCRI) as TAREFA,
    trim(SH4.H4_CODIGO) as H4_CODIGO,
	trim(ST0.T0_ESPECIA) as T0_ESPECIA,
	trim(ST1.T1_CODFUNC) as T1_CODFUNC,
	trim(SB1.B1_COD) as COD_PRODUTO,
	trim(SB1.B1_DESC) as PRODUTO,
	trim(SA2.A2_COD) as COD_FORNECEDOR,
	trim(SA2.A2_NOME) as FORNECEDOR,
    
    trim(STL.TL_DOC) as NFE_NUM,
    trim(STL.TL_ITEM) as NFE_ITEM,
    trim(SD1.D1_PEDIDO) as PC_NUM,
    trim(SD1.D1_ITEMPC) as PC_ITEM

from STL010 STL (nolock)
    inner join STJ010 STJ (nolock)
		on STJ.D_E_L_E_T_ = ''
		and STJ.TJ_ORDEM = STL.TL_ORDEM
		and STJ.TJ_PLANO = STL.TL_PLANO
		and STJ.TJ_FILIAL = STL.TL_FILIAL

        inner join ST4010 ST4 (nolock)
            on ST4.D_E_L_E_T_ = ''
            and ST4.T4_SERVICO = STJ.TJ_SERVICO
        
        inner join ST9010 ST9 (nolock)
            on ST9.D_E_L_E_T_ = ''
            and ST9.T9_CODBEM = STJ.TJ_CODBEM

            inner join TQR010 TQR (nolock)
                on TQR.D_E_L_E_T_ = ''
                and TQR.TQR_TIPMOD = ST9.T9_TIPMOD
                
                inner join ST7010 ST7 (nolock)
                    on ST7.D_E_L_E_T_ = ''
                    and ST7.T7_FABRICA = TQR.TQR_FABRIC

        left join STI010 STI (nolock)
            on STI.D_E_L_E_T_ = ''
            and STI.TI_FILIAL = STJ.TJ_FILIAL
            and STI.TI_PLANO = STJ.TJ_PLANO
        left join STE010 STE (nolock)
            on STE.D_E_L_E_T_ = ''
            and STE.TE_TIPOMAN = STJ.TJ_TIPO
    
    left join TT9010 TT9 (nolock)
        on TT9.D_E_L_E_T_ = ''
        and TT9.TT9_TAREFA = STL.TL_TAREFA
    left join SH4010 SH4 (nolock)
        on SH4.D_E_L_E_T_ = ''
        and SH4.H4_CODIGO = STL.TL_CODIGO
    left join ST0010 ST0 (nolock)
        on ST0.D_E_L_E_T_ = ''
        and ST0.T0_ESPECIA = STL.TL_CODIGO
    left join ST1010 ST1 (nolock)
        on ST1.D_E_L_E_T_ = ''
        and ST1.T1_FILIAL = STL.TL_FILIAL
        and ST1.T1_CODFUNC = STL.TL_CODIGO
    
    left join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = STL.TL_CODIGO

    left join SD1010 SD1 (nolock)
        on STL.TL_ORIGNFE = 'SD1'
        and SD1.D_E_L_E_T_ = ''
        and SD1.D1_FILIAL = STL.TL_FILIAL
        and left(SD1.D1_OP, 6) = STL.TL_ORDEM
        and SD1.D1_DOC = STL.TL_NOTFIS
        and SD1.D1_SERIE = STL.TL_SERIE
        and SD1.D1_ITEM = STL.TL_ITEM
        and SD1.D1_FORNECE = STL.TL_FORNEC
        and SD1.D1_LOJA = STL.TL_LOJA

        left join SC7010 SC7 (nolock)
            on SC7.D_E_L_E_T_ = ''
            and SC7.C7_FILIAL = SD1.D1_FILIAL
            and SC7.C7_NUM = SD1.D1_PEDIDO
            and SC7.C7_ITEM = SD1.D1_ITEMPC

            left join SA2010 SA2 (nolock)
                on SA2.D_E_L_E_T_ = ''
                and SA2.A2_COD = SC7.C7_FORNECE
                and SA2.A2_LOJA = SC7.C7_LOJA

where
        STL.D_E_L_E_T_ = ''
    and STL.TL_SEQRELA > 0
    and STJ.TJ_SERVICO != 'PNEROD'
    and STJ.TJ_SERVICO != 'PNEMOV'

	and left(STL.TL_DTFIM, 6)>=:PERIODO
    and STE.TE_CARACTE=:TIPO_MNT
    and trim(TQR.TQR_DESMOD)=:MODELO
