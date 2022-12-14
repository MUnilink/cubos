select
    trim(STI.TI_FILIAL) as FILIAL,
    convert(date, STI.TI_DATAPLA, 103) as PERIODO,
    trim(STI.TI_DESCRIC) as NOME_PLANO,

    trim(STJ.TJ_CCUSTO) as CC,
    trim(STJ.TJ_CODBEM) as EQUIPAMENTO,
    trim(STJ.TJ_ORDEM) as OS,
    trim(STJ.TJ_PLANO) as PLANO,
    trim(STJ.TJ_SERVICO) as SERVICO,
    trim(STJ.TJ_TERMINO) as ENCERRADA,
    convert(date, STJ.TJ_DTMRINI, 103) as DT_INI_OS,
    convert(date, STJ.TJ_DTMRFIM, 103) as DT_FIM_OS,
    trim(isnull(ST4.T4_NOME, '-')) as DESC_SERVICO,

    STJ.TJ_SEQRELA as SEQ_OS,
    case STJ.TJ_SITUACA when 'L' then 'LIBERADA' when 'P' then 'PENDENTE' else 'CANCELADA' end as STATUS_OS,
    case STJ.TJ_SITUACA when 'L' then (select top 1 STL010.TL_NUMSA from STL010 where STL010.D_E_L_E_T_ = '' and STL010.TL_ORDEM = STJ.TJ_ORDEM and STL010.TL_FILIAL = STJ.TJ_FILIAL and STL010.TL_PLANO = STJ.TJ_PLANO) when 'C' then 999999 else 0 end as SA,

    trim(STF.TF_NOMEMAN) as DESC_MAN,
    trim(STF.TF_PADRAO) as PADRAO,
    convert(date, STF.TF_DTULTMA, 103) as DATA_ULTIMAN,
    cast(datediff(month, STF.TF_DTULTMA, getdate()) /30 as numeric(15,1)) as MESES_ULTIMAN,
    
    STF.TF_CONMANU as CONT_ULTIMAN,
    STF.TF_INENMAN as INCREMENTO,
    (select max(STP010.TP_ACUMCON) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STJ.TJ_CODBEM and STP010.TP_DTLEITU >= STF.TF_DTULTMA) as CONT_ACUM,
    (select max(STP010.TP_POSCONT) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STJ.TJ_CODBEM and STP010.TP_DTLEITU >= STF.TF_DTULTMA) as CONT_ATUAL,
    abs((select max(STP010.TP_ACUMCON) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STJ.TJ_CODBEM and STP010.TP_DTLEITU >= STF.TF_DTULTMA) - STF.TF_CONMANU) as DIFF_CONT,
    abs(STF.TF_CONMANU - (select max(STP010.TP_ACUMCON) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STJ.TJ_CODBEM and STP010.TP_DTLEITU >= STF.TF_DTULTMA)) - STF.TF_INENMAN as VENCIDO,
    case when (abs(STF.TF_CONMANU - (select max(STP010.TP_ACUMCON) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STJ.TJ_CODBEM and STP010.TP_DTLEITU >= STF.TF_DTULTMA))) > STF.TF_INENMAN then 'ATRASADA' else 'EM DIA' end as STATUS_PREVENTIVA,
    
    STF.TF_TEENMAN as TEMPO_ENTRE,
    STF.TF_TOLECON as TOLERANCIA,
    
    case STF.TF_TIPACOM when 'T' then 'TEMPO' when 'C' then 'CONTADOR' else '-' end as TIPO_ACOMP,
    case STF.TF_UNENMAN when 'H' then 'HORAS' when 'M' then 'MES' when 'S' then 'SEMANA' else 'CONTADOR' end as UNIDADE_MAN,
    
    trim(STF.TF_PARADA) as PARADA,
    STF.TF_ATIVO as ATIVO,
    STG.TG_SEQRELA as TG_SEQRELA,
    trim(STG.TG_TAREFA) as TAREFA,
    trim(isnull(TT9.TT9_DESCRI, '-')) as DESC_TAREFA,
    trim(STG.TG_TIPOREG) as TIPO_INSUMO,
    STG.TG_CODIGO as INSUMO,

    (
        select count(*)
        from STF010 (nolock)
            inner join STG010 (nolock)
                on STG010.D_E_L_E_T_ = ''
                and STG010.TG_CODBEM = STF010.TF_CODBEM
                and STG010.TG_SERVICO = STF010.TF_SERVICO
                and STG010.TG_SEQRELA = STF010.TF_SEQRELA
        where
                STF010.D_E_L_E_T_ = ''
            and STG010.TG_CODIGO = STG.TG_CODIGO
            and STF010.TF_CONMANU = STF.TF_CONMANU
            and STF010.TF_CODBEM = STJ.TJ_CODBEM
    ) as contador,

    trim(SB1.B1_DESC) as PRODUTO,
    case SB1.B1_MSBLQL when 1 then 'SIM' else 'NAO' end as BLOQUEADO,
    STG.TG_QUANTID as QTD,
    STG.TG_UNIDADE as UN,
    STG.TG_LOCAL as ARMAZEM

from STJ010 STJ (nolock)
    inner join STI010 STI (nolock)
        on STI.D_E_L_E_T_ = ''
        and STI.TI_FILIAL = STJ.TJ_FILIAL
        and STI.TI_PLANO = STJ.TJ_PLANO
    inner join STF010 STF (nolock)
        on STF.D_E_L_E_T_ = ''
        and STF.TF_CODBEM = STJ.TJ_CODBEM
        and STF.TF_SERVICO = STJ.TJ_SERVICO
        and STF.TF_SEQRELA = STJ.TJ_SEQRELA

        inner join STG010 STG (nolock)
            on STG.D_E_L_E_T_ = ''
            and STG.TG_CODBEM = STF.TF_CODBEM
            and STG.TG_SERVICO = STF.TF_SERVICO
            and STG.TG_SEQRELA = STF.TF_SEQRELA

            left join TT9010 TT9 (nolock)
                on TT9.D_E_L_E_T_ = ''
                and TT9.TT9_TAREFA = STG.TG_TAREFA
            left join SB1010 SB1 (nolock)
                on SB1.D_E_L_E_T_ = ''
                and SB1.B1_COD = STG.TG_CODIGO
    
    inner join ST4010 ST4 (nolock)
		on ST4.D_E_L_E_T_ = ''
		and ST4.T4_SERVICO = STJ.TJ_SERVICO
where STJ.D_E_L_E_T_ = '' and substring(STI.TI_DATAPLA, 1, 6) > '202112'
