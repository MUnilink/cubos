select distinct
    'P |01|01' AS BK_EMPRESA,
    case when nullif(ZC1.ZC1_FILIAL, '') is not null then 'P |01|01'+ CAST(ZC1.ZC1_FILIAL AS CHAR (6)) when nullif(concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)), trim(DUD.DUD_FILORI)) is not null then 'P |01|01'+ CAST(DUD.DUD_FILORI AS CHAR (6)) else 'P |01||' end as BK_FILIAL,
    
    case
        when nullif(ZC1.ZC1_CODSA1, '') is not null then 'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CLIOPP.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(CLIOPP.A1_COD, ' '))+RTRIM(COALESCE(CLIOPP.A1_LOJA, ' ')), ' '), '|')
        when nullif(concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)), trim(DUD.DUD_FILORI)) is not null then
        (
            select max('P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1010.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA1010.A1_COD, ' '))+RTRIM(COALESCE(SA1010.A1_LOJA, ' ')), ' '), '|'))
            from DUD010 (nolock)
                inner join DT6010 (nolock)
                    on DT6010.D_E_L_E_T_ = ''
                    and DT6010.DT6_FILDOC = DUD010.DUD_FILDOC
                    and DT6010.DT6_DOC = DUD010.DUD_DOC
                    and DT6010.DT6_SERIE = DUD010.DUD_SERIE
                    
                    left join SA1010 (nolock)
                        on SA1010.D_E_L_E_T_ = ''
                        and SA1010.A1_COD = DT6010.DT6_CLIDEV
                        and SA1010.A1_LOJA = DT6010.DT6_LOJDEV
            where
                    DUD010.D_E_L_E_T_ = ''
                and DUD010.DUD_FILORI = DUD.DUD_FILORI
                and DUD010.DUD_VIAGEM = DUD.DUD_VIAGEM
        )
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
    
    'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD010.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(ZE3.ZE3_ITORIG, ' ')), ' '), '|') as BK_ITEM_CONTABIL,
    'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT010.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(ZE3.ZE3_ORIGEM, ' ')), ' '), '|') as BK_CENTRO_DE_CUSTO,
    
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
    trim(CLIOPP.A1_NOME) as CLIENTE,
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
    left join CTD010
        on CTD010.D_E_L_E_T_ = ''
        and CTD010.CTD_ITEM = ZE3.ZE3_ITORIG
where
        ZE3.ZE3_COMPET=:PERIODO
    and ZE3.D_E_L_E_T_ = ''
