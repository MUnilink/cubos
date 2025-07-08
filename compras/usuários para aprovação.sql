select
    trim(SAL.AL_COD) as Grupo_Aprovacao,
    trim(SAL.AL_ITEM) as Item_Grupo,
    trim(SAL.AL_APROV) as Codigo_Aprovador,
    trim(SAL.AL_PERFIL) as Perfil_Aprovador,
    trim(SAL.AL_USER) as Codigo_Usuario,
    trim(SAL.AL_NIVEL) as Nivel_Aprovacao,
    trim(SAL.AL_DESC) as GRUPO,
    trim(SAK.AK_LOGIN) as NOME,
    case SAL.AL_MSBLQL when 1 then 'BLQ' when 2 then 'LIB' else 'N/A' end as BLOQUEADO
from SAL010 SAL (nolock)
    inner join SAK010 SAK (nolock)
        on SAK.D_E_L_E_T_ = ''
        and SAK.AK_COD = SAL.AL_APROV
where SAL.D_E_L_E_T_ = ''
