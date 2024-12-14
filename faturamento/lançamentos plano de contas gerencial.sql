select distinct
    ZE2.ZE2_COD as CODIGO,
    upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc'))) as DESCRICAO,
    concat(trim(ZE2.ZE2_COD), ' ', upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc')))) as CODDESC,
    trim(ZE2.ZE2_ORIGEM) as ORIGEM,
    ZE2.ZE2_MSBLQL as BLOQUEADO,
    ZE3.ZE3_COMPET as PERIODO,
    
    case
        when len(trim(ZE2.ZE2_COD)) = 8 then left(trim(ZE2.ZE2_COD), 5)
        when len(trim(ZE2.ZE2_COD)) = 5 then left(trim(ZE2.ZE2_COD), 3)
        when len(trim(ZE2.ZE2_COD)) = 3 then left(trim(ZE2.ZE2_COD), 2)
        else null
    end as CODSUP,
    ZE3.ZE3_VALOR as VALOR

from ZE3010 ZE3
    inner join ZE2010 ZE2
        on ZE2.D_E_L_E_T_ = ''
        and ZE2.ZE2_COD = ZE3.ZE3_ITEMPL
where
        ZE3.D_E_L_E_T_ = ''
