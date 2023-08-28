select 
    SG1.G1_FILIAL as FILIAL,
    SG1.G1_COD as G1_CODIGO,

    /* SB1COD.B1_COD as B1_CODIGO, */
    SB1COD.B1_DESC as B1_COD_DESC,

    SG1.G1_COMP as G1_COMPONENTE,

    /* SB1COMP.B1_COD as B1_COMPONENTE, */
    SB1COMP.B1_DESC as B1_COMP_DESC,

    SC2.C2_NUM as NUM_OP,

    convert(date, SG1.G1_INI, 101) as DATA_INI,
    convert(date, SG1.G1_FIM, 101) as DATA_FIM

from SC2010 as SC2 (nolock)
    inner join SG1010 as SG1 (nolock)
        on SG1.D_E_L_E_T_ = ''
        and SG1.G1_COD = SC2.C2_PRODUTO
        left join SB1010 SB1COD (nolock)
            on SB1COD.D_E_L_E_T_ = ''
            and SB1COD.B1_COD = SG1.G1_COD
        left join SB1010 SB1COMP (nolock)
            on SB1COMP.D_E_L_E_T_ = ''
            and SB1COMP.B1_COD = SG1.G1_COMP
where SC2.D_E_L_E_T_ = ''