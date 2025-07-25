select
    ZE2.ZE2_COD as CODIGO,
    upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc'))) as DESCRICAO,
    concat(trim(ZE2.ZE2_COD), ' ', upper(trim(translate(lower(replace(ZE2.ZE2_DESC, ',', ' ')), 'áéíóúãõç', 'aeiouaoc')))) as CODDESC,
    trim(ZE3.ZE3_ORIGEM) as CC,
    
    coalesce
    (
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
            where
                    SC6010.D_E_L_E_T_ = ''
                and concat(SC6010.C6_FILIAL, SC6010.C6_YOS) = ZE3.ZE3_NUM
        ),
        (
            select min('P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD010.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD010.CTD_ITEM, ' ')), ' '), '|'))
            from SD2010 SD2 (nolock)
                left join DUD010 DUD (nolock)
                    on DUD.D_E_L_E_T_ = ''
                    and DUD.DUD_FILDOC = SD2.D2_FILIAL
                    and DUD.DUD_DOC = SD2.D2_DOC
                    and DUD.DUD_SERIE = SD2.D2_SERIE
                    and DUD.DUD_SERIE != 'COL'
                
                left join SD2010 COMP (nolock)
                    on COMP.D_E_L_E_T_ = ''
                    and COMP.D2_DOC = SD2.D2_NFORI
                    and COMP.D2_SERIE = SD2.D2_SERIORI
                    and COMP.D2_CLIENTE = SD2.D2_CLIENTE
                    and COMP.D2_LOJA = SD2.D2_LOJA

                    left join DUD010 VGA2 (nolock)
                        on VGA2.D_E_L_E_T_ = ''
                        and VGA2.DUD_FILDOC = COMP.D2_FILIAL
                        and VGA2.DUD_DOC = COMP.D2_DOC
                        and VGA2.DUD_SERIE = COMP.D2_SERIE
                
                left join SC5010 (nolock)
                    on SC5010.D_E_L_E_T_ = ' '
                    and SC5010.C5_FILIAL = SD2.D2_FILIAL
                    and SC5010.C5_NOTA = SD2.D2_DOC
                    and SC5010.C5_SERIE = SD2.D2_SERIE
                    and SC5010.C5_CLIENTE = SD2.D2_CLIENTE
                    and SC5010.C5_LOJACLI = SD2.D2_LOJA

                    left join DUD010 VGA3 (nolock)
                        on VGA3.D_E_L_E_T_ = ' '
                        and VGA3.DUD_VIAGEM = SC5010.C5_YVIAGEM
                
                inner join CTD010 (nolock)
                    on CTD010.D_E_L_E_T_ = ''
                    and CTD010.CTD_ITEM = SD2.D2_ITEMCC
            where
                    SD2.D_E_L_E_T_ = ''
                and coalesce
                (
                    concat(DUD.DUD_FILDOC, DUD.DUD_VIAGEM),
                    concat(VGA2.DUD_FILDOC, VGA2.DUD_VIAGEM),
                    concat(VGA3.DUD_FILDOC, VGA3.DUD_VIAGEM),
                    ''
                ) = ZE3.ZE3_NUM
        ),
        (
            select min('P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD010.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD010.CTD_ITEM, ' ')), ' '), '|'))
            from SE1010 (nolock)
                inner join CTD010 (nolock)
                    on CTD010.D_E_L_E_T_ = ''
                    and CTD010.CTD_ITEM = SE1010.E1_ITEMCTA
            where
                    SE1010.D_E_L_E_T_ = ''
                and
                (
                    select distinct concat(DUD010.DUD_FILDOC, DUD010.DUD_VIAGEM)
                    from DUD010 (nolock)
                        inner join SE1010 (nolock)
                            on SE1010.D_E_L_E_T_ = ''
                            and (trim(SE1010.E1_YVIATMS) = DUD010.DUD_VIAGEM or SE1010.E1_YVIAGEM = DUD010.DUD_VIAGEM)
                ) = ZE3.ZE3_NUM
        )
    ) as ATIVIDADE,
    
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
where
        ZE3.D_E_L_E_T_ = ''
