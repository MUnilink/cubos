select distinct
    'P |01|01' AS BK_EMPRESA,
    case when nullif(ZC1.ZC1_FILIAL, '') is not null then 'P |01|01'+ CAST(ZC1.ZC1_FILIAL AS CHAR (6)) when nullif(concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)), trim(DUD.DUD_FILORI)) is not null then 'P |01|01'+ CAST(DUD.DUD_FILORI AS CHAR (6)) else 'P |01||' end as BK_FILIAL,
    
    case
        when nullif(ZC1.ZC1_CODSA1, '') is not null then 'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CLIOPP.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(CLIOPP.A1_COD, ' '))+RTRIM(COALESCE(CLIOPP.A1_LOJA, ' ')), ' '), '|')
        when nullif(concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)), trim(DUD.DUD_FILORI)) is not null then 'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CLITMS.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(CLITMS.A1_COD, ' '))+RTRIM(COALESCE(CLITMS.A1_LOJA, ' ')), ' '), '|')
        else null
    end as BK_CLIENTE,
    
    'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA2.A2_COD, ' '))+RTRIM(COALESCE(SA2.A2_LOJA, ' ')), ' '), '|') as BK_FORNECEDOR,
    concat(trim(ZC1.ZC1_FILIAL), trim(ZC1.ZC1_NUM)) as ID_OSPORTUARIA,
    concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)) as ID_VIAGEMTMS,
    'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(ZC1.ZC1_MERCAD, ' ')), ' '), '|') as ID_MERCADORIA,
    null as ID_PEDIDODEVENDA,
    null as ID_NFS,
    'P |01|SED010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SED.ED_FILIAL, ' '))+'|'+RTRIM(COALESCE(SED.ED_CODIGO, ' ')), ' '), '|') AS BK_NAT_FINANCEIRA,
    'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SE4.E4_CODIGO, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO,
    
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
    end as BK_ITEM_CONTABIL,
    
    case
        when right(left(trim(ZE3.ZE3_NUM), 6), 1) = '1' then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE('', ' '))+'|'+RTRIM(COALESCE('', ' ')), ' '), '|')
        else 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT010.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(ZE3.ZE3_ORIGEM, ' ')), ' '), '|')
    end as BK_CENTRO_DE_CUSTO,
    
    concat(trim(DA0.DA0_FILIAL), trim(DA0.DA0_CODTAB)) as ID_TABELA_PRECO,
    concat(ZE3.ZE3_COMPET, '01') as PERIODO,
    concat(ZE3.ZE3_COMPET, '01') as COMPETENCIA,
    ZE2.ZE2_COD as CONTAROP,
    ZE2.ZE2_CONTA as CONTA_CONTABIL,
    
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
    as DT_FIMOS,
/*
    case
        when ZC1.ZC1_NUM is not null then
        (
            select min(SD2010.D2_EMISSAO)
            from SD2010
                inner join SC6010
                    on SC6010.D_E_L_E_T_= ''
                    and SC6010.C6_FILIAL = SD2010.D2_FILIAL
                    and SC6010.C6_NUM = SD2010.D2_PEDIDO
                    and SC6010.C6_ITEM = SD2010.D2_ITEMPV
        where
                    SD2010.D_E_L_E_T_ = ''
                and concat(SC6010.C6_FILIAL, SC6010.C6_YOS) = ZE3.ZE3_NUM
        )
        when nullif(concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)), trim(DUD.DUD_FILORI)) is not null then
        (
            select min(SD2010.D2_EMISSAO)
            from SD2010
            where
                    SD2010.D_E_L_E_T_ = ''
                and SD2010.D2_FILIAL = DUD.DUD_FILORI
                and SD2010.D2_DOC = DUD.DUD_DOC
                and SD2010.D2_SERIE = DUD.DUD_SERIE
                and coalesce
                (
                    DUD010.DUD_VIAGEM, /* viagem normal */
                    VGA2.DUD_VIAGEM, /* se viagem atrelada ao complemento */
                    (
                        select distinct DUD010.DUD_VIAGEM /* NF de receita extra da viagem */
                        from DUD010 (nolock)
                            inner join SC5010 (nolock)
                                on SC5010.D_E_L_E_T_ = ' '
                                and nullif(SC5010.C5_YVIAGEM, '') = DUD010.DUD_VIAGEM
                        where
                                DUD010.D_E_L_E_T_ = ''
                            and SD2.D2_FILIAL = SC5010.C5_FILIAL
                            and SD2.D2_DOC = SC5010.C5_NOTA
                            and SD2.D2_SERIE = SC5010.C5_SERIE
                            and SD2.D2_CLIENTE = SC5010.C5_CLIENTE
                            and SD2.D2_LOJA = SC5010.C5_LOJACLI
                    )
                )
        )
        else null
    end as DT_NF,
    */
    case
        when ZE2.ZE2_ORIGEM = 'F' then ZE3.ZE3_VALOR
        when left(ZE2.ZE2_COD, 2) = '01' then ZE3.ZE3_VALOR
        when left(ZE2.ZE2_COD, 2) = '11' then ZE3.ZE3_VALOR*-1
        when left(ZE2.ZE2_COD, 2) like '[0-9][2-9]' then ZE3.ZE3_VALOR*-1
    else 0.0 end as VALOR,
    
    /* para validação no RM */
    trim(ZE3.ZE3_NUM) as OS_VGA,
    trim(ZC1.ZC1_FILIAL) as FILIAL_OS,
    trim(ZC1.ZC1_NUM) as NUM_OS,
    trim(DUD.DUD_FILORI) as FILIAL_VG,
    trim(DUD.DUD_VIAGEM) as NUM_VG,
    
    ZE3.ZE3_VALOR as VL_ORIGINAL,
    coalesce(trim(CLIOPP.A1_NOME), trim(CLITMS.A1_NOME)) as CLIENTE,
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
    left join ZC1010 ZC1
        on ZC1.D_E_L_E_T_ = ''
        and left(ZE3.ZE3_NUM, 6) = ZC1.ZC1_FILIAL
        and concat(ZC1.ZC1_FILIAL, ZC1.ZC1_NUM) = ZE3.ZE3_NUM
    left join DUD010 DUD
        on DUD.D_E_L_E_T_ = ''
        and left(ZE3.ZE3_NUM, 4) = DUD.DUD_FILIAL
        and concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)) = trim(ZE3.ZE3_NUM)

        left join
        (
            select
                DT6010.DT6_FILDOC as CTE_FILDOC,
                DT6010.DT6_DOC as CTE_DOC,
                DT6010.DT6_SERIE as CTE_SERIE,
                DT6010.DT6_CLIDEV as CTE_CLIENTE,
                DT6010.DT6_LOJDEV as CTE_LOJA,
                CMP.D2_DOC as CMP_DOC,
                CMP.D2_SERIE as CMP_SERIE,
                CMP.D2_CLIENTE as CMP_CLIENTE,
                CMP.D2_LOJA as CMP_LOJA,
                RPS.D2_FILIAL as RPS_FILIAL,
                RPS.D2_DOC as RPS_DOC,
                RPS.D2_SERIE as RPS_SERIE,
                RPS.D2_CLIENTE as RPS_CLIENTE,
                RPS.D2_LOJA as RPS_LOJA,
                DUD010.DUD_FILDOC as FILDOC,
                DUD010.DUD_DOC as DOC,
                DUD010.DUD_VIAGEM as VIAGEM
            from DUD010
                left join DT6010
                    on DT6010.D_E_L_E_T_ = ''
                    and DT6010.DT6_FILDOC = DUD010.DUD_FILDOC
                    and DT6010.DT6_DOC = DUD010.DUD_DOC
                    and DT6010.DT6_SERIE = DUD010.DUD_SERIE

                    left join SD2010 CMP
                        on CMP.D_E_L_E_T_ = ''
                        and CMP.D2_NFORI = DT6010.DT6_DOC
                        and CMP.D2_SERIORI = DT6010.DT6_SERIE
                        and CMP.D2_CLIENTE = DT6010.DT6_CLIDEV
                        and CMP.D2_LOJA = DT6010.DT6_LOJDEV

                left join SC5010 SC5
                    on SC5.D_E_L_E_T_ = ''
                    and left(SC5.C5_FILIAL, 4) = DUD010.DUD_FILIAL
                    and SC5.C5_FILIAL = DUD010.DUD_FILORI
                    and SC5.C5_YVIAGEM = DUD010.DUD_VIAGEM

                    left join SD2010 RPS
                        on RPS.D_E_L_E_T_ = ''
                        and RPS.D2_FILIAL = SC5.C5_FILIAL
                        and RPS.D2_DOC = SC5.C5_NOTA
                        and RPS.D2_SERIE = SC5.C5_SERIE
                        and RPS.D2_CLIENTE = SC5.C5_CLIENTE
                        and RPS.D2_LOJA = SC5.C5_LOJACLI
            
            where DUD010.D_E_L_E_T_ = ''
        ) SD2
            on SD2.FILDOC = DUD.DUD_FILDOC
            and SD2.DOC = DUD.DUD_DOC
            and SD2.VIAGEM = DUD.DUD_VIAGEM
            
            left join SA1010 CLITMS
                on CLITMS.D_E_L_E_T_ = ''
                and
                (
                    concat(CLITMS.A1_COD, CLITMS.A1_LOJA) = concat(SD2.CTE_CLIENTE, SD2.CTE_LOJA) or
                    concat(CLITMS.A1_COD, CLITMS.A1_LOJA) = concat(SD2.CMP_CLIENTE, SD2.CMP_LOJA) or
                    concat(CLITMS.A1_COD, CLITMS.A1_LOJA) = concat(SD2.RPS_CLIENTE, SD2.RPS_LOJA)
                )

        left join SA1010 CLIOPP
            on CLIOPP.D_E_L_E_T_ = ''
            and CLIOPP.A1_COD = ZC1.ZC1_CODSA1
            and CLIOPP.A1_LOJA = ZC1.ZC1_LOJSA1
        left join SED010 SED
            on SED.D_E_L_E_T_ = ''
            and SED.ED_CODIGO = ZC1.ZC1_NATURE
        left join SE4010 SE4
            on SE4.D_E_L_E_T_ = ''
            and SE4.E4_CODIGO = ZC1.ZC1_COND
        left join DA0010 DA0
            on DA0.D_E_L_E_T_ = ''
            and DA0.DA0_CODTAB = ZC1.ZC1_TABPRC
        left join SA2010 SA2
            on SA2.D_E_L_E_T_ = ''
            and SA2.A2_COD = ZC1.ZC1_DESPA
            and SA2.A2_LOJA = ZC1.ZC1_LJDESP
        left join SB1010 SB1
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = ZC1.ZC1_MERCAD

    left join CTT010
        on CTT010.D_E_L_E_T_ = ''
        and CTT010.CTT_CUSTO = ZE3.ZE3_ORIGEM
where
        ZE3.ZE3_COMPET=:PERIODO
    and ZE3.D_E_L_E_T_ = ''
