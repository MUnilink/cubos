select
    DUD.DUD_VIAGEM,
    DT6.DT6_FILDOC,
    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    DF1.DF1_NUMAGE,
    DF1.DF1_ITEAGE,
    DF1.DF1_FILDOC,
    DF1.DF1_DOC,
    DF1.DF1_SERVIC
    
from DUD010 DUD (nolock)
    left join DT6010 DT6 (nolock)
        on DT6.D_E_L_E_T_ = ''
        and DT6.DT6_FILDOC = DUD.DUD_FILDOC
        and DT6.DT6_DOC = DUD.DUD_DOC
        and DT6.DT6_SERIE = DUD.DUD_SERIE
        
        left join DTC010 DTC (nolock)
            on DTC.D_E_L_E_T_ = ''
            and DTC.DTC_FILORI = DT6.DT6_FILDOC
            and DTC.DTC_DOC = DT6.DT6_DOC
            and DTC.DTC_SERIE = DT6.DT6_SERIE

            left join DF1010 DF1 (nolock)
                on DF1.D_E_L_E_T_ = ''
                and DF1.DF1_FILDOC = DTC.DTC_FILORI
                and DF1.DF1_DOC = DTC.DTC_NUMSOL
where
        DUD.D_E_L_E_T_ = ''