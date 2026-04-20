select
    concat(trim(DA0.DA0_FILIAL), trim(DA0.DA0_CODTAB)) as ID_TABELA_PRECO,
	trim(DA0.DA0_CODTAB) as COD_TABELA,
    trim(DA0.DA0_DESCRI) as NOME_TABELA
from DA0010 DA0
where DA0.D_E_L_E_T_ = ''
