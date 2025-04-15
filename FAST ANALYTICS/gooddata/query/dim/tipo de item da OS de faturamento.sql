    select distinct
        cast(ZC2.ZC2_TIPO as int) as ID_TIPO_ITEM,
        case cast(ZC2.ZC2_TIPO as int)
            when 1 then 'RECEITA'
            when 2 then 'FOLHA'
            when 3 then 'MANUTENÇÃO'
            when 4 then 'MATERIAIS'
            when 5 then 'COMPRAS'
            when 6 then 'DEPRECIAÇÃO'
            when 7 then 'CONTABILIDADE'
            when 8 then 'DESPESAS FINANCEIRAS'
            when 9 then 'DOCUMENTAÇÃO'
            when 10 then 'COMBUSTIVEL'
            when 11 then 'SERVIÇOS TOMADOS'
            when 12 then 'SEGURO EQUIPAMENTO'
            when 13 then 'PNEUS'
            when 14 then 'PROVISÕES'
            else 'OUTROS'
        end as TIPO_INSUMO
    from ZC2010 ZC2
    where ZC2.D_E_L_E_T_ = ''
union select null, null
