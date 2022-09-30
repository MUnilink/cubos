select
    STI.TI_FILIAL,
    STI.TI_DATAPLA,
    STI.TI_DESCRIC,

    STJ.TJ_CODBEM,
    STJ.TJ_ORDEM,
    STJ.TJ_PLANO,
    STJ.TJ_SERVICO,
    STJ.TJ_SEQRELA,
    STJ.TJ_SITUACA,

    STF.TF_NOMEMAN,
    STF.TF_PADRAO,
    STF.TF_DTULTMA,
    STF.TF_TIPACOM,
    STF.TF_PARADA,
    STF.TF_CONMANU,
    STF.TF_INENMAN,
    STF.TF_ATIVO,
    
    STG.TG_SEQRELA,
    STG.TG_TAREFA,
    STG.TG_TIPOREG,
    STG.TG_CODIGO,
    SB1.B1_DESC,
    SB1.B1_MSBLQL,
    STG.TG_QUANTID,
    STG.TG_UNIDADE,
    STG.TG_LOCAL,
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
                and SB2.B2_LOCAL = case STG.TG_LOCAL when '80' then '01' else STG.TG_LOCAL end
where STJ.D_E_L_E_T_ = '' and substring(STI.TI_DATAPLA, 1, 6) > '202112'
