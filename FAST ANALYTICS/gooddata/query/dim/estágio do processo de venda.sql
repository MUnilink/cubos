select
    'P |01|AC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(AC2.AC2_FILIAL, ' '))+'|'+RTRIM(COALESCE(AC2.AC2_PROVEN, ' '))+RTRIM(COALESCE(AC2.AC2_STAGE, ' ')), ' '), '|') as ID_ESTAGIOVENDA,
    AC2.AC2_STAGE as AC2_STAGE,
    translate(trim(AC2.AC2_DESCRI), upper('áéíóúãõç'), upper('aeiouaoc')) as AC2_DESCRI
from AC2010 AC2
where AC2.D_E_L_E_T_ = ''
