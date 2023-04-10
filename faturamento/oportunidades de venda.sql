select
    AC2.AC2_DESCRI as ESTAGIO_PROCESSO,
    trim(SA3.A3_NREDUZ) as VENDEDOR,
    SUS.US_COD as COD_PROS,
    SUS.US_LOJA as LOJA_PROS,
    trim(SUS.US_NOME) as NOME_PROS,
    trim(SUS.US_NREDUZ) as RAZAOSOCIAL_PROS,
    SUS.US_CGC as CNPJ_PROS,
    convert(datetime, datetimefromparts(year(SUS.US_DTCAD), month(SUS.US_DTCAD), day(SUS.US_DTCAD), substring(SUS.US_HRCAD, 1, 2), substring(SUS.US_HRCAD, 4, 5), 0, 0), 113) as DATA_PROSPECT,
    SA1.A1_COD as COD_CLI,
    SA1.A1_LOJA as LOJA_CLI,
    trim(SA1.A1_NOME) as NOME_CLI,
    trim(SA1.A1_NREDUZ) as RAZAOSOCIAL_CLI,
    SA1.A1_CGC as CNPJ_CLI,
    AD1.AD1_NROPOR as OPORTUNIDADE,
    AD1.AD1_REVISA as VERSAO,
    trim(AD1.AD1_DESCRI) as DESCRICAO


from AD1010 AD1 (nolock)
    inner join SA3010 SA3 (nolock)
        on SA3.D_E_L_E_T_ = ''
        and SA3.A3_COD = AD1.AD1_VEND
    inner join AC2010 AC2 (nolock)
        on AC2.D_E_L_E_T_ = ''
        and AC2.AC2_PROVEN = AD1.AD1_PROVEN
        and AC2.AC2_STAGE = AD1.AD1_STAGE
    left join SUS010 SUS (nolock)
        on SUS.D_E_L_E_T_ = ''
        and SUS.US_FILIAL = substring(AD1.AD1_FILIAL, 1, 4)
        and SUS.US_COD = AD1.AD1_PROSPE
        and SUS.US_LOJA = AD1.AD1_LOJPRO
    left join SA1010 SA1 (nolock)
        on SA1.D_E_L_E_T_ = ''
        and SA1.A1_COD = AD1.AD1_CODCLI
        and SA1.A1_LOJA = AD1.AD1_LOJCLI
where AD1.D_E_L_E_T_ = ''
