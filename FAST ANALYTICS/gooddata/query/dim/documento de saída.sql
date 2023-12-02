select
    concat('SD2', trim(SD2.D2_FILIAL), trim(SD2.D2_CLIENTE), trim(SD2.D2_LOJA), trim(SD2.D2_DOC), trim(SD2.D2_SERIE)) as ID_NF,
    SD2.D2_DOC,
    SD2.D2_SERIE
from SD2010 SD2
where SD2.D_E_L_E_T_ = ''
