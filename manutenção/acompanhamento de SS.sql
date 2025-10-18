select
    TQB.TQB_SOLICI as SS,
    left(TQB.TQB_DTABER, 6) PERIODO,
    convert(datetime, concat(TQB.TQB_DTABER, ' ', TQB.TQB_HOABER), 113) as DT_INISS,
    convert(datetime, concat(TQB.TQB_DTFECH, ' ', TQB.TQB_HOFECH), 113) as DT_ENCSS,
    case when TQB.TQB_DTFECH != '' then cast(datediff(minute, concat(TQB.TQB_DTABER, ' ', TQB.TQB_HOABER), concat(TQB.TQB_DTFECH, ' ', TQB.TQB_HOFECH))/60.0 as numeric(15, 2)) else 0.0 end as DURACAO_SS,
    
    case TQB.TQB_SOLUCA
        when 'A' then upper('Aguardando Analise')
        when 'D' then upper('Distribuida')
        when 'E' then upper('Encerrada')
        when 'C' then upper('Cancelada')
        else 'OUTROS'
    end as SITUACAO_SS,
    
    concat(trim(TQB.TQB_CDSERV), ' - ', (select upper(trim(TQ3010.TQ3_NMSERV)) from TQ3010 where TQ3010.D_E_L_E_T_ = '' and TQ3010.TQ3_FILIAL = TQB.TQB_FILIAL and TQ3010.TQ3_CDSERV = TQB.TQB_CDSERV)) as SERVICO_SS,
    (select upper(trim(TQ4010.TQ4_NMEXEC)) from TQ4010 where TQ4010.D_E_L_E_T_ = '' and TQ4010.TQ4_FILIAL = TQB.TQB_FILIAL and TQ4010.TQ4_CDEXEC = TQB.TQB_CDEXEC) as EXECUTA_SS,
    TQB.TQB_POSCON as CONTADOR,
    trim(ST9.T9_CODBEM) as EQUIPAMENTO,
    trim(ST9.T9_CODFAMI) as FAMILIA,
    trim(TQB.TQB_CCUSTO) as CC,
    trim(STJ.TJ_YITMCT) as ATIVIDADE,
    upper(TQB.TQB_USUARI) as USR_SS,
    
    STJ.TJ_FILIAL as FILIAL,
    STJ.TJ_ORDEM as OS,
    cast(STJ.TJ_DTORIGI as date) as DATA_OS,
    left(STJ.TJ_DTORIGI, 6) as PERIODO_OS,
	trim(upper(STJ.TJ_USUAFIM)) as USR_FIM,
    trim(upper(STJ.TJ_USUARIO)) as USR_INI,
    cast(STI.TI_DATAPLA as date) as DATA_PLANO,
    trim(STI.TI_DESCRIC) as NOME_PLANO,
    trim(STI.TI_PLANO) as NUM_PLANO,

    case STJ.TJ_TERMINO when 'S' then 'SIM' when 'N' then 'NÃO' end as TERMINO,
    case STJ.TJ_SITUACA 
        when 'C' then upper('Cancelado')
        when 'L' then upper('Liberado')
        when 'P' then upper('Pendente')
        else 'OUTROS'
    end as SITUACAO_OS,
    
    case when isdate(concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI)) = 1 then convert(datetime, concat(STJ.TJ_DTMRINI, ' ', STJ.TJ_HOMRINI), 113) else null end as DTH_INIMNT,
    case when isdate(concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI)) = 1 then convert(datetime, concat(STJ.TJ_DTPRINI, ' ', STJ.TJ_HOPRINI), 113) else null end as DTH_INIPAR,
	case when isdate(concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM)) = 1 then convert(datetime, concat(STJ.TJ_DTMRFIM, ' ', STJ.TJ_HOMRFIM), 113) else null end as DTH_FIMMNT,
    case when isdate(concat(STJ.TJ_DTPRFIM, ' ', STJ.TJ_HOPRFIM)) = 1 then convert(datetime, concat(STJ.TJ_DTPRFIM, ' ', STJ.TJ_HOPRFIM), 113) else null end as DTH_FIMPAR,

    trim(STJ.TJ_TIPO) as COD_CTIPO,
    trim(STE.TE_TIPOMAN) as TE_TIPOMAN,
	trim(STE.TE_NOME) as CARAC_TIPO,
    trim(ST4.T4_SERVICO) as COD_SERVICO,
	trim(ST4.T4_NOME) as SERVICO,
    case STJ.TJ_SERVICO when 'PNEMOV' then 'PNEUS' when 'CONSEP' then 'PNEUS' when 'REFORP' then 'PNEUS' when 'PNEROD' then 'PNEUS' else 'MNT' end as TIPO_SERV

from TQB010 TQB (nolock)
    left join STJ010 STJ (nolock)
        on STJ.D_E_L_E_T_ = ''
        and STJ.TJ_FILIAL = TQB.TQB_FILIAL
        and STJ.TJ_ORDEM = TQB.TQB_ORDEM

        left join ST4010 ST4 (nolock)
            on ST4.D_E_L_E_T_ = ''
            and ST4.T4_SERVICO = STJ.TJ_SERVICO
        left join STI010 STI (nolock)
            on STI.D_E_L_E_T_ = ''
            and STI.TI_FILIAL = STJ.TJ_FILIAL
            and STI.TI_PLANO = STJ.TJ_PLANO
        left join STE010 STE (nolock)
            on STE.D_E_L_E_T_ = ''
            and STE.TE_TIPOMAN = STJ.TJ_TIPO
    
    inner join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and ST9.T9_CODBEM = TQB.TQB_CODBEM

where TQB.D_E_L_E_T_ = ''
