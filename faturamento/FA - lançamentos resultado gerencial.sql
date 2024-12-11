select distinct
    CASE WHEN ZC1.ZC1_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(ZC1.ZC1_FILIAL AS CHAR (6)) END AS BK_FILIAL,
    concat(trim(ZC1.ZC1_FILIAL), trim(ZC1.ZC1_NUM)) as ID_OSPORTUARIA,
    concat(ZE3.ZE3_COMPET, '01') as PERIODO,

    case when len(trim(ZE2.ZE2_COD)) <= 2 then trim(ZE2.ZE2_COD) else left(trim(ZE2.ZE2_COD), 2) end as CODIGO_C1,
    case when len(trim(ZE2.ZE2_COD)) <= 3 then trim(ZE2.ZE2_COD) else left(trim(ZE2.ZE2_COD), 3) end as CODIGO_C2,
    case when len(trim(ZE2.ZE2_COD)) <= 5 then trim(ZE2.ZE2_COD) else left(trim(ZE2.ZE2_COD), 5) end as CODIGO_C3,
    case when len(trim(ZE2.ZE2_COD)) <= 8 then trim(ZE2.ZE2_COD) else left(trim(ZE2.ZE2_COD), 8) end as CODIGO_C4,
    
    case when len(trim(ZE2.ZE2_COD)) <= 2 then upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc'))) else (select upper(trim(ZE2010.ZE2_DESC)) from ZE2010 where ZE2010.D_E_L_E_T_ = '' and ZE2010.ZE2_COD = left(trim(ZE2.ZE2_COD), 2)) end as DESC_C1,
    case when len(trim(ZE2.ZE2_COD)) <= 3 then upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc'))) else (select upper(trim(ZE2010.ZE2_DESC)) from ZE2010 where ZE2010.D_E_L_E_T_ = '' and ZE2010.ZE2_COD = left(trim(ZE2.ZE2_COD), 3)) end as DESC_C2,
    case when len(trim(ZE2.ZE2_COD)) <= 5 then upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc'))) else (select upper(trim(ZE2010.ZE2_DESC)) from ZE2010 where ZE2010.D_E_L_E_T_ = '' and ZE2010.ZE2_COD = left(trim(ZE2.ZE2_COD), 5)) end as DESC_C3,
    case when len(trim(ZE2.ZE2_COD)) <= 8 then upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc'))) else (select upper(trim(ZE2010.ZE2_DESC)) from ZE2010 where ZE2010.D_E_L_E_T_ = '' and ZE2010.ZE2_COD = left(trim(ZE2.ZE2_COD), 8)) end as DESC_C4,

    case when len(trim(ZE2.ZE2_COD)) <= 2 then concat(trim(ZE2.ZE2_COD), ' ', upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc')))) else (select concat(trim(ZE2010.ZE2_COD), ' ', upper(trim(ZE2010.ZE2_DESC))) from ZE2010 where ZE2010.D_E_L_E_T_ = '' and ZE2010.ZE2_COD = left(trim(ZE2.ZE2_COD), 2)) end as CODDESC_C1,
    case when len(trim(ZE2.ZE2_COD)) <= 3 then concat(trim(ZE2.ZE2_COD), ' ', upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc')))) else (select concat(trim(ZE2010.ZE2_COD), ' ', upper(trim(ZE2010.ZE2_DESC))) from ZE2010 where ZE2010.D_E_L_E_T_ = '' and ZE2010.ZE2_COD = left(trim(ZE2.ZE2_COD), 3)) end as CODDESC_C2,
    case when len(trim(ZE2.ZE2_COD)) <= 5 then concat(trim(ZE2.ZE2_COD), ' ', upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc')))) else (select concat(trim(ZE2010.ZE2_COD), ' ', upper(trim(ZE2010.ZE2_DESC))) from ZE2010 where ZE2010.D_E_L_E_T_ = '' and ZE2010.ZE2_COD = left(trim(ZE2.ZE2_COD), 5)) end as CODDESC_C3,
    case when len(trim(ZE2.ZE2_COD)) <= 8 then concat(trim(ZE2.ZE2_COD), ' ', upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc')))) else (select concat(trim(ZE2010.ZE2_COD), ' ', upper(trim(ZE2010.ZE2_DESC))) from ZE2010 where ZE2010.D_E_L_E_T_ = '' and ZE2010.ZE2_COD = left(trim(ZE2.ZE2_COD), 8)) end as CODDESC_C4,
    
    ZE2.ZE2_COD as CODIGO,
    upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc'))) as DESCRICAO,
    concat(trim(ZE2.ZE2_COD), ' ', upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc')))) as CODDESC,
    trim(ZE2.ZE2_ORIGEM) as ORIGEM,
    ZE2.ZE2_MSBLQL as BLOQUEADO,
    
    case
        when len(trim(ZE2.ZE2_COD)) = 8 then left(trim(ZE2.ZE2_COD), 5)
        when len(trim(ZE2.ZE2_COD)) = 5 then left(trim(ZE2.ZE2_COD), 3)
        when len(trim(ZE2.ZE2_COD)) = 3 then left(trim(ZE2.ZE2_COD), 2)
        else null
    end as CODSUP,

    case when left(ZE2.ZE2_COD, 2) = '01' then ZE3.ZE3_VALOR else ZE3.ZE3_VALOR*-1 end as VALOR
from ZE3010 ZE3
    inner join ZE2010 ZE2
        on ZE2.D_E_L_E_T_ = ''
        and ZE2.ZE2_COD = ZE3.ZE3_ITEMPL
    inner join ZC1010 ZC1
        on ZC1.D_E_L_E_T_ = ''
        and concat(ZC1.ZC1_FILIAL, ZC1.ZC1_NUM) = ZE3.ZE3_NUM
where ZE3.D_E_L_E_T_ = ''
