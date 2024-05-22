select
    SAK010.AK_FILIAL,
    SAK010.AK_COD,
    SCR.CR_LIBAPRO,
    SCR.CR_FILIAL,
    SCR.CR_TIPO,
    SCR.CR_NUM,
    SCR.CR_NIVEL,
    case SCR.CR_STATUS
        when 1 then 'PENDENTE'
        when 2 then 'PENDENTE'
        when 3 then 'APROVADA'
        when 5 then 'APROVADA'
        when 6 then 'REJEITADA'
        when 7 then 'REJEITADA'
        else 'LIBERADA'
    end as STATUS,
    'P |01|SAK010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAK010.AK_FILIAL, ' '))+'|'+RTRIM(COALESCE(SAK010.AK_COD, ' ')), ' '), '|') as BK_APROVADOR,
    count(*)
from SCR010 SCR
    inner join SAK010
        on SAK010.D_E_L_E_T_ = ''
        and SAK010.AK_COD = SCR.CR_LIBAPRO
where
        SCR.D_E_L_E_T_ = ''
    and SCR.CR_NIVEL = 
    (
        select max(SCR010.CR_NIVEL)
        from SCR010 (nolock)
        where
                SCR010.D_E_L_E_T_ = ''
            and SCR010.CR_FILIAL = SCR.CR_FILIAL
            and SCR010.CR_TIPO = SCR.CR_TIPO
            and SCR010.CR_NUM = SCR.CR_NUM
        group by
            SCR010.CR_FILIAL,
            SCR010.CR_TIPO,
            SCR010.CR_NUM
    )
group by
    SAK010.AK_FILIAL,
    SAK010.AK_COD,
    SCR.CR_LIBAPRO,
    SCR.CR_FILIAL,
    SCR.CR_TIPO,
    SCR.CR_NUM,
    SCR.CR_NIVEL,
    SCR.CR_STATUS
