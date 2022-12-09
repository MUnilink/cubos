select
    trim(SB1.B1_COD) as CODIGO,
    trim(SB1.B1_DESC) as DESCRICAO,
    trim(SAH.AH_DESCPO) as UNIDADE,
    trim(SBM.BM_GRUPO) AS COD_GRUPO_ESTOQUE,
    trim(SBM.BM_DESC) AS DESC_GRUPO_ESTOQUE
from SB1010 SB1 (nolock)
    inner join SBM010 SBM (nolock)
        on SBM.D_E_L_E_T_ = ''
        and SBM.BM_GRUPO = SB1.B1_GRUPO
        and SBM.BM_GRUPO not like '3%'
    inner join SAH010 SAH (nolock)
        on SAH.D_E_L_E_T_ = ''
        and SAH.AH_UNIMED = SB1.B1_UM
where
        SB1.D_E_L_E_T_ = ''
