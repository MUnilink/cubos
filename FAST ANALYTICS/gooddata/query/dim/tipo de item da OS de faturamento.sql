select distinct
    ZC2.ZC2_TIPO,
    case ZC2.ZC2_TIPO
        when 1 then 'RECEITA'
        when 2 then 'FUNÇÃO'
        when 3 then 'EQUIPAMENTO'
        when 4 then 'MATERIAIS'
        when 6 then 'DEPRECIAÇÃO'
        when 7 then 'CONTABILIDADE'
        when 8 then 'DESPESAS FINANCEIRAS'
        when 9 then 'DOCUMENTAÇÃO E TAXAS'
        when 10 then 'COMBUSTIVEL'
        when 11 then 'TAXAS'
        when 12 then 'SEGURO'
        when 13 then 'PNEUS'
        else 'OUTROS'
    end as TIPO_INSUMO
from ZC2010 ZC2
where ZC2.D_E_L_E_T_ = ''
