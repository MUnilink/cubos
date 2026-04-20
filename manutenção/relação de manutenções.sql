select distinct
    trim(STF.TF_CODBEM) as EQUIPAMENTO,
    trim(TQR.TQR_DESMOD) as MODELO,
    trim(ST7.T7_NOME) as FABRICANTE,
    trim(ST9.T9_RENAVAM) as RENAVAM,
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

    ST5.T5_SEQRELA as SEQ_TAREFA_MNT,
    trim(ST5.T5_TAREFA) as COD_TAREFA_MNT,
    trim(ST5.T5_DESCRIC) as TAREFA_MNT,
    case ST5.T5_ATIVA when '1' then 'S' else 'N' end as ATIVA_TAREFA_MNT,

    STG.TG_SEQRELA as SEQ_TAREFA_ITEM,
    trim(TAR_ITEM.TT9_TAREFA) as TAREFA_ITEM,
    trim(TAR_ITEM.TT9_DESCRI) as DESC_TAREFA_ITEM,
    trim(STG.TG_TIPOREG) as TIPO,
    trim(STG.TG_CODIGO) as CODIGO,
    STG.TG_QUANREC as QTD_RECURSO,
    STG.TG_QUANTID as QTD_PREVIST,
    STG.TG_UNIDADE as UN_ITEM,
    
    case STG.TG_TIPOREG
        when 'M' then trim(ST1.T1_NOME)
		when 'E' then trim(ST0.T0_NOME)
		when 'P' then trim(SB1.B1_DESC)
		when 'T' then trim(SA2.A2_NOME)
		else 'OUTROS'
	end as DESC_INSUMO,

    STH.TH_SEQRELA as SEQ_TAREFA_ETAPA,
    trim(TAR_ETAPA.TT9_TAREFA) as TAREFA_ETAPA,
    trim(TAR_ETAPA.TT9_DESCRI) as DESC_TAREFA_ETAPA,
    'h' as UN_ETAPA,
    trim(STH.TH_ETAPA) as CODETAPA,
    trim(TPA.TPA_DESCRI) as ETAPA,
    cast((left(TPA.TPA_TEMPOM, 2) + right(trim(TPA.TPA_TEMPOM), 2)/60.0) as numeric(15, 2)) as TEMPO_ETAPA,
    case TPA.TPA_BLOQPT when '1' then 'S' else 'N' end as BLOQ_ETAPA
    
from STF010 STF (nolock)    
    left join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and ST9.T9_CODBEM = STF.TF_CODBEM
    
        left join TQR010 TQR (nolock)
            on TQR.D_E_L_E_T_ = ''
            and TQR.TQR_TIPMOD = ST9.T9_TIPMOD
            
            left join ST7010 ST7 (nolock)
                on ST7.D_E_L_E_T_ = ''
                and TQR.TQR_FABRIC = ST7.T7_FABRICA
    
    inner join ST4010 ST4 (nolock)
        on STF.D_E_L_E_T_ = ''
        and STF.TF_SERVICO = ST4.T4_SERVICO
    left join ST5010 ST5 (nolock)
        on ST5.D_E_L_E_T_ = ''
        and STF.TF_CODBEM = ST5.T5_CODBEM
        and STF.TF_SERVICO = ST5.T5_SERVICO
        and STF.TF_SEQRELA = ST5.T5_SEQRELA
    
        left join STH010 STH (nolock)
            on STH.D_E_L_E_T_ = ''
            and STH.TH_CODBEM = ST5.T5_CODBEM
            and STH.TH_TAREFA = ST5.T5_TAREFA
            and STH.TH_SERVICO = ST5.T5_SERVICO
            and STH.TH_SEQRELA = ST5.T5_SEQRELA

            left join TT9010 TAR_ETAPA (nolock)
                on TAR_ETAPA.D_E_L_E_T_ = ''
                and TAR_ETAPA.TT9_TAREFA = STH.TH_TAREFA
            left join TPA010 TPA (nolock)
                on TPA.D_E_L_E_T_ = ''
                and TPA.TPA_ETAPA = STH.TH_ETAPA

        left join STG010 STG (nolock)
            on STG.D_E_L_E_T_ = ''
            and STG.TG_CODBEM = ST5.T5_CODBEM
            and STG.TG_TAREFA = ST5.T5_TAREFA
            and STG.TG_SERVICO = ST5.T5_SERVICO
            and STG.TG_SEQRELA = ST5.T5_SEQRELA

            left join SA2010 SA2 (nolock)
                on SA2.D_E_L_E_T_ = ''
                and SA2.A2_COD = STG.TG_CODIGO
            left join SB1010 SB1 (nolock)
                on SB1.D_E_L_E_T_ = ''
                and SB1.B1_COD = STG.TG_CODIGO
            left join SH4010 SH4 (nolock)
                on SH4.D_E_L_E_T_ = ''
                and SH4.H4_CODIGO = STG.TG_CODIGO
            left join ST0010 ST0 (nolock)
                on ST0.D_E_L_E_T_ = ''
                and ST0.T0_ESPECIA = STG.TG_CODIGO
            left join ST1010 ST1 (nolock)
                on ST1.D_E_L_E_T_ = ''
                and ST1.T1_CODFUNC = STG.TG_CODIGO
            left join TT9010 TAR_ITEM (nolock)
                on TAR_ITEM.D_E_L_E_T_ = ''
                and TAR_ITEM.TT9_TAREFA = STG.TG_TAREFA
where STF.D_E_L_E_T_ = ''
