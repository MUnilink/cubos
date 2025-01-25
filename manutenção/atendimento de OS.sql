select
    STL.TL_FILIAL as FILIAL,
    STL.TL_ORDEM as OS,
    trim(STJ.TJ_CODBEM) as EQUIPAMENTO,
    cast(STJ.TJ_DTORIGI as date) as DATA_OS,
    left(STJ.TJ_DTORIGI, 6) as PERIODO_OS,
    ST9.T9_CODFAMI as FAMILIA,
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
    
    case when SCP.CP_QUANT = SCP.CP_QUJE then 'TOT. ATENDIDA'
    else
        case when SCP.CP_QUJE = 0.0 then 'PENDENTE'
        else
            case when SCP.CP_QUANT > SCP.CP_QUJE then 'PARC. ATENDIDA'
            else 'OUTROS'
            end
        end
    end as APP_PRODUTO,

    SCP.CP_NUM as NUM_SA,
    SCP.CP_ITEM as ITEM_SA,
    SCP.CP_UM as UN,
    SCP.CP_QUANT as QTD_SOLICTADA,
    SCP.CP_QUJE as QTD_ATENDIDA,
    trim(SB1.B1_GRUPO) as B1_GRUPO,

    case when STL.TL_TIPOREG = 'P' and STL.TL_DOC = '' then 'NÃO ATENDIDA'
    else
        case when STL.TL_TIPOREG = 'P' and STL.TL_DOC != '' then 'ATENDIDA'
        else
            case when STL.TL_TIPOREG = 'M' then 'MDO REALIZADA'
            else
                case when STL.TL_TIPOREG = 'T' then 'EXTERNO'
                else
                    case when STL.TL_TIPOREG = 'E' then 'MDO PREVISTA'
                    else 'OUTROS'
                    end
                end
            end
        end
    end as ATENDIMENTO,

	case STL.TL_TIPOREG
		when 'M' then 'MÃO-DE-OBRA'
		when 'E' then 'ESPECIALIDADE'
		when 'P' then 'PEÇAS'
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

    TQB.TQB_SOLICI as SS,
    convert(datetime, concat(TQB.TQB_DTABER, ' ', TQB.TQB_HOABER), 113) as DT_INISS,
    convert(datetime, concat(TQB.TQB_DTFECH, ' ', TQB.TQB_HOFECH), 113) as DT_ENCSS,
    TQB.TQB_USUARI,
    TQB.TQB_SOLUCA,
    TQB.TQB_CDEXEC,

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
        left join TQB010 TQB (nolock)
            on TQB.D_E_L_E_T_ = ''
            and TQB.TQB_FILIAL = STJ.TJ_FILIAL
            and TQB.TQB_ORDEM = STJ.TJ_ORDEM
    
    left join SCP010 SCP (nolock)
        on SCP.D_E_L_E_T_ = ''
        and SCP.CP_FILIAL = STL.TL_FILIAL
        and SCP.CP_NUM = STL.TL_NUMSA
        and SCP.CP_ITEM = STL.TL_ITEMSA
    left join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = STL.TL_CODIGO            
    left join TT9010 TT9 (nolock)
        on TT9.D_E_L_E_T_ = ''
        and TT9.TT9_TAREFA = STL.TL_TAREFA
    left join SA2010 SA2 (nolock)
        on SA2.D_E_L_E_T_ = ''
        and SA2.A2_COD + SA2.A2_LOJA = STL.TL_FORNEC + STL.TL_LOJA
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
    left join STI010 STI (nolock)
        on STI.D_E_L_E_T_ = ''
        and STI.TI_FILIAL = STL.TL_FILIAL
        and STI.TI_PLANO = STL.TL_PLANO
    left join STE010 STE (nolock)
        on STE.D_E_L_E_T_ = ''
        and STE.TE_TIPOMAN = STJ.TJ_TIPO
where STL.D_E_L_E_T_ = ''
