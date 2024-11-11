select
    trim(ZE2.ZE2_COD) as CODIGO,
    upper(trim(ZE2.ZE2_DESC)) as DESCRICAO,
    trim(ZE2.ZE2_ORIGEM) as ORIGEM,
    ZE2.ZE2_MSBLQL as BLOQUEADO
from ZE2010 ZE2
where ZE2.D_E_L_E_T_ = ''
