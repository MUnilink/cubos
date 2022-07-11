select
    DUD010.DUD_VIAGEM,
    DT6010.DT6_FILDOC as DT6_FILDOC,
    DT6010.DT6_DOC as DT6_DOC,
    DT6010.DT6_SERIE as DT6_SERIE,
    trim(DUY010.DUY_GRPVEN) as DUY_GRPVEN
    
from DUD010 (nolock)
    left join DT6010 (nolock)
        on DT6010.D_E_L_E_T_ = ''
        and DT6010.DT6_FILDOC = DUD010.DUD_FILDOC
        and DT6010.DT6_DOC = DUD010.DUD_DOC
        and DT6010.DT6_SERIE = DUD010.DUD_SERIE
        
        left join DUY010 (nolock)
            on DUY010.D_E_L_E_T_ = ''
            and DUY010.DUY_GRPVEN = DT6010.DT6_CDRDES
where
        DUD010.D_E_L_E_T_ = ''
    and DUD010.DUD_VIAGEM = '007080'
    