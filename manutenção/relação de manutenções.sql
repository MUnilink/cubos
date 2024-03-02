select
    trim(STF.TF_CODBEM) as EQUIPAMENTO,
    trim(ST4.T4_SERVICO) as SERVICO,
    trim(ST4.T4_NOME) as DESC_SERVICO,

    trim(STF.TF_NOMEMAN) as DESC_MAN,
    trim(STF.TF_PADRAO) as PADRAO,
    convert(date, STF.TF_DTULTMA, 103) as DATA_ULTIMAN,
    cast(datediff(month, STF.TF_DTULTMA, getdate()) /30 as numeric(15,1)) as MESES_ULTIMAN,
    
    STF.TF_CONMANU as CONT_ULTIMAN,
    STF.TF_INENMAN as INCREMENTO,
    (select max(STP010.TP_ACUMCON) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STF.TF_CODBEM and STP010.TP_DTLEITU >= STF.TF_DTULTMA) as CONT_ACUM,
    (select max(STP010.TP_POSCONT) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STF.TF_CODBEM and STP010.TP_DTLEITU >= STF.TF_DTULTMA) as CONT_ATUAL,
    abs((select max(STP010.TP_ACUMCON) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STF.TF_CODBEM and STP010.TP_DTLEITU >= STF.TF_DTULTMA) - STF.TF_CONMANU) as DIFF_CONT,
    abs(STF.TF_CONMANU - (select max(STP010.TP_ACUMCON) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STF.TF_CODBEM and STP010.TP_DTLEITU >= STF.TF_DTULTMA)) - STF.TF_INENMAN as VENCIDO,
    case when (abs(STF.TF_CONMANU - (select max(STP010.TP_ACUMCON) from STP010 where STP010.D_E_L_E_T_ = '' and STP010.TP_CODBEM = STF.TF_CODBEM and STP010.TP_DTLEITU >= STF.TF_DTULTMA))) > STF.TF_INENMAN then 'ATRASADA' else 'EM DIA' end as STATUS_PREVENTIVA,
    
    STF.TF_TEENMAN as TEMPO_ENTRE,
    STF.TF_TOLECON as TOLERANCIA,
    
    case STF.TF_TIPACOM when 'T' then 'TEMPO' when 'C' then 'CONTADOR' else '-' end as TIPO_ACOMP,
    case STF.TF_UNENMAN when 'H' then 'HORAS' when 'M' then 'MES' when 'S' then 'SEMANA' else 'CONTADOR' end as UNIDADE_MAN,
    
    trim(STF.TF_PARADA) as PARADA,
    STF.TF_ATIVO as ATIVO,
    STG.TG_SEQRELA as TG_SEQRELA,
    trim(STG.TG_TAREFA) as TAREFA,
    trim(ST5.T5_DESCRIC) as DESC_TAREFA,
    trim(STG.TG_TIPOREG) as TIPO_INSUMO,
    STG.TG_CODIGO as INSUMO,

    STG.TG_QUANTID as QTD,
    STG.TG_UNIDADE as UN

from STF010 STF (nolock)    
    inner join ST4010 ST4 (nolock)
		on ST4.D_E_L_E_T_ = ''
		and ST4.T4_SERVICO = STF.TF_SERVICO
        
        inner join ST5010 ST5 (nolock)
            on ST5.D_E_L_E_T_ = ''
            and ST5.T5_SERVICO = ST4.T4_SERVICO

            inner join STG010 STG (nolock)
                on STG.D_E_L_E_T_ = ''
                and STG.TG_CODBEM = ST5.T5_CODBEM
                and STG.TG_SERVICO = ST5.T5_SERVICO
                and STG.TG_SEQRELA = ST5.T5_SEQRELA
where STF.D_E_L_E_T_ = ''
