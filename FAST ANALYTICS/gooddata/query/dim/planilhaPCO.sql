select
    concat(trim(AK1.AK1_CODIGO), trim(AK1.AK1_VERSAO)) as ID_PLANILHAPCO,
    AK1.AK1_CODIGO,
    AK1.AK1_VERSAO,
    
    AK1.AK1_DESCRI,
    AK1.AK1_INIPER,
    AK1.AK1_FIMPER
from AK1010 AK1 (nolock)
where AK1.D_E_L_E_T_ = ''
