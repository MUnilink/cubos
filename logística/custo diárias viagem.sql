select
    DYV.DYV_VIAGEM as VIAGEM,
    DYV.DYV_CODMOT as CODMOT,
    DA4.DA4_MAT as MATRICULA,
    DA4.DA4_NOME as MOTORISTA,
    DA4.DA4_FORNEC as FORNECEDOR,
    DYV.DYV_IDCDIA as TITULO_TMS,
    DYX.DYX_ITEM as ITEM,
    convert(date, DYX.DYX_DATDIA, 103) as DATA_DIARIA,
    DYX.DYX_QTDE,
    DYX.DYX_VLRUNI,
    DYX.DYX_STATUS,
    DYX.DYX_USRAPR,
    convert(date, DYX.DYX_DATAPR, 103) as DATA_APROV,
    SE2.E2_NUM as TITULO_FIN,
    convert(date, SE2.E2_BAIXA, 103) as DATA_BAIXA,
    SE2.E2_VALOR as VALOR_DIARIA,    
    substring(DYX.DYX_DATDIA, 1, 6) as PERIODO_DIARIA
from DYV010 DYV (nolock)
    inner join DYX010 DYX (nolock)
        on DYX.D_E_L_E_T_ = ''
        and DYX.DYX_IDCDIA = DYV.DYV_IDCDIA
        and year(DYX.DYX_DATDIA) > 2021

            inner join SX5010 SX5 (nolock)
                on SX5.D_E_L_E_T_ = ''
                and SX5.X5_TABELA = 'MS'
                and SX5.X5_CHAVE = DYX.DYX_TIPVAL
        
        left join SE2010 SE2 (nolock)
            on SE2.D_E_L_E_T_ = ''
            and SE2.E2_PREFIXO = DYX.DYX_PRETIT
            and SE2.E2_NUM = DYX.DYX_NUMTIT

    inner join DA4010 DA4 (nolock)
        on DA4.D_E_L_E_T_ = ''
        and DA4.DA4_COD = DYV.DYV_CODMOT
where
        DYV.D_E_L_E_T_ = ''
