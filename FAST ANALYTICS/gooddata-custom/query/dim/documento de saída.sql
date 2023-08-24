select
    concat(SF2.F2_FILIAL, SF2.F2_CLIENTE, SF2.F2_LOJA, SF2.F2_DOC, isnull(nullif(SF2.F2_SERIE, ''), '000')) as ID_SF2,
    SF2.F2_FILIAL,
    SF2.F2_DOC,
    SF2.F2_SERIE,
    SF2.F2_CLIENTE,
    SF2.F2_LOJA,
    SF2.F2_TIPO
from SF2010 SF2
where SF2.D_E_L_E_T_ = ''
