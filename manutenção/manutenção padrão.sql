select
    trim(STF.TF_NOMEMAN) as PREVENTIVA,
    trim(STF.TF_PADRAO) as MAN_PADRAO,
    STF.TF_DTULTMA as ULTIMA_MAN,
    trim(STF.TF_TIPACOM) as TIPO_ACOMP,
    trim(STF.TF_PARADA) as PARADA,
    STF.TF_CONMANU as CONTADOR_ULTIMA,
    STF.TF_INENMAN as INCREMENTO,
    STF.TF_ATIVO as ATIVO,
    STG.TG_SEQRELA as TG_SEQRELA,
    trim(STG.TG_TAREFA) as TAREFA,
    trim(STG.TG_TIPOREG) as TIPO_INSUMO,
    STG.TG_CODIGO as INSUMO,
    trim(SB1.B1_DESC) as PRODUTO,
    case SB1.B1_MSBLQL when 1 then 'SIM' else 'NAO' end as BLOQUEADO,
    STG.TG_QUANTID as QTD,
    STG.TG_UNIDADE as UNIDADE,
    STG.TG_LOCAL as ARMAZEM

from STF010 STF (nolock)
    inner join STG010 STG (nolock)
        on STG.D_E_L_E_T_ = ''
        and STG.TG_CODBEM = STF.TF_CODBEM
        and STG.TG_SERVICO = STF.TF_SERVICO
        and STG.TG_SEQRELA = STF.TF_SEQRELA

        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = STG.TG_CODIGO

where STF.D_E_L_E_T_ = ''
