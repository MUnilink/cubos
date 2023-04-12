select
    concat(trim(AC1.AC1_FILIAL), trim(AC1.AC1_PROVEN)) as ID_PROCESSOVENDA,
    AC1.AC1_PROVEN,
    AC1.AC1_DESCRI
from AC1010 AC1
where AC1.D_E_L_E_T_ = ''
