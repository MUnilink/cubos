select
	SX6.X6_FIL as FILIAL,
    SX6.X6_VAR as PARAMETRO,
    SX6.X6_TIPO as TIPO,
    trim(SX6.X6_DESCRIC) +' '+ trim(SX6.X6_DESC1) +' '+ trim(SX6.X6_DESC2) as DESCRICAO,
    SX6.X6_PROPRI as PROPRI,
    SX6.X6_PYME as PYME,
    trim(SX6.X6_CONTEUD) as CONTEUDO
from SX6010 SX6 (nolock)
where
    SX6.D_E_L_E_T_ = ''
