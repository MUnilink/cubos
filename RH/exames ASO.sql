select
    TMY.TMY_FILIAL,
    TMY.TMY_NUMFIC,
    TM5.TM5_EXAME,
    TM5.TM5_FORNEC,
    TM5.TM5_LOJA,
    TM5.TM5_FILFUN,
    TM5.TM5_MAT,
    SRA.RA_NOME,
    TM5.TM5_CC,
    TM5.TM5_CODFUN,
    TM5.TM5_CBO
from TMY010 TMY (nolock)
    inner join TM5010 TM5 (nolock)
        on TM5.D_E_L_E_T_ = ''
        and TM5.TM5_NUMASO = TMY.TMY_NUMASO
        and TM5.TM5_NUMFIC = TMY.TMY_NUMFIC

        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = TM5.TM5_FILFUN
            and SRA.RA_MAT = TM5.TM5_MAT
where TMY.D_E_L_E_T_ = ''