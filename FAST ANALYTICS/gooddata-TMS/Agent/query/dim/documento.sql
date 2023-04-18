select
    trim(DT6.DT6_DOC) as DOCUMENTO,
    trim(DT6.DT6_SERIE) as SERIE,
    null as INSTANCIA
from DT6010 DT6
where DT6.D_E_L_E_T_ = ''
