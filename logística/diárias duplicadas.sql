select
    DYV.DYV_VIAGEM,
    DYV.DYV_CODMOT,
    DA4.DA4_MAT,
    DA4.DA4_NOME,
    DA4.DA4_FORNEC,
    DYV.DYV_IDCDIA,
    DYX.DYX_ITEM,
    convert(date, DYX.DYX_DATDIA, 103) as DYX_DATDIA,
    DYX.DYX_QTDE,
    DYX.DYX_VLRUNI,
    
    SE2.E2_NUM,
    SE2.E2_EMISSAO,
    SE2.E2_VALOR,
    SE2.E2_BAIXA,

    year(DYX.DYX_DATDIA) as ano_DIARIA,
    month(DYX.DYX_DATDIA) as mes_DIARIA
from DYV010 DYV (nolock)
    inner join DYX010 DYX (nolock)
        on DYX.D_E_L_E_T_ = ''
        and DYX.DYX_IDCDIA = DYV.DYV_IDCDIA
        and year(DYX.DYX_DATDIA) = 2022
        
        left join SE2010 SE2
            on SE2.D_E_L_E_T_ = ''
            and SE2.E2_PREFIXO = DYX.DYX_PRETIT
            and SE2.E2_NUM = DYX.DYX_NUMTIT

    inner join DA4010 DA4 (nolock)
        on DA4.D_E_L_E_T_ = ''
        and DA4.DA4_COD = DYV.DYV_CODMOT
where
        DYV.D_E_L_E_T_ = ''
    and exists
    (
        select DUD010.DUD_VIAGEM
        from DUD010
            inner join DT6010 (nolock)
                on DT6010.DT6_FILIAL = DUD010.DUD_FILIAL
                and DT6010.DT6_FILDOC = DUD010.DUD_FILDOC
                and DT6010.DT6_DOC = DUD010.DUD_DOC
                and DT6010.DT6_SERIE = DUD010.DUD_SERIE

                inner join SE1010 (nolock)
                    on SE1010.D_E_L_E_T_ = ''
                    and SE1010.E1_FILIAL = DT6010.DT6_FILDOC
                    and SE1010.E1_CLIENTE = DT6010.DT6_CLIDEV
                    and SE1010.E1_LOJA = DT6010.DT6_LOJDEV
                    and SE1010.E1_PREFIXO = DT6010.DT6_PREFIX
                    and SE1010.E1_NUM = DT6010.DT6_NUM
                    and SE1010.E1_TIPO = DT6010.DT6_TIPO
        where
                DUD010.D_E_L_E_T_ = ''
            and DUD010.DUD_VIAGEM = DYV.DYV_VIAGEM
    )
