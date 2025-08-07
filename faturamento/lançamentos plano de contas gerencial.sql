select
    ZE2.ZE2_COD as CODIGO,
    upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc'))) as DESCRICAO,
    concat(trim(ZE2.ZE2_COD), ' ', upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc')))) as CODDESC,
    trim(ZE3.ZE3_ORIGEM) as CC,
    
    case
        when ZC1.ZC1_NUM is not null then
        (
            select min('P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD010.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC6010.C6_ITEMCTA, ' ')), ' '), '|'))
            from SC6010
                inner join CTD010
                    on CTD010.CTD_FILIAL = ''
                    and CTD010.CTD_ITEM = SC6010.C6_ITEMCTA
                    and CTD010.D_E_L_E_T_ = ''
                inner join SD2010
                    on SD2010.D_E_L_E_T_= ''
                    and SD2010.D2_FILIAL = SC6010.C6_FILIAL
                    and SD2010.D2_PEDIDO = SC6010.C6_NUM
                    and SD2010.D2_ITEMPV = SC6010.C6_ITEM
        where
                    SC6010.D_E_L_E_T_ = ''
                and concat(SC6010.C6_FILIAL, SC6010.C6_YOS) = ZE3.ZE3_NUM
        )
        
        when nullif(concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)), trim(DUD.DUD_FILORI)) is not null then ('P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE('', ' '))+'|'+RTRIM(COALESCE('11', ' ')), ' '), '|'))
        else null
    end as ATIVIDADE,
    
    ZE2.ZE2_MSBLQL as BLOQUEADO,
    ZE3.ZE3_COMPET as PERIODO,
    ZE3.ZE3_NUM,
    trim(ZE2.ZE2_CONTA) as CONTA,
    left(ZE3.ZE3_NUM, 6) as FILORI,
    right(trim(ZE3.ZE3_NUM), 11) as NUM_OS,
    right(trim(ZE3.ZE3_NUM), 6) as NUM_VG,
    
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
    
    ZE3.ZE3_VALOR as VL_ORIGINAL,
    case
        when ZE2.ZE2_ORIGEM = 'F' then ZE3.ZE3_VALOR
        when left(ZE2.ZE2_COD, 2) = '01' then ZE3.ZE3_VALOR
        when left(ZE2.ZE2_COD, 2) = '11' then ZE3.ZE3_VALOR*-1
        when left(ZE2.ZE2_COD, 2) like '[0-9][2-9]' then ZE3.ZE3_VALOR*-1
    else 0.0 end as VALOR,

    case
        when left(ZE3.ZE3_NUM, 6) = '010101' and trim(ZE3.ZE3_ORIGEM) = '304' then 'TMS'
        when left(ZE3.ZE3_NUM, 6) = '010101' and trim(ZE3.ZE3_ORIGEM) = '305' then 'OPP MATRIZ'
        when left(ZE3.ZE3_NUM, 6) = '010102' and trim(ZE3.ZE3_ORIGEM) = '304' then 'TMS PECEM'
        when left(ZE3.ZE3_NUM, 6) = '010102' and trim(ZE3.ZE3_ORIGEM) = '305' then 'OPP'
    else 'OUTROS' end as TIPO_RODA

from ZE3010 ZE3 (nolock)
    inner join ZE2010 ZE2 (nolock)
        on ZE2.D_E_L_E_T_ = ''
        and ZE2.ZE2_COD = ZE3.ZE3_ITEMPL
    left join ZC1010 ZC1
        on ZC1.D_E_L_E_T_ = ''
        and left(ZE3.ZE3_NUM, 6) = ZC1.ZC1_FILIAL
        and concat(ZC1.ZC1_FILIAL, ZC1.ZC1_NUM) = ZE3.ZE3_NUM
    left join DUD010 DUD
        on DUD.D_E_L_E_T_ = ''
        and left(ZE3.ZE3_NUM, 4) = DUD.DUD_FILIAL
        and concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)) = trim(ZE3.ZE3_NUM)
where
        ZE3.D_E_L_E_T_ = ''
    and ZE3.ZE3_COMPET=:PERIODO
