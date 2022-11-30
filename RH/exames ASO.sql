select
    TM0.TM0_NUMFIC as FICHA_MEDICA,
    TM0.TM0_NOMFIC as NOME_FICHA,
    TM0.TM0_DTIMPL as DATA_INI,

    trim(SRA.RA_FILIAL) as FILIAL,
    trim(SRA.RA_MAT) as MATRICULA,
    trim(SRA.RA_NOME) as NOME,
    trim(SRJ.RJ_DESC) as FUNCAO,
    convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
    case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
    case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

    trim(CTT.CTT_CUSTO) as CC,
    trim(CTT.CTT_DESC01) as CCUSTO,
    trim(CTD.CTD_ITEM) as ITCT,
    trim(CTD.CTD_DESC01) as ATIVIDADE,
    trim(SQB.QB_DEPTO) as DEPTO,
    trim(SQB.QB_DESCRIC) as DEPARTAMENTO,

    trim(SRJ.RJ_CODCBO) as CBO,
    trim(SRA.RA_SEXO) as SEXO,
    trim(SRA.RA_CIC) as CPF,
    substring(TM5.TM5_DTPROG, 1, 6) as PERIODO,

    TM5.TM5_EXAME as EXAME,
    TM5.TM5_EXAME as contador,
    convert(date, TM5.TM5_DTPROG, 103) as DATA,
    case TM5.TM5_ORIGEX when 1 then 'ASSISTENCIAL' when 2 then 'OCUPACIONAL' else 'OUTROS' end as ORIGEM_EXAME,
    TM5.TM5_NATEXA as NATUREZA_EXAME,
    trim(TM4.TM4_NOMEXA) as NOME_EXAME,
    trim(TM4.TM4_DESEXA) as DESC_EXAME,
    TMD.TMD_VALEXA as VALOR_EXAME,
    TM5.TM5_FORNEC as FORNECEDOR,
    TM5.TM5_LOJA as LOJA,

    year(TM5.TM5_DTPROG) as ano_prog,
    month(TM5.TM5_DTPROG) as mes_prog
from TM5010 TM5 (nolock)
    inner join TMY010 TMY (nolock)
        on TMY.D_E_L_E_T_ = ''
        and TMY.TMY_FILIAL = TM5.TM5_FILIAL
        and TMY.TMY_NUMASO = TM5.TM5_NUMASO
        and TMY.TMY_NUMFIC = TM5.TM5_NUMFIC

        inner join TM0010 TM0 (nolock)
            on TM0.D_E_L_E_T_ = ''
            and TM0.TM0_FILIAL = TMY.TMY_FILIAL
            and TM0.TM0_NUMFIC = TMY.TMY_NUMFIC

        inner join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = TM5.TM5_FILFUN
            and SRA.RA_MAT = TM5.TM5_MAT

            inner join SQB010 SQB (nolock)
                on SQB.D_E_L_E_T_ = ''
                and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                and SQB.QB_DEPTO = SRA.RA_DEPTO
            inner join SRJ010 SRJ (nolock)
                on SRJ.D_E_L_E_T_ = ''
                and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
            inner join CTT010 CTT (nolock)
                on CTT.D_E_L_E_T_ = ''
                and CTT.CTT_CUSTO = SRA.RA_CC
            inner join CTD010 CTD (nolock)
                on CTD.D_E_L_E_T_ = ''
                and CTD.CTD_ITEM = SRA.RA_ITEM

        left join TM4010 TM4 (nolock)
            on TM4.D_E_L_E_T_ = ''
            and TM4.TM4_EXAME = TM5.TM5_EXAME

            left join TMD010 TMD (nolock)
                on TMD.D_E_L_E_T_ = ''
                and TMD.TMD_EXAME = TM4.TM4_EXAME
where TM5.D_E_L_E_T_ = ''
