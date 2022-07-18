select
    case DU5010.DU5_INTERV when 1000 then (DU5010.DU5_VALOR/10)/100 else (DU5010.DU5_VALOR)/100 end,
    DU5010.DU5_INTERV,
    DU5010.DU5_VALOR,
    DTC.DTC_FILDOC,
    DTC.DTC_DOC,
    DTC.DTC_SERIE,
    DTC.DTC_FILORI,
    DTC.DTC_NUMNFC,
    DTC.DTC_SERNFC,    
    (
        select count(*)
        from DTC010 (nolock)
        where 
                DTC010.D_E_L_E_T_ = ''
            and DTC010.DTC_FILORI = DTC.DTC_FILORI
            and DTC010.DTC_NUMNFC = DTC.DTC_NUMNFC
            and DTC010.DTC_SERNFC = DTC.DTC_SERNFC
    ) as qtd_NFs
from DU5010 (nolock)
    inner join DTC010 DTC (nolock)
        on DTC.D_E_L_E_T_ = ''
        and DU5010.DU5_CDRORI = DTC.DTC_CDRORI
        and DU5010.DU5_CDRDES = DTC.DTC_CDRCAL
where
        DU5010.D_E_L_E_T_ = ''
