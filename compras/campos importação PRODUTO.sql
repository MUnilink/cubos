select
    '01' as EMPRESA,
    SB1.B1_COD as CODIGO,
    SB1.B1_DESC as DESCRICAO,
    SB1.B1_YDESCRI as COMPLEMENTO,
    SB1.B1_YPARTNU as PART_NUMBER,
    SB1.B1_POSIPI as NCM,
    SB1.B1_UM as UNIDADE_MEDIDA,
    SBM.BM_GRUPO as GRUPO,
    SBM.BM_DESC as DESCRICAO_GRUPO
from SB1010 SB1
    inner join SBM010 SBM
        on SBM.D_E_L_E_T_ = ''
        and SBM.BM_GRUPO = SB1.B1_GRUPO
        and SBM.BM_GRUPO not like '3%'
where
        SB1.D_E_L_E_T_ = ''
