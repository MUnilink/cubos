select
    case when len(trim(ZE2.ZE2_COD)) <= 2 then trim(ZE2.ZE2_COD) else left(trim(ZE2.ZE2_COD), 2) end as CODIGO_C1,
    case when len(trim(ZE2.ZE2_COD)) <= 3 then trim(ZE2.ZE2_COD) else left(trim(ZE2.ZE2_COD), 3) end as CODIGO_C2,
    case when len(trim(ZE2.ZE2_COD)) <= 4 then trim(ZE2.ZE2_COD) else left(trim(ZE2.ZE2_COD), 4) end as CODIGO_C3,
    case when len(trim(ZE2.ZE2_COD)) <= 7 then trim(ZE2.ZE2_COD) else left(trim(ZE2.ZE2_COD), 7) end as CODIGO_C4,
    
    trim(ZE2.ZE2_COD) as CODIGO,
    upper(trim(ZE2.ZE2_DESC)) as DESCRICAO,
    concat(trim(ZE2.ZE2_COD), ' ', upper(trim(ZE2.ZE2_DESC))) as CODDESC,
    
    trim(ZE2.ZE2_ORIGEM) as ORIGEM,
    ZE2.ZE2_MSBLQL as BLOQUEADO,
    
    case
        when len(trim(ZE2.ZE2_COD)) = 7 then left(trim(ZE2.ZE2_COD), 4)
        when len(trim(ZE2.ZE2_COD)) = 4 then left(trim(ZE2.ZE2_COD), 3)
        when len(trim(ZE2.ZE2_COD)) = 3 then left(trim(ZE2.ZE2_COD), 2)
        else null
    end as CODSUP

from ZE2010 ZE2
where ZE2.D_E_L_E_T_ = ''
