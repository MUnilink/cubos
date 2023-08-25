select
    concat(SF1.F1_FILIAL, SF1.F1_FORNECE, SF1.F1_LOJA, SF1.F1_DOC, isnull(nullif(SF1.F1_SERIE, ''), '000')) as ID_SF1,
    SF1.F1_FILIAL,
    SF1.F1_DOC,
    SF1.F1_SERIE,
    SF1.F1_FORNECE,
    SF1.F1_LOJA,
    SF1.F1_TIPO
from SF1010 SF1
where SF1.D_E_L_E_T_ = ''
