select distinct
    'P |01|01' AS BK_EMPRESA,
    CASE WHEN ZC1.ZC1_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(ZC1.ZC1_FILIAL AS CHAR (6)) END AS BK_FILIAL,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA1.A1_COD, ' '))+RTRIM(COALESCE(SA1.A1_LOJA, ' ')), ' '), '|') as BK_CLIENTE,
    'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA2.A2_COD, ' '))+RTRIM(COALESCE(SA2.A2_LOJA, ' ')), ' '), '|') as BK_FORNECEDOR,
    concat(trim(ZC1.ZC1_FILIAL), trim(ZC1.ZC1_NUM)) as ID_OSPORTUARIA,
    PV.ID_PEDIDODEVENDA,
    PV.ID_NFS,
    'P |01|SED010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SED.ED_FILIAL, ' '))+'|'+RTRIM(COALESCE(SED.ED_CODIGO, ' ')), ' '), '|') AS BK_NAT_FINANCEIRA,
    'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SE4.E4_CODIGO, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO,
    PV.BK_ITEM_CONTABIL,
    PV.BK_CENTRO_DE_CUSTO,
    concat(trim(DA0.DA0_FILIAL), trim(DA0.DA0_CODTAB)) as ID_TABELA_PRECO,
    concat(ZE3.ZE3_COMPET, '01') as PERIODO,
    ZE2.ZE2_COD as CONTAROP,
    ZE2.ZE2_CONTA as CONTA_CONTABIL,
    
    case
        when ZE2.ZE2_ORIGEM = 'F' then abs(ZE3.ZE3_VALOR)
        when left(ZE2.ZE2_COD, 2) = '01' then ZE3.ZE3_VALOR
        when left(ZE2.ZE2_COD, 2) like '0[2-9]' then abs(ZE3.ZE3_VALOR)*-1
        when left(ZE2.ZE2_COD, 2) like '_[1-9]' then abs(ZE3.ZE3_VALOR)*-1
    else 0.0 end as VALOR

from ZE3010 ZE3
    inner join ZE2010 ZE2
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
        concat(ZE3.ZE3_COMPET, '01') BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
    and ZE3.D_E_L_E_T_ = ''
