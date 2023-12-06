select 
    DTW.DTW_VIAGEM,

    SA1.A1_COD,
    SA1.A1_LOJA,
    SA1.A1_NOME,
    SA1.A1_END,
    SA1.A1_COMPLEM,
    SA1.A1_BAIRRO,
    SA1.A1_CEP,
    SA1.A1_MUN,
    SA1.A1_EST,
    SA1.A1_TEL,
    SA1.A1_CGC as CPF_CNPJ,
    SA1.A1_EMAIL

from DTW010 as DTW (nolock)
    join DTQ010 as DTQ (nolock)
        on DTQ.D_E_L_E_T_ = ''
        and DTQ.DTQ_FILORI = DTW.DTW_FILORI
        and DTQ.DTQ_VIAGEM = DTW.DTW_VIAGEM

    join SA1010 as SA1 (nolock)
        on SA1.D_E_L_E_T_ = ''
        and SA1.A1_COD = DTW.DTW_CODCLI
        and SA1.A1_LOJA = DTW.DTW_LOJCLI
where DTW.D_E_L_E_T_ = ''

/*
fica o adendo que um join DTW = DTR pode trazer o veiculo para a consulta
*/