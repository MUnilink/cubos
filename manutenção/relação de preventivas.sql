select
    trim(STI.TI_FILIAL) as FILIAL,
    convert(date, STI.TI_DATAPLA, 103) as PERIODO,
    trim(STI.TI_DESCRIC) as NOME_PLANO,

    trim(STJ.TJ_CCUSTO) as CC,
    trim(STJ.TJ_CODBEM) as EQUIPAMENTO,
    trim(STJ.TJ_ORDEM) as OS,
    trim(STJ.TJ_PLANO) as PLANO,
    trim(STJ.TJ_SERVICO) as SERVICO,
    STJ.TJ_SEQRELA as SEQ_OS,
    case STJ.TJ_SITUACA when 'L' then 'LIBERADA' when 'P' then 'PENDENTE' else 'CANCELADA' end as STATUS_OS,

    trim(STF.TF_NOMEMAN) as DESC_MAN,
    trim(STF.TF_PADRAO) as PADRAO,
    convert(date, STF.TF_DTULTMA, 103) as DATA_ULTIMAN,
    cast(datediff(month, STF.TF_DTULTMA, getdate()) /30 as numeric(15,1)) as MESES_ULTIMAN,
    
    STF.TF_CONMANU as CONT_ULTIMAN,
    STF.TF_INENMAN as INCREMENTO,
    (select max(STP010.TP_POSCONT) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STJ.TJ_CODBEM and STP010.TP_DTLEITU >= STF.TF_DTULTMA) as CONT_ATUAL,
    abs(STF.TF_CONMANU - (select max(STP010.TP_POSCONT) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STJ.TJ_CODBEM and STP010.TP_DTLEITU >= STF.TF_DTULTMA)) as DIFF_CONT,
    case when (abs(STF.TF_CONMANU - (select max(STP010.TP_POSCONT) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STJ.TJ_CODBEM and STP010.TP_DTLEITU >= STF.TF_DTULTMA))) > STF.TF_INENMAN then 'ATRASADA' else 'EM DIA' end as STATUS_PREVENTIVA,
    
    STF.TF_TEENMAN as TEMPO_ENTRE,
    STF.TF_TOLECON as TOLERANCIA,
    
    case STF.TF_TIPACOM when 'T' then 'TEMPO' when 'C' then 'CONTADOR' else '-' end as TIPO_ACOMP,
    case STF.TF_UNENMAN when 'H' then 'HORAS' when 'M' then 'MES' when 'S' then 'SEMANA' else 'CONTADOR' end as UNIDADE_MAN,
    
    trim(STF.TF_PARADA) as PARADA,
    STF.TF_ATIVO as ATIVO,
    STG.TG_SEQRELA as TG_SEQRELA,
    trim(STG.TG_TAREFA) as TAREFA,
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
    STG.TG_LOCAL as ARMAZEM,

    SB2.B2_FILIAL,
    SB2.B2_LOCAL,
    SB2.B2_COD,
    SB2.B2_QFIM,
    SB2.B2_QATU,
    SB2.B2_VFIM1,
    SB2.B2_VATU1,
    SB2.B2_CM1

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

            left join SB1010 SB1 (nolock)
                on SB1.D_E_L_E_T_ = ''
                and SB1.B1_COD = STG.TG_CODIGO
    
            left join SB2010 SB2 (nolock)
                on SB2.D_E_L_E_T_ = ''
                and SB2.B2_COD = STG.TG_CODIGO
                and SB2.B2_LOCAL = STG.TG_LOCAL

where STJ.D_E_L_E_T_ = '' and substring(STI.TI_DATAPLA, 1, 6) > '202112'
