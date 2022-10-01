select
    trim(STI.TI_FILIAL) as FILIAL,
    trim(STI.TI_DATAPLA) as PERIODO,
    trim(STI.TI_DESCRIC) as NOME_PLANO,

    trim(STJ.TJ_CCUSTO) as CC,
    trim(STJ.TJ_CODBEM) as EQUIPAMENTO,
    trim(STJ.TJ_ORDEM) as OS,
    trim(STJ.TJ_PLANO) as PLANO,
    trim(STJ.TJ_SERVICO) as SERVICO,
    STJ.TJ_SEQRELA as TJ_SEQRELA,
    case STJ.TJ_SITUACA when 'L' then 'LIBERADA' when 'P' then 'PENDENTE' else 'CANCELADA' end as STATUS_OS,

    trim(STF.TF_NOMEMAN) as PREVENTIVA,
    trim(STF.TF_PADRAO) as MAN_PADRAO,
    STF.TF_DTULTMA as ULTIMA_MAN,
    trim(STF.TF_TIPACOM) as TIPO_ACOMP,
    trim(STF.TF_PARADA) as PARADA,
    STF.TF_CONMANU as NUM_MAN,
    STF.TF_INENMAN as VENCIMENTO,
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

            left join SB1010 SB1 (nolock)
                on SB1.D_E_L_E_T_ = ''
                and SB1.B1_COD = STG.TG_CODIGO

where STJ.D_E_L_E_T_ = '' and substring(STI.TI_DATAPLA, 1, 6) > '202112'
