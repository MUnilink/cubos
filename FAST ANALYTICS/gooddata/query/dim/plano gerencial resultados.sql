select
    trim(ZE2.ZE2_COD) as CODIGO,
    upper(trim(ZE2.ZE2_DESC)) as DESCRICAO,
    concat(trim(ZE2.ZE2_COD), ' ', upper(trim(ZE2.ZE2_DESC))) as CODDESC,
    trim(ZE2.ZE2_ORIGEM) as ORIGEM,
    ZE2.ZE2_MSBLQL as BLOQUEADO,
    
    case
        when len(trim(ZE2.ZE2_COD)) = 7 then left(trim(ZE2.ZE2_COD), 4)
        when len(trim(ZE2.ZE2_COD)) = 6 then left(trim(ZE2.ZE2_COD), 3)
        when len(trim(ZE2.ZE2_COD)) = 4 then left(trim(ZE2.ZE2_COD), 3)
        when len(trim(ZE2.ZE2_COD)) = 3 then left(trim(ZE2.ZE2_COD), 2)
        else null
    end as CODSUP

from ZE2010 ZE2
where ZE2.D_E_L_E_T_ = ''
