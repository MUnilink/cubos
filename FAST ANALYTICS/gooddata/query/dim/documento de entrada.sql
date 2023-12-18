select
    concat('SF1', trim(SF1.F1_FILIAL), trim(SF1.F1_FORNECE), trim(SF1.F1_LOJA), trim(SF1.F1_DOC), trim(SF1.F1_SERIE)) as ID_NF,
    SF1.F1_DOC,
    SF1.F1_SERIE,
    SF1.F1_ESPECIE
from SF1010 SF1
where SF1.D_E_L_E_T_ = ''
