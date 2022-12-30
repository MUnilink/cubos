select
    concat(trim(AK1.AK1_CODIGO), trim(AK1.AK1_VERSAO)) as ID_PLANILHAPCO,
    trim(AK1.AK1_CODIGO) as AK1_CODIGO,
    trim(AK1.AK1_VERSAO) as AK1_VERSAO,
    trim(AK1.AK1_VERREV) as AK1_VERREV,
    trim(AK1.AK1_DESCRI) as AK1_DESCRI
from AK1010 AK1 (nolock)
where AK1.D_E_L_E_T_ = ''
