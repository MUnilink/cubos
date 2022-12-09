select
    trim(SA2.A2_CGC) as CNPJ,
    trim(SA2.A2_NOME) as NOME_FORNECEDOR,
	trim(SA2.A2_NREDUZ) as NOMERED_FORNECEDOR,
    trim(SA2.A2_CONTATO) as CONTATO,
    trim(SA2.A2_EMAIL) as EMAIL,
    trim(SA2.A2_END) as ENDERECO,
    trim(SA2.A2_COMPLEM) as COMPLEMENTO,
    trim(SA2.A2_BAIRRO) as BAIRRO,
    trim(SA2.A2_MUN) as CIDADE,
    trim(SA2.A2_EST) as ESTADO
from SA2010 SA2 (nolock)
where SA2.D_E_L_E_T_ = ''
