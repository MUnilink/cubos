select distinct
    ZE2.ZE2_COD as CODIGO,
    upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc'))) as DESCRICAO,
    concat(trim(ZE2.ZE2_COD), ' ', upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc')))) as CODDESC,
    trim(ZE3.ZE3_ORIGEM) as ORIGEM_CC,
    trim(ZE3.ZE3_ITORIG) as ORIGEM_AT,
    
    ZE2.ZE2_MSBLQL as BLOQUEADO,
    ZE3.ZE3_COMPET as PERIODO,
    trim(ZE3.ZE3_NUM) as OS_VGA,
    trim(ZE2.ZE2_CONTA) as CONTA,
    left(ZE3.ZE3_NUM, 6) as FILIAL_OSVGA,
    
    trim(ZC1.ZC1_NUM) as NUM_OS,
    trim(DUD.DUD_VIAGEM) as NUM_VG,
    
    case DUD.DUD_STATUS
        when '1' then upper('Em Aberto')
        when '2' then upper('Em Transito')
        when '3' then upper('Carregado')
        when '4' then upper('Encerrado')
        when '9' then upper('Cancelado')
        else 'N/A'
    end as STATUS_DOCVIAGEM,
    
    DUD.VGA_NORMAL as TIPO_VIAGEM,
    DUD.DUA_NUMVTR as VIAGEM_SUB,
    
    left
    (
        case
            when exists (select * from DTQ010 where DTQ010.D_E_L_E_T_ = '' and DTQ010.DTQ_FILORI = DUD.DUD_FILORI and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM and DTQ010.DTQ_STATUS != '3') then null
            when exists (select * from DTQ010 where DTQ010.D_E_L_E_T_ = '' and DTQ010.DTQ_FILORI = DUD.DUD_FILORI and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM and DTQ010.DTQ_STATUS = '3') then
            (
                select DTW010.DTW_DATREA
                from DTW010 (nolock)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILIAL = DUD.DUD_FILIAL
                    and DTW010.DTW_FILORI = DUD.DUD_FILORI
                    and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                    and DTW010.DTW_ATIVID = 50
            )
            when ZC1.ZC1_STATUS = 1 then null
            else ZC1.ZC1_DTENCE end
    ,6) as PERIODO_FIMOS,
    
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
        when left(ZE2.ZE2_COD, 8) = '02101007' then ZE3.ZE3_VALOR
        when left(ZE2.ZE2_COD, 8) = '02501002' then ZE3.ZE3_VALOR*-1
        when left(ZE2.ZE2_COD, 5) = '072' then ZE3.ZE3_VALOR
        when left(ZE2.ZE2_COD, 2) = '01' then ZE3.ZE3_VALOR
        when left(ZE2.ZE2_COD, 2) = '11' then ZE3.ZE3_VALOR*-1
        when left(ZE2.ZE2_COD, 2) like '[0-9][2-9]' then ZE3.ZE3_VALOR*-1
    else 0.0 end as VALOR,

    case
        when ZE2.ZE2_ORIGEM in ('Q', 'T') and coalesce(nullif(concat(trim(ZC1.ZC1_NUM), trim(DUD.DUD_VIAGEM)), ''), nullif(trim(ZE2.ZE2_CONTA), ''), 'ERRO?') = 'ERRO?' then 'ERRO'
        when ZE2.ZE2_ORIGEM in ('E', 'F') and cast(ZE2.ZE2_COD as int) < 9 and coalesce(nullif(concat(trim(ZC1.ZC1_NUM), trim(DUD.DUD_VIAGEM)), ''), nullif(trim(ZE2.ZE2_CONTA), ''), 'ERRO?') = 'ERRO?' then 'ERRO'
        else 'VERIFICAR'
    end as OSVGACONTA

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
    and ZE3.ZE3_COMPET>=:PERIODO_INI
    and ZE3.ZE3_COMPET<=:PERIODO_FIM
