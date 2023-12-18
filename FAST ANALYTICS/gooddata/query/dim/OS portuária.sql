select
    concat(trim(ZC1.ZC1_FILIAL), trim(ZC1.ZC1_NUM)) as ID_OS,
    substring(ZC1.ZC1_NUM, 6, 10) as OS,
    (select trim(ZA3010.ZA3_DESC) from ZA3010 where ZA3010.D_E_L_E_T_ = '' and ZA3010.ZA3_COD = ZC1.ZC1_NAVIO) as DESC_NAVIO,
    (select trim(SX5010.X5_DESCRI) from SX5010 where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = '_1' and SX5010.X5_CHAVE = ZC1.ZC1_PORTO) as DESC_PORTO,
    
    case ZC1.ZC1_STATUS
        when 1 then 'ABERTA'
        when 6 then 'FECHADA'
        else 'OUTROS'
    end as STATUS_OS
from ZC1010 ZC1
where ZC1.D_E_L_E_T_ = ''
