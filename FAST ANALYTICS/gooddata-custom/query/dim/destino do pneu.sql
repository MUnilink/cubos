select
    concat(trim(SX5010.X5_FILIAL), trim(SX5010.X5_TABELA), trim(SX5010.X5_CHAVE)) as ID_DESTINO,
    trim(SX5010.X5_TABELA) as X5_TABELA
    trim(SX5010.X5_CHAVE) as X5_CHAVE
    trim(SX5010.X5_DESCRI) as X5_DESCRI
from SX5010
where
        SX5010.D_E_L_E_T_ = ''
    and SX5010.X5_TABELA = 'DP'
