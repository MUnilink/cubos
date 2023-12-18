select
    concat('SF2', trim(SF2.F2_FILIAL), trim(SF2.F2_CLIENTE), trim(SF2.F2_LOJA), trim(SF2.F2_DOC), trim(SF2.F2_SERIE)) as ID_NF,
    SF2.F2_DOC,
    SF2.F2_SERIE,
    SF2.F2_ESPECIE
from SF2010 SF2
where SF2.D_E_L_E_T_ = ''
