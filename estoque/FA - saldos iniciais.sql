select
    'P |01|01' AS BK_EMPRESA,
    case when SB9.B9_FILIAL is null then 'P |01||' else 'P |01|01'+ CAST(SB9.B9_FILIAL as char (6)) end as BK_FILIAL,
    'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_COD, ' ')), ' '), '|') AS BK_ITEM,
    'P |01|SAH010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAH.AH_FILIAL, ' '))+'|'+RTRIM(COALESCE(SAH.AH_UNIMED, ' ')), ' '), '|') AS BK_UNIDADE_DE_MEDIDA,
    'P |01|ACU010|'+ COALESCE(NULLIF(RTRIM(COALESCE(ACU.ACU_FILIAL, ' '))+'|'+RTRIM(COALESCE(ACU.ACU_COD, ' ')), ' '), '|') AS BK_FAMILIA_COMERCIAL,
    'P |01|SBM010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SBM.BM_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_GRUPO, ' ')), ' '), '|') AS BK_GRUPO_ESTOQUE,
    'P |01|NNR010|'+ COALESCE(NULLIF(RTRIM(COALESCE(NNR.NNR_FILIAL, ' '))+'|'+RTRIM(COALESCE(NNR.NNR_CODIGO, ' ')), ' '), '|') as ID_ARMAZEM,
    cast(SB9.B9_QINI as numeric(15, 2)) as QTD_INI,
    cast(SB9.B9_QISEGUM as numeric(15, 2)) as QTD_INI2,
    cast(SB9.B9_VINI1 as numeric(15, 2)) as VAL_INI,
    cast(SB9.B9_CM1 as numeric(15, 2)) as CM_INI,
    SB9.B9_DATA as EMISSAO
from SB9010 SB9
    left join NNR010 NNR
        on NNR.D_E_L_E_T_ = ''
        and NNR.NNR_FILIAL = SB9.B9_FILIAL
        and NNR.NNR_CODIGO = SB9.B9_LOCAL
    inner join SB1010 SB1
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SB9.B9_COD
        and SB1.B1_GRUPO like '1%'

        left join SBM010 SBM
            on SBM.D_E_L_E_T_ = ' '
            and SBM.BM_GRUPO = SB1.B1_GRUPO
        left join SAH010 SAH
            on SAH.D_E_L_E_T_ = ''
            and SAH.AH_UNIMED = SB1.B1_COD
        left join ACV010 ACV
            on ACV.D_E_L_E_T_ = ' '
            and coalesce(nullif(ACV.ACV_FILIAL, ''), '0101') = coalesce(nullif(SB1.B1_FILIAL, ''), '0101')
            and ACV.ACV_CODPRO = SB1.B1_COD

            left join ACU010 ACU
                on ACU.D_E_L_E_T_ = ' '
                and ACU.ACU_FILIAL = coalesce(nullif(ACV.ACV_FILIAL, ''), '0101')
                and ACU.ACU_COD = ACV.ACV_CATEGO
where
        SB9.D_E_L_E_T_ = ''
    and SB9.B9_DATA like '2026%'
