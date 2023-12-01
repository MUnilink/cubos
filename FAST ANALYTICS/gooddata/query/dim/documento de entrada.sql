select
    concat('SD1', trim(SD1.D1_FILIAL), trim(SD1.D1_FORNECE), trim(SD1.D1_LOJA), trim(SD1.D1_DOC), trim(SD1.D1_SERIE)) as ID_NF,
    SD1.D1_FILIAL,
    SD1.D1_FORNECE,
    SD1.D1_LOJA,
    SD1.D1_DOC,
    SD1.D1_SERIE
from SD1010 SD1
where SD1.D_E_L_E_T_ = ''
