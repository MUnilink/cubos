select
    ZC1.ZC1_FILIAL as FILIAL,
    concat(trim(ZC1.ZC1_NUM), trim(ZC2.ZC2_ITEM)) as ID_OS,
    ZC1.ZC1_NUM as NUM_OS,
    cast(substring(ZC1.ZC1_NUM, 6, 10) as int) as OS,
    ZC2.ZC2_ITEM as ITEM,
    substring(ZC1.ZC1_NUM, 1, 4) as ANO_OS,
    substring(ZC1.ZC1_EMISSA, 1, 6) as PERIODO_OS,
    convert(date, ZC1.ZC1_EMISSA, 103) as DATA_OS,
    
    SD2.D2_LOCAL as ARMAZEM,
    SD2.D2_TES as TM,
    SD2.D2_CF as CF,
    SD2.D2_DOC as DOC,
    
    ZC1.ZC1_PORTO as PORTO,
    (select trim(SX5010.X5_DESCRI) from SX5010 where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = '_1' and SX5010.X5_CHAVE = ZC1.ZC1_PORTO) as DESC_PORTO,
    ZC1.ZC1_NAVIO as NAVIO,
    (select trim(ZA3010.ZA3_DESC) from ZA3010 where ZA3010.D_E_L_E_T_ = '' and ZA3010.ZA3_COD = ZC1.ZC1_NAVIO) as DESC_NAVIO,
    trim(ZC1.ZC1_VIAGEM) as VIAGEM_PORT,

    DEV.A1_COD as CLI_CODIGO,
    DEV.A1_LOJA as CLI_LOJA,
    DEV.A1_CGC as CLI_CNPJ,
    trim(DEV.A1_NOME) as CLIENTE,

    ARM.A1_COD as ARM_CODIGO,
    ARM.A1_LOJA as ARM_LOJA,
    ARM.A1_CGC as ARM_CNPJ,
    trim(DEV.A1_NOME) as ARMADORA,

    DES.A2_COD as DESP_CODIGO,
    DES.A2_LOJA as DESP_LOJA,
    DES.A2_CGC as DESP_CNPJ,
    trim(DES.A2_NOME) as DESPACHANTE,
    
    ZC2.ZC2_INCLUS as TIPO_INCLUSAO,
    ZC1.ZC1_TABPRC as TABELADEPRECO,
    (select trim(DA0010.DA0_DESCRI) from DA0010 where DA0010.D_E_L_E_T_ = '' and DA0010.DA0_CODTAB = ZC1.ZC1_TABPRC) as TABELA_PRECO,

    trim(ZC2.ZC2_COD) as INSUMO,
    (select trim(SRJ010.RJ_DESC) from SRJ010 (nolock) where SRJ010.D_E_L_E_T_ = '' and SRJ010.RJ_FUNCAO = trim(ZC2.ZC2_COD) and ZC2.ZC2_TIPO = 2) as DESC_INSUMO,

    case ZC1.ZC1_STATUS
        when 1 then 'ABERTA'
        when 6 then 'FECHADA'
        when 9 then 'PEDIDO CRIADO'
        else 'OUTROS'
    end as STATUS_OS,
    
    ZC2.ZC2_QTDPRV as QTD_PREV,
    ZC2.ZC2_QTDREA as QTD_REAL,
    ZC2.ZC2_VLUPRV as VAL_PREV,
    ZC2.ZC2_VLUREA as VAL_REAL,
    ZC2.ZC2_QTDREC as QTD_RECURSO,
    
    trim(ZC2.ZC2_CONTEI) as CONTEINER,
    trim(ZC2.ZC2_LACRE) as LACRE,
    ZC2.ZC2_MOTORI as COD_MOT,
    DA4.DA4_NOME as MOTORISTA,
    ZC2.ZC2_VEICUL as CM,
    ZC2.ZC2_CARRET as SR,

    convert(date, ZC2.ZC2_DTINI, 103) as DATA_INIAPONT,
    convert(date, ZC2.ZC2_DTFIM, 103) as DATA_FIMAPONT,
    trim(upper(ZC2.ZC2_NMUSU)) as USUARIO,

    SC6.C6_NUM as PEDIDO,
    SC6.C6_ITEM as ITEM_PEDIDO,
    SC6.C6_UM as UN_PEDIDO,
    SC6.C6_QTDVEN as QTD_PEDIDO,
    SC6.C6_PRCVEN as PRECO_PEDIDO,
    SC6.C6_VALOR as VALOR_PEDIDO,
    SC6.C6_CC as CC_PEDIDO,
    SC6.C6_ITEMCTA as ATIVIDADE_PEDIDO

from ZC2010 ZC2 (nolock)
    left join ZC1010 ZC1 (nolock)
        on ZC1.D_E_L_E_T_ = ''
        and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
        and ZC1.ZC1_NUM = ZC2.ZC2_NUM
        
        left join SA1010 DEV (nolock)
            on DEV.D_E_L_E_T_ = ''
            and DEV.A1_COD = ZC1.ZC1_CODSA1
            and DEV.A1_LOJA = ZC1.ZC1_LOJSA1
        left join SA1010 ARM (nolock)
            on ARM.D_E_L_E_T_ = ''
            and ARM.A1_COD = ZC1.ZC1_ARMADO
            and ARM.A1_LOJA = ZC1.ZC1_LJARMA
        left join SA2010 DES (nolock)
            on DES.D_E_L_E_T_ = ''
            and DES.A2_COD = ZC1.ZC1_DESPA
            and DES.A2_LOJA = ZC1.ZC1_LJDESP

    left join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and trim(ST9.T9_CODBEM) = trim(ZC2.ZC2_COD)
    left join ZA7010 ZA7 (nolock)
        on ZA7.D_E_L_E_T_ = ''
        and trim(ZA7.ZA7_COD) = trim(ZC2.ZC2_COD)
    left join DA4010 DA4 (nolock)
        on DA4.D_E_L_E_T_ = ''
        and DA4.DA4_COD = ZC2.ZC2_MOTORI
    left join SC6010 SC6 (nolock)
        on SC6.D_E_L_E_T_ = ''
        and SC6.C6_FILIAL = ZC2.ZC2_FILIAL
        and SC6.C6_YOS = ZC2.ZC2_NUM
        and SC6.C6_YITOS = ZC2.ZC2_ITEM

    inner join SC6010 SC6
        on SC6.C6_FILIAL = SC5.C5_FILIAL
        and SC6.C6_NUM = SC5.C5_NUM
        and SC6.D_E_L_E_T_ = ' '
            
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
where
        ZC2.D_E_L_E_T_ = ''
    and ZC2.ZC2_TIPO = 2
    and year(ZC1.ZC1_EMISSA) > 2022
