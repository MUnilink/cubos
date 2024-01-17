select
    'P |01|01' AS BK_EMPRESA,
    CASE WHEN SD2.D2_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(SD2.D2_FILIAL AS CHAR (6)) END AS BK_FILIAL,
    concat(trim(ZC1.ZC1_FILIAL), trim(ZC1.ZC1_NUM)) as BK_OSPORTUARIA,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DEV.A1_COD, ' '))+RTRIM(COALESCE(DEV.A1_LOJA, ' ')), ' '), '|') as BK_CLIENTE,
    concat(trim(SC5.C5_FILIAL), trim(SC5.C5_NUM)) as BK_PEDIDODEVENDA,
    concat('SF2', trim(SF2.F2_FILIAL), trim(SF2.F2_CLIENTE), trim(SF2.F2_LOJA), trim(SF2.F2_DOC), trim(SF2.F2_SERIE)) as ID_NF,

    ZC1.ZC1_EMISSA as DATA_OS,    
    /*concat(ARM.A1_COD, ARM.A1_LOJA) as ARMADORA,*/
    concat(DES.A2_COD, DES.A2_LOJA) as DESPACHANTE,
    ZC1.ZC1_TABPRC as TABELA_PRECO,
    
    ZC2.ZC2_ITEM as ITEM,
    
    case ZC2.ZC2_TIPO
        when 1 then 'RECEITA'
        else 'CUSTO OU DESPESA'
    end as TIPO_INSUMO,

    trim(ZC2.ZC2_COD) as INSUMO,
    ZC2.ZC2_QTDPRV as QTD_PREV,
    ZC2.ZC2_QTDREA as QTD_REAL,
    ZC2.ZC2_VLUPRV as VAL_PREV,
    ZC2.ZC2_VLUREA as VAL_REAL,
    ZC2.ZC2_QTDREC as QTD_RECURSO

from ZC2010 ZC2
    left join ZC1010 ZC1
        on ZC1.D_E_L_E_T_ = ''
        and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
        and ZC1.ZC1_NUM = ZC2.ZC2_NUM
        and substring(ZC1.ZC1_NUM, 1, 4) > 2022
        
        left join SA1010 DEV
            on DEV.D_E_L_E_T_ = ''
            and DEV.A1_COD = ZC1.ZC1_CODSA1
            and DEV.A1_LOJA = ZC1.ZC1_LOJSA1
        left join SA1010 ARM
            on ARM.D_E_L_E_T_ = ''
            and ARM.A1_COD = ZC1.ZC1_ARMADO
            and ARM.A1_LOJA = ZC1.ZC1_LJARMA
        left join SA2010 DES
            on DES.D_E_L_E_T_ = ''
            and DES.A2_COD = ZC1.ZC1_DESPA
            and DES.A2_LOJA = ZC1.ZC1_LJDESP
        left join SC5010 SC5
            on SC5.D_E_L_E_T_ = ''
            and SC5.C5_FILIAL = ZC1.ZC1_FILIAL
            and SC5.C5_YOS = ZC1.ZC1_NUM

            left join SD2010 SD2
                on SD2.D_E_L_E_T_ = ''
                and SD2.D2_FILIAL = SC5.C5_FILIAL
                and SD2.D2_PEDIDO = SC5.C5_NUM

                left join SF2010 SF2
                    on SF2.D_E_L_E_T_= ' '
                    and SF2.F2_FILIAL = SD2.D2_FILIAL
                    and SF2.F2_CLIENTE = SD2.D2_CLIENTE
                    and SF2.F2_LOJA = SD2.D2_LOJA
                    and SF2.F2_DOC = SD2.D2_DOC
                    and SF2.F2_SERIE = SD2.D2_SERIE

    left join ST9010 ST9
        on ST9.D_E_L_E_T_ = ''
        and trim(ST9.T9_CODBEM) = trim(ZC2.ZC2_COD)
    left join ZA7010 ZA7
        on ZA7.D_E_L_E_T_ = ''
        and trim(ZA7.ZA7_COD) = trim(ZC2.ZC2_COD)
    left join DA4010 DA4
        on DA4.D_E_L_E_T_ = ''
        and DA4.DA4_COD = ZC2.ZC2_MOTORI
where
        ZC2.ZC2_DTFIM between <<START_DATE>> and <<FINAL_DATE>>
    and ZC2.D_E_L_E_T_ = ''
