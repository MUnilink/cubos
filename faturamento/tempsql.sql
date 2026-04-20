select distinct
    
    case
        when len(trim(ZE2.ZE2_COD)) > 2 and coalesce(nullif(concat(trim(ZC1.ZC1_NUM), trim(DUD.DUD_VIAGEM)), ''), nullif(trim(ZE2.ZE2_CONTA), ''), 'ERRO?') = 'ERRO?' then 'ERRO'
        when len(trim(ZE2.ZE2_COD)) <= 2 then 'OK'
    end as OSVGACONTA,
    
    concat(trim(ZE2.ZE2_COD), ' ', upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc')))) as CODDESC,
    trim(ZE3.ZE3_ORIGEM) as ORIGEM_CC,
    trim(ZE3.ZE3_ITORIG) as ORIGEM_AT,
    ZE3.ZE3_COMPET as COMPET,
    
    ZE2.ZE2_MSBLQL as BLOQUEADO,
    ZE3.ZE3_COMPET as PERIODO,
    trim(ZE3.ZE3_NUM) as OS_VGA,
    trim(ZE2.ZE2_CONTA) as CONTA,
    left(ZE3.ZE3_NUM, 6) as FILIAL_OSVGA,
    
    trim(ZC1.ZC1_NUM) as NUM_OS,
    trim(DUD.DUD_VIAGEM) as NUM_VG,
    
    DUD.VGA_NORMAL as TIPO_VIAGEM,
    DUD.DUA_NUMVTR as VIAGEM_SUB,
    ZE3.ZE3_VALOR as VL_ORIGINAL

from ZE3010 ZE3 (nolock)
    inner join ZE2010 ZE2 (nolock)
        on ZE2.D_E_L_E_T_ = ''
        and ZE2.ZE2_COD = ZE3.ZE3_ITEMPL
    left join ZC1010 ZC1 (nolock)
        on ZC1.D_E_L_E_T_ = ''
        and concat(ZC1.ZC1_FILIAL, ZC1.ZC1_NUM) = ZE3.ZE3_NUM
    left join
    (
        select distinct
            DUD010.DUD_FILIAL,
            DUD010.DUD_FILORI,
            DUD010.DUD_VIAGEM,
            DUD010.DUD_FILDOC,
            DUD010.DUD_DOC,
            DUD010.DUD_SERIE,
            DUD010.DUD_STATUS,
            DUA010.DUA_CODOCO, /* and DUA010.DUA_CODOCO != 'E004' */
            DUA010.DUA_FILVTR,
            DUA010.DUA_NUMVTR, /* and DUA010.DUA_NUMVTR = '' */
            case when DUA010.DUA_CODOCO = 'E004' and concat(DUA010.DUA_FILVTR, DUA010.DUA_NUMVTR) != '' then 'SOCORRO' else 'NORMAL' end as VGA_NORMAL
        from DUD010
            left join DUA010
                on DUA010.D_E_L_E_T_ = ''
                and DUA010.DUA_FILIAL = DUD010.DUD_FILIAL
                and DUA010.DUA_FILORI = DUD010.DUD_FILORI
                and DUA010.DUA_VIAGEM = DUD010.DUD_VIAGEM
                and DUA010.DUA_FILDOC = DUD010.DUD_FILDOC
                and DUA010.DUA_DOC = DUD010.DUD_DOC
                and DUA010.DUA_SERIE = DUD010.DUD_SERIE
        where
                DUD010.D_E_L_E_T_ = ''
            and DUD010.DUD_SERIE != 'COL'
    ) DUD on nullif(concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)), trim(DUD.DUD_FILORI)) = trim(ZE3.ZE3_NUM)
    
    left join CTT010 (nolock)
        on CTT010.D_E_L_E_T_ = ''
        and CTT010.CTT_CUSTO = ZE3.ZE3_ORIGEM
    left join CTD010 (nolock)
        on CTD010.D_E_L_E_T_ = ''
        and CTD010.CTD_ITEM = ZE3.ZE3_ITORIG
where
        ZE3.D_E_L_E_T_ = ''
    and ZE3.ZE3_COMPET like '20250[1-3]'
    and
        case
            when len(trim(ZE2.ZE2_COD)) > 2 and coalesce(nullif(concat(trim(ZC1.ZC1_NUM), trim(DUD.DUD_VIAGEM)), ''), nullif(trim(ZE2.ZE2_CONTA), ''), 'ERRO?') = 'ERRO?' then 'ERRO'
            when len(trim(ZE2.ZE2_COD)) <= 2 then 'OK'
            else 'OK' end = 'OK'
