select distinct
    'P |01|01' AS BK_EMPRESA,
    CASE WHEN ZC1.ZC1_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(ZC1.ZC1_FILIAL AS CHAR (6)) END AS BK_FILIAL,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA1.A1_COD, ' '))+RTRIM(COALESCE(SA1.A1_LOJA, ' ')), ' '), '|') as BK_CLIENTE,
    'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA2.A2_COD, ' '))+RTRIM(COALESCE(SA2.A2_LOJA, ' ')), ' '), '|') as BK_FORNECEDOR,
    concat(trim(ZC1.ZC1_FILIAL), trim(ZC1.ZC1_NUM)) as ID_OSPORTUARIA,
    PV.ID_PEDIDODEVENDA,
    PV.ID_NFS,
    null as ID_NFE,
    null as ID_PEDIDO,
    'P |01|SED010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SED.ED_FILIAL, ' '))+'|'+RTRIM(COALESCE(SED.ED_CODIGO, ' ')), ' '), '|') AS BK_NAT_FINANCEIRA,
    'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SE4.E4_CODIGO, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO,
    PV.BK_ITEM_CONTABIL,
    trim(ZE3.ZE3_ORIGEM) as BK_CENTRO_DE_CUSTO,
    concat(trim(DA0.DA0_FILIAL), trim(DA0.DA0_CODTAB)) as ID_TABELA_PRECO,
    concat(ZE3.ZE3_COMPET, '01') as PERIODO,
    ZE2.ZE2_COD as CONTAROP,
    ZE2.ZE2_CONTA as CONTA_CONTABIL,
    
    case
        when ZE2.ZE2_ORIGEM = 'F' then abs(ZE3.ZE3_VALOR)
        when left(ZE2.ZE2_COD, 2) = '01' then ZE3.ZE3_VALOR
        when left(ZE2.ZE2_COD, 2) like '0[2-9]' then abs(ZE3.ZE3_VALOR)*-1
        when left(ZE2.ZE2_COD, 2) like '_[1-9]' then abs(ZE3.ZE3_VALOR)*-1
    else 0.0 end as VALOR,

    (select trim(max(SX6010.X6_CONTEUD)) from SX6010 where SX6010.X6_FIL = ZC2.FILIAL and SX6010.X6_VAR like 'UN_ULTOS%') as PERIODO_ATUAL,
    
    /* para validação no RM */
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
        and concat(ZC1.ZC1_FILIAL, ZC1.ZC1_NUM) = ZE3.ZE3_NUM

        left join SA1010 SA1
            on SA1.D_E_L_E_T_ = ''
            and SA1.A1_COD = ZC1.ZC1_CODSA1
            and SA1.A1_LOJA = ZC1.ZC1_LOJSA1
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

        left join
        (
            select
                SC6010.C6_FILIAL as FILIAL,
                SC6010.C6_YOS as OS,
                concat(trim(SC6010.C6_FILIAL), trim(SC6010.C6_NUM)) as ID_PEDIDODEVENDA,
                concat('SF2', trim(SF2010.F2_FILIAL), trim(SF2010.F2_CLIENTE), trim(SF2010.F2_LOJA), trim(SF2010.F2_DOC), trim(SF2010.F2_SERIE)) as ID_NFS,
                'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD010.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC6010.C6_ITEMCTA, ' ')), ' '), '|') as BK_ITEM_CONTABIL,
                'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT010.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC6010.C6_CC, ' ')), ' '), '|') as BK_CENTRO_DE_CUSTO,
                1 as QTD
            from SC6010
                left join SD2010
                    on SD2010.D_E_L_E_T_= ''
                    and SD2010.D2_FILIAL = SC6010.C6_FILIAL
                    and SD2010.D2_PEDIDO = SC6010.C6_NUM
                    and SD2010.D2_ITEMPV = SC6010.C6_ITEM
                            
                    left join SF2010
                        on SF2010.D_E_L_E_T_= ' '
                        and SF2010.F2_FILIAL = SD2010.D2_FILIAL
                        and SF2010.F2_CLIENTE = SD2010.D2_CLIENTE
                        and SF2010.F2_LOJA = SD2010.D2_LOJA
                        and SF2010.F2_DOC = SD2010.D2_DOC
                        and SF2010.F2_SERIE = SD2010.D2_SERIE
                
                left join CTD010
                    on CTD010.CTD_FILIAL = ''
                    and CTD010.CTD_ITEM = SC6010.C6_ITEMCTA
                    and CTD010.D_E_L_E_T_ = ''
                left join CTT010
                    on CTT010.D_E_L_E_T_ = ''
                    and CTT010.CTT_FILIAL = substring(SC6010.C6_FILIAL, 1, 4)
                    and CTT010.CTT_CUSTO = SC6010.C6_CC
            where
                    SC6010.D_E_L_E_T_ = ''
        ) PV
            on PV.FILIAL = ZC1.ZC1_FILIAL
            and PV.OS = ZC1.ZC1_NUM
where
        ZE3.D_E_L_E_T_ = ''
