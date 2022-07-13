select
    case DU5010.DU5_INTERV when 1000 then DU5010.DU5_VALOR/10 else DU5010.DU5_VALOR end,
    DT6010.DT6_FILDOC,
    DT6010.DT6_DOC,
    DT6010.DT6_SERIE
from DU5010 (nolock)
    inner join DT6010 (nolock)
        on DT6010.D_E_L_E_T_ = ''
        and DU5010.DU5_CDRORI = DT6010.DT6_CDRORI
        and DU5010.DU5_CDRDES = DT6010.DT6_CDRCAL
where
        DU5010.D_E_L_E_T_ = ''