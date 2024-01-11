select
    concat(trim(ZC1.ZC1_FILIAL), trim(ZC1.ZC1_NUM)) as ID_OS,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DEV.A1_COD, ' '))+RTRIM(COALESCE(DEV.A1_LOJA, ' ')), ' '), '|') as BK_CLIENTE,
    concat(trim(SC5.C5_FILIAL), trim(SC5.C5_NUM)) as BK_PEDIDODEVENDA,
    concat('SF2', trim(SF2.F2_FILIAL), trim(SF2.F2_CLIENTE), trim(SF2.F2_LOJA), trim(SF2.F2_DOC), trim(SF2.F2_SERIE)) as ID_NF,

    ZC1.ZC1_EMISSA as DATA_OS,    
    /*concat(ARM.A1_COD, ARM.A1_LOJA) as ARMADORA,*/
    concat(DES.A2_COD, DES.A2_LOJA) as DESPACHANTE,
    ZC1.ZC1_TABPRC as TABELA_PRECO,
    
    ZC2.ZC2_ITEM as ITEM,
    ZC2.ZC2_INCLUS as TIPO_INCLUSAO,
    
    case ZC2.ZC2_TIPO
        when 1 then 'RECEITA'
        when 2 then 'FUNÇÃO'
        when 3 then 'EQUIPAMENTO'
        when 4 then 'MATERIAIS'
        when 6 then 'DEPRECIAÇÃO'
        when 7 then 'CONTABILIDADE'
        else 'OUTROS'
    end as TIPO_INSUMO,

    trim(ZC2.ZC2_COD) as INSUMO,
    case ZC2.ZC2_TIPO
        when 1 then (select case when SB1010.B1_DESC like 'TRANSPORTE PORTUARIO - %' then replace(SB1010.B1_DESC, 'TRANSPORTE PORTUARIO - ', '') else trim(SB1010.B1_DESC) end from DA1010 inner join SB1010 on SB1010.D_E_L_E_T_ = '' and SB1010.B1_COD = DA1010.DA1_CODPRO where DA1010.D_E_L_E_T_ = '' and DA1010.DA1_CODTAB = ZC1.ZC1_TABPRC and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and ZC2.ZC2_TIPO = 1)
        when 2 then (select trim(SRJ010.RJ_DESC) from SRJ010 where SRJ010.D_E_L_E_T_ = '' and SRJ010.RJ_FUNCAO = trim(ZC2.ZC2_COD) and ZC2.ZC2_TIPO = 2)
        when 3 then trim(ST9.T9_CODBEM)
        when 4 then (select trim(SB1010.B1_DESC) from SB1010 where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and ZC2.ZC2_TIPO = 4)
        when 6 then trim(ST9.T9_CODBEM)
        when 7 then trim(ZA7.ZA7_DESC)
        else trim(ZC2.ZC2_DESC)
    end as DESC_INSUMO,
    
    ZC2.ZC2_QTDPRV as QTD_PREV,
    ZC2.ZC2_QTDREA as QTD_REAL,
    ZC2.ZC2_VLUPRV as VAL_PREV,
    ZC2.ZC2_VLUREA as VAL_REAL,
    ZC2.ZC2_QTDREC as QTD_RECURSO,
    
    trim(ZC2.ZC2_CONTEI) as CONTEINER,
    trim(ZC2.ZC2_LACRE) as LACRE,
    ZC2.ZC2_MOTORI as COD_MOT,
    ZC2.ZC2_VEICUL as CM,
    ZC2.ZC2_CARRET as SR,

    concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI) as DTINI_APONT,
    concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM) as DTFIM_APONT,
    trim(upper(ZC2.ZC2_NMUSU)) as USUARIO

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
