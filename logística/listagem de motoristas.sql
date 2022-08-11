select
    DA4.DA4_FILIAL,
    DA4.DA4_MAT,
    DA4.DA4_NOME,
    SRA.RA_SITFOLH
from DA4010 DA4 (nolock)
    inner join SRA010 SRA (nolock)
        on SRA.D_E_L_E_T_ = ''
        and substring(SRA.RA_FILIAL, 1, 4) = DA4.DA4_FILIAL
        and SRA.RA_MAT = DA4.DA4_MAT
where DA4.D_E_L_E_T_ = ''
