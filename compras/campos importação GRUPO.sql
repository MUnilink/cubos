select
    SBM.BM_GRUPO as GRUPO,
    SBM.BM_DESC as DESCRICAO_GRUPO
from SBM010 SBM (nolock)
where
        SBM.D_E_L_E_T_ = ''
    and SBM.BM_GRUPO not like '3%'
