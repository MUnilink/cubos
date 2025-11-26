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
    left(ZE3.ZE3_NUM, 6) as FILORI,
    
    trim(ZC1.ZC1_NUM) as NUM_OS,
    trim(DUD.DUD_VIAGEM) as NUM_VG,
    
    DT6.DT6_DOC as DOC_VIAGEM,
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
    
    COMP.D2_DOC as DOCOMP_VGA,
    case VGA2.DUD_STATUS
        when '1' then upper('Em Aberto')
        when '2' then upper('Em Transito')
        when '3' then upper('Carregado')
        when '4' then upper('Encerrado')
        when '9' then upper('Cancelado')
        else 'N/A'
    end as STATUS_DOCOMPVGA,

    SC5010.C5_NUM as RPS_PEDIDO,
    RPS.D2_DOC as RPS_DOC,

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
            when ZC1.ZC1_DTENCE = '' then ZC1.ZC1_DTFIM
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
        when left(ZE2.ZE2_COD, 2) = '01' then ZE3.ZE3_VALOR
        when left(ZE2.ZE2_COD, 2) = '11' then ZE3.ZE3_VALOR*-1
        when left(ZE2.ZE2_COD, 2) like '[0-9][2-9]' then ZE3.ZE3_VALOR*-1
    else 0.0 end as VALOR

from ZE3010 ZE3 (nolock)
    inner join ZE2010 ZE2 (nolock)
        on ZE2.D_E_L_E_T_ = ''
        and ZE2.ZE2_COD = ZE3.ZE3_ITEMPL
    left join ZC1010 ZC1 (nolock)
        on ZC1.D_E_L_E_T_ = ''
        and left(ZE3.ZE3_NUM, 6) = ZC1.ZC1_FILIAL
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
    ) DUD
        on DUD.DUD_FILIAL = left(ZE3.ZE3_NUM, 4)
        and nullif(concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)), trim(DUD.DUD_FILORI)) = trim(ZE3.ZE3_NUM)
        
        left join DT6010 DT6 (nolock)
            on DT6.D_E_L_E_T_ = ''
            and DT6.DT6_FILDOC = DUD.DUD_FILDOC
            and DT6.DT6_DOC = DUD.DUD_DOC
            and DT6.DT6_SERIE = DUD.DUD_SERIE
            
            left join SD2010 COMP (nolock)
                on COMP.D_E_L_E_T_ = ''
                and COMP.D2_NFORI = DT6.DT6_DOC
                and COMP.D2_SERIORI = DT6.DT6_SERIE
                and COMP.D2_CLIENTE = DT6.DT6_CLIDEV
                and COMP.D2_LOJA = DT6.DT6_LOJDEV

                left join DUD010 VGA2 (nolock)
                    on VGA2.D_E_L_E_T_ = ''
                    and VGA2.DUD_FILDOC = COMP.D2_FILIAL
                    and VGA2.DUD_DOC = COMP.D2_DOC
                    and VGA2.DUD_SERIE = COMP.D2_SERIE

        left join SC5010 (nolock)
            on SC5010.D_E_L_E_T_ = ''
            and trim(SC5010.C5_YVIAGEM) = DUD.DUD_VIAGEM

            left join SD2010 RPS (nolock)
                on RPS.D_E_L_E_T_ = ''
                and RPS.D2_FILIAL = SC5010.C5_FILIAL
                and RPS.D2_DOC = SC5010.C5_NOTA
                and RPS.D2_SERIE = SC5010.C5_SERIE
                and RPS.D2_CLIENTE = SC5010.C5_CLIENTE
                and RPS.D2_LOJA = SC5010.C5_LOJACLI
    
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
