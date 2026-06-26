select
    trim(SBF.BF_FILIAL) as FILIAL,
    trim(SBF.BF_PRODUTO) as PRODUTO,
    trim(SB1.B1_DESC) as NOMEPRODUTO,
    trim(SB1.B1_UM) as UN,
    trim(SB1.B1_SEGUM) as UN2,
    SBF.BF_LOCAL as ARMAZEM,
    SBF.BF_LOCALIZ as ENDERECO,
    cast(SBF.BF_QUANT as numeric(15, 2)) as 'Quantidade no Endereco',
    cast(SBF.BF_EMPENHO as numeric(15, 2)) as 'Empenho no Endereco',
    cast(SBF.BF_QEMPPRE as numeric(15, 2)) as 'Quantidade Empenhada Prev',
    cast(SBF.BF_QTSEGUM as numeric(15, 2)) as 'Qtde na Segunda Unidade',
    cast(SBF.BF_EMPEN2 as numeric(15, 2)) as 'Empenho Endereco na un 2',
    cast(SBF.BF_QEPRE2 as numeric(15, 2)) as 'Qtde Emp. Prevista un 2',
    SB7.B7_DOC as DOC,
    cast(SB7.B7_QUANT as numeric(15, 2)) as QUANT,
    cast(SB7.B7_QTSEGUM as numeric(15, 2)) as QTSEGUM,
    left(SB7.B7_DATA, 6) as PERIODO,
    cast(SB7.B7_DATA as date) as DATA,
    SB7.B7_CONTAGE as CONTAGEM,
    SB7.B7_STATUS as STATUS,
    cast(SB7.B7_QUANT as numeric(15, 2)) as QTD_CONTAGEM,

    (select SB2010.B2_CM1 from SB2010 where SB2010.D_E_L_E_T_ = '' and SB2010.B2_FILIAL = SBF.BF_FILIAL and SB2010.B2_COD = SBF.BF_PRODUTO and SB2010.B2_LOCAL = SBF.BF_LOCAL) as CM,
    (select sum(SD3010.D3_QUANT) from SD3010 where SD3010.D_E_L_E_T_ = '' and SD3010.D3_FILIAL = SBF.BF_FILIAL and SD3010.D3_COD = SBF.BF_PRODUTO and SD3010.D3_LOCAL = SBF.BF_LOCAL and SD3010.D3_LOCALIZ = SBF.BF_LOCALIZ) as MOV_INVENT
from SBF010 SBF
    inner join SB7010 SB7 (nolock)
        on SB7.D_E_L_E_T_ = ''
        and SB7.B7_FILIAL = SBF.BF_FILIAL
        and SB7.B7_COD = SBF.BF_PRODUTO
        and SB7.B7_LOCAL = SBF.BF_LOCAL
        and SB7.B7_LOCALIZ = SBF.BF_LOCALIZ
    inner join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SBF.BF_PRODUTO
where SBF.D_E_L_E_T_ = ''
