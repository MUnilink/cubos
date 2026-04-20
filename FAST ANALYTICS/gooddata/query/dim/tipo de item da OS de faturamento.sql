    select distinct
        cast(ZC2.ZC2_TIPO as int) as ID_TIPO_ITEM,
        case cast(ZC2.ZC2_TIPO as int)
            when 1 then 'RECEITA'
            when 2 then 'PESSOAL'
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
            when 17 then 'DIÁRIA'
            when 18 then 'SEGURO AVARIA'
            when 19 then 'SEGURO ROUBO'
            when 20 then 'IMPR COMB'
            when 21 then 'IMPR PNEU'
            else 'OUTROS'
        end as TIPO_INSUMO,
        case when cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13, 20, 21) then 'EQUIPAMENTO' when cast(ZC2.ZC2_TIPO as int) in (2, 14, 17) then 'PESSOAL' else 'OUTROS' end as ENTIDADE
    from ZC2010 ZC2
    where ZC2.D_E_L_E_T_ = ''
union select null, null, null
