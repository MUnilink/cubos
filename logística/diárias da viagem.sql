select
    DYV.DYV_VIAGEM,
    DYV.DYV_CODMOT,
    DYV.DYV_IDCDIA,
    DYX.DYX_ITEM,
    convert(date, DYX.DYX_DATDIA, 103) as DYX_DATDIA,
    DYX.DYX_QTDE,
    DYX.DYX_VLRUNI,
    
    year(DYX.DYX_DATDIA) as ano_DIARIA,
    month(DYX.DYX_DATDIA) as mes_DIARIA
from DYV010 DYV (nolock)
    inner join DYX010 DYX (nolock)
        on DYX.D_E_L_E_T_ = ''
        and DYX.DYX_IDCDIA = DYV.DYV_IDCDIA
where
        DYV.D_E_L_E_T_ = ''
