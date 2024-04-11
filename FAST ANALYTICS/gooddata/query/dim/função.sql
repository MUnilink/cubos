select
    concat(trim(SRJ.RJ_FILIAL), trim(SRJ.RJ_FUNCAO)) as ID_FUNCAO,
    trim(SRJ.RJ_FUNCAO) as COD_FUNCAO,
    trim(SRJ.RJ_DESC) as DESC_FUNCAO,
    trim(SRJ.RJ_YPORTAL) as APP_PORT
from SRJ010 SRJ
where SRJ.D_E_L_E_T_ = ''
