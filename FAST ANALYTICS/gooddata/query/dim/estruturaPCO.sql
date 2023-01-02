select
    concat(trim(AK3.AK3_ORCAME), trim(AK3.AK3_VERSAO), trim(AK3.AK3_CO)) as ID_ESTRUTURAPCO,
    AK3.AK3_ORCAME,
    AK3.AK3_VERSAO,
    AK3.AK3_CO as N2,
    case when AK3.AK3_CO is null then AK3.AK3_CO else AK5.AK5_CODIGO end as N1,
    AK3.AK3_TIPO,
    AK3.AK3_NIVEL,
    AK3.AK3_DESCRI
from AK3010 AK3 (nolock)
    left join AK5010 AK5 (nolock)
        on AK5.D_E_L_E_T_ = ''
        and AK5.AK5_CODIGO = AK3.AK3_PAI
        and AK5.AK5_COSUP != AK3.AK3_CO
where AK3.D_E_L_E_T_ = ''
