select
    RCC.RCC_FILIAL as FILIAL,
    RCC.RCC_CHAVE as CHAVE,
    RCC.RCC_CODIGO as TABELA,
    RCC.RCC_SEQUEN as SEQ,
    trim(RCC.RCC_CONTEU) as CONTEUDO,

    case RCC.RCC_CODIGO
        when 'S004' then 'SALARIO MINIMO'
        when 'S001' then 'INSS'
        when 'S002' then 'IRRF'
    else 'OUTRAS' end as DESC_TABELA,

    substring(RCC.RCC_CONTEU, 1, 6) as INI_VIGENCIA,
    substring(RCC.RCC_CONTEU, 7, 6) as FIM_VIGENCIA,
    trim(trim(substring(trim(substring(RCC.RCC_CONTEU, 13, 20)), 1, 8))) as VALOR_PISO,
    trim(substring(trim(substring(RCC.RCC_CONTEU, 25, 20)), 1, 6)) as PERC_PISO
from RCC010 RCC (nolock)
where RCC.D_E_L_E_T_ = ''
