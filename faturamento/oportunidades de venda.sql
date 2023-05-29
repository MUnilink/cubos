select
    trim(AC2.AC2_DESCRI) as ESTAGIO_PROCESSO,
    trim(VEN.A3_NREDUZ) as VENDEDOR,
    trim(TIM.A3_NREDUZ) as TIMEVENDAS,
    AD2.AD2_VEND,
    AD2.AD2_PERC,
    AD1.AD1_VERBA as RECEITA_ESTIMADA,
    .01*AD2.AD2_PERC * AD1.AD1_VERBA as RECEITA_ESTIMADA_PERC,
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
    trim(AD1.AD1_DESCRI) as DESCRICAO,
    substring(AD1.AD1_DATA, 1, 6) as PERIODO_OPORTUNIDADE,
    convert(datetime, datetimefromparts(year(AD1.AD1_DATA), month(AD1.AD1_DATA), day(AD1.AD1_DATA), substring(AD1.AD1_HORA, 1, 2), substring(AD1.AD1_HORA, 4, 5), 0, 0), 113) as DATA_OPORTUNIDADE,
    (select upper(trim(SX5010.X5_DESCRI)) from SX5010 (nolock) where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = 'A6' and SX5010.X5_CHAVE = AD1.AD1_FCS) as FATOR_SUCESSO,
    (select upper(trim(SX5010.X5_DESCRI)) from SX5010 (nolock) where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = 'A6' and SX5010.X5_CHAVE = AD1.AD1_FCI) as FATOR_INSUCESSO,
    convert(date, AD1.AD1_DTINI, 103) as DTINI,
    convert(date, AD1.AD1_DTFIM, 103) as DTFIM,
    trim(SUN.UN_DESC) as MOTIVO_ENCERR,
    AD1.AD1_OBSPRO as OBS,
    case AD1.AD1_STATUS when 1 then 'ABERTA' when 2 then 'PERDIDA' when 3 then 'SUSPENSA' when 9 then 'GANHA' else 'OUTROS' end as AD1_STATUS,
    case AD1.AD1_FEELIN when 1 then 'BAIXA' when 2 then 'MEDIA' when 3 then 'ALTA' else 'OUTROS' end as AD1_FEELIN,
    case AD1.AD1_PRIOR when 1 then 'BAIXA' when 2 then 'MEDIA' when 3 then 'ALTA' else 'OUTROS' end as AD1_PRIOR,
    ADJ.ADJ_ITEM,
    SB1.B1_COD,
    trim(SB1.B1_DESC) as B1_DESC,
    ADJ.ADJ_QUANT,
    ADJ.ADJ_PRUNIT,
    ADJ.ADJ_VALOR,
    1 as contador

from AD1010 AD1 (nolock)
    inner join AC2010 AC2 (nolock)
        on AC2.D_E_L_E_T_ = ''
        and AC2.AC2_FILIAL = substring(AD1.AD1_FILIAL, 1, 4)
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
    left join SUN010 SUN (nolock)
        on SUN.D_E_L_E_T_ = ''
        and SUN.UN_FILIAL = substring(AD1.AD1_FILIAL, 1, 4)
        and SUN.UN_ENCERR = AD1.AD1_ENCERR
    left join AD2010 AD2 (nolock)
        on AD2.D_E_L_E_T_ = ''
        and AD2.AD2_NROPOR = AD1.AD1_NROPOR
        and AD2.AD2_REVISA = AD1.AD1_REVISA
        
        left join SA3010 TIM (nolock)
            on TIM.D_E_L_E_T_ = ''
            and TIM.A3_COD = AD2.AD2_VEND

    left join SA3010 VEN (nolock)
        on VEN.D_E_L_E_T_ = ''
        and VEN.A3_COD = AD1.AD1_VEND

    left join ADJ010 ADJ
        on ADJ.D_E_L_E_T_ = ''
        and ADJ.ADJ_FILIAL = AD1.AD1_FILIAL
        and ADJ.ADJ_NROPOR = AD1.AD1_NROPOR
        and ADJ.ADJ_REVISA = AD1.AD1_REVISA

        left join SB1010 SB1
            on SB1.D_E_L_E_T_= ' '
            and SB1.B1_COD = ADJ.ADJ_PROD

            left join SBM010 SBM
                on SBM.D_E_L_E_T_ = ' '
                and SBM.BM_GRUPO = SB1.B1_GRUPO

where AD1.D_E_L_E_T_ = ''
