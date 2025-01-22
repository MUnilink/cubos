select
    concat(trim(ZC1.ZC1_FILIAL), trim(ZC1.ZC1_NUM)) as BK_OSPORTUARIA,
    substring(ZC1.ZC1_NUM, 6, 10) as OS,
    trim(ZC1.ZC1_VIAGEM) as VIAGEM_PORT,
    (select trim(ZA3010.ZA3_DESC) from ZA3010 where ZA3010.D_E_L_E_T_ = '' and ZA3010.ZA3_COD = ZC1.ZC1_NAVIO) as DESC_NAVIO,
    (select trim(SX5010.X5_DESCRI) from SX5010 where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = '_1' and SX5010.X5_CHAVE = ZC1.ZC1_PORTO) as DESC_PORTO,
    
    case ZC1.ZC1_STATUS
        when 1 then 'ABERTA'
        when 2 then 'SOLICITADO CANCELAMENTO'
        when 3 then 'CANCELADA'
        when 5 then 'CORTESIA'
        when 6 then 'ENCERRADA'
        else 'OUTROS'
    end as STATUS_OS,

    case ZC1.ZC1_STATU2
        when 1 then 'PENDENTE'
        when 2 then 'PARCIAL'
        when 3 then 'FINALIZADO'
        else 'OUTROS'
    end as STATUS_FATURAMENTO

from ZC1010 ZC1
where
        ZC1.D_E_L_E_T_ = ''

union select null, null, null, null, null, null, null
