select distinct
    'P |01|01' AS BK_EMPRESA,
    case when nullif(concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)), trim(DUD.DUD_FILORI)) is not null then 'P |01|01'+ CAST(DUD.DUD_FILORI AS CHAR (6)) else 'P |01||' end as BK_FILIAL,
    
    case
        when nullif(concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)), trim(DUD.DUD_FILORI)) is not null then ('P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE('', ' '))+'|'+RTRIM(COALESCE('11', ' ')), ' '), '|'))
        else null
    end as BK_ITEM_CONTABIL,
    case
        when right(left(trim(ZE3.ZE3_NUM), 6), 1) = '1' then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE('', ' '))+'|'+RTRIM(COALESCE('', ' ')), ' '), '|')
        else 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT010.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(ZE3.ZE3_ORIGEM, ' ')), ' '), '|')
    end as BK_CENTRO_DE_CUSTO,
    
    /* para validação no RM */
    trim(ZE3.ZE3_NUM) as OS_VGA,
    trim(DUD.DUD_FILORI) as FILIAL_VG,
    trim(DUD.DUD_VIAGEM) as NUM_VG,
    
    ZE3.ZE3_VALOR as VL_ORIGINAL,
    trim(ZE2.ZE2_CONTA) as CONTA,
    trim(ZE2.ZE2_CLASS) as CLASSE,

    case
        when len(trim(ZE2.ZE2_COD)) <= 2 then 1
        when len(trim(ZE2.ZE2_COD)) <= 3 then 2
        when len(trim(ZE2.ZE2_COD)) <= 5 then 3
        when len(trim(ZE2.ZE2_COD)) <= 8 then 4
        else 0
    end as NIVEL,

    case
        when len(trim(ZE2.ZE2_COD)) = 8 then left(trim(ZE2.ZE2_COD), 5)
        when len(trim(ZE2.ZE2_COD)) = 5 then left(trim(ZE2.ZE2_COD), 3)
        when len(trim(ZE2.ZE2_COD)) = 3 then left(trim(ZE2.ZE2_COD), 2)
        else null
    end as CODSUP,

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
    trim(ZE2.ZE2_ORIGEM) as ORIGEM

from ZE3010 ZE3 (nolock)
    inner join ZE2010 ZE2 (nolock)
        on ZE2.D_E_L_E_T_ = ''
        and ZE2.ZE2_COD = ZE3.ZE3_ITEMPL
    left join DUD010 DUD
        on DUD.D_E_L_E_T_ = ''
        and left(ZE3.ZE3_NUM, 4) = DUD.DUD_FILIAL
        and concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)) = trim(ZE3.ZE3_NUM)
    left join CTT010
        on CTT010.D_E_L_E_T_ = ''
        and CTT010.CTT_CUSTO = ZE3.ZE3_ORIGEM
where
        ZE3.D_E_L_E_T_ = '' and ZE3.ZE3_COMPET like '2025%'
