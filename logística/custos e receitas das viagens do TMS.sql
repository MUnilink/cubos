select
    ZE4.ZE4_TOTHR as VGA_HORAS,
    ZE4.ZE4_STATUS as STATUS_TMS,
    ZE4.ZE4_KMINI as km_ini,
    ZE4.ZE4_KMFIM as km_fim,
    ZE4.ZE4_KMFIM - ZE4.ZE4_KMINI as km_VIAGEM,
    ZE5.ZE5_ITENS as VGA_ITEMCOM,
    
    trim(ZE1.ZE1_COD) as VGA_CODIGO,
    cast(ZE1.ZE1_TOTAL as numeric(15, 2)) as VGA_VALOR,
    cast(ZE1.ZE1_DATA as date) as VGA_DATA,
    left(ZE1.ZE1_COMPET, 6) as VGA_PERIODO,

    ZE1.ZE1_ITEM as VGA_ITEMCUSTO,
    ZE1.ZE1_TIPO as VGA_TIPO,
    case ZE1.ZE1_TIPO
        when 1 then 'RECEITA'
        when 2 then 'FOLHA'
        when 3 then 'MANUTENÇÃO'
        when 4 then 'MATERIAIS'
        when 5 then 'COMPRAS'
        when 6 then 'DEPRECIAÇÃO'
        when 7 then 'CONTABILIDADE'
        when 8 then 'DESPESAS FINANCEIRAS'
        when 9 then 'OUTROS CUSTOS - TAXAS'
        when 10 then 'COMBUSTIVEL'
        when 11 then 'SERVIÇOS TOMADOS'
        when 12 then 'SEGURO'
        when 13 then 'PNEUS'
        when 14 then 'PROVISÕES'
        when 15 then 'TIPO RH IMPROD'
        when 16 then 'TIPO MNT IMPROD'
        when 17 then 'DIÁRIA'
        else 'OUTROS'
    end as TIPO_ITEM,

    case
        when ZE1.ZE1_TIPO in (1, 4, 5, 11) then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO in (1, 4, 5, 11))
        when ZE1.ZE1_TIPO in (2, 14, 15) then (select trim(SQ3010.Q3_DESCSUM) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and SQ3010.Q3_CARGO = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO in (2, 14))
        when ZE1.ZE1_TIPO in (3, 6, 9, 10, 12, 13, 16) then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO in (3, 6, 9, 10, 12, 13, 16))
        when ZE1.ZE1_TIPO = 7 then (select trim(ZA7010.ZA7_DESC) from ZA7010 (nolock) where ZA7010.D_E_L_E_T_ = '' and trim(ZA7010.ZA7_COD) = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO = 7)
    else null end as DESC_RECURSO

from ZE1010 ZE1 (nolock)
    inner join ZE4010 ZE4 (nolock)
        on ZE4.D_E_L_E_T_ = ''
        and ZE4.ZE4_FILIAL = ZE1.ZE1_FILIAL
        and ZE4.ZE4_VIAGEM = ZE1.ZE1_NUM

        left join ZE5010 ZE5 (nolock)
            on ZE5.D_E_L_E_T_ = ''
            and ZE5.ZE5_FILIAL = ZE4.ZE4_FILIAL
            and ZE5.ZE5_VIAGEM = ZE4.ZE4_VIAGEM

where
        ZE1.D_E_L_E_T_ = ''
