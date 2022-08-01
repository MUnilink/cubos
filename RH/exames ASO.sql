select
    TM0.TM0_FILIAL,
    TM0.TM0_NUMFIC,
    TM0.TM0_NOMFIC,
    TM0.TM0_DTIMPL,
    TM5.TM5_FILIAL,
    TM5.TM5_EXAME,
    TM5.TM5_EXAME as contador,
    convert(date, TM5.TM5_DTPROG, 103) as TM5_DTPROG,
    trim(TM4.TM4_NOMEXA) as TM4_NOMEXA,
    trim(TM4.TM4_DESEXA) as TM4_DESEXA,
    TM5.TM5_FORNEC,
    TM5.TM5_LOJA,
    TM5.TM5_FILFUN,
    TM5.TM5_MAT,
    TM5.TM5_CC,
    TM5.TM5_CODFUN,
    SRJ.RJ_DESC,
    TM5.TM5_CBO,

    year(TM5.TM5_DTPROG) as ano_prog,
    month(TM5.TM5_DTPROG) as mes_prog
from TM0010 TM0 (nolock)
    inner join TMY010 TMY (nolock)
        on TMY.D_E_L_E_T_ = ''
        and TMY.TMY_FILIAL = TM0.TM0_FILIAL
        and TMY.TMY_NUMFIC = TM0.TM0_NUMFIC

        inner join TM5010 TM5 (nolock)
            on TM5.D_E_L_E_T_ = ''
            and TM5.TM5_FILIAL = TMY.TMY_FILIAL
            and TM5.TM5_NUMASO = TMY.TMY_NUMASO
            and TM5.TM5_NUMFIC = TMY.TMY_NUMFIC

            inner join SRJ010 SRJ (nolock)
                on SRJ.D_E_L_E_T_ = ''
                and SRJ.RJ_FILIAL = substring(TM5.TM5_FILFUN, 1, 4)
                and SRJ.RJ_FUNCAO = TM5.TM5_CODFUN

            inner join TM4010 TM4 (nolock)
                on TM4.D_E_L_E_T_ = ''
                and TM4.TM4_EXAME = TM5.TM5_EXAME
where TM0.D_E_L_E_T_ = ''
