select
    concat(trim(DYV.DYV_FILORI), trim(DYV.DYV_VIAGEM), trim(DYV.DYV_CODMOT), trim(DYV.DYV_IDCDIA)) as ID_DIARIA,
    DYV.DYV_IDCDIA as TITULO_TMS,
    DYX.DYX_ITEM as ITEM,
    DYX.DYX_STATUS,
    SE2.E2_NUM as TITULO_FIN
from DYV010 DYV (nolock)
    inner join DYX010 DYX (nolock)
        on DYX.D_E_L_E_T_ = ''
        and DYX.DYX_IDCDIA = DYV.DYV_IDCDIA
        and year(DYX.DYX_DATDIA) > 2021
        
        left join SE2010 SE2 (nolock)
            on SE2.D_E_L_E_T_ = ''
            and SE2.E2_PREFIXO = DYX.DYX_PRETIT
            and SE2.E2_NUM = DYX.DYX_NUMTIT
where
        DYV.D_E_L_E_T_ = ''
