select
    TM0.TM0_FILIAL as FILIAL,
    TM0.TM0_NUMFIC as FICHA_MEDICA,
    TM0.TM0_NOMFIC as NOME_FICHA,
    TM0.TM0_DTIMPL as DATA_INI,
    TM5.TM5_FILIAL as FILIAL,
    TM5.TM5_EXAME as EXAME,
    TM5.TM5_EXAME as contador,
    convert(date, TM5.TM5_DTPROG, 103) as DATA,
    TM5.TM5_ORIGEX as ORIGEM_EXAME,
    TM5.TM5_NATEXA as NATUREZA_EXAME,
    trim(TM4.TM4_NOMEXA) as NOME_EXAME,
    trim(TM4.TM4_DESEXA) as DESC_EXAME,
    TMD.TMD_VALEXA as VALOR_EXAME,
    TM5.TM5_FORNEC as FORNECEDOR,
    TM5.TM5_LOJA as LOJA,
    TM5.TM5_MAT as MATRICULA,
    TM5.TM5_CC as CC,
    SRJ.RJ_DESC as FUNCAO,
    TM5.TM5_CBO as CBO,

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

                inner join TMD010 TMD (nolock)
                    on TMD.D_E_L_E_T_ = ''
                    and TMD.TMD_EXAME = TM4.TM4_EXAME
where TM0.D_E_L_E_T_ = ''
